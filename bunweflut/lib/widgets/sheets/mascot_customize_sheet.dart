import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../mascot_widget.dart';

class MascotCustomizeSheet extends StatefulWidget {
  const MascotCustomizeSheet({super.key});

  @override
  State<MascotCustomizeSheet> createState() => _MascotCustomizeSheetState();
}

class _MascotCustomizeSheetState extends State<MascotCustomizeSheet> {
  String? _equippedHat;
  String? _equippedAcc;
  MascotMood _mood = MascotMood.happy;

  final List<_Item> _hats = [
    _Item('none',     '—',  'Sin sombrero', true),
    _Item('wizard',   '🎩', 'Sombrero mago', true),
    _Item('crown',    '👑', 'Corona dorada', true),
    _Item('bow',      '🎀', 'Lazo rosa',     false),
    _Item('sunglasses','🕶️','Lentes cool',  false),
  ];

  final List<_Item> _accessories = [
    _Item('none',     '—',  'Ninguno',          true),
    _Item('backpack', '🎒', 'Mochila espacial',  true),
    _Item('guitar',   '🎸', 'Guitarra mini',     false),
    _Item('necklace', '⚡', 'Collar relámpago',  false),
    _Item('flowers',  '🌸', 'Flores de cerezo',  false),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
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
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
                children: [
                  Text('Personaliza a Bungwe',
                      style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
                  Text('Elige los accesorios que quieres ponerle',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 20),

                  // Preview mascota
                  Center(
                    child: Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.card2,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.purple, width: 2),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        MascotWidget(size: 110, mood: _mood),
                        if (_equippedHat != null && _equippedHat != 'none')
                          Text(_hats.firstWhere((h) => h.id == _equippedHat).emoji,
                              style: const TextStyle(fontSize: 26)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Humor
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _moodChip('😊 Feliz',     MascotMood.happy),
                    const SizedBox(width: 8),
                    _moodChip('🌙 Dormido',   MascotMood.sleeping),
                    const SizedBox(width: 8),
                    _moodChip('🎉 Emocionado', MascotMood.excited),
                  ]),
                  const SizedBox(height: 20),

                  _sectionTitle('Sombreros y gorros'),
                  const SizedBox(height: 8),
                  _itemGrid(_hats, _equippedHat, (id) => setState(() => _equippedHat = id)),

                  const SizedBox(height: 16),
                  _sectionTitle('Accesorios'),
                  const SizedBox(height: 8),
                  _itemGrid(_accessories, _equippedAcc, (id) => setState(() => _equippedAcc = id)),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Guardar personalización'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodChip(String label, MascotMood mood) {
    final selected = _mood == mood;
    return GestureDetector(
      onTap: () => setState(() => _mood = mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.purple : AppColors.card2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.purple : AppColors.border),
        ),
        child: Text(label, style: GoogleFonts.poppins(
            fontSize: 11, color: selected ? Colors.white : AppColors.textMuted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: GoogleFonts.poppins(
      fontSize: 12, color: AppColors.purplePale, fontWeight: FontWeight.w700));

  Widget _itemGrid(List<_Item> items, String? equipped, ValueChanged<String> onTap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item    = items[i];
        final isEquip = item.id == equipped;
        return GestureDetector(
          onTap: item.owned ? () => onTap(item.id) : null,
          child: Opacity(
            opacity: item.owned ? 1 : 0.4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isEquip ? AppColors.purple.withValues(alpha: 0.2) : AppColors.card2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEquip ? AppColors.purple : AppColors.border,
                  width: isEquip ? 2 : 1,
                ),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(item.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 3),
                Text(item.name, textAlign: TextAlign.center, maxLines: 2,
                    style: GoogleFonts.poppins(fontSize: 8, color: AppColors.textSecondary)),
                if (!item.owned)
                  Text('🔒', style: GoogleFonts.poppins(fontSize: 9)),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _Item {
  final String id, emoji, name;
  final bool owned;
  const _Item(this.id, this.emoji, this.name, this.owned);
}
