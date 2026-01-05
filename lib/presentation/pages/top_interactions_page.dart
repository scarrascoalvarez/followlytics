import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';
import '../blocs/analytics/analytics_bloc.dart';
import '../widgets/profile_tile.dart';
import '../widgets/profile_detail_sheet.dart';
import '../widgets/time_filter.dart';

class TopInteractionsPage extends StatefulWidget {
  const TopInteractionsPage({super.key});

  @override
  State<TopInteractionsPage> createState() => _TopInteractionsPageState();
}

class _TopInteractionsPageState extends State<TopInteractionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TimePeriod _selectedPeriod = TimePeriod.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  InteractionAnalytics _calculateFilteredAnalytics(InstagramData data) {
    final startDate = _selectedPeriod.startDate;

    bool isInPeriod(DateTime timestamp) {
      if (startDate == null) return true;
      return timestamp.isAfter(startDate);
    }

    // Collect detailed data per user
    final userLikes = <String, List<LikedContent>>{};
    final userComments = <String, List<Comment>>{};
    final userStoryInteractions = <String, List<StoryInteraction>>{};

    // Count likes per user (filtered by date)
    final likeCounts = <String, int>{};
    for (final like in data.likedPosts) {
      if (isInPeriod(like.timestamp)) {
        likeCounts[like.author] = (likeCounts[like.author] ?? 0) + 1;
        userLikes.putIfAbsent(like.author, () => []).add(like);
      }
    }
    for (final like in data.likedComments) {
      if (isInPeriod(like.timestamp)) {
        likeCounts[like.author] = (likeCounts[like.author] ?? 0) + 1;
        userLikes.putIfAbsent(like.author, () => []).add(like);
      }
    }

    // Count comments per user (filtered by date)
    final commentCounts = <String, int>{};
    for (final comment in data.comments) {
      if (isInPeriod(comment.timestamp)) {
        commentCounts[comment.mediaOwner] =
            (commentCounts[comment.mediaOwner] ?? 0) + 1;
        userComments.putIfAbsent(comment.mediaOwner, () => []).add(comment);
      }
    }

    // Count story likes per user (filtered by date)
    final storyLikeCounts = <String, int>{};
    for (final storyLike in data.storyLikes) {
      if (isInPeriod(storyLike.timestamp)) {
        storyLikeCounts[storyLike.author] =
            (storyLikeCounts[storyLike.author] ?? 0) + 1;
        userStoryInteractions.putIfAbsent(storyLike.author, () => []).add(storyLike);
      }
    }

    // Build DM counts map
    final dmCounts = <String, int>{};
    for (final dm in data.dmConversations) {
      dmCounts[dm.username] = dm.messageCount;
    }

    // Get all users and calculate combined scores
    final allUsers = <String>{
      ...likeCounts.keys,
      ...commentCounts.keys,
      ...storyLikeCounts.keys,
      ...dmCounts.keys,
    };

    final combinedScores = allUsers.map((username) {
      return UserInteractionScore(
        username: username,
        likesCount: likeCounts[username] ?? 0,
        commentsCount: commentCounts[username] ?? 0,
        storyLikesCount: storyLikeCounts[username] ?? 0,
        dmCount: dmCounts[username] ?? 0,
      );
    }).toList();

    // Build detailed user interaction map
    final userDetails = <String, UserInteractionDetails>{};
    for (final username in allUsers) {
      final likes = userLikes[username] ?? [];
      final comments = userComments[username] ?? [];
      final stories = userStoryInteractions[username] ?? [];
      
      // Sort each list by timestamp (most recent first)
      likes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      comments.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      stories.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      userDetails[username] = UserInteractionDetails(
        username: username,
        comments: comments,
        dmCount: dmCounts[username] ?? 0,
        likedPosts: likes,
        storyInteractions: stories,
      );
    }

    // Sort by different criteria
    final topLikedUsers = [...combinedScores]
      ..sort((a, b) => b.likesCount.compareTo(a.likesCount));

    final topCommentedUsers = [...combinedScores]
      ..sort((a, b) => b.commentsCount.compareTo(a.commentsCount));

    final topStoryInteractions = [...combinedScores]
      ..sort((a, b) => b.storyLikesCount.compareTo(a.storyLikesCount));

    final combinedTopUsers = [...combinedScores]
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return InteractionAnalytics(
      topLikedUsers: topLikedUsers.where((u) => u.likesCount > 0).toList(),
      topCommentedUsers:
          topCommentedUsers.where((u) => u.commentsCount > 0).toList(),
      topStoryInteractions:
          topStoryInteractions.where((u) => u.storyLikesCount > 0).toList(),
      combinedTopUsers:
          combinedTopUsers.where((u) => u.totalScore > 0).toList(),
      userDetails: userDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Tus interacciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state.instagramData == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Calculate filtered analytics
          final analytics = _selectedPeriod == TimePeriod.all
              ? state.interactionAnalytics!
              : _calculateFilteredAnalytics(state.instagramData!);

          // Build sets for checking follow status
          final followerUsernames = state.instagramData!.followers
              .map((p) => p.username.toLowerCase())
              .toSet();
          final followingUsernames = state.instagramData!.following
              .map((p) => p.username.toLowerCase())
              .toSet();

          return Column(
            children: [
              // Period filter chips
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: TimeFilterChips(
                  selectedPeriod: _selectedPeriod,
                  onChanged: (period) {
                    setState(() => _selectedPeriod = period);
                  },
                ),
              ),

              // Count indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Cuentas a las que más interactúas',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${analytics.combinedTopUsers.length} cuentas',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'Todo'),
                  Tab(text: 'Likes'),
                  Tab(text: 'Comentarios'),
                  Tab(text: 'Stories'),
                ],
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(
                      analytics.combinedTopUsers,
                      'interacciones',
                      followerUsernames,
                      followingUsernames,
                      analytics.userDetails,
                    ),
                    _buildList(
                      analytics.topLikedUsers,
                      'likes',
                      followerUsernames,
                      followingUsernames,
                      analytics.userDetails,
                    ),
                    _buildList(
                      analytics.topCommentedUsers,
                      'comentarios',
                      followerUsernames,
                      followingUsernames,
                      analytics.userDetails,
                    ),
                    _buildList(
                      analytics.topStoryInteractions,
                      'stories',
                      followerUsernames,
                      followingUsernames,
                      analytics.userDetails,
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

  Widget _buildList(
    List<UserInteractionScore> users,
    String metric,
    Set<String> followerUsernames,
    Set<String> followingUsernames,
    Map<String, UserInteractionDetails> userDetails,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin $metric en este período',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            if (_selectedPeriod != TimePeriod.all) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _selectedPeriod = TimePeriod.all),
                child: const Text('Ver todo el tiempo'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isFollower =
            followerUsernames.contains(user.username.toLowerCase());
        final isFollowing =
            followingUsernames.contains(user.username.toLowerCase());
        final details = userDetails[user.username];

        return InteractionProfileTile(
          username: user.username,
          likesCount: user.likesCount,
          commentsCount: user.commentsCount,
          storyLikesCount: user.storyLikesCount,
          totalScore: user.totalScore,
          isFollower: isFollower,
          isFollowing: isFollowing,
          onTap: () => _showDetail(user, details, isFollower, isFollowing),
        );
      },
    );
  }

  void _showDetail(
    UserInteractionScore user,
    UserInteractionDetails? details,
    bool isFollower,
    bool isFollowing,
  ) {
    showInteractionDetailSheet(
      context,
      user: user,
      details: details,
      isFollower: isFollower,
      isFollowing: isFollowing,
    );
  }
}
