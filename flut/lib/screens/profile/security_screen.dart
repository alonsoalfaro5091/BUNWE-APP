import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  static const String _email = 'camila@ejemplo.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Seguridad y cuenta')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle('CORREO ENLAZADO'),
          const SizedBox(height: 8),
          _infoCard(
            icon: Icons.email_rounded,
            label: 'Correo electrónico',
            value: _email,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Verificado',
                  style: GoogleFonts.poppins(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 20),

          _sectionTitle('CONTRASEÑA'),
          const SizedBox(height: 8),
          _actionCard(
            icon: Icons.lock_rounded,
            label: 'Cambiar contraseña',
            subtitle: 'Última actualización hace 30 días',
            onTap: () => _showChangePasswordSheet(),
          ),
          const SizedBox(height: 8),
          _actionCard(
            icon: Icons.help_rounded,
            label: '¿Olvidaste tu contraseña?',
            subtitle: 'Recuperar acceso vía correo',
            onTap: () => _showForgotPasswordFlow(),
            iconColor: AppColors.gold,
          ),
          const SizedBox(height: 20),

          _sectionTitle('SESIONES'),
          const SizedBox(height: 8),
          _infoCard(
            icon: Icons.phone_android_rounded,
            label: 'Este dispositivo',
            value: 'Android · Activo ahora',
          ),
          const SizedBox(height: 8),
          _infoCard(
            icon: Icons.computer_rounded,
            label: 'Sesión anterior',
            value: 'Linux · Hace 3 días',
          ),
          const SizedBox(height: 20),

          _sectionTitle('ZONA DE PELIGRO'),
          const SizedBox(height: 8),
          _actionCard(
            icon: Icons.delete_forever_rounded,
            label: 'Eliminar cuenta',
            subtitle: 'Acción irreversible',
            onTap: _confirmDelete,
            iconColor: AppColors.red,
            textColor: AppColors.red,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: GoogleFonts.poppins(
      fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w700, letterSpacing: 1));

  Widget _infoCard({required IconData icon, required String label, required String value, Widget? trailing}) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Container(width: 38, height: 38,
              decoration: BoxDecoration(color: AppColors.card2, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.purple, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
            Text(value,  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          ])),
          if (trailing != null) trailing,
        ]),
      );

  Widget _actionCard({required IconData icon, required String label, required String subtitle,
      required VoidCallback onTap, Color? iconColor, Color? textColor}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            Container(width: 38, height: 38,
                decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.purple).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor ?? AppColors.purple, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: GoogleFonts.poppins(
                  fontSize: 13, color: textColor ?? AppColors.textPrimary, fontWeight: FontWeight.w500)),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
            ])),
            Icon(Icons.chevron_right_rounded, color: AppColors.textDark, size: 20),
          ]),
        ),
      );

  // ── Cambiar contraseña ────────────────────────────────────────────────────
  void _showChangePasswordSheet() {
    final currCtrl    = TextEditingController();
    final newCtrl     = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 14),
          Text('Cambiar contraseña',
              style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          _passField(currCtrl, 'Contraseña actual'),
          const SizedBox(height: 10),
          _passField(newCtrl, 'Nueva contraseña'),
          const SizedBox(height: 10),
          _passField(confirmCtrl, 'Confirmar nueva contraseña'),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar nueva contraseña'),
          )),
        ]),
      ),
    );
  }

  // ── Olvidé mi contraseña (3 pasos) ───────────────────────────────────────
  void _showForgotPasswordFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _ForgotPasswordFlow(email: _email),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('¿Eliminar cuenta?',
            style: GoogleFonts.fredoka(color: AppColors.red, fontSize: 18)),
        content: Text('Esta acción eliminará todos tus datos permanentemente. No se puede deshacer.',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: GoogleFonts.poppins(color: AppColors.purpleLight))),
          TextButton(onPressed: () => Navigator.pop(context),
              child: Text('Eliminar', style: GoogleFonts.poppins(color: AppColors.red, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Widget _passField(TextEditingController ctrl, String hint) => TextField(
    controller: ctrl,
    obscureText: true,
    style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.textMuted, size: 20),
    ),
  );
}

