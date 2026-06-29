import 'package:flutter/material.dart';
import '../core/colors.dart';

class SleepBarChart extends StatelessWidget {
  final List<double> hours;        // horas dormidas por día
  final List<String> labels;       // etiquetas (L, M, X...)
  final int todayIndex;
  final double goalHours;
  final double height;

  const SleepBarChart({
    super.key,
    required this.hours,
    required this.labels,
    this.todayIndex = 6,
    this.goalHours = 8,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    final maxH = hours.reduce((a, b) => a > b ? a : b).clamp(goalHours, 12.0);

    return Column(
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(hours.length, (i) {
              final ratio  = hours[i] / maxH;
              final isGood = hours[i] >= goalHours;
              final isToday = i == todayIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: ratio,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400 + i * 60),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.purpleLight
                                  : isGood
                                      ? AppColors.accent.withValues(alpha: 0.8)
                                      : AppColors.purple.withValues(alpha: 0.6),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(labels.length, (i) {
            final isToday = i == todayIndex;
            return Expanded(
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: isToday ? AppColors.purpleLight : AppColors.textMuted,
                  fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
