import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/reviewed_profiles_service.dart';
import '../../domain/entities/interaction_analytics.dart';
import '../blocs/analytics/analytics_bloc.dart';
import '../widgets/reviewed_section.dart';
import '../widgets/swipeable_profile_tile.dart';

class NonFollowersPage extends StatefulWidget {
  const NonFollowersPage({super.key});

  @override
  State<NonFollowersPage> createState() => _NonFollowersPageState();
}

class _NonFollowersPageState extends State<NonFollowersPage> {
  String _searchQuery = '';

  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('No te siguen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          final reviewedService = sl<ReviewedProfilesService>();
          final nonFollowers = state.followAnalytics?.nonFollowers ?? [];
          
          // Separate reviewed and pending profiles
          final reviewedProfiles = nonFollowers
              .where((p) => reviewedService.isReviewed(p.username))
              .where((p) => p.username
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
          
          final pendingProfiles = nonFollowers
              .where((p) => !reviewedService.isReviewed(p.username))
              .where((p) => p.username
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          final totalReviewed = nonFollowers
              .where((p) => reviewedService.isReviewed(p.username))
              .length;
          final pendingCount = nonFollowers.length - totalReviewed;

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
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_remove_outlined,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${nonFollowers.length} usuarios',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pendingCount > 0
                                      ? '$pendingCount pendientes de revisar'
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
                            'Desliza a la izquierda para archivar',
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

              // List with reviewed section
              Expanded(
                child: pendingProfiles.isEmpty && reviewedProfiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.celebration,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No se encontraron resultados'
                                  : '¡Todos te siguen de vuelta!',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          // Reviewed section (collapsible)
                          SliverToBoxAdapter(
                            child: ReviewedSection(
                              reviewedProfiles: reviewedProfiles,
                              isFollower: false,
                              isFollowing: true,
                              onProfileUnreviewed: _refreshList,
                              userDetails: state.interactionAnalytics?.userDetails.map(
                                (key, value) => MapEntry(key.toLowerCase(), value),
                              ),
                              userScores: state.interactionAnalytics?.combinedTopUsers
                                  .fold<Map<String, UserInteractionScore>>(
                                    {},
                                    (map, score) {
                                      map[score.username.toLowerCase()] = score;
                                      return map;
                                    },
                                  ),
                            ),
                          ),

                          // Pending profiles list
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final profile = pendingProfiles[index];
                                final usernameLower = profile.username.toLowerCase();
                                // Buscar interacciones de forma case-insensitive
                                final userScore = state.interactionAnalytics?.combinedTopUsers
                                    .where((u) => u.username.toLowerCase() == usernameLower)
                                    .firstOrNull;
                                final userDetails = state.interactionAnalytics?.userDetails.entries
                                    .where((e) => e.key.toLowerCase() == usernameLower)
                                    .map((e) => e.value)
                                    .firstOrNull;
                                return SwipeableProfileTile(
                                  profile: profile,
                                  isFollower: false,
                                  isFollowing: true,
                                  onReviewed: _refreshList,
                                  likesCount: userScore?.likesCount,
                                  commentsCount: userScore?.commentsCount,
                                  storyLikesCount: userScore?.storyLikesCount,
                                  interactionDetails: userDetails,
                                );
                              },
                              childCount: pendingProfiles.length,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
