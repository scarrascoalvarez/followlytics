import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/instagram_button.dart';

class ExportGuidePage extends StatefulWidget {
  const ExportGuidePage({super.key});

  @override
  State<ExportGuidePage> createState() => _ExportGuidePageState();
}

class _ExportGuidePageState extends State<ExportGuidePage> {
  final _scrollController = ScrollController();

  final _steps = const [
    _GuideStep(
      number: 1,
      title: 'Abre la configuración de Instagram',
      description: 'Ve a tu perfil y toca el menú ☰, luego "Centro de cuentas".',
      icon: Icons.settings_outlined,
    ),
    _GuideStep(
      number: 2,
      title: 'Tu información y permisos',
      description: 'Busca la sección "Tu información y permisos" y selecciónala.',
      icon: Icons.info_outline,
    ),
    _GuideStep(
      number: 3,
      title: 'Descargar tu información',
      description: 'Toca "Descargar tu información" para iniciar el proceso de exportación.',
      icon: Icons.download_outlined,
    ),
    _GuideStep(
      number: 4,
      title: 'Selecciona formato JSON',
      description: 'Elige "Exportar a dispositivo", selecciona formato JSON y toda la información disponible.',
      icon: Icons.data_object,
    ),
    _GuideStep(
      number: 5,
      title: 'Espera el email',
      description: 'Instagram te enviará un email cuando tu exportación esté lista. Puede tardar hasta 48 horas.',
      icon: Icons.email_outlined,
    ),
    _GuideStep(
      number: 6,
      title: 'Descarga e importa',
      description: 'Descarga el archivo ZIP desde el email e impórtalo en esta app.',
      icon: Icons.folder_zip_outlined,
    ),
  ];

  Future<void> _openInstagram() async {
    final url = Uri.parse(AppConstants.instagramExportUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Cómo exportar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/onboarding'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.secondary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.security,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '¿Por qué exportar?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Al usar tus propios datos exportados, garantizamos tu privacidad. No necesitamos tu contraseña ni acceso a tu cuenta.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

                const SizedBox(height: 24),

                // Steps
                ...List.generate(_steps.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _steps[index]
                        .animate()
                        .fadeIn(delay: (100 * index).ms, duration: 400.ms)
                        .slideX(begin: 0.1, duration: 400.ms),
                  );
                }),

                const SizedBox(height: 8),

                // Privacy note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tus datos se procesan solo en tu dispositivo. Nunca se envían a ningún servidor.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InstagramButton(
                    text: 'Abrir Instagram',
                    icon: Icons.open_in_new,
                    onPressed: _openInstagram,
                  ),
                  const SizedBox(height: 12),
                  InstagramButton(
                    text: 'Ya tengo el archivo',
                    isOutlined: true,
                    onPressed: () => context.go('/import'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final IconData icon;

  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.instagramGradient,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

