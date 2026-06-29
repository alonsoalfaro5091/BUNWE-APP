import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/score_ring.dart';
import '../../widgets/sleep_bar_chart.dart';
import '../../widgets/xp_progress_bar.dart';
import '../../widgets/sheets/score_info_sheet.dart';
import '../../widgets/sheets/sleep_history_sheet.dart';
import '../../widgets/sheets/level_sheet.dart';
import '../../widgets/sheets/mascot_customize_sheet.dart';
import '../../widgets/sheets/streak_sheet.dart';

class DashboardTab extends StatelessWidget {
  final ValueChanged<int>? onNavigate;
  const DashboardTab({super.key, this.onNavigate});

  static const int    _score      = 85;
  static const int    _streakDays = 12;
  static const int    _level      = 7;
  static const int    _currentXp  = 1250;
  static const int    _maxXp      = 2000;
  static const String _horasAnoche = '8h 15m';
  static const List<double> _weekHours  = [7.0, 6.5, 8.0, 7.5, 6.0, 7.0, 8.2];
  static const List<String> _weekLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildScoreRow(context),
            const SizedBox(height: 10),
            _buildStreakCard(context),
            const SizedBox(height: 10),
            _buildLevelRow(context),
            const SizedBox(height: 10),
            _buildQuickAccess(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Buenas noches 🌙',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
          Text('Hola, Camila 👋',
              style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
        ]),
        GestureDetector(
          onTap: () => onNavigate?.call(4),
          child: Stack(children: [
            Container(width: 42, height: 42,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.card2,
                border: Border.all(color: AppColors.purple, width: 2)),
              child: const Center(child: Text('🐰', style: TextStyle(fontSize: 20)))),
            Positioned(top: 0, right: 0,
              child: Container(width: 12, height: 12,
                decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 1.5)))),
          ]),
        ),
      ],
    );
  }

  Widget _buildScoreRow(BuildContext context) {
    return Row(children: [
      Expanded(child: BentoCard(
        borderColor: AppColors.purple,
        onTap: () => showModalBottomSheet(
          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (_) => ScoreInfoSheet(currentScore: _score)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const BentoLabel('Puntuación'),
            const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textMuted),
          ]),
          const SizedBox(height: 8),
          ScoreRing(score: _score, size: 90, label: 'pts hoy'),
        ]),
      )),
      const SizedBox(width: 10),
      Expanded(child: BentoCard(
        onTap: () => showModalBottomSheet(
          context: context, isScrollControlled: true,
          backgroundColor: AppColors.card,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (_) => const SleepHistorySheet()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const BentoLabel('Anoche'),
            const Icon(Icons.bar_chart_rounded, size: 14, color: AppColors.textMuted),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.nightlight_round, color: AppColors.purple, size: 20),
            const SizedBox(width: 4),
            Text(_horasAnoche, style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 6),
          BentoPill.green('✓ Meta cumplida'),
          const SizedBox(height: 8),
          SleepBarChart(hours: _weekHours, labels: _weekLabels, todayIndex: 6, height: 50),
        ]),
      )),
    ]);
  }

  Widget _buildStreakCard(BuildContext context) {
    return BentoCard(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const StreakSheet(),
      ),
      child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BentoLabel('Racha actual'),
        const SizedBox(height: 4),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('$_streakDays', style: GoogleFonts.fredoka(fontSize: 38, color: AppColors.textPrimary)),
          const SizedBox(width: 4),
          Text('días', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 6),
        BentoPill.gold('🔥 ¡Racha épica!'),
        const SizedBox(height: 10),
        _miniStreakDots(),
      ])),
      const Text('🔥', style: TextStyle(fontSize: 40)),
    ]));
  }

  Widget _miniStreakDots() {
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final done = [true, true, true, true, true, false, false];
    return Row(children: List.generate(7, (i) {
      final isToday = i == 5;
      return Expanded(child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        height: 24,
        decoration: BoxDecoration(
          color: isToday ? AppColors.accent : done[i] ? AppColors.purple : AppColors.card2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isToday ? const Color(0xFF34D399) : done[i] ? AppColors.purpleLight : AppColors.border,
            width: 1)),
        child: Center(child: Text(days[i], style: TextStyle(
          fontSize: 9,
          color: isToday ? const Color(0xFF064E3B) : done[i] ? Colors.white : AppColors.textMuted,
          fontWeight: FontWeight.w600)))));
    }));
  }

  Widget _buildLevelRow(BuildContext context) {
    return Row(children: [
      Expanded(child: BentoCard(
        onTap: () => showModalBottomSheet(
          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (_) => LevelSheet(currentLevel: _level, currentXp: _currentXp)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const BentoLabel('Nivel'),
            const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.textMuted),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 6),
            Text('Lv. $_level', style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 4),
          Text('$_currentXp / $_maxXp XP', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          XpProgressBar(progress: _currentXp / _maxXp),
          const SizedBox(height: 4),
          Text('${_maxXp - _currentXp} XP para nivel ${_level + 1}',
              style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary)),
        ]),
      )),
      const SizedBox(width: 10),
      Expanded(child: BentoCard(
        onTap: () => showModalBottomSheet(
          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (_) => const MascotCustomizeSheet()),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const BentoLabel('Mascota'),
            const Icon(Icons.edit_rounded, size: 12, color: AppColors.textMuted),
          ]),
          const SizedBox(height: 4),
          const MascotWidget(size: 70, mood: MascotMood.happy),
          const SizedBox(height: 6),
          BentoPill.purple('Evolución 2/5'),
        ]),
      )),
    ]);
  }

  Widget _buildQuickAccess(BuildContext context) {
    return Row(children: [
      Expanded(child: BentoCard(
        onTap: () => onNavigate?.call(1),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('📋', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text('Metas', style: GoogleFonts.poppins(fontSize: 10,
              color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ]),
      )),
      const SizedBox(width: 10),
      Expanded(child: BentoCard(
        borderColor: AppColors.purple,
        onTap: () => onNavigate?.call(2),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🌙', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text('Dormir', style: GoogleFonts.poppins(fontSize: 10,
              color: AppColors.purple, fontWeight: FontWeight.w600)),
        ]),
      )),
      const SizedBox(width: 10),
      Expanded(child: BentoCard(
        onTap: () => onNavigate?.call(3),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🛍️', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text('Tienda', style: GoogleFonts.poppins(fontSize: 10,
              color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ]),
      )),
    ]);
  }
}
