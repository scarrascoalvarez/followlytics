import '../entities/entities.dart';
import '../repositories/instagram_repository.dart';

class GetInteractionAnalyticsUseCase {
  final InstagramRepository repository;

  GetInteractionAnalyticsUseCase(this.repository);

  InteractionAnalytics call(InstagramData data, {DateTime? startDate}) {
    return repository.calculateInteractionAnalytics(data, startDate: startDate);
  }
}

