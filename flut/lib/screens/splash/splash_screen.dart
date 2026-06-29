import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../core/routes.dart';
import '../../widgets/mascot_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _floatAnim = Tween<double>(begin: -6, end: 6)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Mascota flotando
                AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(0, _floatAnim.value),
                    child: child,
                  ),
                  child: const MascotWidget(size: 150, mood: MascotMood.sleeping),
                ),

                const SizedBox(height: 28),

                // Logo
                Text(
                  'BUNGWE',
                  style: GoogleFonts.fredoka(
                    fontSize: 40,
                    color: AppColors.textPrimary,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'DUERME  ·  DESCANSA  ·  EVOLUCIONA',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.purple,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(width: 50, height: 2, decoration: BoxDecoration(
                  color: AppColors.borderAccent,
                  borderRadius: BorderRadius.circular(2),
                )),
                const SizedBox(height: 18),
                Text(
                  '"Duerme como un héroe,\nevoluciona cada día."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const Spacer(flex: 2),

                // Botones
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Comenzar →'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes cuenta? ',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                      child: Text('Inicia sesión',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.purpleLight, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Dots indicador
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(true),
                    const SizedBox(width: 6),
                    _dot(false),
                    const SizedBox(width: 6),
                    _dot(false),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: active ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: active ? AppColors.purple : AppColors.border,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
