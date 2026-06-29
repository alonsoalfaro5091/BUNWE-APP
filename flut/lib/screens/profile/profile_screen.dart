import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../core/routes.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/xp_progress_bar.dart';
import '../../widgets/sheets/sleep_reminder_sheet.dart';
import '../../widgets/sheets/sleep_goal_sheet.dart';
import 'edit_profile_screen.dart';
import 'security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TimeOfDay _reminderTime = const TimeOfDay(hour: 23, minute: 0);
  int _sleepGoalHours = 8;

  static const List<_Stat> _stats = [
    _Stat('Noches registradas',  '47'),
    _Stat('Horas de sueño total', '358h'),
    _Stat('Metas cumplidas',      '128'),
    _Stat('Puntuación promedio',  '78 pts'),
    _Stat('Mejor racha',          '18 días 🔥'),
    _Stat('Logros obtenidos',     '12/34'),
  ];

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.period == DayPeriod.am ? "AM" : "PM"}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Text('Mi perfil',
                style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _buildProfileCard(context),
            const SizedBox(height: 10),
            _buildStatsCard(),
            const SizedBox(height: 10),
            _buildSettingsCard(context),
            const SizedBox(height: 14),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return BentoCard(child: Column(children: [
      Stack(children: [
        const MascotWidget(size: 80, mood: MascotMood.happy),
        Positioned(bottom: 0, right: 0,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
            child: Container(width: 26, height: 26,
              decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2)),
              child: const Icon(Icons.edit, size: 13, color: Color(0xFF064E3B))))),
      ]),
      const SizedBox(height: 10),
      Text('Camila Ramos', style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
      Text('@camiramos · Lv. 7 Soñador Épico',
          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        BentoPill.gold('🔥 12 días'),
        const SizedBox(width: 8),
        BentoPill.purple('⭐ 1,250 XP'),
      ]),
      const SizedBox(height: 10),
      const BentoLabel('Progreso al nivel 8'),
      const SizedBox(height: 4),
      const XpProgressBar(progress: 1250 / 2000),
      const SizedBox(height: 4),
      Text('750 XP para nivel 8',
          style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary)),
    ]));
  }

  Widget _buildStatsCard() {
    return BentoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const BentoLabel('Estadísticas totales'),
      const SizedBox(height: 6),
      ..._stats.map((s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(s.label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          Text(s.value, style: GoogleFonts.fredoka(fontSize: 14, color: AppColors.textPrimary)),
        ]),
      )),
    ]));
  }

  Widget _buildSettingsCard(BuildContext context) {
    return BentoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const BentoLabel('Configuración'),
      const SizedBox(height: 6),
      // Editar perfil
      _settingRow(
        icon: Icons.person_rounded, label: 'Editar perfil',
        value: 'Camila Ramos',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
      ),
      // Seguridad
      _settingRow(
        icon: Icons.security_rounded, label: 'Seguridad y cuenta',
        value: '',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen())),
      ),
      // Recordatorio
      _settingRow(
        icon: Icons.notifications_rounded, label: 'Recordatorio de sueño',
        value: _formatTime(_reminderTime),
        iconColor: AppColors.accent,
        onTap: () async {
          final result = await showModalBottomSheet<Map<String, dynamic>>(
            context: context, isScrollControlled: true,
            backgroundColor: AppColors.card,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            builder: (_) => SleepReminderSheet(initialTime: _reminderTime),
          );
          if (result != null && mounted) {
            setState(() => _reminderTime = result['time'] as TimeOfDay);
          }
        },
      ),
      // Meta de sueño
      _settingRow(
        icon: Icons.nightlight_round, label: 'Meta de sueño',
        value: '$_sleepGoalHours horas',
        iconColor: AppColors.purpleLight,
        onTap: () async {
          final result = await showModalBottomSheet<int>(
            context: context, isScrollControlled: true,
            backgroundColor: AppColors.card,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            builder: (_) => SleepGoalSheet(initialHours: _sleepGoalHours),
          );
          if (result != null && mounted) setState(() => _sleepGoalHours = result);
        },
      ),
    ]));
  }

  Widget _settingRow({required IconData icon, required String label, required String value,
      required VoidCallback onTap, Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Icon(icon, size: 16, color: iconColor ?? AppColors.purple),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
          if (value.isNotEmpty)
            Text(value, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.purpleLight, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textDark),
        ]),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(width: double.infinity, child: OutlinedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Text('Cerrar sesión', style: GoogleFonts.fredoka(color: AppColors.red, fontSize: 18)),
          content: Text('¿Seguro que quieres cerrar sesión?',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: Text('Cancelar', style: GoogleFonts.poppins(color: AppColors.purpleLight))),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false),
              child: Text('Salir', style: GoogleFonts.poppins(color: AppColors.red, fontWeight: FontWeight.w700))),
          ],
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red, width: 1)),
      child: const Text('Cerrar sesión'),
    ));
  }
}

class _Stat {
  final String label, value;
  const _Stat(this.label, this.value);
}
