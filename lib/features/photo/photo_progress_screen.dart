import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Photo progress tracking with front/side/back views.
class PhotoProgressScreen extends StatefulWidget {
  const PhotoProgressScreen({super.key});

  @override
  State<PhotoProgressScreen> createState() => _PhotoProgressScreenState();
}

class _PhotoProgressScreenState extends State<PhotoProgressScreen> {
  final _repo = PhotoProgressRepository();
  bool _loading = true;
  Map<PhotoType, List<PhotoEntry>> _entries = {
    PhotoType.front: [],
    PhotoType.side: [],
    PhotoType.back: [],
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.load();
    setState(() {
      _entries = data;
      _loading = false;
    });
    _maybePromptReminder();
  }

  void _maybePromptReminder() {
    final latest = _entries.values
        .expand((list) => list)
        .map((e) => e.takenAt)
        .fold<DateTime?>(null, (current, next) {
      if (current == null || next.isAfter(current)) {
        return next;
      }
      return current;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (latest == null) {
        _showReminderDialog('Start your photo journey',
            'Add your first set of photos to track progress.');
        return;
      }
      final days = DateTime.now().difference(latest).inDays;
      if (days >= 30) {
        _showReminderDialog('Monthly check-in',
            'It’s been $days days. Capture a fresh set of progress photos.');
      } else if (days >= 7) {
        _showReminderDialog('Weekly reminder',
            'It’s been $days days. Take a new progress photo.');
      }
    });
  }

  Future<void> _showReminderDialog(String title, String message) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto(PhotoType type, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 92);
    if (image == null) {
      return;
    }

    final saved = await _repo.saveImage(type, File(image.path));
    setState(() {
      _entries[type] = [saved, ..._entries[type]!];
    });
  }

  void _showSourcePicker(PhotoType type) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickPhoto(type, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickPhoto(type, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photo Progress'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Front'),
              Tab(text: 'Side'),
              Tab(text: 'Back'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _PhotoTab(
                    type: PhotoType.front,
                    entries: _entries[PhotoType.front]!,
                    onAdd: () => _showSourcePicker(PhotoType.front),
                    onDelete: (entry) async {
                      await _repo.deleteEntry(PhotoType.front, entry);
                      setState(() {
                        _entries[PhotoType.front] =
                            _entries[PhotoType.front]!
                                .where((item) => item.path != entry.path)
                                .toList();
                      });
                    },
                  ),
                  _PhotoTab(
                    type: PhotoType.side,
                    entries: _entries[PhotoType.side]!,
                    onAdd: () => _showSourcePicker(PhotoType.side),
                    onDelete: (entry) async {
                      await _repo.deleteEntry(PhotoType.side, entry);
                      setState(() {
                        _entries[PhotoType.side] =
                            _entries[PhotoType.side]!
                                .where((item) => item.path != entry.path)
                                .toList();
                      });
                    },
                  ),
                  _PhotoTab(
                    type: PhotoType.back,
                    entries: _entries[PhotoType.back]!,
                    onAdd: () => _showSourcePicker(PhotoType.back),
                    onDelete: (entry) async {
                      await _repo.deleteEntry(PhotoType.back, entry);
                      setState(() {
                        _entries[PhotoType.back] =
                            _entries[PhotoType.back]!
                                .where((item) => item.path != entry.path)
                                .toList();
                      });
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _PhotoTab extends StatelessWidget {
  const _PhotoTab({
    required this.type,
    required this.entries,
    required this.onAdd,
    required this.onDelete,
  });

  final PhotoType type;
  final List<PhotoEntry> entries;
  final VoidCallback onAdd;
  final Future<void> Function(PhotoEntry entry) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        _AddCard(onTap: onAdd),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          _EmptyState(type: type)
        else
          ...entries.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final previous = index + 1 < entries.length ? entries[index + 1] : null;
            return _PhotoCard(
              entry: item,
              previous: previous,
              onDelete: () => onDelete(item),
            );
          }),
      ],
    );
  }
}

