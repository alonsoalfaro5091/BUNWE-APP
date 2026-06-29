import 'package:flutter/material.dart';
import '../core/colors.dart';

class XpProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double height;

  const XpProgressBar({super.key, required this.progress, this.height = 8});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppColors.background,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple),
      ),
    );
  }
}
