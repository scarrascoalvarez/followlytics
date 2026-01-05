import '../entities/entities.dart';
import '../repositories/instagram_repository.dart';

class GetFollowAnalyticsUseCase {
  final InstagramRepository repository;

  GetFollowAnalyticsUseCase(this.repository);

  FollowAnalytics call(InstagramData data) {
    return repository.calculateFollowAnalytics(data);
  }
}

