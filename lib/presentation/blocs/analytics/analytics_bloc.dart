import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/get_instagram_data_usecase.dart';
import '../../../domain/usecases/get_follow_analytics_usecase.dart';
import '../../../domain/usecases/get_interaction_analytics_usecase.dart';

// Events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class AnalyticsLoadRequested extends AnalyticsEvent {
  const AnalyticsLoadRequested();
}

class AnalyticsDataUpdated extends AnalyticsEvent {
  final InstagramData data;

  const AnalyticsDataUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

// State
enum AnalyticsStatus { initial, loading, loaded, noData, error }

class AnalyticsState extends Equatable {
  final AnalyticsStatus status;
  final InstagramData? instagramData;
  final FollowAnalytics? followAnalytics;
  final InteractionAnalytics? interactionAnalytics;
  final String? errorMessage;

  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.instagramData,
    this.followAnalytics,
    this.interactionAnalytics,
    this.errorMessage,
  });

  bool get hasData => instagramData != null && instagramData!.isNotEmpty;

  int get followersCount => instagramData?.followers.length ?? 0;
  int get followingCount => instagramData?.following.length ?? 0;
  int get nonFollowersCount => followAnalytics?.nonFollowers.length ?? 0;
  int get fansCount => followAnalytics?.fans.length ?? 0;
  int get mutualsCount => followAnalytics?.mutuals.length ?? 0;
  int get pendingRequestsCount => followAnalytics?.pendingRequests.length ?? 0;
  int get oldPendingRequestsCount => followAnalytics?.oldPendingRequests.length ?? 0;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    InstagramData? instagramData,
    FollowAnalytics? followAnalytics,
    InteractionAnalytics? interactionAnalytics,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      instagramData: instagramData ?? this.instagramData,
      followAnalytics: followAnalytics ?? this.followAnalytics,
      interactionAnalytics: interactionAnalytics ?? this.interactionAnalytics,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    instagramData,
    followAnalytics,
    interactionAnalytics,
    errorMessage,
  ];
}

// BLoC
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetInstagramDataUseCase getInstagramDataUseCase;
  final GetFollowAnalyticsUseCase getFollowAnalyticsUseCase;
  final GetInteractionAnalyticsUseCase getInteractionAnalyticsUseCase;

  AnalyticsBloc({
    required this.getInstagramDataUseCase,
    required this.getFollowAnalyticsUseCase,
    required this.getInteractionAnalyticsUseCase,
  }) : super(const AnalyticsState()) {
    on<AnalyticsLoadRequested>(_onLoadRequested);
    on<AnalyticsDataUpdated>(_onDataUpdated);
  }

  Future<void> _onLoadRequested(
    AnalyticsLoadRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading));

    try {
      final data = await getInstagramDataUseCase();
      
      if (data == null || data.isEmpty) {
        emit(state.copyWith(status: AnalyticsStatus.noData));
        return;
      }

      final followAnalytics = getFollowAnalyticsUseCase(data);
      final interactionAnalytics = getInteractionAnalyticsUseCase(data);

      emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        instagramData: data,
        followAnalytics: followAnalytics,
        interactionAnalytics: interactionAnalytics,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnalyticsStatus.error,
        errorMessage: 'Error al cargar los datos',
      ));
    }
  }

  void _onDataUpdated(
    AnalyticsDataUpdated event,
    Emitter<AnalyticsState> emit,
  ) {
    final followAnalytics = getFollowAnalyticsUseCase(event.data);
    final interactionAnalytics = getInteractionAnalyticsUseCase(event.data);

    emit(state.copyWith(
      status: AnalyticsStatus.loaded,
      instagramData: event.data,
      followAnalytics: followAnalytics,
      interactionAnalytics: interactionAnalytics,
    ));
  }
}

