import 'package:flutter/material.dart';
import '../core/colors.dart';

class BentoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final double? height;

  const BentoCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 18,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.card,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.border,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(14),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Etiqueta pequeña en mayúsculas estilo Bento
class BentoLabel extends StatelessWidget {
  final String text;
  final double fontSize;

  const BentoLabel(this.text, {super.key, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: fontSize,
        color: AppColors.textMuted,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Valor numérico grande estilo Fredoka
class BentoValue extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;

  const BentoValue(this.text, {super.key, this.fontSize = 28, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontFamily: 'FredokaOne',
        height: 1.1,
      ),
    );
  }
}

/// Pill/Badge pequeño
class BentoPill extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const BentoPill({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  factory BentoPill.green(String text) => BentoPill(
        text: text,
        backgroundColor: const Color(0xFF064E3B),
        textColor: const Color(0xFF6EE7B7),
      );

  factory BentoPill.gold(String text) => BentoPill(
        text: text,
        backgroundColor: const Color(0xFF451A03),
        textColor: const Color(0xFFFCD34D),
      );

  factory BentoPill.purple(String text) => BentoPill(
        text: text,
        backgroundColor: const Color(0xFF4C1D95),
        textColor: const Color(0xFFDDD6FE),
      );

  factory BentoPill.pink(String text) => BentoPill(
        text: text,
        backgroundColor: const Color(0xFF500724),
        textColor: const Color(0xFFFBCFE8),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
