import '../entities/entities.dart';
import '../repositories/instagram_repository.dart';

class GetInstagramDataUseCase {
  final InstagramRepository repository;

  GetInstagramDataUseCase(this.repository);

  Future<InstagramData?> call() async {
    return await repository.getStoredData();
  }
}

