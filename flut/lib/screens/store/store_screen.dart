import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/mascot_widget.dart';

class ShopItem {
  final String emoji, name, category;
  final int price;
  bool owned, equipped;
  ShopItem({required this.emoji, required this.name, required this.price,
    required this.category, this.owned = false, this.equipped = false});
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _coins = 1250;
  String _selectedCategory = 'Todo';
  final List<String> _categories = ['Todo', 'Sombreros', 'Ropa', 'Fondos', 'Accesorios'];

  final List<ShopItem> _items = [
    ShopItem(emoji:'🎩', name:'Sombrero de mago',    price:200, category:'Sombreros',  owned:true, equipped:true),
    ShopItem(emoji:'👑', name:'Corona dorada',        price:300, category:'Sombreros'),
    ShopItem(emoji:'🎀', name:'Lazo rosa',            price:150, category:'Sombreros'),
    ShopItem(emoji:'🕶️', name:'Lentes cool',          price:200, category:'Accesorios'),
    ShopItem(emoji:'🎒', name:'Mochila espacial',     price:350, category:'Ropa',      owned:true),
    ShopItem(emoji:'🌙', name:'Aura lunar',           price:500, category:'Fondos'),
    ShopItem(emoji:'🎸', name:'Guitarra mini',        price:400, category:'Accesorios'),
    ShopItem(emoji:'🌸', name:'Flores de cerezo',     price:180, category:'Fondos'),
    ShopItem(emoji:'🎮', name:'Mando retro',          price:250, category:'Accesorios'),
    ShopItem(emoji:'🌈', name:'Arcoíris fondo',       price:600, category:'Fondos'),
    ShopItem(emoji:'🧣', name:'Bufanda estrellada',   price:220, category:'Ropa'),
    ShopItem(emoji:'⚡', name:'Collar relámpago',     price:300, category:'Accesorios'),
    ShopItem(emoji:'🎓', name:'Birrete graduado',     price:350, category:'Sombreros'),
    ShopItem(emoji:'🌊', name:'Fondo oceánico',       price:450, category:'Fondos'),
  ];

  List<ShopItem> get _filtered => _selectedCategory == 'Todo'
      ? _items : _items.where((i) => i.category == _selectedCategory).toList();

