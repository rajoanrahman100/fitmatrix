import 'package:flutter/material.dart';

/// Decorative gradient and glow blobs behind the home screen.
class BackgroundGlow extends StatelessWidget {
  const BackgroundGlow({super.key});

  /// Builds the background gradient and blobs.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A111A), Color(0xFF111B2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: GlowBlob(size: 240, color: Color(0xFF2B8FFF)),
          ),
          Positioned(
            bottom: -160,
            right: -60,
            child: GlowBlob(size: 280, color: Color(0xFFFFB86B)),
          ),
        ],
      ),
    );
  }
}

/// Single glow circle used in the background.
class GlowBlob extends StatelessWidget {
  const GlowBlob({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  /// Builds the glowing circle.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.3), Colors.transparent],
        ),
      ),
    );
  }
}
