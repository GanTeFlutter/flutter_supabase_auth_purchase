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
      name: 'LoginView',
      path: '/loginview',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginView();
      },
    ),
    GoRoute(
      name: 'HomeView',
      path: '/homeview',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'AccountView',
          path: '/accountview',
          builder: (BuildContext context, GoRouterState state) {
            return const AccountView();
          },
        ),

        GoRoute(
          name: 'PurchaseView',
          path: '/purchaseview',
          builder: (BuildContext context, GoRouterState state) {
            return const PurchaseView();
          },
        ),
      ],
    ),
  ],
);