// ── Widget de flujo olvidé contraseña ────────────────────────────────────────
class _ForgotPasswordFlow extends StatefulWidget {
  final String email;
  const _ForgotPasswordFlow({required this.email});

  @override
  State<_ForgotPasswordFlow> createState() => _ForgotPasswordFlowState();
}

class _ForgotPasswordFlowState extends State<_ForgotPasswordFlow> {
  int _step = 0; // 0=info, 1=código, 2=nueva pass
  final _codeCtrl    = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _codeError    = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 14),
        // Indicador de pasos
        Row(children: List.generate(3, (i) => Expanded(child: Padding(
          padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            decoration: BoxDecoration(
              color: i <= _step ? AppColors.purple : AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )))),
        const SizedBox(height: 18),
        if (_step == 0) _stepEmail(),
        if (_step == 1) _stepCode(),
        if (_step == 2) _stepNewPassword(),
      ]),
    );
  }

  Widget _stepEmail() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Recuperar contraseña', style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
    const SizedBox(height: 6),
    Text('Enviaremos un código de 6 dígitos a:', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
    const SizedBox(height: 10),
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card2, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        const Icon(Icons.email_rounded, color: AppColors.purple, size: 20),
        const SizedBox(width: 10),
        Text(widget.email, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ]),
    ),
    const SizedBox(height: 20),
    SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: () => setState(() => _step = 1),
      child: const Text('Enviar código'),
    )),
  ]);

  Widget _stepCode() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Ingresa el código', style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
    const SizedBox(height: 6),
    Text('Revisa tu correo ${widget.email}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
    const SizedBox(height: 16),
    TextField(
      controller: _codeCtrl,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: GoogleFonts.fredoka(fontSize: 28, color: AppColors.textPrimary, letterSpacing: 10),
      decoration: InputDecoration(
        hintText: '000000',
        hintStyle: GoogleFonts.fredoka(fontSize: 28, color: AppColors.textDark, letterSpacing: 10),
        counterText: '',
        errorText: _codeError ? 'Código incorrecto. Intenta de nuevo.' : null,
      ),
    ),
    const SizedBox(height: 6),
    GestureDetector(
      onTap: () {},
      child: Text('¿No llegó el código? Reenviar', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.purple)),
    ),
    const SizedBox(height: 20),
    SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: () {
        if (_codeCtrl.text == '123456') {
          setState(() { _codeError = false; _step = 2; });
        } else {
          setState(() => _codeError = true);
        }
      },
      child: const Text('Verificar código'),
    )),
  ]);

  Widget _stepNewPassword() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Nueva contraseña', style: GoogleFonts.fredoka(fontSize: 20, color: AppColors.textPrimary)),
    const SizedBox(height: 6),
    Text('Elige una contraseña segura', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
    const SizedBox(height: 16),
    TextField(
      controller: _passCtrl, obscureText: true,
      style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
      decoration: const InputDecoration(
        hintText: 'Nueva contraseña',
        prefixIcon: Icon(Icons.lock_rounded, color: AppColors.textMuted, size: 20),
      ),
    ),
    const SizedBox(height: 10),
    TextField(
      controller: _confirmCtrl, obscureText: true,
      style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
      decoration: const InputDecoration(
        hintText: 'Confirmar contraseña',
        prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 20),
      ),
    ),
    const SizedBox(height: 20),
    SizedBox(width: double.infinity, child: ElevatedButton(
      onPressed: () {
        if (_passCtrl.text == _confirmCtrl.text && _passCtrl.text.length >= 6) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.accentDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Text('¡Contraseña actualizada! 🎉',
                style: GoogleFonts.poppins(color: AppColors.accent)),
          ));
        }
      },
      child: const Text('Guardar nueva contraseña'),
    )),
  ]);
}
