import 'package:equatable/equatable.dart';
import 'instagram_profile.dart';
import 'liked_content.dart';
import 'story_interaction.dart';
import 'comment.dart';
import 'dm_conversation.dart';

class InstagramData extends Equatable {
  final List<InstagramProfile> followers;
  final List<InstagramProfile> following;
  final List<InstagramProfile> closeFriends;
  final List<InstagramProfile> blockedProfiles;
  final List<InstagramProfile> restrictedProfiles;
  final List<InstagramProfile> hideStoryFrom;
  final List<InstagramProfile> pendingRequests;
  final List<InstagramProfile> recentUnfollows;
  final List<LikedContent> likedPosts;
  final List<LikedContent> likedComments;
  final List<StoryInteraction> storyLikes;
  final List<Comment> comments;
  final List<DmConversation> dmConversations;
  final DateTime importedAt;

  const InstagramData({
    required this.followers,
    required this.following,
    required this.closeFriends,
    required this.blockedProfiles,
    required this.restrictedProfiles,
    required this.hideStoryFrom,
    required this.pendingRequests,
    required this.recentUnfollows,
    required this.likedPosts,
    required this.likedComments,
    required this.storyLikes,
    required this.comments,
    this.dmConversations = const [],
    required this.importedAt,
  });

  factory InstagramData.empty() => InstagramData(
    followers: const [],
    following: const [],
    closeFriends: const [],
    blockedProfiles: const [],
    restrictedProfiles: const [],
    hideStoryFrom: const [],
    pendingRequests: const [],
    recentUnfollows: const [],
    likedPosts: const [],
    likedComments: const [],
    storyLikes: const [],
    comments: const [],
    dmConversations: const [],
    importedAt: DateTime.now(),
  );

  bool get isEmpty => followers.isEmpty && following.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
    followers,
    following,
    closeFriends,
    blockedProfiles,
    restrictedProfiles,
    hideStoryFrom,
    pendingRequests,
    recentUnfollows,
    likedPosts,
    likedComments,
    storyLikes,
    comments,
    dmConversations,
    importedAt,
  ];
}

