import 'package:amumal/domain/model/feed_model.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/ui/pages/comments/view/comment_page.dart';
import 'package:amumal/ui/pages/feed/view/feed_view.dart';
import 'package:amumal/ui/pages/home/view/home_page.dart';
import 'package:amumal/ui/pages/join/view/root_page.dart';
import 'package:amumal/ui/pages/join/view/splash_page.dart';
import 'package:amumal/ui/pages/login/view/login_page.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/root',
      builder: (context, state) => const RootPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Loginpage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final user = state.extra as UserModel?;
        if (user == null) {
          // user가 없으면 root로 리다이렉트
          return const RootPage();
        }
        return HomePage(user: user);
      },
    ),
    GoRoute(
      path: '/feed',
      builder: (context, state) {
        final user = state.extra as UserModel?;
        if (user == null) {
          return const RootPage();
        }
        return FeedView(user: user);
      },
    ),
    GoRoute(
      path: '/feed/:feedId/edit',
      builder: (context, state) {
        // feedId는 경로 파라미터로만 사용, 실제 데이터는 extra에서 가져옴
        final extra = state.extra as Map<String, dynamic>?;
        final user = extra?['user'] as UserModel?;
        final existingFeed = extra?['feed'] as FeedModel?;
        
        if (user == null) {
          return const RootPage();
        }
        return FeedView(user: user, existingFeed: existingFeed);
      },
    ),
    GoRoute(
      path: '/comment/:feedId',
      builder: (context, state) {
        final feedId = state.pathParameters['feedId']!;
        final user = state.extra as UserModel?;
        if (user == null) {
          return const RootPage();
        }
        return CommentPage(feedId: feedId, user: user);
      },
    ),
  ],
);
