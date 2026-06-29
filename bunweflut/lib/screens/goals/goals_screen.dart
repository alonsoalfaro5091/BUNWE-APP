import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/bento_card.dart';
import '../../widgets/xp_progress_bar.dart';

class Goal {
  String title;
  String description;
  int xp;
  String category;
  bool completed;

  Goal({required this.title, this.description = '', required this.xp,
    required this.category, this.completed = false});
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _selectedCategory = 'Todas';

  // Categorías incluyen las del usuario + predeterminadas
  final List<String> _categories = ['Todas', 'Sueño', 'Salud', 'Personal', 'Estudio'];

  final List<Goal> _dailyGoals = [
    Goal(title:'Dormir 8 horas',   description:'Acostarme antes de las 11pm', xp:150, category:'Sueño',    completed:true),
    Goal(title:'Leer 20 minutos',  description:'Cualquier libro o artículo',   xp:100, category:'Personal', completed:true),
    Goal(title:'Beber 2L de agua', description:'',                              xp:100, category:'Salud',   completed:true),
    Goal(title:'Estudiar 1 hora',  description:'Flutter o Python',              xp:150, category:'Estudio',  completed:false),
    Goal(title:'Hacer ejercicio',  description:'Al menos 30 minutos',           xp:150, category:'Salud',   completed:false),
  ];

  final List<Goal> _weeklyGoals = [
    Goal(title:'5 noches de 8h seguidas', description:'', xp:300, category:'Sueño',   completed:false),
    Goal(title:'Meditar 10 min/día',      description:'', xp:200, category:'Personal', completed:false),
  ];

  List<Goal> get _filtered => _selectedCategory == 'Todas'
      ? _dailyGoals
      : _dailyGoals.where((g) => g.category == _selectedCategory).toList();

