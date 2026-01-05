import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewedProfilesService {
  static const String _key = 'reviewed_profiles';
  final SharedPreferences _prefs;

  ReviewedProfilesService(this._prefs);

  Set<String> getReviewedProfiles() {
    final json = _prefs.getString(_key);
    if (json == null) return {};
    final list = List<String>.from(jsonDecode(json));
    return list.toSet();
  }

  Future<void> markAsReviewed(String username) async {
    final reviewed = getReviewedProfiles();
    reviewed.add(username.toLowerCase());
    await _prefs.setString(_key, jsonEncode(reviewed.toList()));
  }

  Future<void> unmarkAsReviewed(String username) async {
    final reviewed = getReviewedProfiles();
    reviewed.remove(username.toLowerCase());
    await _prefs.setString(_key, jsonEncode(reviewed.toList()));
  }

  bool isReviewed(String username) {
    return getReviewedProfiles().contains(username.toLowerCase());
  }

  Future<void> clearAll() async {
    await _prefs.remove(_key);
  }
}

