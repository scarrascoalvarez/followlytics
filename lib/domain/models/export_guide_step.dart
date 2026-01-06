import 'package:flutter/material.dart';

/// Modelo que representa un paso de la guía de exportación
class ExportGuideStep {
  /// Número del paso (1, 2, 3...)
  final int stepNumber;

  /// Título corto y claro del paso
  final String title;

  /// Descripción detallada de qué hacer
  final String description;

  /// Tip importante (opcional) - se muestra destacado
  final String? importantTip;

  /// Icono representativo del paso
  final IconData icon;

  /// Widget del mockup que ilustra el paso
  final Widget Function(BuildContext context) mockupBuilder;

  /// Si es un paso crítico donde el usuario puede equivocarse
  final bool isCritical;

  /// Texto del botón de acción (ej: "Abrir Instagram")
  final String? actionButtonText;

  /// Callback del botón de acción
  final VoidCallback? onActionPressed;

  const ExportGuideStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.mockupBuilder,
    this.importantTip,
    this.isCritical = false,
    this.actionButtonText,
    this.onActionPressed,
  });
}

/// Fábrica de pasos de la guía
class ExportGuideSteps {
  /// Genera todos los pasos de la guía con sus mockups
  static List<ExportGuideStep> generateSteps({
    required VoidCallback onOpenInstagram,
    required VoidCallback onHaveFile,
  }) {
    return [
      // Paso 1: Intro y privacidad
      ExportGuideStep(
        stepNumber: 1,
        title: '¿Por qué exportar?',
        description:
            'Exportar tus datos de Instagram nos permite analizarlos de forma segura, sin necesitar tu contraseña.',
        icon: Icons.security,
        importantTip: 'Tus datos nunca salen de tu dispositivo. 100% privado.',
        mockupBuilder: (context) => _buildPrivacyMockup(),
      ),

      // Paso 2: Abrir perfil
      ExportGuideStep(
        stepNumber: 2,
        title: 'Abre tu perfil',
        description:
            'Ve a Instagram y toca tu foto de perfil en la esquina inferior derecha.',
        icon: Icons.person_outline,
        mockupBuilder: (context) => _buildProfileMockup(),
        actionButtonText: 'Abrir Instagram',
        onActionPressed: onOpenInstagram,
      ),

      // Paso 3: Menú hamburguesa
      ExportGuideStep(
        stepNumber: 3,
        title: 'Abre el menú',
        description:
            'Toca el icono ☰ (tres líneas) en la esquina superior derecha de tu perfil.',
        icon: Icons.menu,
        mockupBuilder: (context) => _buildMenuIconMockup(),
      ),

      // Paso 4: Centro de cuentas
      ExportGuideStep(
        stepNumber: 4,
        title: 'Centro de cuentas',
        description:
            'Busca y toca "Centro de cuentas" en la parte superior del menú de configuración.',
        icon: Icons.account_circle_outlined,
        importantTip: 'Es la primera opción del menú de configuración.',
        mockupBuilder: (context) => _buildAccountCenterMockup(),
      ),

      // Paso 5: Tu información y permisos
      ExportGuideStep(
        stepNumber: 5,
        title: 'Tu información',
        description:
            'Busca la sección "Tu información y permisos" y tócala.',
        icon: Icons.info_outline,
        mockupBuilder: (context) => _buildYourInfoMockup(),
      ),

      // Paso 6: Descargar tu información
      ExportGuideStep(
        stepNumber: 6,
        title: 'Descargar información',
        description:
            'Selecciona "Descargar tu información" para acceder a las opciones de exportación.',
        icon: Icons.download_outlined,
        mockupBuilder: (context) => _buildDownloadInfoMockup(),
      ),

      // Paso 7: Crear exportación
      ExportGuideStep(
        stepNumber: 7,
        title: 'Crear exportación',
        description:
            'Pulsa el botón azul "Crear exportación" para iniciar una nueva solicitud.',
        icon: Icons.add_circle_outline,
        mockupBuilder: (context) => _buildCreateExportMockup(),
      ),

      // Paso 8: Exportar a dispositivo
      ExportGuideStep(
        stepNumber: 8,
        title: 'Exportar a dispositivo',
        description:
            'Elige "Exportar a dispositivo" para descargar el archivo a tu móvil.',
        icon: Icons.smartphone,
        isCritical: true,
        importantTip:
            'NO elijas "Exportar a servicio externo". Selecciona siempre "Exportar a dispositivo".',
        mockupBuilder: (context) => _buildExportDestinationMockup(),
      ),

      // Paso 9: Formato JSON (CRÍTICO)
      ExportGuideStep(
        stepNumber: 9,
        title: 'Formato JSON',
        description:
            'En la opción "Formato", asegúrate de seleccionar JSON (no HTML).',
        icon: Icons.data_object,
        isCritical: true,
        importantTip:
            '¡MUY IMPORTANTE! Debes elegir JSON para que la app pueda leer tus datos.',
        mockupBuilder: (context) => _buildFormatMockup(),
      ),

      // Paso 10: Toda la información
      ExportGuideStep(
        stepNumber: 10,
        title: 'Toda la información',
        description:
            'En "Personalizar información", selecciona "Toda la información disponible".',
        icon: Icons.select_all,
        isCritical: true,
        importantTip:
            'Necesitas TODOS los datos para usar todas las funciones de la app.',
        mockupBuilder: (context) => _buildAllDataMockup(),
      ),

      // Paso 11: Iniciar exportación
      ExportGuideStep(
        stepNumber: 11,
        title: 'Iniciar exportación',
        description:
            'Pulsa "Iniciar exportación" para enviar la solicitud a Instagram.',
        icon: Icons.play_arrow,
        mockupBuilder: (context) => _buildStartExportMockup(),
      ),

      // Paso 12: Esperar email
      ExportGuideStep(
        stepNumber: 12,
        title: 'Espera el email',
        description:
            'Instagram preparará tu archivo. Recibirás un email cuando esté listo.',
        icon: Icons.email_outlined,
        importantTip:
            'Puede tardar desde minutos hasta 48 horas. Ten paciencia.',
        mockupBuilder: (context) => _buildWaitEmailMockup(),
      ),

      // Paso 13: Descargar ZIP
      ExportGuideStep(
        stepNumber: 13,
        title: 'Descarga el archivo',
        description:
            'Cuando recibas el email, vuelve a Instagram y descarga el archivo ZIP desde "Descargas disponibles".',
        icon: Icons.folder_zip,
        importantTip:
            'Tienes 4 días para descargar el archivo antes de que expire.',
        mockupBuilder: (context) => _buildDownloadZipMockup(),
      ),

      // Paso 14: Listo para importar
      ExportGuideStep(
        stepNumber: 14,
        title: '¡Listo!',
        description:
            'Ya tienes el archivo. Ahora solo falta importarlo en la app.',
        icon: Icons.check_circle,
        mockupBuilder: (context) => _buildReadyMockup(),
        actionButtonText: 'Ya tengo el archivo',
        onActionPressed: onHaveFile,
      ),
    ];
  }

