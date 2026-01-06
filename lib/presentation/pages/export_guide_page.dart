import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/export_guide_step.dart';
import '../widgets/instagram_button.dart';

class ExportGuidePage extends StatefulWidget {
  const ExportGuidePage({super.key});

  @override
  State<ExportGuidePage> createState() => _ExportGuidePageState();
}

class _ExportGuidePageState extends State<ExportGuidePage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late List<ExportGuideStep> _steps;
  int _currentPage = 0;
  
  // Para el auto-avance de la barra de progreso tipo Stories
  late AnimationController _progressController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _steps = ExportGuideSteps.generateSteps(
      onOpenInstagram: _openInstagram,
      onHaveFile: () => context.go('/import'),
    );
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _openInstagram() async {
    final url = Uri.parse(AppConstants.instagramExportUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _goToPage(int page) {
    if (page >= 0 && page < _steps.length) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;
    
    // Tap en el tercio izquierdo = anterior
    // Tap en los dos tercios derechos = siguiente
    if (tapPosition < screenWidth / 3) {
      _goToPage(_currentPage - 1);
    } else {
      _goToPage(_currentPage + 1);
    }
    
    // Feedback háptico
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header con indicador tipo Stories y botón cerrar
            _buildHeader(),
            
            // Carrusel principal
            Expanded(
              child: GestureDetector(
                onTapDown: _onTapDown,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    HapticFeedback.selectionClick();
                  },
                  itemBuilder: (context, index) {
                    return _buildStepPage(_steps[index], index);
                  },
                ),
              ),
            ),
            
            // Botones de navegación y acción
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          // Fila con botón cerrar
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => context.go('/onboarding'),
                color: AppColors.textSecondary,
                tooltip: 'Volver al inicio',
              ),
              const Spacer(),
              Text(
                '${_currentPage + 1} de ${_steps.length}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, size: 22),
                onPressed: () => context.go('/import'),
                color: AppColors.textSecondary,
                tooltip: 'Ya tengo el archivo',
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Indicador de progreso tipo Stories
          _buildStoriesProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildStoriesProgressIndicator() {
    return Row(
      children: List.generate(_steps.length, (index) {
        final isActive = index == _currentPage;
        final isCompleted = index < _currentPage;
        final isCritical = _steps[index].isCritical;
        
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 2,
              right: index == _steps.length - 1 ? 0 : 2,
            ),
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isCompleted
                  ? (isCritical ? AppColors.warning : AppColors.primary)
                  : isActive
                      ? AppColors.primary.withValues(alpha: 0.8)
                      : AppColors.surfaceVariant,
            ),
            child: isActive
                ? TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isCritical
                                ? AppColors.warning
                                : AppColors.primary,
                          ),
                        ),
                      );
                    },
                  )
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildStepPage(ExportGuideStep step, int index) {
    final isCritical = step.isCritical;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Número y título del paso
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCritical
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Text(
                    '${step.stepNumber}',
                    style: TextStyle(
                      color: isCritical ? AppColors.warning : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (isCritical)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.priority_high,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Importante',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05),
          
          const SizedBox(height: 16),
          
          // Descripción
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
          
          // Tip importante (si existe)
          if (step.importantTip != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCritical
                    ? AppColors.warning.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCritical
                      ? AppColors.warning.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isCritical ? Icons.warning_amber : Icons.lightbulb_outline,
                    color: isCritical ? AppColors.warning : AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step.importantTip!,
                      style: TextStyle(
                        color: isCritical
                            ? AppColors.warning
                            : AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 300.ms).scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
          ],
          
          const SizedBox(height: 24),
          
          // Mockup ilustrado
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 340,
                  decoration: BoxDecoration(
                    color: step.stepNumber == 1 || step.stepNumber == 14
                        ? AppColors.surface
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: step.mockupBuilder(context),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(
                begin: 0.05,
                curve: Curves.easeOut,
              ),
          
          const SizedBox(height: 24),
          
          // Indicador de navegación
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chevron_left,
                  color: _currentPage > 0
                      ? AppColors.textSecondary
                      : Colors.transparent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Desliza o toca para navegar',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: _currentPage < _steps.length - 1
                      ? AppColors.textSecondary
                      : Colors.transparent,
                  size: 20,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final currentStep = _steps[_currentPage];
    final isLastStep = _currentPage == _steps.length - 1;
    final hasAction = currentStep.actionButtonText != null;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón de acción principal (si existe)
          if (hasAction)
            InstagramButton(
              text: currentStep.actionButtonText!,
              icon: _currentPage == 1
                  ? Icons.open_in_new
                  : isLastStep
                      ? Icons.folder_open
                      : null,
              onPressed: currentStep.onActionPressed,
            ),
          
          // Botón secundario de navegación
          if (!isLastStep) ...[
            if (hasAction) const SizedBox(height: 12),
            InstagramButton(
              text: hasAction ? 'Siguiente paso' : 'Continuar',
              isOutlined: hasAction,
              onPressed: () => _goToPage(_currentPage + 1),
            ),
          ],
          
          // En el último paso, mostrar opción de ver guía otra vez
          if (isLastStep && !hasAction) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _goToPage(0),
              child: Text(
                'Ver guía desde el inicio',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
