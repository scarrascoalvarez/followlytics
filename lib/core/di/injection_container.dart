import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/instagram_local_datasource.dart';
import '../../data/repositories/instagram_repository_impl.dart';
import '../../domain/repositories/instagram_repository.dart';
import '../../domain/usecases/get_instagram_data_usecase.dart';
import '../../domain/usecases/import_instagram_data_usecase.dart';
import '../../domain/usecases/get_follow_analytics_usecase.dart';
import '../../domain/usecases/get_interaction_analytics_usecase.dart';
import '../../presentation/blocs/import/import_bloc.dart';
import '../../presentation/blocs/analytics/analytics_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<InstagramLocalDataSource>(
    () => InstagramLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<InstagramRepository>(
    () => InstagramRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => ImportInstagramDataUseCase(sl()));
  sl.registerLazySingleton(() => GetInstagramDataUseCase(sl()));
  sl.registerLazySingleton(() => GetFollowAnalyticsUseCase(sl()));
  sl.registerLazySingleton(() => GetInteractionAnalyticsUseCase(sl()));

  // BLoCs
  sl.registerFactory<ImportBloc>(() => ImportBloc(
    importDataUseCase: sl(),
  ));
  
  sl.registerFactory<AnalyticsBloc>(() => AnalyticsBloc(
    getInstagramDataUseCase: sl(),
    getFollowAnalyticsUseCase: sl(),
    getInteractionAnalyticsUseCase: sl(),
  ));
}

