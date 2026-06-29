import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';

class SleepGoalSheet extends StatefulWidget {
  final int initialHours;
  const SleepGoalSheet({super.key, this.initialHours = 8});

  @override
  State<SleepGoalSheet> createState() => _SleepGoalSheetState();
}

class _SleepGoalSheetState extends State<SleepGoalSheet> {
  late int _hours;
  late int _minutes;

  final List<int> _minuteOptions = [0, 15, 30, 45];

  @override
  void initState() {
    super.initState();
    _hours   = widget.initialHours;
    _minutes = 0;
  }

  String _qualityLabel() {
    final total = _hours + _minutes / 60;
    if (total < 6)  return '😟 Insuficiente para adultos';
    if (total < 7)  return '⚠️ Por debajo del mínimo';
    if (total < 8)  return '✅ Aceptable';
    if (total <= 9) return '🌟 Óptimo recomendado';
    return '💤 Puede causar somnolencia';
  }

  Color _qualityColor() {
    final total = _hours + _minutes / 60;
    if (total < 6)  return AppColors.red;
    if (total < 7)  return AppColors.gold;
    if (total < 8)  return AppColors.accent;
    if (total <= 9) return AppColors.accent;
    return AppColors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.nightlight_round, color: AppColors.purple, size: 22),
            const SizedBox(width: 8),
            Text('Meta de sueño',
                style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
          ]),
          Text('¿Cuántas horas quieres dormir cada noche?',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 24),

          // Selector de horas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _hourBtn(Icons.remove_rounded, () {
                if (_hours > 4) setState(() => _hours--);
              }),
              const SizedBox(width: 20),
              Column(children: [
                Text('$_hours', style: GoogleFonts.fredoka(fontSize: 56, color: AppColors.textPrimary, height: 1)),
                Text('horas', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
              ]),
              const SizedBox(width: 20),
              _hourBtn(Icons.add_rounded, () {
                if (_hours < 12) setState(() => _hours++);
              }),
            ],
          ),
          const SizedBox(height: 14),

          // Minutos
          Text('MINUTOS EXTRA', style: GoogleFonts.poppins(
              fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(children: _minuteOptions.map((m) {
            final sel = m == _minutes;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: m < 45 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _minutes = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 38,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.purple : AppColors.card2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? AppColors.purple : AppColors.border),
                    ),
                    child: Center(child: Text('+${m}m',
                        style: GoogleFonts.poppins(fontSize: 12,
                            color: sel ? Colors.white : AppColors.textMuted,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400))),
                  ),
                ),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),

          // Calidad
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _qualityColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _qualityColor().withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              Icon(Icons.info_outline_rounded, color: _qualityColor(), size: 18),
              const SizedBox(width: 8),
              Text(_qualityLabel(),
                  style: GoogleFonts.poppins(fontSize: 12, color: _qualityColor(), fontWeight: FontWeight.w500)),
            ]),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _hours),
              child: Text('Guardar meta: ${_hours}h ${_minutes > 0 ? "${_minutes}m" : ""}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hourBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        color: AppColors.card2,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: AppColors.purpleLight, size: 22),
    ),
  );
}
