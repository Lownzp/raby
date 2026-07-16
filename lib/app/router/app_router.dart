import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/profile_page.dart';
import '../../features/rabbits/presentation/rabbit_detail_page.dart';
import '../../features/rabbits/presentation/rabbit_edit_page.dart';
import '../../features/rabbits/presentation/rabbit_onboarding_page.dart';
import '../../features/records/presentation/diary_edit_page.dart';
import '../../features/records/presentation/diary_detail_page.dart';
import '../../features/records/presentation/diary_search_page.dart';
import '../../features/records/presentation/photo_album_page.dart';
import '../../features/records/presentation/photo_viewer_page.dart';
import '../../features/records/presentation/records_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/startup/presentation/startup_page.dart';
import '../../features/weight/presentation/weight_edit_page.dart';
import '../../features/weight/presentation/weight_page.dart';
import '../../shared/navigation/raby_shell.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.startup}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoutes.startup),
      GoRoute(
        path: AppRoutes.startup,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: StartupPage()),
      ),
      GoRoute(
        path: AppRoutes.onboardingRabbit,
        pageBuilder: (context, state) =>
            const MaterialPage(child: RabbitOnboardingPage()),
      ),
      GoRoute(
        path: AppRoutes.rabbitDetail,
        pageBuilder: (context, state) =>
            const MaterialPage(child: RabbitDetailPage()),
      ),
      GoRoute(
        path: AppRoutes.rabbitEdit,
        pageBuilder: (context, state) =>
            const MaterialPage(child: RabbitEditPage()),
      ),
      GoRoute(
        path: AppRoutes.recordsSearch,
        pageBuilder: (context, state) =>
            const MaterialPage(child: DiarySearchPage()),
      ),
      GoRoute(
        path: AppRoutes.recordsNew,
        pageBuilder: (context, state) =>
            const MaterialPage(child: DiaryEditPage()),
      ),
      GoRoute(
        path: AppRoutes.recordDetailPattern,
        pageBuilder: (context, state) => MaterialPage(
          child: DiaryDetailPage(diaryId: state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.recordEditPattern,
        pageBuilder: (context, state) => MaterialPage(
          child: DiaryEditPage(diaryId: state.pathParameters['id']),
        ),
      ),
      GoRoute(
        path: AppRoutes.weightNew,
        pageBuilder: (context, state) => MaterialPage(
          child: WeightEditPage(returnToPrevious: state.extra == true),
        ),
      ),
      GoRoute(
        path: AppRoutes.weightEditPattern,
        pageBuilder: (context, state) => MaterialPage(
          child: WeightEditPage(recordId: state.pathParameters['id']),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SettingsPage()),
      ),
      GoRoute(
        path: AppRoutes.mediaAlbum,
        pageBuilder: (context, state) =>
            const MaterialPage(child: PhotoAlbumPage()),
      ),
      GoRoute(
        path: AppRoutes.mediaPhotos,
        pageBuilder: (context, state) {
          final extra = state.extra;
          return MaterialPage(
            fullscreenDialog: true,
            child: PhotoViewerPage(
              args: extra is PhotoViewerArgs
                  ? extra
                  : const PhotoViewerArgs.empty(),
            ),
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return RabyShell(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.records,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RecordsPage()),
          ),
          GoRoute(
            path: AppRoutes.weight,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WeightPage()),
          ),
          GoRoute(
            path: AppRoutes.me,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
    ],
  );
}

final appRouter = createAppRouter();
