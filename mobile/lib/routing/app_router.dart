import 'package:go_router/go_router.dart';
import '../features/devs/presentation/pages/devs_list_page.dart';
import '../features/devs/presentation/pages/dev_create_page.dart';
import '../features/devs/presentation/pages/dev_detail_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DevsListPage(),
    ),
    // /devs/new must come before /devs/:id to avoid being matched as id="new"
    GoRoute(
      path: '/devs/new',
      builder: (context, state) => const DevCreatePage(),
    ),
    GoRoute(
      path: '/devs/:id',
      builder: (context, state) => DevDetailPage(
        id: state.pathParameters['id']!,
      ),
    ),
  ],
);
