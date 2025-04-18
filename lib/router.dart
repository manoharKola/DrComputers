import 'package:drcomputer/main.dart';
import 'package:go_router/go_router.dart';
import 'dashboard.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListPage(),
    ),
    GoRoute(
      path: '/product/:title',
      builder: (context, state) {
        final title = state.pathParameters['title'] ?? '';
        return ProductDetailPage(productTitle: title, product: null,);
      },
    ),
  ],
);