import '../../domain/entities/entities.dart';
import '../../core/utils/date_formatter.dart';

// Re-export for convenience
typedef _Decoder = InstagramTextDecoder;

/// Parser for Instagram JSON export files
class InstagramJsonParser {
  /// Parse followers_1.json - Array root with string_list_data
  static List<InstagramProfile> parseFollowers(List<dynamic> json) {
    final profiles = <InstagramProfile>[];
    for (final item in json) {
      final stringListData = item['string_list_data'] as List<dynamic>?;
      if (stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        profiles.add(InstagramProfile(
          username: data['value'] as String? ?? '',
          href: data['href'] as String?,
          timestamp: data['timestamp'] != null 
              ? DateFormatter.fromTimestamp(data['timestamp'] as int)
              : null,
        ));
      }
    }
    return profiles;
  }

  /// Parse following.json - Has relationships_following key with title field
  static List<InstagramProfile> parseFollowing(Map<String, dynamic> json) {
    final profiles = <InstagramProfile>[];
    final following = json['relationships_following'] as List<dynamic>?;
    if (following == null) return profiles;

    for (final item in following) {
      final title = item['title'] as String?;
      final stringListData = item['string_list_data'] as List<dynamic>?;
      
      String? href;
      DateTime? timestamp;
      
      if (stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        href = data['href'] as String?;
        if (data['timestamp'] != null) {
          timestamp = DateFormatter.fromTimestamp(data['timestamp'] as int);
        }
      }
      
      if (title != null && title.isNotEmpty) {
        profiles.add(InstagramProfile(
          username: title,
          href: href,
          timestamp: timestamp,
        ));
      }
    }
    return profiles;
  }

  /// Parse close_friends.json - Same format as followers
  static List<InstagramProfile> parseCloseFriends(Map<String, dynamic> json) {
    final profiles = <InstagramProfile>[];
    final closeFriends = json['relationships_close_friends'] as List<dynamic>?;
    if (closeFriends == null) return profiles;

    for (final item in closeFriends) {
      final stringListData = item['string_list_data'] as List<dynamic>?;
      if (stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        profiles.add(InstagramProfile(
          username: data['value'] as String? ?? '',
          href: data['href'] as String?,
          timestamp: data['timestamp'] != null 
              ? DateFormatter.fromTimestamp(data['timestamp'] as int)
              : null,
        ));
      }
    }
    return profiles;
  }

  /// Parse blocked_profiles.json
  static List<InstagramProfile> parseBlockedProfiles(Map<String, dynamic> json) {
    return _parseProfilesWithTitleKey(json, 'relationships_blocked_users');
  }

  /// Parse restricted_profiles.json
  static List<InstagramProfile> parseRestrictedProfiles(Map<String, dynamic> json) {
    return _parseProfilesWithStringListData(json, 'relationships_restricted_users');
  }

  /// Parse hide_story_from.json
  static List<InstagramProfile> parseHideStoryFrom(Map<String, dynamic> json) {
    return _parseProfilesWithStringListData(json, 'relationships_hide_stories_from');
  }

  /// Parse pending_follow_requests.json
  static List<InstagramProfile> parsePendingRequests(Map<String, dynamic> json) {
    return _parseProfilesWithStringListData(json, 'relationships_follow_requests_sent');
  }

  /// Parse recently_unfollowed_profiles.json
  static List<InstagramProfile> parseUnfollowed(Map<String, dynamic> json) {
    return _parseProfilesWithStringListData(json, 'relationships_unfollowed_users');
  }

  /// Parse liked_posts.json
  static List<LikedContent> parseLikedPosts(Map<String, dynamic> json) {
    final likes = <LikedContent>[];
    final mediaLikes = json['likes_media_likes'] as List<dynamic>?;
    if (mediaLikes == null) return likes;

    for (final item in mediaLikes) {
      final title = item['title'] as String?;
      final stringListData = item['string_list_data'] as List<dynamic>?;
      
      if (title != null && stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        likes.add(LikedContent(
          author: title,
          postUrl: data['href'] as String?,
          timestamp: data['timestamp'] != null 
              ? DateFormatter.fromTimestamp(data['timestamp'] as int)
              : DateTime.now(),
        ));
      }
    }
    return likes;
  }

  /// Parse liked_comments.json
  static List<LikedContent> parseLikedComments(Map<String, dynamic> json) {
    final likes = <LikedContent>[];
    final commentLikes = json['likes_comment_likes'] as List<dynamic>?;
    if (commentLikes == null) return likes;

    for (final item in commentLikes) {
      final title = item['title'] as String?;
      final stringListData = item['string_list_data'] as List<dynamic>?;
      
      if (title != null && stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        likes.add(LikedContent(
          author: title,
          postUrl: data['href'] as String?,
          timestamp: data['timestamp'] != null 
              ? DateFormatter.fromTimestamp(data['timestamp'] as int)
              : DateTime.now(),
        ));
      }
    }
    return likes;
  }

