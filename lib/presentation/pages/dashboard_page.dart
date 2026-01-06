import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/entities.dart';
import '../blocs/analytics/analytics_bloc.dart';
import '../widgets/stat_card.dart';
import '../widgets/profile_tile.dart';
import '../widgets/unified_profile_sheet.dart';
import '../widgets/data_options_sheet.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state.status == AnalyticsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.status == AnalyticsStatus.noData) {
            return _buildNoDataState(context);
          }

          if (state.status == AnalyticsStatus.error) {
            return _buildErrorState(context, state.errorMessage);
          }

          return _buildDashboard(context, state);
        },
      ),
    );
  }

  Widget _buildNoDataState(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_download_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Sin datos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Importa tus datos de Instagram para ver tus estadísticas',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/export-guide'),
                child: const Text('Importar datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              message ?? 'Ha ocurrido un error',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showInteractionDetail(
    BuildContext context,
    UserInteractionScore user,
    bool isFollower,
    bool isFollowing,
    AnalyticsState state,
  ) {
    // Buscar timestamp en followers/following para mostrar fecha en el detalle
    DateTime? timestamp;
    final usernameLower = user.username.toLowerCase();
    
    if (isFollower) {
      final follower = state.instagramData?.followers
          .where((p) => p.username.toLowerCase() == usernameLower)
          .firstOrNull;
      timestamp = follower?.timestamp;
    }
    if (timestamp == null && isFollowing) {
      final following = state.instagramData?.following
          .where((p) => p.username.toLowerCase() == usernameLower)
          .firstOrNull;
      timestamp = following?.timestamp;
    }

    showUnifiedProfileSheetFromInteraction(
      context,
      user: user,
      isFollower: isFollower,
      isFollowing: isFollowing,
      timestamp: timestamp,
    );
  }

  Widget _buildDashboard(BuildContext context, AnalyticsState state) {
    final bloc = context.read<AnalyticsBloc>();
    
    return CustomScrollView(
      slivers: [
        // App Bar - simple white text, no gradient
        SliverAppBar(
          backgroundColor: AppColors.background,
          floating: true,
          title: Text(
            'Followlytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Last update info (clickable)
              if (state.instagramData != null)
                GestureDetector(
                  onTap: () => showDataOptionsSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.update,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Actualizado ${DateFormatter.formatTimestampRelative(
                            state.instagramData!.importedAt.millisecondsSinceEpoch ~/ 1000,
                          )}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // Main stats grid - now using sober design
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 160,
                      child: GradientStatCard(
                        title: 'No te siguen',
                        value: '${state.nonFollowersCount}',
                        icon: Icons.person_remove_outlined,
                        gradient: AppColors.cardGradient,
                        onTap: () => context.go('/non-followers', extra: bloc),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 160,
                      child: GradientStatCard(
                        title: 'Fans',
                        value: '${state.fansCount}',
                        icon: Icons.favorite_outline,
                        gradient: AppColors.cardGradient,
                        onTap: () => context.go('/fans', extra: bloc),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: StatCard(
                        title: 'Mutuos',
                        value: '${state.mutualsCount}',
                        icon: Icons.people_outline,
                        onTap: () => context.go('/mutuals', extra: bloc),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: StatCard(
                        title: 'Pendientes',
                        value: '${state.pendingRequestsCount}',
                        icon: Icons.hourglass_empty,
                        subtitle: '+30 días',
                        onTap: () => context.go('/pending-requests', extra: bloc),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Top interactions section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tus interacciones',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/top-interactions', extra: bloc),
                        child: Text(
                          'Ver todo',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Cuentas a las que más les das like, comentas o reaccionas',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 12),

              // Top 5 interactions
              if (state.interactionAnalytics != null &&
                  state.interactionAnalytics!.combinedTopUsers.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Column(
                    children: state.interactionAnalytics!.combinedTopUsers
                        .take(5)
                        .map((user) {
                          final followerUsernames = state.instagramData?.followers
                              .map((p) => p.username.toLowerCase())
                              .toSet() ?? {};
                          final followingUsernames = state.instagramData?.following
                              .map((p) => p.username.toLowerCase())
                              .toSet() ?? {};
                          final isFollower = followerUsernames.contains(user.username.toLowerCase());
                          final isFollowing = followingUsernames.contains(user.username.toLowerCase());
                          
                          return InteractionProfileTile(
                            username: user.username,
                            likesCount: user.likesCount,
                            commentsCount: user.commentsCount,
                            storyLikesCount: user.storyLikesCount,
                            totalScore: user.totalScore,
                            isFollower: isFollower,
                            isFollowing: isFollowing,
                            onTap: () => _showInteractionDetail(context, user, isFollower, isFollowing, state),
                          );
                        })
                        .toList(),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Quick stats
              Text(
                'Resumen',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      context,
                      'Seguidores',
                      '${state.followersCount}',
                      Icons.people,
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      context,
                      'Siguiendo',
                      '${state.followingCount}',
                      Icons.person_add_alt,
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      context,
                      'Ratio',
                      state.followingCount > 0
                          ? (state.followersCount / state.followingCount)
                              .toStringAsFixed(2)
                          : '0',
                      Icons.show_chart,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
