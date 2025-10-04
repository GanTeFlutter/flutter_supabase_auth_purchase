part of '../../main.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
    GoRoute(
      name: 'LoginPage',
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      name: 'AccountPage',
      path: '/account',
      builder: (BuildContext context, GoRouterState state) {
        return const AccountPage();
      },
    ),
    GoRoute(
      name: 'HomeView',
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
    ),
  ],
);
