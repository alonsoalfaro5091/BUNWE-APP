import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/xp_progress_bar.dart';
import '../../widgets/sheets/achievement_detail_sheet.dart';

class _Achievement {
  final String emoji, name, description;
  final AchievementStatus status;
  final double? progress;
  final String? progressLabel, requirement, reward, unlockedDate;
  const _Achievement({required this.emoji, required this.name, required this.description,
    required this.status, this.progress, this.progressLabel,
    this.requirement, this.reward, this.unlockedDate});
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const List<_Achievement> _unlocked = [
    _Achievement(emoji:'🌙', name:'Primera noche', description:'Registra tu primer sueño',
      status: AchievementStatus.unlocked, requirement:'Registra 1 noche', reward:'+ 50 XP', unlockedDate:'1 Jun 2025'),
    _Achievement(emoji:'🔥', name:'Racha de 7 días', description:'7 días seguidos de 8h',
      status: AchievementStatus.unlocked, requirement:'7 noches consecutivas', reward:'+ 200 XP', unlockedDate:'8 Jun 2025'),
    _Achievement(emoji:'⭐', name:'Nivel 5', description:'Alcanza el nivel 5',
      status: AchievementStatus.unlocked, requirement:'Acumula 1000 XP', reward:'+ 100 XP + Sombrero básico', unlockedDate:'5 Jun 2025'),
    _Achievement(emoji:'💎', name:'Puntuación 100', description:'Obtén 100 pts en un día',
      status: AchievementStatus.unlocked, requirement:'Duerme 9h+ de calidad', reward:'+ 300 XP', unlockedDate:'10 Jun 2025'),
    _Achievement(emoji:'🎯', name:'10 metas cumplidas', description:'Completa 10 metas',
      status: AchievementStatus.unlocked, requirement:'Cumple 10 metas cualquiera', reward:'+ 150 XP', unlockedDate:'12 Jun 2025'),
    _Achievement(emoji:'🐰', name:'Evolución 2', description:'Evoluciona tu mascota',
      status: AchievementStatus.unlocked, requirement:'Nivel 5 + 500 XP acumulados', reward:'Nueva skin mascota', unlockedDate:'15 Jun 2025'),
  ];

  static const List<_Achievement> _inProgress = [
    _Achievement(emoji:'🏆', name:'Racha de 30 días', description:'30 días consecutivos de 8h',
      status: AchievementStatus.inProgress, progress: 12/30, progressLabel:'12/30 días',
      requirement:'30 noches de 8h seguidas', reward:'+ 1000 XP + Corona dorada'),
    _Achievement(emoji:'🌟', name:'Nivel 10', description:'Alcanza el nivel 10',
      status: AchievementStatus.inProgress, progress: 7/10, progressLabel:'Lv. 7/10',
      requirement:'Acumula 4500 XP total', reward:'+ 500 XP + Evolución 3'),
    _Achievement(emoji:'💪', name:'50 metas completas', description:'Completa 50 metas',
      status: AchievementStatus.inProgress, progress: 28/50, progressLabel:'28/50',
      requirement:'Cumple 50 metas en total', reward:'+ 400 XP + Guitarra mini'),
    _Achievement(emoji:'🧘', name:'Semana zen', description:'Medita 7 días seguidos',
      status: AchievementStatus.inProgress, progress: 3/7, progressLabel:'3/7 días',
      requirement:'Meta "Meditar" 7 días seguidos', reward:'+ 250 XP'),
  ];

  static const List<_Achievement> _locked = [
    _Achievement(emoji:'👑', name:'Racha 100 días', description:'100 días consecutivos',
      status: AchievementStatus.locked, requirement:'100 noches de 8h seguidas', reward:'+ 5000 XP + Skin legendario'),
    _Achievement(emoji:'🦄', name:'Evolución final', description:'Alcanza evolución 5/5',
      status: AchievementStatus.locked, requirement:'Nivel 50 + 20000 XP total', reward:'Skin último del juego'),
    _Achievement(emoji:'💫', name:'Puntuación perfecta', description:'100 pts 7 días seguidos',
      status: AchievementStatus.locked, requirement:'Score 100 durante 7 días', reward:'+ 2000 XP + Aura especial'),
    _Achievement(emoji:'🏅', name:'Leyenda del sueño', description:'Completa todos los logros',
      status: AchievementStatus.locked, requirement:'Obtén todos los demás logros', reward:'Título: Leyenda Bungwe'),
  ];

  void _showDetail(BuildContext context, _Achievement a) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => AchievementDetailSheet(
        emoji: a.emoji, name: a.name, description: a.description,
        status: a.status, progress: a.progress, progressLabel: a.progressLabel,
        requirement: a.requirement, reward: a.reward, unlockedDate: a.unlockedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Logros 🏆', style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
          Text('Toca un logro para ver los detalles',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 14),
          _buildSummaryCard(),
          const SizedBox(height: 14),
          _buildSection(context, 'Obtenidos ✅', _unlocked),
          const SizedBox(height: 14),
          _buildSection(context, 'En progreso ⏳', _inProgress, showProgress: true),
          const SizedBox(height: 14),
          _buildSection(context, 'Bloqueados 🔒', _locked, locked: true),
        ]),
      ),
    );
  }

  Widget _buildSummaryCard() => BentoCard(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
    _statItem('${_unlocked.length}', 'Obtenidos', AppColors.textPrimary),
    Container(width: 1, height: 36, color: AppColors.border),
    _statItem('${_inProgress.length}', 'En progreso', AppColors.textPrimary),
    Container(width: 1, height: 36, color: AppColors.border),
    _statItem('${_locked.length}', 'Bloqueados', AppColors.textMuted),
  ]));

  Widget _statItem(String v, String l, Color c) => Column(children: [
    Text(v, style: GoogleFonts.fredoka(fontSize: 20, color: c)),
    Text(l, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
  ]);

  Widget _buildSection(BuildContext context, String title, List<_Achievement> items,
      {bool showProgress = false, bool locked = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.purplePale,
            fontWeight: FontWeight.w700, letterSpacing: 0.5))),
      GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.82),
        itemCount: items.length,
        itemBuilder: (_, i) => _achieveItem(context, items[i], showProgress: showProgress, locked: locked)),
    ]);
  }

  Widget _achieveItem(BuildContext context, _Achievement a, {bool showProgress = false, bool locked = false}) {
    return GestureDetector(
      onTap: () => _showDetail(context, a),
      child: Opacity(
        opacity: locked ? 0.4 : 1.0,
        child: BentoCard(
          backgroundColor: AppColors.card2,
          borderColor: a.status == AchievementStatus.inProgress ? AppColors.purple : AppColors.border,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(a.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(a.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
            if (showProgress && a.progress != null) ...[
              const SizedBox(height: 4),
              Text(a.progressLabel ?? '', style: GoogleFonts.poppins(fontSize: 8, color: AppColors.purple)),
              const SizedBox(height: 3),
              XpProgressBar(progress: a.progress!, height: 4),
            ],
            if (locked) Padding(padding: const EdgeInsets.only(top: 3),
              child: Text('🔒', style: GoogleFonts.poppins(fontSize: 9))),
          ]),
        ),
      ),
    );
  }
}
