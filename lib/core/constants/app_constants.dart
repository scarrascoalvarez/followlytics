class AppConstants {
  static const String appName = 'Followlytics';
  static const String appVersion = '1.0.0';
  
  // Instagram URLs
  static const String instagramExportUrl = 
      'https://accountscenter.instagram.com/info_and_permissions/dyi/?entry_point=notification';
  static const String instagramProfileBaseUrl = 'https://www.instagram.com/';
  
  // Storage keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyLastImportDate = 'last_import_date';
  static const String keyInstagramData = 'instagram_data';
  
  // File paths within Instagram export
  static const String followersPath = 'connections/followers_and_following/followers_1.json';
  static const String followingPath = 'connections/followers_and_following/following.json';
  static const String closeFriendsPath = 'connections/followers_and_following/close_friends.json';
  static const String blockedPath = 'connections/followers_and_following/blocked_profiles.json';
  static const String restrictedPath = 'connections/followers_and_following/restricted_profiles.json';
  static const String hideStoryPath = 'connections/followers_and_following/hide_story_from.json';
  static const String pendingRequestsPath = 'connections/followers_and_following/pending_follow_requests.json';
  static const String recentRequestsPath = 'connections/followers_and_following/recent_follow_requests.json';
  static const String unfollowedPath = 'connections/followers_and_following/recently_unfollowed_profiles.json';
  static const String likedPostsPath = 'your_instagram_activity/likes/liked_posts.json';
  static const String likedCommentsPath = 'your_instagram_activity/likes/liked_comments.json';
  static const String commentsPath = 'your_instagram_activity/comments/post_comments_1.json';
  static const String storyLikesPath = 'your_instagram_activity/story_interactions/story_likes.json';
  
  // Privacy messages
  static const List<String> privacyMessages = [
    'Tus datos nunca salen de tu dispositivo',
    'No recopilamos información personal',
    'Sin login de Instagram requerido',
    'Cumple con políticas de Instagram',
  ];
}

