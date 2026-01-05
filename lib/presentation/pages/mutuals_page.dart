import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/reviewed_profiles_service.dart';
import '../blocs/analytics/analytics_bloc.dart';
import '../widgets/swipeable_profile_tile.dart';

class MutualsPage extends StatefulWidget {
  const MutualsPage({super.key});

  @override
  State<MutualsPage> createState() => _MutualsPageState();
}

class _MutualsPageState extends State<MutualsPage> {
  String _searchQuery = '';
  bool _hideReviewed = false;
  int _reviewedCount = 0;

  @override
  void initState() {
    super.initState();
    _updateReviewedCount();
  }

  void _updateReviewedCount() {
    final state = context.read<AnalyticsBloc>().state;
    final mutuals = state.followAnalytics?.mutuals ?? [];
    final reviewedService = sl<ReviewedProfilesService>();
    setState(() {
      _reviewedCount = mutuals
          .where((p) => reviewedService.isReviewed(p.username))
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Mutuos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _hideReviewed = !_hideReviewed),
            tooltip: _hideReviewed ? 'Mostrar todos' : 'Ocultar revisados',
            icon: Icon(
              _hideReviewed ? Icons.visibility : Icons.visibility_off,
              size: 22,
              color: _hideReviewed ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          final reviewedService = sl<ReviewedProfilesService>();
          final mutuals = state.followAnalytics?.mutuals ?? [];
          
          var filtered = mutuals
              .where((p) => p.username
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          if (_hideReviewed) {
            filtered = filtered
                .where((p) => !reviewedService.isReviewed(p.username))
                .toList();
          }

          final pendingCount = mutuals.length - _reviewedCount;

          return Column(
            children: [
              // Header with count
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.info.withValues(alpha: 0.15),
                            const Color(0xFF00D4FF).withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.people_outline,
                              color: AppColors.info,
                              size: 24,
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
                                      '${mutuals.length} mutuos',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    if (_reviewedCount > 0) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$_reviewedCount ✓',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: AppColors.success,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pendingCount > 0
                                      ? 'Se siguen mutuamente'
                                      : '¡Todos revisados!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Swipe hint
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.swipe_left,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Desliza a la izquierda para marcar como revisado',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Search bar
                    TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Buscar usuario...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () =>
                                    setState(() => _searchQuery = ''),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _hideReviewed
                                  ? Icons.check_circle_outline
                                  : Icons.people_outline,
                              size: 48,
                              color: _hideReviewed ? AppColors.success : AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No se encontraron resultados'
                                  : _hideReviewed
                                      ? '¡Todos revisados!'
                                      : 'No hay mutuos',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            if (_hideReviewed && _reviewedCount > 0) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _hideReviewed = false),
                                child: const Text('Mostrar revisados'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final profile = filtered[index];
                          return SwipeableProfileTile(
                            profile: profile,
                            isFollower: true,
                            isFollowing: true,
                            isMutual: true,
                            onReviewed: _updateReviewedCount,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
