import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/repositories/instagram_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _clearData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          '¿Eliminar datos?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          'Se eliminarán todos los datos importados. Tendrás que volver a importar tu archivo de Instagram.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await sl<InstagramRepository>().clearData();
      if (context.mounted) {
        context.go('/export-guide');
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'contacto@sergio-carrasco.com',
      query: 'subject=Followlytics - Contacto',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Data section (first - main actions)
          _buildSectionTitle(context, 'Datos'),
          const SizedBox(height: 12),
          _buildCard(
            context,
            children: [
              _buildActionTile(
                context,
                icon: Icons.refresh,
                title: 'Actualizar datos',
                subtitle: 'Importar un nuevo archivo',
                color: AppColors.info,
                onTap: () => context.go('/import'),
              ),
              _buildDivider(),
              _buildActionTile(
                context,
                icon: Icons.delete_outline,
                title: 'Eliminar datos',
                subtitle: 'Borrar todos los datos importados',
                color: AppColors.error,
                onTap: () => _clearData(context),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Privacy section (informative card)
          _buildSectionTitle(context, 'Privacidad'),
          const SizedBox(height: 12),
          _buildPrivacyInfoCard(context),

          const SizedBox(height: 28),

          // Developer section
          _buildSectionTitle(context, 'Desarrollador'),
          const SizedBox(height: 12),
          _buildCard(
            context,
            children: [
              _buildActionTile(
                context,
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'contacto@sergio-carrasco.com',
                color: AppColors.primary,
                trailing: const Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                onTap: _sendEmail,
              ),
              _buildDivider(),
              _buildActionTile(
                context,
                icon: Icons.link,
                title: 'LinkedIn',
                subtitle: 'Sergio Carrasco',
                color: const Color(0xFF0A66C2),
                trailing: const Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                onTap: () => _openUrl('https://www.linkedin.com/in/scarrascoalvarez/'),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // About section
          _buildSectionTitle(context, 'Información'),
          const SizedBox(height: 12),
          _buildCard(
            context,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Versión',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      AppConstants.appVersion,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Footer
          Center(
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.instagramGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tu privacidad, tu control',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hecho con ❤️ por Sergio Carrasco',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPrivacyInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.08),
            AppColors.info.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus datos están protegidos',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Followlytics respeta tu privacidad',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Info items
          _buildPrivacyItem(
            context,
            icon: Icons.phone_android,
            text: 'Procesamiento 100% local en tu dispositivo',
          ),
          const SizedBox(height: 12),
          _buildPrivacyItem(
            context,
            icon: Icons.cloud_off,
            text: 'Sin servidores ni almacenamiento en la nube',
          ),
          const SizedBox(height: 12),
          _buildPrivacyItem(
            context,
            icon: Icons.lock_outline,
            text: 'No necesitamos tu contraseña de Instagram',
          ),
          const SizedBox(height: 12),
          _buildPrivacyItem(
            context,
            icon: Icons.visibility_off_outlined,
            text: 'Tus datos nunca salen de tu móvil',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.success,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56, color: AppColors.border);
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
