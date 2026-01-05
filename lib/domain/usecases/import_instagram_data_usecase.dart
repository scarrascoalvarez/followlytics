import '../entities/entities.dart';
import '../repositories/instagram_repository.dart';

class ImportInstagramDataUseCase {
  final InstagramRepository repository;

  ImportInstagramDataUseCase(this.repository);

  Future<InstagramData> call(String zipPath) async {
    final data = await repository.importFromZip(zipPath);
    await repository.saveData(data);
    return data;
  }
}

