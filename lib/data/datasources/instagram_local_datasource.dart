import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/entities.dart';
import '../models/instagram_json_models.dart';

abstract class InstagramLocalDataSource {
  Future<InstagramData> importFromZip(String zipPath);
  Future<InstagramData?> getStoredData();
  Future<void> saveData(InstagramData data);
  Future<void> clearData();
  Future<bool> hasData();
}

class InstagramLocalDataSourceImpl implements InstagramLocalDataSource {
  final SharedPreferences sharedPreferences;

  InstagramLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<InstagramData> importFromZip(String zipPath) async {
    final file = File(zipPath);
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Create temp directory for extraction
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory('${tempDir.path}/instagram_export');
    if (await extractDir.exists()) {
      await extractDir.delete(recursive: true);
    }
    await extractDir.create(recursive: true);

    // Extract files
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final outFile = File('${extractDir.path}/$filename');
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(data);
      }
    }

    // Parse all JSON files
    final followers = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.followersPath,
      (json) => InstagramJsonParser.parseFollowers(json as List<dynamic>),
    ) ?? [];

    final following = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.followingPath,
      (json) => InstagramJsonParser.parseFollowing(json as Map<String, dynamic>),
    ) ?? [];

    final closeFriends = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.closeFriendsPath,
      (json) => InstagramJsonParser.parseCloseFriends(json as Map<String, dynamic>),
    ) ?? [];

    final blockedProfiles = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.blockedPath,
      (json) => InstagramJsonParser.parseBlockedProfiles(json as Map<String, dynamic>),
    ) ?? [];

    final restrictedProfiles = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.restrictedPath,
      (json) => InstagramJsonParser.parseRestrictedProfiles(json as Map<String, dynamic>),
    ) ?? [];

    final hideStoryFrom = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.hideStoryPath,
      (json) => InstagramJsonParser.parseHideStoryFrom(json as Map<String, dynamic>),
    ) ?? [];

    final pendingRequests = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.pendingRequestsPath,
      (json) => InstagramJsonParser.parsePendingRequests(json as Map<String, dynamic>),
    ) ?? [];

    final recentUnfollows = await _parseJsonFile<List<InstagramProfile>>(
      extractDir,
      AppConstants.unfollowedPath,
      (json) => InstagramJsonParser.parseUnfollowed(json as Map<String, dynamic>),
    ) ?? [];

    final likedPosts = await _parseJsonFile<List<LikedContent>>(
      extractDir,
      AppConstants.likedPostsPath,
      (json) => InstagramJsonParser.parseLikedPosts(json as Map<String, dynamic>),
    ) ?? [];

    final likedComments = await _parseJsonFile<List<LikedContent>>(
      extractDir,
      AppConstants.likedCommentsPath,
      (json) => InstagramJsonParser.parseLikedComments(json as Map<String, dynamic>),
    ) ?? [];

    final storyLikes = await _parseJsonFile<List<StoryInteraction>>(
      extractDir,
      AppConstants.storyLikesPath,
      (json) => InstagramJsonParser.parseStoryLikes(json as Map<String, dynamic>),
    ) ?? [];

    final postComments = await _parseJsonFile<List<Comment>>(
      extractDir,
      AppConstants.commentsPath,
      (json) => InstagramJsonParser.parseComments(json as List<dynamic>),
    ) ?? [];

    final reelsComments = await _parseJsonFile<List<Comment>>(
      extractDir,
      AppConstants.reelsCommentsPath,
      (json) => InstagramJsonParser.parseReelsComments(json as Map<String, dynamic>),
    ) ?? [];

    // Combine all comments
    final comments = [...postComments, ...reelsComments];

    // Parse DM conversations
    final dmConversations = await _parseDmConversations(extractDir);

    // Cleanup
    await extractDir.delete(recursive: true);

    return InstagramData(
      followers: followers,
      following: following,
      closeFriends: closeFriends,
      blockedProfiles: blockedProfiles,
      restrictedProfiles: restrictedProfiles,
      hideStoryFrom: hideStoryFrom,
      pendingRequests: pendingRequests,
      recentUnfollows: recentUnfollows,
      likedPosts: likedPosts,
      likedComments: likedComments,
      storyLikes: storyLikes,
      comments: comments,
      dmConversations: dmConversations,
      importedAt: DateTime.now(),
    );
  }

  Future<List<DmConversation>> _parseDmConversations(Directory extractDir) async {
    final conversations = <DmConversation>[];
    
    try {
      final inboxDir = Directory('${extractDir.path}/${AppConstants.dmInboxPath}');
      if (!await inboxDir.exists()) return conversations;

      // List all conversation folders
      await for (final entity in inboxDir.list()) {
        if (entity is Directory) {
          final folderName = entity.path.split('/').last;
          
          // Look for message_1.json in each folder
          final messageFile = File('${entity.path}/message_1.json');
          if (await messageFile.exists()) {
            try {
              final content = await messageFile.readAsString();
              final json = jsonDecode(content) as Map<String, dynamic>;
              final conversation = InstagramJsonParser.parseDmConversation(json, folderName);
              if (conversation != null) {
                conversations.add(conversation);
              }
            } catch (e) {
              // Skip malformed files
              continue;
            }
          }
        }
      }
      
      // Sort by message count (most messages first)
      conversations.sort((a, b) => b.messageCount.compareTo(a.messageCount));
    } catch (e) {
      // Return empty list on error
    }
    
    return conversations;
  }

  Future<T?> _parseJsonFile<T>(
    Directory extractDir,
    String relativePath,
    T Function(dynamic) parser,
  ) async {
    try {
      final file = File('${extractDir.path}/$relativePath');
      if (!await file.exists()) return null;
      
      final content = await file.readAsString();
      final json = jsonDecode(content);
      return parser(json);
    } catch (e) {
      // File doesn't exist or parsing error - return null
      return null;
    }
  }

  @override
  Future<InstagramData?> getStoredData() async {
    final jsonString = sharedPreferences.getString(AppConstants.keyInstagramData);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return _instagramDataFromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveData(InstagramData data) async {
    final json = _instagramDataToJson(data);
    await sharedPreferences.setString(
      AppConstants.keyInstagramData,
      jsonEncode(json),
    );
    await sharedPreferences.setString(
      AppConstants.keyLastImportDate,
      data.importedAt.toIso8601String(),
    );
  }

  @override
  Future<void> clearData() async {
    await sharedPreferences.remove(AppConstants.keyInstagramData);
    await sharedPreferences.remove(AppConstants.keyLastImportDate);
  }

  @override
  Future<bool> hasData() async {
    return sharedPreferences.containsKey(AppConstants.keyInstagramData);
  }

  // Serialization helpers
  Map<String, dynamic> _instagramDataToJson(InstagramData data) {
    return {
      'followers': data.followers.map(_profileToJson).toList(),
      'following': data.following.map(_profileToJson).toList(),
      'closeFriends': data.closeFriends.map(_profileToJson).toList(),
      'blockedProfiles': data.blockedProfiles.map(_profileToJson).toList(),
      'restrictedProfiles': data.restrictedProfiles.map(_profileToJson).toList(),
      'hideStoryFrom': data.hideStoryFrom.map(_profileToJson).toList(),
      'pendingRequests': data.pendingRequests.map(_profileToJson).toList(),
      'recentUnfollows': data.recentUnfollows.map(_profileToJson).toList(),
      'likedPosts': data.likedPosts.map(_likedContentToJson).toList(),
      'likedComments': data.likedComments.map(_likedContentToJson).toList(),
      'storyLikes': data.storyLikes.map(_storyInteractionToJson).toList(),
      'comments': data.comments.map(_commentToJson).toList(),
      'dmConversations': data.dmConversations.map(_dmConversationToJson).toList(),
      'importedAt': data.importedAt.toIso8601String(),
    };
  }

  InstagramData _instagramDataFromJson(Map<String, dynamic> json) {
    return InstagramData(
      followers: (json['followers'] as List).map(_profileFromJson).toList(),
      following: (json['following'] as List).map(_profileFromJson).toList(),
      closeFriends: (json['closeFriends'] as List).map(_profileFromJson).toList(),
      blockedProfiles: (json['blockedProfiles'] as List).map(_profileFromJson).toList(),
      restrictedProfiles: (json['restrictedProfiles'] as List).map(_profileFromJson).toList(),
      hideStoryFrom: (json['hideStoryFrom'] as List).map(_profileFromJson).toList(),
      pendingRequests: (json['pendingRequests'] as List).map(_profileFromJson).toList(),
      recentUnfollows: (json['recentUnfollows'] as List).map(_profileFromJson).toList(),
      likedPosts: (json['likedPosts'] as List).map(_likedContentFromJson).toList(),
      likedComments: (json['likedComments'] as List).map(_likedContentFromJson).toList(),
      storyLikes: (json['storyLikes'] as List).map(_storyInteractionFromJson).toList(),
      comments: (json['comments'] as List).map(_commentFromJson).toList(),
      dmConversations: (json['dmConversations'] as List?)?.map(_dmConversationFromJson).toList() ?? [],
      importedAt: DateTime.parse(json['importedAt'] as String),
    );
  }

  Map<String, dynamic> _profileToJson(InstagramProfile p) => {
    'username': p.username,
    'href': p.href,
    'timestamp': p.timestamp?.toIso8601String(),
  };

  InstagramProfile _profileFromJson(dynamic json) => InstagramProfile(
    username: json['username'] as String,
    href: json['href'] as String?,
    timestamp: json['timestamp'] != null 
        ? DateTime.parse(json['timestamp'] as String) 
        : null,
  );

  Map<String, dynamic> _likedContentToJson(LikedContent l) => {
    'author': l.author,
    'postUrl': l.postUrl,
    'timestamp': l.timestamp.toIso8601String(),
  };

  LikedContent _likedContentFromJson(dynamic json) => LikedContent(
    author: json['author'] as String,
    postUrl: json['postUrl'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  Map<String, dynamic> _storyInteractionToJson(StoryInteraction s) => {
    'author': s.author,
    'timestamp': s.timestamp.toIso8601String(),
    'value': s.value,
  };

  StoryInteraction _storyInteractionFromJson(dynamic json) => StoryInteraction(
    author: json['author'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    value: json['value'] as String?,
  );

  Map<String, dynamic> _commentToJson(Comment c) => {
    'mediaOwner': c.mediaOwner,
    'content': c.content,
    'timestamp': c.timestamp.toIso8601String(),
  };

  Comment _commentFromJson(dynamic json) => Comment(
    mediaOwner: json['mediaOwner'] as String,
    content: json['content'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  Map<String, dynamic> _dmConversationToJson(DmConversation dm) => {
    'username': dm.username,
    'messageCount': dm.messageCount,
    'lastMessageDate': dm.lastMessageDate?.toIso8601String(),
  };

  DmConversation _dmConversationFromJson(dynamic json) => DmConversation(
    username: json['username'] as String,
    messageCount: json['messageCount'] as int,
    lastMessageDate: json['lastMessageDate'] != null
        ? DateTime.parse(json['lastMessageDate'] as String)
        : null,
  );
}

