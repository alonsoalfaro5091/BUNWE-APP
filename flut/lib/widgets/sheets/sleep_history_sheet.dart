import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';

class SleepHistorySheet extends StatelessWidget {
  const SleepHistorySheet({super.key});

  static const List<_DayData> _data = [
    _DayData('Lun', 7.0),  _DayData('Mar', 6.5),  _DayData('Mié', 8.2),
    _DayData('Jue', 7.5),  _DayData('Vie', 6.0),  _DayData('Sáb', 8.5),
    _DayData('Dom', 8.2),
  ];

  static const double _goalHours = 8.0;

  @override
  Widget build(BuildContext context) {
    final maxH = _data.map((d) => d.hours).reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Text('Historial de esta semana',
              style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
          Text('Horas dormidas por día vs. meta de 8h',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 20),

          // Línea de meta
          Row(children: [
            Container(width: 14, height: 2, color: AppColors.gold),
            const SizedBox(width: 6),
            Text('Meta: ${_goalHours.toStringAsFixed(0)}h',
                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),

          // Gráfico
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _data.asMap().entries.map((e) {
                final i = e.key;
                final d = e.value;
                final isToday = i == _data.length - 1;
                final isGood  = d.hours >= _goalHours;
                final ratio   = d.hours / maxH;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Etiqueta horas
                        Text(
                          '${d.hours.toStringAsFixed(1)}h',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: isToday ? AppColors.purpleLight
                                : isGood ? AppColors.accent
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Barra
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + i * 70),
                          curve: Curves.easeOut,
                          height: 140 * ratio,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppColors.purple
                                : isGood
                                    ? AppColors.accent.withValues(alpha: 0.8)
                                    : AppColors.purpleDark.withValues(alpha: 0.6),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Día
                        Text(d.day,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: isToday ? AppColors.purpleLight : AppColors.textMuted,
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),

          // Stats resumidas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Promedio', '7h 42m', AppColors.textPrimary),
              _stat('Mejor noche', '8h 30m', AppColors.accent),
              _stat('Meta 8h', '4/7 días', AppColors.gold),
              _stat('Déficit', '1h 18m', AppColors.red),
            ],
          ),
          const SizedBox(height: 14),

          // Leyenda
          Row(children: [
            _legendItem(AppColors.accent.withValues(alpha: 0.8), '8h+ cumplidas'),
            const SizedBox(width: 14),
            _legendItem(AppColors.purpleDark.withValues(alpha: 0.6), 'Menos de 8h'),
            const SizedBox(width: 14),
            _legendItem(AppColors.purple, 'Hoy'),
          ]),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) => Column(children: [
    Text(value, style: GoogleFonts.fredoka(fontSize: 15, color: color)),
    Text(label, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
  ]);

  Widget _legendItem(Color color, String label) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 4),
    Text(label, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
  ]);
}

class _DayData {
  final String day;
  final double hours;
  const _DayData(this.day, this.hours);
}
