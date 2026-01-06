import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/data_utils.dart';

void showDataOptionsSheet(BuildContext context) {
  // Save the parent context before showing the sheet
  final parentContext = context;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DataOptionsSheet(parentContext: parentContext),
  );
}

class DataOptionsSheet extends StatelessWidget {
  final BuildContext parentContext;
  
  const DataOptionsSheet({
    super.key,
    required this.parentContext,
  });

  Future<void> _clearData(BuildContext sheetContext) async {
    // Close the sheet first
    Navigator.pop(sheetContext);
    
    // Use the parent context for the dialog and navigation
    if (parentContext.mounted) {
      await clearInstagramDataWithConfirmation(parentContext);
    }
  }

  void _goToImport(BuildContext sheetContext) {
    Navigator.pop(sheetContext);
    if (parentContext.mounted) {
      parentContext.go('/import');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'Opciones de datos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 20),

          // Update option
          _buildOption(
            context,
            icon: Icons.refresh,
            title: 'Actualizar datos',
            subtitle: 'Importar un nuevo archivo de Instagram',
            onTap: () => _goToImport(context),
          ),

          const SizedBox(height: 12),

          // Delete option
          _buildOption(
            context,
            icon: Icons.delete_outline,
            title: 'Eliminar datos',
            subtitle: 'Borrar todos los datos importados',
            isDestructive: true,
            onTap: () => _clearData(context),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon, 
                  color: isDestructive ? AppColors.error : AppColors.textSecondary, 
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
              Icon(
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
