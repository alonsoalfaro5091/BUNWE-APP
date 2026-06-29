import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../xp_progress_bar.dart';

class LevelSheet extends StatelessWidget {
  final int currentLevel;
  final int currentXp;
  const LevelSheet({super.key, required this.currentLevel, required this.currentXp});

  static List<_LevelData> buildLevels() {
    final List<_LevelData> levels = [];
    final rewards = [
      '⭐ 50 estrellas', '🎩 Sombrero básico', '⭐ 75 estrellas',
      '🌙 Aura nocturna',  '⭐ 100 estrellas',  '🎀 Lazo especial',
      '⭐ 150 estrellas', '🦊 Skin: Zorro rojo','⭐ 200 estrellas',
      '👑 Corona dorada',  '⭐ 250 estrellas',  '🌈 Fondo arcoíris',
      '⭐ 300 estrellas', '🎮 Mando retro',     '⭐ 350 estrellas',
      '🧣 Bufanda estelar','⭐ 400 estrellas',  '⚡ Collar relámpago',
      '⭐ 450 estrellas', '🦋 Evolución final', '⭐ 500 estrellas',
    ];
    for (int i = 1; i <= 100; i++) {
      int xpRequired;
      if (i <= 10)       xpRequired = i * 100;
      else if (i <= 25)  xpRequired = 1000 + (i - 10) * 150;
      else if (i <= 50)  xpRequired = 3250 + (i - 25) * 250;
      else if (i <= 75)  xpRequired = 9500 + (i - 50) * 400;
      else               xpRequired = 19500 + (i - 75) * 600;

      final reward = (i % 5 == 0) ? rewards[((i ~/ 5) - 1) % rewards.length] : null;
      levels.add(_LevelData(level: i, xpRequired: xpRequired, reward: reward));
    }
    return levels;
  }

  @override
  Widget build(BuildContext context) {
    final levels = buildLevels();
    final nextXp  = currentLevel < 100 ? levels[currentLevel].xpRequired : 0;
    final progress = nextXp > 0 ? currentXp / nextXp : 1.0;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sistema de niveles',
                    style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
                Text('Niveles 1–100 · Recompensas y XP necesaria',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(height: 12),
                // Tu nivel actual
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.purple, width: 1.5),
                  ),
                  child: Row(children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text('⭐',
                          style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Nivel $currentLevel · Soñador Épico',
                          style: GoogleFonts.fredoka(fontSize: 16, color: AppColors.textPrimary)),
                      Text('$currentXp / $nextXp XP',
                          style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      XpProgressBar(progress: progress.clamp(0, 1.0)),
                    ])),
                  ]),
                ),
                const SizedBox(height: 14),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: levels.length,
                itemBuilder: (_, i) => _levelRow(levels[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelRow(_LevelData d) {
    final isCurrent  = d.level == currentLevel;
    final isUnlocked = d.level < currentLevel;
    final hasReward  = d.reward != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.purple.withValues(alpha: 0.12)
            : hasReward ? AppColors.gold.withValues(alpha: 0.05)
            : AppColors.card2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? AppColors.purple
              : hasReward ? AppColors.gold.withValues(alpha: 0.4)
              : AppColors.border,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Número de nivel
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.purple
                  : isUnlocked ? AppColors.purpleDark
                  : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(
              '${d.level}',
              style: GoogleFonts.fredoka(
                fontSize: isUnlocked || isCurrent ? 14 : 12,
                color: isCurrent ? Colors.white
                    : isUnlocked ? AppColors.purpleLight
                    : AppColors.textDark,
              ),
            )),
          ),
          const SizedBox(width: 10),
          // XP
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Nivel ${d.level}${isCurrent ? "  ← Tú" : ""}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isCurrent ? AppColors.purpleLight : AppColors.textSecondary,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            Text(
              '${d.xpRequired.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} XP necesarios',
              style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted),
            ),
          ])),
          // Recompensa
          if (d.reward != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.goldDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                d.reward!,
                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w600),
              ),
            )
          else if (isUnlocked)
            const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 18)
          else
            const Icon(Icons.lock_rounded, color: AppColors.textDark, size: 16),
        ],
      ),
    );
  }
}

class _LevelData {
  final int level, xpRequired;
  final String? reward;
  const _LevelData({required this.level, required this.xpRequired, this.reward});
}
