import 'package:equatable/equatable.dart';
import 'instagram_profile.dart';

class FollowAnalytics extends Equatable {
  final List<InstagramProfile> nonFollowers;
  final List<InstagramProfile> fans;
  final List<InstagramProfile> mutuals;
  final List<InstagramProfile> nonMutualCloseFriends;
  final List<InstagramProfile> pendingRequests;

  const FollowAnalytics({
    required this.nonFollowers,
    required this.fans,
    required this.mutuals,
    required this.nonMutualCloseFriends,
    required this.pendingRequests,
  });

  factory FollowAnalytics.empty() => const FollowAnalytics(
    nonFollowers: [],
    fans: [],
    mutuals: [],
    nonMutualCloseFriends: [],
    pendingRequests: [],
  );

  /// Solicitudes pendientes de más de 30 días
  List<InstagramProfile> get oldPendingRequests {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return pendingRequests
        .where((p) => p.timestamp != null && p.timestamp!.isBefore(thirtyDaysAgo))
        .toList();
  }

  @override
  List<Object?> get props => [
    nonFollowers,
    fans,
    mutuals,
    nonMutualCloseFriends,
    pendingRequests,
  ];
}