class _AddCard extends StatelessWidget {
  const _AddCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_a_photo, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add photo',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Capture today’s progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.entry,
    required this.previous,
    required this.onDelete,
  });

  final PhotoEntry entry;
  final PhotoEntry? previous;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDate(entry.takenAt);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.file(
              File(entry.path),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ),
                if (previous != null)
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PhotoCompareScreen(
                          current: entry,
                          previous: previous!,
                        ),
                      ),
                    ),
                    child: const Text('Compare'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white70,
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This photo will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      onDelete();
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type});

  final PhotoType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No ${type.label} photos yet',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your first photo to start tracking progress.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}

class PhotoCompareScreen extends StatefulWidget {
  const PhotoCompareScreen({
    super.key,
    required this.current,
    required this.previous,
  });

  final PhotoEntry current;
  final PhotoEntry previous;

  @override
  State<PhotoCompareScreen> createState() => _PhotoCompareScreenState();
}

class _PhotoCompareScreenState extends State<PhotoCompareScreen> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        File(widget.previous.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _sliderValue,
                          child: Image.file(
                            File(widget.current.path),
                            width: width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: width * _sliderValue - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                Slider(
                  value: _sliderValue,
                  onChanged: (value) => setState(() {
                    _sliderValue = value;
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(widget.previous.takenAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    Text(
                      _formatDate(widget.current.takenAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoProgressRepository {
  static const _storageKey = 'fitmatrix_photo_progress';

  Future<Map<PhotoType, List<PhotoEntry>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return {
        PhotoType.front: [],
        PhotoType.side: [],
        PhotoType.back: [],
      };
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return PhotoType.values.fold<Map<PhotoType, List<PhotoEntry>>>(
      {},
      (map, type) {
        final list = (decoded[type.name] as List<dynamic>? ?? [])
            .map((item) => PhotoEntry.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.takenAt.compareTo(a.takenAt));
        map[type] = list;
        return map;
      },
    );
  }

  Future<PhotoEntry> saveImage(PhotoType type, File file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final directory = Directory('${appDir.path}/photo_progress');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${type.name}_$timestamp.jpg';
    final newPath = '${directory.path}/$fileName';
    final savedFile = await file.copy(newPath);

    final entry = PhotoEntry(
      path: savedFile.path,
      takenAt: DateTime.now(),
    );

    await _appendEntry(type, entry);
    return entry;
  }

  Future<void> deleteEntry(PhotoType type, PhotoEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return;
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = (decoded[type.name] as List<dynamic>? ?? [])
        .where((item) => item is Map<String, dynamic>)
        .cast<Map<String, dynamic>>()
        .where((item) => item['path'] != entry.path)
        .toList();
    decoded[type.name] = list;
    await prefs.setString(_storageKey, jsonEncode(decoded));
    try {
      final file = File(entry.path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  Future<void> _appendEntry(PhotoType type, PhotoEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    final decoded = raw == null
        ? <String, dynamic>{}
        : jsonDecode(raw) as Map<String, dynamic>;

    final list = (decoded[type.name] as List<dynamic>? ?? [])..insert(0, entry.toJson());
    decoded[type.name] = list;
    await prefs.setString(_storageKey, jsonEncode(decoded));
  }
}

enum PhotoType { front, side, back }

extension PhotoTypeLabel on PhotoType {
  String get label {
    switch (this) {
      case PhotoType.front:
        return 'front';
      case PhotoType.side:
        return 'side';
      case PhotoType.back:
        return 'back';
    }
  }
}

class PhotoEntry {
  const PhotoEntry({required this.path, required this.takenAt});

  final String path;
  final DateTime takenAt;

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'takenAt': takenAt.toIso8601String(),
    };
  }

  factory PhotoEntry.fromJson(Map<String, dynamic> json) {
    return PhotoEntry(
      path: json['path'] as String,
      takenAt: DateTime.parse(json['takenAt'] as String),
    );
  }
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
