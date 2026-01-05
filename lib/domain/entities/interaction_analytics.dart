import 'package:equatable/equatable.dart';

class InteractionAnalytics extends Equatable {
  final List<UserInteractionScore> topLikedUsers;
  final List<UserInteractionScore> topCommentedUsers;
  final List<UserInteractionScore> topStoryInteractions;
  final List<UserInteractionScore> combinedTopUsers;

  const InteractionAnalytics({
    required this.topLikedUsers,
    required this.topCommentedUsers,
    required this.topStoryInteractions,
    required this.combinedTopUsers,
  });

  factory InteractionAnalytics.empty() => const InteractionAnalytics(
    topLikedUsers: [],
    topCommentedUsers: [],
    topStoryInteractions: [],
    combinedTopUsers: [],
  );

  @override
  List<Object?> get props => [
    topLikedUsers,
    topCommentedUsers,
    topStoryInteractions,
    combinedTopUsers,
  ];
}

class UserInteractionScore extends Equatable {
  final String username;
  final int likesCount;
  final int commentsCount;
  final int storyLikesCount;

  const UserInteractionScore({
    required this.username,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.storyLikesCount = 0,
  });

  int get totalScore => likesCount + (commentsCount * 2) + storyLikesCount;

  @override
  List<Object?> get props => [username, likesCount, commentsCount, storyLikesCount];
}

