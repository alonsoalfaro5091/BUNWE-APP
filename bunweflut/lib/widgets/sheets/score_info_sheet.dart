import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../score_ring.dart';

class ScoreInfoSheet extends StatelessWidget {
  final int currentScore;
  const ScoreInfoSheet({super.key, required this.currentScore});

  static const List<_ScoreRange> _ranges = [
    _ScoreRange(min: 80, max: 100, emoji: '🌟', label: 'Excelente',
      color: Color(0xFF6EE7B7),
      description: 'Dormiste lo suficiente y con buena calidad. Tu cerebro consolida recuerdos, tu cuerpo repara tejidos y tus hormonas están en equilibrio óptimo.'),
    _ScoreRange(min: 60, max: 79, emoji: '✅', label: 'Bueno',
      color: Color(0xFFA78BFA),
      description: 'Cerca de la meta. Pequeños ajustes en tu hora de dormir mejorarán tu concentración y humor durante el día.'),
    _ScoreRange(min: 40, max: 59, emoji: '⚠️', label: 'Regular',
      color: Color(0xFFFCD34D),
      description: 'Rendimiento reducido. Puedes sentir fatiga acumulada, dificultad para concentrarte y mayor irritabilidad a lo largo del día.'),
    _ScoreRange(min: 20, max: 39, emoji: '😟', label: 'Preocupante',
      color: Color(0xFFF97316),
      description: 'Privación de sueño notable. Tu sistema inmune está comprometido, la memoria a corto plazo falla y el riesgo de accidentes aumenta significativamente.'),
    _ScoreRange(min: 0, max: 19, emoji: '🚨', label: 'Muy bajo',
      color: Color(0xFFF87171),
      description: 'Peligroso para tu salud. La privación severa de sueño afecta el corazón, el metabolismo y la salud mental. Prioriza descansar hoy.'),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
            _handle(),
            const SizedBox(height: 6),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text('Escala de puntuación',
                      style: GoogleFonts.fredoka(fontSize: 22, color: AppColors.textPrimary)),
                  Text('¿Qué significa tu puntaje de sueño?',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 16),
                  // Tu puntuación actual
                  _currentScoreCard(),
                  const SizedBox(height: 20),
                  Text('RANGOS DE PUNTUACIÓN',
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: AppColors.textMuted,
                          fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  ..._ranges.map((r) => _rangeCard(r)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentScoreCard() {
    final range = _ranges.firstWhere(
      (r) => currentScore >= r.min && currentScore <= r.max,
      orElse: () => _ranges.last,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: range.color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Row(
        children: [
          ScoreRing(score: currentScore, size: 80),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tu puntuación hoy', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
            const SizedBox(height: 2),
            Row(children: [
              Text(range.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(range.label, style: GoogleFonts.fredoka(fontSize: 18, color: range.color)),
            ]),
            const SizedBox(height: 4),
            Text(range.description,
                maxLines: 3, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted, height: 1.4)),
          ])),
        ],
      ),
    );
  }

  Widget _rangeCard(_ScoreRange r) {
    final bool isCurrent = currentScore >= r.min && currentScore <= r.max;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCurrent ? r.color.withValues(alpha: 0.08) : AppColors.card2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? r.color : AppColors.border,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: r.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(r.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(r.label, style: GoogleFonts.fredoka(fontSize: 16, color: r.color)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: r.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${r.min} – ${r.max}',
                    style: GoogleFonts.poppins(fontSize: 10, color: r.color, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 4),
            Text(r.description,
                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted, height: 1.4)),
          ])),
        ],
      ),
    );
  }

  Widget _handle() => Center(
    child: Container(width: 40, height: 4,
        decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
  );
}

class _ScoreRange {
  final int min, max;
  final String emoji, label, description;
  final Color color;
  const _ScoreRange({required this.min, required this.max, required this.emoji,
    required this.label, required this.description, required this.color});
}
