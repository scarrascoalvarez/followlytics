import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/data_utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                onTap: () => context.go('/import'),
              ),
              _buildDivider(),
              _buildActionTile(
                context,
                icon: Icons.delete_outline,
                title: 'Eliminar datos',
                subtitle: 'Borrar todos los datos importados',
                isDestructive: true,
                onTap: () => clearInstagramDataWithConfirmation(context),
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
                        color: AppColors.surfaceVariant,
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
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tu privacidad, tu control',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 0.5,
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
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.primary,
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
          color: AppColors.textSecondary,
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
    bool isDestructive = false,
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
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon, 
                  color: isDestructive ? AppColors.error : AppColors.textSecondary, 
                  size: 20,
                ),
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
                            color: isDestructive ? AppColors.error : null,
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
