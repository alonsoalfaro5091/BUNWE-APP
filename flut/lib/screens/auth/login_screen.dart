import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../core/routes.dart';
import '../../widgets/mascot_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  bool _obscurePass   = true;
  bool _isLoading     = false;
  bool _showRegister  = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Mascota y título
              const MascotWidget(size: 80, mood: MascotMood.happy),
              const SizedBox(height: 12),
              Text(
                _showRegister ? '¡Únete a Bungwe!' : '¡Bienvenido!',
                style: GoogleFonts.fredoka(fontSize: 26, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                _showRegister
                    ? 'Crea tu cuenta y comienza a dormir mejor'
                    : 'Inicia sesión para continuar',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),

              // Form
              if (_showRegister) ...[
                _fieldLabel('Nombre de usuario'),
                const SizedBox(height: 6),
                _textField(hint: 'tunombre', icon: Icons.person_rounded),
                const SizedBox(height: 12),
              ],

              _fieldLabel('Correo electrónico'),
              const SizedBox(height: 6),
              _textField(
                controller: _emailCtrl,
                hint: 'tucorreo@ejemplo.com',
                icon: Icons.email_rounded,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              _fieldLabel('Contraseña'),
              const SizedBox(height: 6),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePass,
                style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.textMuted, size: 20),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePass = !_obscurePass),
                    child: Icon(
                      _obscurePass ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: AppColors.textDark,
                      size: 20,
                    ),
                  ),
                ),
              ),

              if (!_showRegister) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text('¿Olvidaste tu contraseña?',
                        style: GoogleFonts.poppins(fontSize: 11, color: AppColors.purple)),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Botón principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(_showRegister ? 'Crear cuenta' : 'Iniciar sesión'),
                ),
              ),

              const SizedBox(height: 16),
              _divider(),
              const SizedBox(height: 16),

              // Google
              _googleButton(),

              const SizedBox(height: 24),

              // Cambiar entre login/register
              GestureDetector(
                onTap: () => setState(() => _showRegister = !_showRegister),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: _showRegister
                          ? '¿Ya tienes cuenta? '
                          : '¿No tienes cuenta? ',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textDark),
                    ),
                    TextSpan(
                      text: _showRegister ? 'Inicia sesión' : 'Regístrate gratis',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.purple,
                          fontWeight: FontWeight.w600),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      );

  Widget _textField({
    TextEditingController? controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
  }) =>
      TextField(
        controller: controller,
        keyboardType: keyboard,
        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        ),
      );

  Widget _divider() => Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('o continúa con',
                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textDark)),
          ),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      );

  Widget _googleButton() => OutlinedButton.icon(
        onPressed: _login,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
        icon: _googleIcon(),
        label: Text('Continuar con Google',
            style: GoogleFonts.poppins(color: AppColors.purplePale, fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _googleIcon() => SizedBox(
        width: 20,
        height: 20,
        child: CustomPaint(painter: _GoogleIconPainter()),
      );
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r  = s.width / 2;
    c.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), -1.57, 1.57, false,
        Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = 3);
    c.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 0, 1.57, false,
        Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.stroke..strokeWidth = 3);
    c.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 1.57, 1.57, false,
        Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.stroke..strokeWidth = 3);
    c.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), 3.14, 1.57, false,
        Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.stroke..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(_) => false;
}
