import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../bento_card.dart';
import '../mascot_widget.dart';

class StreakSheet extends StatelessWidget {
  const StreakSheet({super.key});

  static const int _currentStreak = 12;
  static const int _bestStreak    = 18;

  // 0=miss, 1=done(8h), 2=great(9h+), 3=today, 4=future
  static const List<int> _calendarData = [
    4, 4, 0, 1, 1, 0, 1,
    1, 1, 2, 1, 1, 1, 1,
    1, 1, 1, 3, 4, 4, 4,
    4, 4, 4, 4, 4, 4, 4,
  ];
  static const List<String> _dayHeaders = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildHero(),
              const SizedBox(height: 16),
              _buildCalendar(),
              const SizedBox(height: 10),
              _buildStatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(clipBehavior: Clip.none, children: [
          const MascotWidget(size: 88, mood: MascotMood.happy),
          const Positioned(
            top: -6, right: -8,
            child: Text('🌙', style: TextStyle(fontSize: 24)),
          ),
        ]),
        const SizedBox(width: 18),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Racha de sueño',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$_currentStreak',
                    style: GoogleFonts.fredoka(fontSize: 48, color: AppColors.gold, height: 1)),
                const SizedBox(width: 6),
                Text('días',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textMuted)),
              ],
            ),
            Text('consecutivos con 8h+ de sueño',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            BentoPill.gold('🔥 ¡Racha épica!'),
          ]),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return BentoCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BentoLabel('Junio 2026'),
        const SizedBox(height: 8),
        Row(
          children: _dayHeaders.map((d) => Expanded(
            child: Text(d,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 9, color: AppColors.textDark, fontWeight: FontWeight.w600)),
          )).toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, crossAxisSpacing: 3, mainAxisSpacing: 3, childAspectRatio: 1,
          ),
          itemCount: _calendarData.length,
          itemBuilder: (_, i) => _calDay(i + 1, _calendarData[i]),
        ),
        const SizedBox(height: 10),
        _buildLegend(),
      ]),
    );
  }

  Widget _calDay(int day, int type) {
    Color bg, fg, border;
    switch (type) {
      case 0:
        bg = const Color(0xFF1F1235); fg = AppColors.red;        border = AppColors.red;          break;
      case 1:
        bg = AppColors.purpleDark;   fg = AppColors.purplePale;  border = AppColors.purple;       break;
      case 2:
        bg = AppColors.accentDark;   fg = AppColors.accent;      border = const Color(0xFF34D399); break;
      case 3:
        bg = AppColors.purple;       fg = Colors.white;          border = AppColors.purpleLight;  break;
      default:
        bg = AppColors.card2;        fg = AppColors.textDark;    border = AppColors.border;
    }
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1),
      ),
      child: Center(
        child: Text(
          type == 4 ? '·' : '$day',
          style: TextStyle(fontSize: 9, color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final labels = ['8h cumplidas', '+9h', 'No cumplido'];
    final colors = <Color>[AppColors.purpleDark, AppColors.accentDark, const Color(0xFF1F1235)];
    return Row(
      children: List.generate(labels.length, (i) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: colors[i], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 4),
          Text(labels[i],
              style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
        ]),
      )),
    );
  }

  Widget _buildStatsRow() {
    return Row(children: [
      Expanded(child: BentoCard(
        child: Column(children: [
          Text('$_currentStreak',
              style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.gold)),
          Text('Racha actual',
              style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted),
              textAlign: TextAlign.center),
        ]),
      )),
      const SizedBox(width: 8),
      Expanded(child: BentoCard(
        child: Column(children: [
          Text('$_bestStreak',
              style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.textPrimary)),
          Text('Récord personal',
              style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted),
              textAlign: TextAlign.center),
        ]),
      )),
      const SizedBox(width: 8),
      Expanded(child: BentoCard(
        child: Column(children: [
          Text('72%',
              style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.accent)),
          Text('Este mes',
              style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted),
              textAlign: TextAlign.center),
        ]),
      )),
    ]);
  }
}