  /// Parse story_likes.json
  static List<StoryInteraction> parseStoryLikes(Map<String, dynamic> json) {
    final interactions = <StoryInteraction>[];
    final storyLikes = json['story_activities_story_likes'] as List<dynamic>?;
    if (storyLikes == null) return interactions;

    for (final item in storyLikes) {
      final title = item['title'] as String?;
      final stringListData = item['string_list_data'] as List<dynamic>?;
      
      if (title != null && stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        interactions.add(StoryInteraction(
          author: title,
          timestamp: data['timestamp'] != null 
              ? DateFormatter.fromTimestamp(data['timestamp'] as int)
              : DateTime.now(),
        ));
      }
    }
    return interactions;
  }

  /// Parse post_comments_1.json (array format)
  static List<Comment> parseComments(List<dynamic> json) {
    return _parseCommentsList(json);
  }

  /// Parse reels_comments.json (has object root with comments_reels_comments key)
  static List<Comment> parseReelsComments(Map<String, dynamic> json) {
    final reelsComments = json['comments_reels_comments'] as List<dynamic>?;
    if (reelsComments == null) return [];
    return _parseCommentsList(reelsComments);
  }

  /// Helper to parse comments from a list
  static List<Comment> _parseCommentsList(List<dynamic> json) {
    final comments = <Comment>[];
    for (final item in json) {
      final stringMapData = item['string_map_data'] as Map<String, dynamic>?;
      if (stringMapData == null) continue;

      final commentData = stringMapData['Comment'] as Map<String, dynamic>?;
      final ownerData = stringMapData['Media Owner'] as Map<String, dynamic>?;
      final timeData = stringMapData['Time'] as Map<String, dynamic>?;

      if (ownerData != null) {
        // Decode content to fix emoji encoding issues
        final rawContent = commentData?['value'] as String? ?? '';
        final decodedContent = _Decoder.decode(rawContent);
        
        comments.add(Comment(
          mediaOwner: ownerData['value'] as String? ?? '',
          content: decodedContent,
          timestamp: timeData?['timestamp'] != null 
              ? DateFormatter.fromTimestamp(timeData!['timestamp'] as int)
              : DateTime.now(),
        ));
      }
    }
    return comments;
  }

  /// Parse a single DM conversation message_1.json file
  /// Returns a tuple of (username, messageCount, lastMessageTimestamp)
  static DmConversation? parseDmConversation(Map<String, dynamic> json, String folderName) {
    // Extract username from folder name (format: username_numbers)
    final underscoreIndex = folderName.lastIndexOf('_');
    if (underscoreIndex == -1) return null;
    
    // Get the part before the last underscore (could be username with underscores)
    final username = folderName.substring(0, underscoreIndex);
    if (username.isEmpty) return null;

    final messages = json['messages'] as List<dynamic>?;
    if (messages == null || messages.isEmpty) return null;

    // Find the most recent message timestamp
    DateTime? lastMessageDate;
    for (final msg in messages) {
      final timestampMs = msg['timestamp_ms'] as int?;
      if (timestampMs != null) {
        final msgDate = DateTime.fromMillisecondsSinceEpoch(timestampMs);
        if (lastMessageDate == null || msgDate.isAfter(lastMessageDate)) {
          lastMessageDate = msgDate;
        }
      }
    }

    return DmConversation(
      username: username,
      messageCount: messages.length,
      lastMessageDate: lastMessageDate,
    );
  }

  // Helper methods
  static List<InstagramProfile> _parseProfilesWithTitleKey(
    Map<String, dynamic> json,
    String key,
  ) {
    final profiles = <InstagramProfile>[];
    final items = json[key] as List<dynamic>?;
    if (items == null) return profiles;

    for (final item in items) {
      final title = item['title'] as String?;
      final stringListData = item['string_list_data'] as List<dynamic>?;
      
      String? href;
      DateTime? timestamp;
      
      if (stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        href = data['href'] as String?;
        if (data['timestamp'] != null) {
          timestamp = DateFormatter.fromTimestamp(data['timestamp'] as int);
        }
      }
      
      if (title != null && title.isNotEmpty) {
        profiles.add(InstagramProfile(
          username: title,
          href: href,
          timestamp: timestamp,
        ));
      }
    }
    return profiles;
  }

  static List<InstagramProfile> _parseProfilesWithStringListData(
    Map<String, dynamic> json,
    String key,
  ) {
    final profiles = <InstagramProfile>[];
    final items = json[key] as List<dynamic>?;
    if (items == null) return profiles;

    for (final item in items) {
      final stringListData = item['string_list_data'] as List<dynamic>?;
      if (stringListData != null && stringListData.isNotEmpty) {
        final data = stringListData[0] as Map<String, dynamic>;
        final username = data['value'] as String? ?? '';
        if (username.isNotEmpty) {
          profiles.add(InstagramProfile(
            username: username,
            href: data['href'] as String?,
            timestamp: data['timestamp'] != null 
                ? DateFormatter.fromTimestamp(data['timestamp'] as int)
                : null,
          ));
        }
      }
    }
    return profiles;
  }
}

