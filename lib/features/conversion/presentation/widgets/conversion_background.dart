import 'package:coding_interview_frontend/features/conversion/presentation/theme/conversion_colors.dart';
import 'package:flutter/material.dart';

/// Scaffold body: light background + decorative warm circles (mock reference).
class ConversionBackground extends StatelessWidget {
  const ConversionBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        const Positioned(
          right: -1100,
          top: -350,
          child: _Blob(diameter: 1300),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: const BoxDecoration(
          color: ConversionColors.blob,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
