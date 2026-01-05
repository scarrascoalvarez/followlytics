import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../blocs/import/import_bloc.dart';
import '../widgets/instagram_button.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  double _targetProgress = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress(double newProgress) {
    if (newProgress != _targetProgress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: newProgress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _targetProgress = newProgress;
      _progressController.forward(from: 0);
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null && result.files.single.path != null) {
      if (context.mounted) {
        context.read<ImportBloc>().add(
              ImportFileSelected(result.files.single.path!),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Importar datos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/export-guide'),
        ),
      ),
      body: BlocConsumer<ImportBloc, ImportState>(
        listener: (context, state) {
          if (state.status == ImportStatus.success) {
            context.go('/');
          } else if (state.status == ImportStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Error al importar'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          // Update progress animation
          if (state.status == ImportStatus.loading) {
            _updateProgress(state.progress);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: _buildContent(context, state),
                  ),
                  if (state.status != ImportStatus.loading)
                    InstagramButton(
                      text: 'Seleccionar archivo ZIP',
                      icon: Icons.folder_open,
                      onPressed: () => _pickFile(context),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ImportState state) {
    if (state.status == ImportStatus.loading) {
      return _buildLoadingState(context, state);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Upload icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceVariant,
            border: Border.all(
              color: AppColors.border,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: const Icon(
            Icons.folder_zip_outlined,
            size: 44,
            color: AppColors.textSecondary,
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOut),

        const SizedBox(height: 32),

        Text(
          'Selecciona tu archivo',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 12),

        Text(
          'Busca el archivo ZIP que descargaste de Instagram con tus datos exportados.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 32),

        // Info cards
        _buildInfoCard(
          context,
          icon: Icons.speed,
          title: 'Procesamiento rápido',
          description: 'Tu archivo se analiza en segundos',
        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

        const SizedBox(height: 12),

        _buildInfoCard(
          context,
          icon: Icons.delete_outline,
          title: 'Sin almacenamiento',
          description: 'El archivo original no se guarda',
        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, ImportState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated loading indicator
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final progress = _progressAnimation.value;
              return SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          Text(
            'Importando datos...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Analizando tu información de Instagram',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
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

