import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../xp_progress_bar.dart';

enum AchievementStatus { unlocked, inProgress, locked }

class AchievementDetailSheet extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;
  final AchievementStatus status;
  final double? progress;
  final String? progressLabel;
  final String? requirement;
  final String? reward;
  final String? unlockedDate;

  const AchievementDetailSheet({
    super.key,
    required this.emoji,
    required this.name,
    required this.description,
    required this.status,
    this.progress,
    this.progressLabel,
    this.requirement,
    this.reward,
    this.unlockedDate,
  });

  Color get _statusColor {
    switch (status) {
      case AchievementStatus.unlocked:    return AppColors.accent;
      case AchievementStatus.inProgress:  return AppColors.purple;
      case AchievementStatus.locked:      return AppColors.textDark;
    }
  }

  String get _statusLabel {
    switch (status) {
      case AchievementStatus.unlocked:    return '✅ Obtenido';
      case AchievementStatus.inProgress:  return '⏳ En progreso';
      case AchievementStatus.locked:      return '🔒 Bloqueado';
    }
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
        children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),

          // Icono grande
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _statusColor.withValues(alpha: 0.4), width: 2),
            ),
            child: Center(
              child: Text(emoji,
                  style: TextStyle(
                      fontSize: 44,
                      color: status == AchievementStatus.locked ? null : null)),
            ),
          ),
          const SizedBox(height: 14),

          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_statusLabel,
                style: GoogleFonts.poppins(fontSize: 11, color: _statusColor, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),

          Text(name, textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(description, textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMuted, height: 1.4)),

          const SizedBox(height: 16),

          // Progreso si aplica
          if (status == AchievementStatus.inProgress && progress != null) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Progreso', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
              Text(progressLabel ?? '${(progress! * 100).round()}%',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.purple, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            XpProgressBar(progress: progress!),
            const SizedBox(height: 14),
          ],

          // Detalles
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card2,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(children: [
              if (requirement != null)
                _detailRow('📌 Requisito', requirement!),
              if (reward != null)
                _detailRow('🎁 Recompensa', reward!),
              if (unlockedDate != null)
                _detailRow('📅 Obtenido el', unlockedDate!),
              if (status == AchievementStatus.locked)
                _detailRow('🔒 Cómo desbloquear', requirement ?? 'Cumple los requisitos del logro'),
            ]),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 120,
        child: Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
      ),
      Expanded(
        child: Text(value, style: GoogleFonts.poppins(
            fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ),
    ]),
  );
}