  // Mockup builders privados
  static Widget _buildPrivacyMockup() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF0095F6).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline,
              size: 50,
              color: Color(0xFF0095F6),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PrivacyFeature(icon: Icons.no_accounts, label: 'Sin login'),
              SizedBox(width: 20),
              _PrivacyFeature(icon: Icons.cloud_off, label: 'Sin servidor'),
              SizedBox(width: 20),
              _PrivacyFeature(icon: Icons.phone_android, label: 'Solo local'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildProfileMockup() {
    return Column(
      children: [
        // Barra de navegación inferior simulada
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.home_outlined, color: Colors.black87, size: 28),
              const Icon(Icons.search, color: Colors.black87, size: 28),
              const Icon(Icons.add_box_outlined, color: Colors.black87, size: 28),
              const Icon(Icons.movie_outlined, color: Colors.black87, size: 28),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0095F6), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFFE1306C),
                  child: Icon(Icons.person, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildMenuIconMockup() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header del perfil
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  '_tu_usuario',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0095F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF0095F6), width: 2),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Color(0xFF0095F6),
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  static Widget _buildAccountCenterMockup() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.account_circle, color: Color(0xFF0095F6), size: 28),
                SizedBox(width: 12),
                Text(
                  'Centro de cuentas',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: Color(0xFF0095F6)),
              ],
            ),
          ),
          _buildSimpleMenuItem('Configuración'),
          _buildSimpleMenuItem('Archivado'),
          _buildSimpleMenuItem('Tu actividad'),
        ],
      ),
    );
  }

  static Widget _buildYourInfoMockup() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text(
            'Centro de cuentas',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSimpleMenuItem('Perfiles'),
          _buildSimpleMenuItem('Configuración de la cuenta'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF0095F6)),
                SizedBox(width: 12),
                Text(
                  'Tu información y permisos',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: Color(0xFF0095F6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDownloadInfoMockup() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text(
            'Tu información y permisos',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildSimpleMenuItem('Acceder a tu información'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.download_outlined, color: Color(0xFF0095F6)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Descargar tu información',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Color(0xFF0095F6)),
              ],
            ),
          ),
          _buildSimpleMenuItem('Transferir información'),
        ],
      ),
    );
  }

  static Widget _buildCreateExportMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exporta tu información',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Puedes exportar una copia de tu información a un servicio externo o a tu dispositivo.',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0095F6),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0095F6).withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'Crear exportación',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildExportDestinationMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Elige dónde exportar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: const Row(
              children: [
                Text(
                  'Exportar a dispositivo',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.check_circle, color: Color(0xFF0095F6)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Text(
                  'Exportar a servicio externo',
                  style: TextStyle(color: Colors.black54),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFormatMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuración',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildConfigOption('Información', 'Toda la información'),
          _buildConfigOption('Rango de fechas', 'Todo el tiempo'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.data_object, color: Color(0xFF0095F6)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formato',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'JSON',
                      style: TextStyle(
                        color: Color(0xFF0095F6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.check_circle, color: Color(0xFF0095F6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildAllDataMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personalizar información',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: const Row(
              children: [
                Icon(Icons.select_all, color: Color(0xFF0095F6)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toda la información disponible',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Incluye seguidores, seguidos, likes, comentarios...',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: Color(0xFF0095F6)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.tune, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                const Text(
                  'Selección personalizada',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStartExportMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(),
          const Icon(
            Icons.file_download_outlined,
            size: 80,
            color: Color(0xFF0095F6),
          ),
          const SizedBox(height: 24),
          const Text(
            '¡Todo listo!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pulsa el botón para solicitar tu exportación',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0095F6),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0095F6).withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'Iniciar exportación',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget _buildWaitEmailMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_unread_outlined,
              size: 50,
              color: Color(0xFF0095F6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Solicitud enviada',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Te enviaremos un email cuando tu archivo esté listo para descargar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, color: Color(0xFF856404)),
                SizedBox(width: 8),
                Text(
                  'Hasta 48 horas',
                  style: TextStyle(
                    color: Color(0xFF856404),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDownloadZipMockup() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descargas disponibles',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tienes 4 días para descargar tus archivos.',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0095F6), width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade400, Colors.orange.shade400],
                        ),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información completa',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Formato JSON • 1.5 GB',
                            style: TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0095F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Descargar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReadyMockup() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 70,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '¡Perfecto!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ya tienes tu archivo ZIP con todos tus datos de Instagram.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSimpleMenuItem(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  static Widget _buildConfigOption(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.black87)),
              Text(value, style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _PrivacyFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PrivacyFeature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white70, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