  List<ShopItem> get _ownedItems => _items.where((i) => i.owned).toList();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  void _buy(ShopItem item) {
    if (item.owned) {
      setState(() { for (var i in _items) { i.equipped = false; } item.equipped = true; });
      _snack('¡${item.name} equipado! ✨', AppColors.purpleLight);
      return;
    }
    if (_coins >= item.price) {
      setState(() { _coins -= item.price; item.owned = true; });
      _snack('¡Compraste ${item.name}! 🎉', AppColors.accent);
    } else {
      _snack('No tienes suficientes estrellas ⭐', AppColors.red);
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.card2, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Text(msg, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w500)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      // Header
      Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Tienda 🛍️', style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.card2, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('⭐', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text('$_coins', style: GoogleFonts.fredoka(fontSize: 16, color: AppColors.gold)),
            ])),
        ])),
      const SizedBox(height: 10),

      // Tabs
      Container(margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: AppColors.card2, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
        child: TabBar(
          controller: _tabCtrl,
          indicator: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(12)),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: '🛍️  Tienda'),
            Tab(text: '🐰  Mi Mascota'),
          ],
        )),
      const SizedBox(height: 10),

      Expanded(child: TabBarView(controller: _tabCtrl, children: [
        _buildShopTab(),
        _buildMascotTab(),
      ])),
    ]));
  }

  // ── TAB 1: Tienda ─────────────────────────────────────────────────────────
  Widget _buildShopTab() => Column(children: [
    // Mascota preview
    Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BentoCard(child: Row(children: [
        const MascotWidget(size: 64, mood: MascotMood.excited),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tu mascota actual',
              style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
          Text('Bungwe · Nivel 7',
              style: GoogleFonts.fredoka(fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          BentoPill.green('Evolución 2/5'),
        ])),
      ]))),
    const SizedBox(height: 10),

    // Filtros
    SizedBox(height: 34, child: ListView.separated(
      scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 6),
      itemBuilder: (_, i) {
        final cat = _categories[i];
        final sel = cat == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? AppColors.purple : AppColors.card2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? AppColors.purple : AppColors.border)),
            child: Text(cat, style: GoogleFonts.poppins(fontSize: 11,
                color: sel ? Colors.white : AppColors.textMuted,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400))));
      })),
    const SizedBox(height: 10),

    // Grid de items
    Expanded(child: GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.82),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => _shopItemCard(_filtered[i]))),
  ]);

  Widget _shopItemCard(ShopItem item) => GestureDetector(
    onTap: () => _buy(item),
    child: BentoCard(
      backgroundColor: AppColors.card2,
      borderColor: item.equipped ? AppColors.accent : item.owned ? AppColors.purple : AppColors.border,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(item.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 9, color: AppColors.purplePale, fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        if (item.equipped)
          Text('✓ Equipado', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.accent))
        else if (item.owned)
          Text('Equipar', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.purpleLight))
        else
          Text('⭐ ${item.price}', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w600)),
      ]),
    ));

  // ── TAB 2: Mi Mascota ─────────────────────────────────────────────────────
  Widget _buildMascotTab() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    child: Column(children: [
      // Preview mascota con accesorios
      Container(
        width: double.infinity, padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border)),
        child: Column(children: [
          const MascotWidget(size: 120, mood: MascotMood.happy),
          const SizedBox(height: 8),
          Text('Bungwe', style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.textPrimary)),
          Text('Nivel 7 · Soñador Épico',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            BentoPill.purple('Evolución 2/5'),
            const SizedBox(width: 8),
            BentoPill.gold('🎩 Equipado'),
          ]),
        ])),
      const SizedBox(height: 14),

      // Items en inventario
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Mi inventario', style: GoogleFonts.poppins(
            fontSize: 12, color: AppColors.purplePale, fontWeight: FontWeight.w700)),
        Text('${_ownedItems.length} items',
            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
      ]),
      const SizedBox(height: 8),

      _ownedItems.isEmpty
          ? Container(
              padding: const EdgeInsets.all(24),
              child: Text('Aún no tienes items. ¡Ve a la tienda!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)))
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.85),
              itemCount: _ownedItems.length,
              itemBuilder: (_, i) {
                final item = _ownedItems[i];
                return GestureDetector(
                  onTap: () => _buy(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: item.equipped ? AppColors.purple.withValues(alpha: 0.15) : AppColors.card2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: item.equipped ? AppColors.purple : AppColors.border,
                        width: item.equipped ? 2 : 1)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(item.emoji, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 3),
                      Text(item.name, textAlign: TextAlign.center, maxLines: 2,
                          style: GoogleFonts.poppins(fontSize: 8, color: AppColors.textSecondary)),
                      if (item.equipped)
                        Text('Equipado', style: GoogleFonts.poppins(fontSize: 8, color: AppColors.accent)),
                    ])));
              }),
      const SizedBox(height: 14),

      // Evolución
      BentoCard(borderColor: AppColors.gold, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BentoLabel('Progreso de evolución'),
        const SizedBox(height: 8),
        Row(children: List.generate(5, (i) => Expanded(child: Padding(
          padding: EdgeInsets.only(right: i < 4 ? 6 : 0),
          child: Column(children: [
            Container(height: 8, decoration: BoxDecoration(
              color: i < 2 ? AppColors.purple : AppColors.card2,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: i < 2 ? AppColors.purpleLight : AppColors.border))),
            const SizedBox(height: 3),
            Text('Ev.${i + 1}', style: GoogleFonts.poppins(fontSize: 8,
                color: i < 2 ? AppColors.purpleLight : AppColors.textDark)),
          ]))))),
        const SizedBox(height: 6),
        Text('Próxima evolución al Nivel 15 · Faltan 1250 XP',
            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
      ])),
    ]));
}
