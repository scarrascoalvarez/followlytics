import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/injection_container.dart';
import '../theme/app_theme.dart';
import '../../domain/repositories/instagram_repository.dart';

/// Utility function to clear all Instagram data with confirmation dialog
/// Returns true if data was cleared, false otherwise
Future<bool> clearInstagramDataWithConfirmation(BuildContext context) async {
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
    return true;
  }
  return false;
}

