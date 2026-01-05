import '../../domain/entities/entities.dart';
import '../../domain/repositories/instagram_repository.dart';
import '../datasources/instagram_local_datasource.dart';

class InstagramRepositoryImpl implements InstagramRepository {
  final InstagramLocalDataSource localDataSource;

  InstagramRepositoryImpl({required this.localDataSource});

  @override
  Future<InstagramData> importFromZip(String zipPath) {
    return localDataSource.importFromZip(zipPath);
  }

  @override
  Future<InstagramData?> getStoredData() {
    return localDataSource.getStoredData();
  }

  @override
  Future<void> saveData(InstagramData data) {
    return localDataSource.saveData(data);
  }

  @override
  Future<void> clearData() {
    return localDataSource.clearData();
  }

  @override
  Future<bool> hasData() {
    return localDataSource.hasData();
  }

  @override
  FollowAnalytics calculateFollowAnalytics(InstagramData data) {
    final followerUsernames = data.followers.map((p) => p.username.toLowerCase()).toSet();
    final followingUsernames = data.following.map((p) => p.username.toLowerCase()).toSet();
    final mutualUsernames = followerUsernames.intersection(followingUsernames);

    // Non-followers: people you follow who don't follow you back
    final nonFollowers = data.following
        .where((p) => !followerUsernames.contains(p.username.toLowerCase()))
        .toList();

    // Fans: people who follow you but you don't follow back
    final fans = data.followers
        .where((p) => !followingUsernames.contains(p.username.toLowerCase()))
        .toList();

    // Mutuals: both follow each other
    final mutuals = data.following
        .where((p) => mutualUsernames.contains(p.username.toLowerCase()))
        .toList();

    // Close friends who are not mutual
    final nonMutualCloseFriends = data.closeFriends
        .where((p) => !mutualUsernames.contains(p.username.toLowerCase()))
        .toList();

    // All pending requests (sorted by oldest first)
    final pendingRequests = [...data.pendingRequests];
    pendingRequests.sort((a, b) => (a.timestamp ?? DateTime.now())
        .compareTo(b.timestamp ?? DateTime.now()));

    // Sort by timestamp (most recent first)
    nonFollowers.sort((a, b) => (b.timestamp ?? DateTime(2000))
        .compareTo(a.timestamp ?? DateTime(2000)));
    fans.sort((a, b) => (b.timestamp ?? DateTime(2000))
        .compareTo(a.timestamp ?? DateTime(2000)));

    return FollowAnalytics(
      nonFollowers: nonFollowers,
      fans: fans,
      mutuals: mutuals,
      nonMutualCloseFriends: nonMutualCloseFriends,
      pendingRequests: pendingRequests,
    );
  }

  @override
  InteractionAnalytics calculateInteractionAnalytics(InstagramData data, {DateTime? startDate}) {
    // Filter by date if provided
    bool isInPeriod(DateTime timestamp) {
      if (startDate == null) return true;
      return timestamp.isAfter(startDate);
    }

    // Count likes per user (filtered by date)
    final likeCounts = <String, int>{};
    for (final like in data.likedPosts) {
      if (isInPeriod(like.timestamp)) {
        likeCounts[like.author] = (likeCounts[like.author] ?? 0) + 1;
      }
    }
    for (final like in data.likedComments) {
      if (isInPeriod(like.timestamp)) {
        likeCounts[like.author] = (likeCounts[like.author] ?? 0) + 1;
      }
    }

    // Count comments per user (filtered by date)
    final commentCounts = <String, int>{};
    for (final comment in data.comments) {
      if (isInPeriod(comment.timestamp)) {
        commentCounts[comment.mediaOwner] = 
            (commentCounts[comment.mediaOwner] ?? 0) + 1;
      }
    }

    // Count story likes per user (filtered by date)
    final storyLikeCounts = <String, int>{};
    for (final storyLike in data.storyLikes) {
      if (isInPeriod(storyLike.timestamp)) {
        storyLikeCounts[storyLike.author] = 
            (storyLikeCounts[storyLike.author] ?? 0) + 1;
      }
    }

    // Get all users and calculate combined scores
    final allUsers = <String>{
      ...likeCounts.keys,
      ...commentCounts.keys,
      ...storyLikeCounts.keys,
    };

    final combinedScores = allUsers.map((username) {
      return UserInteractionScore(
        username: username,
        likesCount: likeCounts[username] ?? 0,
        commentsCount: commentCounts[username] ?? 0,
        storyLikesCount: storyLikeCounts[username] ?? 0,
      );
    }).toList();

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
      topCommentedUsers: topCommentedUsers.where((u) => u.commentsCount > 0).toList(),
      topStoryInteractions: topStoryInteractions.where((u) => u.storyLikesCount > 0).toList(),
      combinedTopUsers: combinedTopUsers.where((u) => u.totalScore > 0).toList(),
    );
  }
}

