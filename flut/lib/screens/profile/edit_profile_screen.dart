import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/mascot_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl     = TextEditingController(text: 'Camila Ramos');
  final _usernameCtrl = TextEditingController(text: 'camiramos');
  final _bioCtrl      = TextEditingController(text: 'Dormilona profesional 🌙');
  bool _saved = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Guardar',
                style: GoogleFonts.poppins(color: AppColors.purple, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto de perfil
            _buildAvatarSection(),
            const SizedBox(height: 28),

            // Campos
            _label('Nombre completo'),
            const SizedBox(height: 6),
            _textField(controller: _nameCtrl, hint: 'Tu nombre', icon: Icons.person_rounded),
            const SizedBox(height: 14),

            _label('Nombre de usuario'),
            const SizedBox(height: 6),
            _textField(controller: _usernameCtrl, hint: '@tuusuario', icon: Icons.alternate_email_rounded),
            const SizedBox(height: 14),

            _label('Biografía'),
            const SizedBox(height: 6),
            TextField(
              controller: _bioCtrl,
              maxLines: 3,
              maxLength: 120,
              style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cuéntanos algo sobre ti...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textDark, fontSize: 12),
                counterStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10),
              ),
            ),

            const SizedBox(height: 24),
            if (_saved)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 18),
                  const SizedBox(width: 8),
                  Text('¡Perfil actualizado correctamente!',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent)),
                ]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(children: [
      Stack(alignment: Alignment.center, children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.card2,
            border: Border.all(color: AppColors.purple, width: 2),
          ),
          child: const MascotWidget(size: 80, mood: MascotMood.happy),
        ),
        Positioned(
          bottom: 0, right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: AppColors.purple,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
            ),
          ),
        ),
      ]),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: _pickImage,
        child: Text('Cambiar foto de perfil',
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.purple, fontWeight: FontWeight.w600)),
      ),
      Text('JPG o PNG · Máx. 5MB',
          style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
    ]);
  }

  Widget _label(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(text, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
  );

  Widget _textField({required TextEditingController controller, required String hint, required IconData icon}) =>
      TextField(
        controller: controller,
        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        ),
      );

  void _pickImage() {
    // En producción: usar image_picker package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.card2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Próximamente: selección de imagen',
            style: GoogleFonts.poppins(color: AppColors.textPrimary)),
      ),
    );
  }

  void _save() {
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }
}
