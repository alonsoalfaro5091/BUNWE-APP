import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';

class SleepReminderSheet extends StatefulWidget {
  final TimeOfDay initialTime;
  const SleepReminderSheet({super.key, this.initialTime = const TimeOfDay(hour: 23, minute: 0)});

  @override
  State<SleepReminderSheet> createState() => _SleepReminderSheetState();
}

class _SleepReminderSheetState extends State<SleepReminderSheet> {
  late TimeOfDay _time;
  bool _enabled = true;
  final List<bool> _days = [true, true, true, true, true, false, false]; // L-D
  final List<String> _dayNames = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
  }

  String _formatTime(TimeOfDay t) {
    final h   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m   = t.minute.toString().padLeft(2, '0');
    final suf = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $suf';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context, initialTime: _time,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.purple, surface: AppColors.card),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
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
            const Icon(Icons.notifications_rounded, color: AppColors.purple, size: 22),
            const SizedBox(width: 8),
            Text('Recordatorio de sueño',
                style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
            const Spacer(),
            Switch(
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
              activeThumbColor: AppColors.purple,
            ),
          ]),
          Text('Te avisaremos cuando sea hora de dormir',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 20),

          // Hora
          Text('HORA DEL RECORDATORIO',
              style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted,
                  fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _enabled ? _pickTime : null,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _enabled ? AppColors.purple : AppColors.border, width: 1.5),
              ),
              child: Row(children: [
                const Icon(Icons.access_time_rounded, color: AppColors.purple, size: 24),
                const SizedBox(width: 12),
                Text(_formatTime(_time),
                    style: GoogleFonts.fredoka(fontSize: 28, color: AppColors.textPrimary)),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: AppColors.textDark, size: 22),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Días
          Text('REPETIR',
              style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted,
                  fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(children: List.generate(7, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 6 ? 6 : 0),
                child: GestureDetector(
                  onTap: _enabled ? () => setState(() => _days[i] = !_days[i]) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 38,
                    decoration: BoxDecoration(
                      color: _days[i] ? AppColors.purple : AppColors.card2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _days[i] ? AppColors.purple : AppColors.border, width: 1),
                    ),
                    child: Center(child: Text(_dayNames[i],
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _days[i] ? Colors.white : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ))),
                  ),
                ),
              ),
            );
          })),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, {'time': _time, 'days': _days, 'enabled': _enabled}),
              child: const Text('Guardar recordatorio'),
            ),
          ),
        ],
      ),
    );
  }
}
