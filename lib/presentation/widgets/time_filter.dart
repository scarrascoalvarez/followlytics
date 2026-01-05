import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum TimePeriod {
  all,
  last7Days,
  last30Days,
  last3Months,
  last6Months,
  lastYear,
}

extension TimePeriodExtension on TimePeriod {
  String get label {
    switch (this) {
      case TimePeriod.all:
        return 'Todo';
      case TimePeriod.last7Days:
        return '7 días';
      case TimePeriod.last30Days:
        return '30 días';
      case TimePeriod.last3Months:
        return '3 meses';
      case TimePeriod.last6Months:
        return '6 meses';
      case TimePeriod.lastYear:
        return '1 año';
    }
  }

  DateTime? get startDate {
    final now = DateTime.now();
    switch (this) {
      case TimePeriod.all:
        return null;
      case TimePeriod.last7Days:
        return now.subtract(const Duration(days: 7));
      case TimePeriod.last30Days:
        return now.subtract(const Duration(days: 30));
      case TimePeriod.last3Months:
        return now.subtract(const Duration(days: 90));
      case TimePeriod.last6Months:
        return now.subtract(const Duration(days: 180));
      case TimePeriod.lastYear:
        return now.subtract(const Duration(days: 365));
    }
  }
}

class TimeFilterChips extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onChanged;

  const TimeFilterChips({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: TimePeriod.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final period = TimePeriod.values[index];
          final isSelected = period == selectedPeriod;

          return GestureDetector(
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                period.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