  int get _completedToday  => _dailyGoals.where((g) => g.completed).length;
  int get _totalXpAvail    => _dailyGoals.where((g) => !g.completed).fold(0, (s, g) => s + g.xp);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Mis metas 📋', style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
            GestureDetector(
              onTap: () => _showGoalSheet(),
              child: Container(width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.purple, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.add, color: Colors.white, size: 20))),
          ]),
        ),
        const SizedBox(height: 12),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(children: [
            _buildProgressCard(),
            const SizedBox(height: 10),
            _buildCategoryFilter(),
            const SizedBox(height: 10),
            _buildGoalList('HOY', _filtered, daily: true),
            const SizedBox(height: 10),
            _buildGoalList('ESTA SEMANA', _weeklyGoals),
          ]),
        )),
      ]),
    );
  }

  Widget _buildProgressCard() => BentoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const BentoLabel('Progreso hoy'),
      BentoPill.green('$_completedToday/${_dailyGoals.length} completadas'),
    ]),
    const SizedBox(height: 8),
    XpProgressBar(progress: _completedToday / _dailyGoals.length),
    const SizedBox(height: 4),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('${((_completedToday / _dailyGoals.length) * 100).round()}% completado',
          style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textMuted)),
      Text('+ $_totalXpAvail XP disponibles',
          style: GoogleFonts.poppins(fontSize: 9, color: AppColors.gold)),
    ]),
  ]));

  Widget _buildCategoryFilter() => SizedBox(height: 34,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length + 1,
      separatorBuilder: (_, __) => const SizedBox(width: 6),
      itemBuilder: (_, i) {
        if (i == _categories.length) {
          return GestureDetector(
            onTap: _addCategory,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.card2, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1, style: BorderStyle.solid)),
              child: const Icon(Icons.add, size: 14, color: AppColors.textMuted)));
        }
        final cat = _categories[i];
        final selected = cat == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? AppColors.purple : AppColors.card2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? AppColors.purple : AppColors.border)),
            child: Text(cat, style: GoogleFonts.poppins(fontSize: 11,
                color: selected ? Colors.white : AppColors.textMuted,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400))));
      },
    ));

  Widget _buildGoalList(String title, List<Goal> goals, {bool daily = false}) => BentoCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BentoLabel(title),
      const SizedBox(height: 6),
      ...goals.map((g) => _goalItem(g, daily: daily)),
    ]));

  Widget _goalItem(Goal g, {bool daily = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      GestureDetector(
        onTap: () => setState(() => g.completed = !g.completed),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 22, height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: g.completed ? AppColors.purple : Colors.transparent,
            border: Border.all(color: g.completed ? AppColors.purple : AppColors.borderAccent, width: 2)),
          child: g.completed ? const Icon(Icons.check, size: 14, color: Colors.white) : null)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(g.title, style: GoogleFonts.poppins(fontSize: 12,
            color: g.completed ? AppColors.textDark : AppColors.purplePale,
            decoration: g.completed ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textDark)),
        if (g.description.isNotEmpty)
          Text(g.description, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: AppColors.card2, borderRadius: BorderRadius.circular(6)),
            child: Text(g.category, style: GoogleFonts.poppins(fontSize: 8, color: AppColors.textMuted))),
        ]),
      ])),
      const SizedBox(width: 8),
      Row(children: [
        Text('+ ${g.xp} XP', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w600)),
        if (daily) ...[
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showGoalSheet(goal: g),
            child: const Icon(Icons.edit_rounded, size: 14, color: AppColors.textMuted)),
        ],
      ]),
    ]));

  void _addCategory() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Nueva categoría', style: GoogleFonts.fredoka(color: AppColors.textPrimary, fontSize: 18)),
        content: TextField(
          controller: ctrl, autofocus: true,
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
          decoration: const InputDecoration(hintText: 'Nombre de la categoría')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: GoogleFonts.poppins(color: AppColors.textMuted))),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() => _categories.add(ctrl.text.trim()));
                Navigator.pop(context);
              }
            },
            child: Text('Agregar', style: GoogleFonts.poppins(color: AppColors.purple, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  void _showGoalSheet({Goal? goal}) {
    final isEditing = goal != null;
    final titleCtrl = TextEditingController(text: goal?.title ?? '');
    final descCtrl  = TextEditingController(text: goal?.description ?? '');
    String selectedCat = goal?.category ?? _categories.first;
    int xpValue = goal?.xp ?? 100;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(builder: (ctx, setInner) => Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Text(isEditing ? 'Editar meta' : 'Nueva meta',
              style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          // Título
          Text('Título', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(controller: titleCtrl, autofocus: !isEditing,
            style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
            decoration: const InputDecoration(hintText: 'Escribe tu meta...')),
          const SizedBox(height: 12),
          // Descripción
          Text('Descripción (opcional)', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(controller: descCtrl, maxLines: 2,
            style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
            decoration: const InputDecoration(hintText: 'Agrega detalles...')),
          const SizedBox(height: 12),
          // Categoría/Tag
          Text('Categoría', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          SizedBox(height: 34, child: ListView(scrollDirection: Axis.horizontal,
            children: _categories.skip(1).map((cat) {
              final sel = cat == selectedCat;
              return GestureDetector(
                onTap: () => setInner(() => selectedCat = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.purple : AppColors.card2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? AppColors.purple : AppColors.border)),
                  child: Text(cat, style: GoogleFonts.poppins(fontSize: 11,
                      color: sel ? Colors.white : AppColors.textMuted,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400))));
            }).toList())),
          const SizedBox(height: 12),
          // XP
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Valor XP', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            Row(children: [
              GestureDetector(onTap: () { if (xpValue > 50) setInner(() => xpValue -= 50); },
                child: const Icon(Icons.remove_circle_rounded, color: AppColors.textDark, size: 22)),
              const SizedBox(width: 8),
              Text('$xpValue XP', style: GoogleFonts.fredoka(fontSize: 16, color: AppColors.gold)),
              const SizedBox(width: 8),
              GestureDetector(onTap: () { if (xpValue < 500) setInner(() => xpValue += 50); },
                child: const Icon(Icons.add_circle_rounded, color: AppColors.purple, size: 22)),
            ]),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            if (isEditing) ...[
              Expanded(child: OutlinedButton(
                onPressed: () { setState(() => _dailyGoals.remove(goal)); Navigator.pop(ctx); },
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red)),
                child: const Text('Eliminar'))),
              const SizedBox(width: 10),
            ],
            Expanded(child: ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    if (isEditing) {
                      goal.title       = titleCtrl.text.trim();
                      goal.description = descCtrl.text.trim();
                      goal.category    = selectedCat;
                      goal.xp          = xpValue;
                    } else {
                      _dailyGoals.add(Goal(title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim(), xp: xpValue, category: selectedCat));
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text(isEditing ? 'Guardar cambios' : 'Agregar meta'))),
          ]),
        ]),
      )),
    );
  }
}
