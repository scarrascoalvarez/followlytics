import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection_container.dart';
import '../blocs/analytics/analytics_bloc.dart';
import '../blocs/import/import_bloc.dart';
import '../pages/splash_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/export_guide_page.dart';
import '../pages/import_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/non_followers_page.dart';
import '../pages/fans_page.dart';
import '../pages/mutuals_page.dart';
import '../pages/top_interactions_page.dart';
import '../pages/pending_requests_page.dart';
import '../pages/settings_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/export-guide',
        builder: (context, state) => const ExportGuidePage(),
      ),
      GoRoute(
        path: '/import',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ImportBloc>(),
          child: const ImportPage(),
        ),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsLoadRequested()),
          child: const DashboardPage(),
        ),
        routes: [
          GoRoute(
            path: 'non-followers',
            builder: (context, state) {
              final bloc = state.extra as AnalyticsBloc?;
              if (bloc != null) {
                return BlocProvider.value(
                  value: bloc,
                  child: const NonFollowersPage(),
                );
              }
              return BlocProvider(
                create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsLoadRequested()),
                child: const NonFollowersPage(),
              );
            },
          ),
          GoRoute(
            path: 'fans',
            builder: (context, state) {
              final bloc = state.extra as AnalyticsBloc?;
              if (bloc != null) {
                return BlocProvider.value(
                  value: bloc,
                  child: const FansPage(),
                );
              }
              return BlocProvider(
                create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsLoadRequested()),
                child: const FansPage(),
              );
            },
          ),
          GoRoute(
            path: 'mutuals',
            builder: (context, state) {
              final bloc = state.extra as AnalyticsBloc?;
              if (bloc != null) {
                return BlocProvider.value(
                  value: bloc,
                  child: const MutualsPage(),
                );
              }
              return BlocProvider(
                create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsLoadRequested()),
                child: const MutualsPage(),
              );
            },
          ),
          GoRoute(
            path: 'top-interactions',
            builder: (context, state) {
              final bloc = state.extra as AnalyticsBloc?;
              if (bloc != null) {
                return BlocProvider.value(
                  value: bloc,
                  child: const TopInteractionsPage(),
                );
              }
              return BlocProvider(
                create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsLoadRequested()),
                child: const TopInteractionsPage(),
              );
            },
          ),
          GoRoute(
            path: 'pending-requests',
            builder: (context, state) {
              final bloc = state.extra as AnalyticsBloc?;
              if (bloc != null) {
                return BlocProvider.value(
                  value: bloc,
                  child: const PendingRequestsPage(),
                );
              }
              return BlocProvider(
                create: (_) => sl<AnalyticsBloc>()..add(const AnalyticsLoadRequested()),
                child: const PendingRequestsPage(),
              );
            },
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );

  static Future<String> getInitialRoute() async {
    final prefs = sl<SharedPreferences>();
    final hasSeenOnboarding = prefs.getBool(AppConstants.keyHasSeenOnboarding) ?? false;
    final hasData = prefs.containsKey(AppConstants.keyInstagramData);

    if (!hasSeenOnboarding) {
      return '/onboarding';
    } else if (!hasData) {
      return '/export-guide';
    } else {
      return '/';
    }
  }
}

