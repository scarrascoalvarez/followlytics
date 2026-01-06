import 'package:equatable/equatable.dart';
import 'comment.dart';
import 'liked_content.dart';
import 'story_interaction.dart';

class InteractionAnalytics extends Equatable {
  final List<UserInteractionScore> topLikedUsers;
  final List<UserInteractionScore> topCommentedUsers;
  final List<UserInteractionScore> topStoryInteractions;
  final List<UserInteractionScore> combinedTopUsers;
  
  /// Map of username to detailed interaction data
  final Map<String, UserInteractionDetails> userDetails;

  const InteractionAnalytics({
    required this.topLikedUsers,
    required this.topCommentedUsers,
    required this.topStoryInteractions,
    required this.combinedTopUsers,
    this.userDetails = const {},
  });

  factory InteractionAnalytics.empty() => const InteractionAnalytics(
    topLikedUsers: [],
    topCommentedUsers: [],
    topStoryInteractions: [],
    combinedTopUsers: [],
    userDetails: {},
  );

  @override
  List<Object?> get props => [
    topLikedUsers,
    topCommentedUsers,
    topStoryInteractions,
    combinedTopUsers,
    userDetails,
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

  /// Score based only on likes, comments, and story likes (no DMs)
  int get totalScore => likesCount + (commentsCount * 2) + storyLikesCount;

  @override
  List<Object?> get props => [username, likesCount, commentsCount, storyLikesCount];
}

/// Detailed interaction data for a specific user
class UserInteractionDetails extends Equatable {
  final String username;
  final List<Comment> comments;
  final List<LikedContent> likedPosts;
  final List<StoryInteraction> storyInteractions;

  const UserInteractionDetails({
    required this.username,
    this.comments = const [],
    this.likedPosts = const [],
    this.storyInteractions = const [],
  });

  /// Get all interactions sorted by date (most recent first)
  List<InteractionItem> get timeline {
    final items = <InteractionItem>[];
    
    for (final comment in comments) {
      items.add(InteractionItem(
        type: InteractionType.comment,
        timestamp: comment.timestamp,
        description: comment.content,
      ));
    }
    
    for (final like in likedPosts) {
      items.add(InteractionItem(
        type: InteractionType.like,
        timestamp: like.timestamp,
        description: like.postUrl,
      ));
    }
    
    for (final story in storyInteractions) {
      items.add(InteractionItem(
        type: InteractionType.storyLike,
        timestamp: story.timestamp,
        description: story.value,
      ));
    }
    
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  @override
  List<Object?> get props => [username, comments, likedPosts, storyInteractions];
}

enum InteractionType {
  like,
  comment,
  storyLike,
}

class InteractionItem extends Equatable {
  final InteractionType type;
  final DateTime timestamp;
  final String? description;

  const InteractionItem({
    required this.type,
    required this.timestamp,
    this.description,
  });

  @override
  List<Object?> get props => [type, timestamp, description];
}
