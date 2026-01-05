import '../entities/entities.dart';

abstract class InstagramRepository {
  Future<InstagramData> importFromZip(String zipPath);
  Future<InstagramData?> getStoredData();
  Future<void> saveData(InstagramData data);
  Future<void> clearData();
  Future<bool> hasData();
  
  FollowAnalytics calculateFollowAnalytics(InstagramData data);
  InteractionAnalytics calculateInteractionAnalytics(InstagramData data, {DateTime? startDate});
}

