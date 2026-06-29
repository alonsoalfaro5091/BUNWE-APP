import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/score_ring.dart';
import '../../widgets/sleep_bar_chart.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  TimeOfDay _bedTime  = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 15);

  static const List<double> _weekHours  = [8.0, 6.5, 8.2, 7.5, 6.0, 8.5, 8.2];
  static const List<String> _weekLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  double get _hoursSlept {
    final bedMinutes  = _bedTime.hour * 60 + _bedTime.minute;
    final wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    double diff = (wakeMinutes + 1440 - bedMinutes) % 1440 / 60.0;
    return diff;
  }

  String get _hoursLabel {
    final h = _hoursSlept.floor();
    final m = ((_hoursSlept - h) * 60).round();
    return '${h}h ${m}m';
  }

  String _formatTime(TimeOfDay t) {
    final h   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m   = t.minute.toString().padLeft(2, '0');
    final suf = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $suf';
  }

  Future<void> _pickTime(bool isBed) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isBed ? _bedTime : _wakeTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.purple,
            surface: AppColors.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isBed) _bedTime = picked; else _wakeTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registro de sueño',
                style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _buildScoreCard(),
            const SizedBox(height: 10),
            _buildTimeCard(),
            const SizedBox(height: 10),
            _buildHistoryCard(),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.nightlight_round, size: 18),
                label: const Text('Registrar esta noche'),
                onPressed: () => _showConfirmDialog(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return BentoCard(
      borderColor: AppColors.purple,
      child: Row(
        children: [
          ScoreRing(score: 85, size: 100, label: 'Excelente'),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BentoLabel('Puntuación de hoy'),
              const SizedBox(height: 6),
              Text('Excelente 🌟',
                  style: GoogleFonts.fredoka(fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('Dormiste bien anoche.',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              BentoPill.green('+ 150 XP ganados'),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BentoLabel('Horas de anoche'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _timeBox('Me dormí', _formatTime(_bedTime), true)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.textDark, size: 20),
              ),
              Expanded(child: _timeBox('Desperté', _formatTime(_wakeTime), false)),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.card2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.nightlight_round, color: AppColors.purple, size: 16),
                const SizedBox(width: 6),
                Text(_hoursLabel,
                    style: GoogleFonts.fredoka(fontSize: 16, color: AppColors.textPrimary)),
                const SizedBox(width: 4),
                Text('dormidas',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String label, String value, bool isBed) {
    return GestureDetector(
      onTap: () => _pickTime(isBed),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderAccent),
        ),
        child: Column(children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.textPrimary)),
        ]),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BentoLabel('Historial semanal'),
          const SizedBox(height: 10),
          SleepBarChart(hours: _weekHours, labels: _weekLabels, todayIndex: 6, height: 70),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('Promedio', '7h 45m', AppColors.textPrimary),
              _statItem('Mejor noche', '9h 00m', AppColors.accent),
              _statItem('Meta 8h', '5/7 días', AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color valueColor) {
    return Column(children: [
      Text(label, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
      const SizedBox(height: 2),
      Text(value, style: GoogleFonts.fredoka(fontSize: 14, color: valueColor)),
    ]);
  }

  void _showConfirmDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('¿Registrar el sueño de hoy?',
              style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Dormiste $_hoursLabel esta noche',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Confirmar registro'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ),
        ]),
      ),
    );
  }
}
