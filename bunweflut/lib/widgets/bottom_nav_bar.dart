import 'package:flutter/material.dart';
import '../core/colors.dart';

class BungweBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BungweBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF120F25),
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded,        label: 'Inicio',  index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.checklist_rounded,   label: 'Metas',   index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.nightlight_round,    label: 'Sueño',   index: 2, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.shopping_bag_rounded, label: 'Tienda', index: 3, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_rounded,      label: 'Perfil',  index: 4, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final ValueChanged<int> onTap;

  const _NavItem({required this.icon, required this.label,
    required this.index, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: isActive ? const EdgeInsets.all(6) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isActive ? AppColors.purple.withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 22,
                color: isActive ? AppColors.purpleLight : AppColors.textDark)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9,
              color: isActive ? AppColors.purpleLight : AppColors.textDark,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
        ]),
      ),
    );
  }
}
