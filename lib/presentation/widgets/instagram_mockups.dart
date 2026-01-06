import 'package:flutter/material.dart';

/// Colores que simulan la UI de Instagram (modo claro, como en las capturas)
class InstagramMockupColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFDBDBDB);
  static const Color textPrimary = Color(0xFF262626);
  static const Color textSecondary = Color(0xFF8E8E8E);
  static const Color primary = Color(0xFF0095F6);
  static const Color divider = Color(0xFFEFEFEF);
  static const Color highlightBorder = Color(0xFF0095F6);
  static const Color highlightBackground = Color(0xFFE8F4FD);
}

/// Mockup del header de navegación de Instagram
class MockupHeader extends StatelessWidget {
  final String? title;
  final bool showBackButton;
  final bool showCloseButton;

  const MockupHeader({
    super.key,
    this.title,
    this.showBackButton = true,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: InstagramMockupColors.background,
        border: Border(
          bottom: BorderSide(color: InstagramMockupColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: InstagramMockupColors.textPrimary,
            ),
          if (title != null) ...[
            const SizedBox(width: 16),
            Text(
              title!,
              style: const TextStyle(
                color: InstagramMockupColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const Spacer(),
          if (showCloseButton)
            const Icon(
              Icons.close,
              size: 24,
              color: InstagramMockupColors.textPrimary,
            ),
        ],
      ),
    );
  }
}

/// Mockup de un item de lista con icono, título y subtítulo
class MockupListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final bool isHighlighted;
  final Widget? trailing;

  const MockupListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.showArrow = true,
    this.isHighlighted = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted
            ? InstagramMockupColors.highlightBackground
            : InstagramMockupColors.surface,
        border: isHighlighted
            ? Border.all(color: InstagramMockupColors.highlightBorder, width: 2)
            : const Border(
                bottom:
                    BorderSide(color: InstagramMockupColors.divider, width: 0.5),
              ),
        borderRadius: isHighlighted ? BorderRadius.circular(12) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: InstagramMockupColors.divider,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: InstagramMockupColors.textPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: InstagramMockupColors.textPrimary,
                    fontSize: 15,
                    fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: isHighlighted
                          ? InstagramMockupColors.primary
                          : InstagramMockupColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (showArrow && trailing == null)
            const Icon(
              Icons.chevron_right,
              color: InstagramMockupColors.textSecondary,
              size: 22,
            ),
        ],
      ),
    );
  }
}

/// Mockup del botón azul de Instagram
class MockupPrimaryButton extends StatelessWidget {
  final String text;
  final bool isHighlighted;

  const MockupPrimaryButton({
    super.key,
    required this.text,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: InstagramMockupColors.primary,
        borderRadius: BorderRadius.circular(24),
        border: isHighlighted
            ? Border.all(color: Colors.white, width: 3)
            : null,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: InstagramMockupColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Mockup de botón secundario (outlined)
class MockupSecondaryButton extends StatelessWidget {
  final String text;
  final bool isHighlighted;

  const MockupSecondaryButton({
    super.key,
    required this.text,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: InstagramMockupColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted
              ? InstagramMockupColors.highlightBorder
              : InstagramMockupColors.cardBorder,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: InstagramMockupColors.textPrimary,
          fontSize: 14,
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// Mockup de una opción seleccionable (como "Export to device")
class MockupSelectableOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isHighlighted;
  final bool showArrow;

  const MockupSelectableOption({
    super.key,
    required this.title,
    this.subtitle,
    this.isHighlighted = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? InstagramMockupColors.highlightBackground
            : InstagramMockupColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? InstagramMockupColors.highlightBorder
              : InstagramMockupColors.cardBorder,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: InstagramMockupColors.textPrimary,
                    fontSize: 15,
                    fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: InstagramMockupColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.chevron_right,
              color: isHighlighted
                  ? InstagramMockupColors.primary
                  : InstagramMockupColors.textSecondary,
              size: 22,
            ),
        ],
      ),
    );
  }
}

/// Mockup del card de perfil de usuario
class MockupProfileCard extends StatelessWidget {
  final String username;
  final String platform;
  final String? detail;

  const MockupProfileCard({
    super.key,
    required this.username,
    this.platform = 'Instagram',
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: InstagramMockupColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InstagramMockupColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.shade400,
                  Colors.orange.shade400,
                  Colors.pink.shade400,
                ],
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: InstagramMockupColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade400,
                            Colors.orange.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  platform,
                  style: const TextStyle(
                    color: Color(0xFFE1306C),
                    fontSize: 13,
                  ),
                ),
                if (detail != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail!,
                    style: const TextStyle(
                      color: InstagramMockupColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mockup de la card de descarga disponible
class MockupDownloadCard extends StatelessWidget {
  final String dateRange;
  final String username;
  final String expiresOn;
  final String size;
  final bool isHighlighted;

  const MockupDownloadCard({
    super.key,
    required this.dateRange,
    required this.username,
    required this.expiresOn,
    required this.size,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: InstagramMockupColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? InstagramMockupColors.highlightBorder
              : InstagramMockupColors.cardBorder,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: InstagramMockupColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.orange.shade400],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateRange,
                      style: const TextStyle(
                        color: InstagramMockupColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: const TextStyle(
                        color: InstagramMockupColors.primary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Instagram',
                      style: TextStyle(
                        color: InstagramMockupColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      expiresOn,
                      style: const TextStyle(
                        color: InstagramMockupColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      size,
                      style: const TextStyle(
                        color: InstagramMockupColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MockupSecondaryButton(
                  text: 'Download',
                  isHighlighted: isHighlighted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MockupSecondaryButton(text: 'Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mockup del menú hamburguesa de Instagram
class MockupHamburgerMenu extends StatelessWidget {
  final bool highlightSettings;

  const MockupHamburgerMenu({
    super.key,
    this.highlightSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: InstagramMockupColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InstagramMockupColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(Icons.settings_outlined, 'Configuración y privacidad',
              isHighlighted: highlightSettings),
          _buildMenuItem(Icons.schedule, 'Tu actividad'),
          _buildMenuItem(Icons.archive_outlined, 'Archivo'),
          _buildMenuItem(Icons.qr_code, 'Código QR'),
          _buildMenuItem(Icons.bookmark_border, 'Guardado'),
          _buildMenuItem(Icons.favorite_border, 'Supervisión'),
          _buildMenuItem(Icons.people_outline, 'Close Friends'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label,
      {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted
            ? InstagramMockupColors.highlightBackground
            : Colors.transparent,
        border: isHighlighted
            ? Border.all(color: InstagramMockupColors.highlightBorder, width: 2)
            : null,
        borderRadius: isHighlighted ? BorderRadius.circular(8) : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 26,
            color: InstagramMockupColors.textPrimary,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: InstagramMockupColors.textPrimary,
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Contenedor de mockup con marco de teléfono simulado
class MockupPhoneFrame extends StatelessWidget {
  final Widget child;
  final double scale;

  const MockupPhoneFrame({
    super.key,
    required this.child,
    this.scale = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 280,
        height: 500,
        decoration: BoxDecoration(
          color: InstagramMockupColors.background,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(0xFF1C1C1E),
            width: 8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: child,
        ),
      ),
    );
  }
}

/// Indicador de tip importante
class ImportantTip extends StatelessWidget {
  final String text;
  final IconData? icon;

  const ImportantTip({
    super.key,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: InstagramMockupColors.highlightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: InstagramMockupColors.highlightBorder.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.info_outline,
            color: InstagramMockupColors.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: InstagramMockupColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

