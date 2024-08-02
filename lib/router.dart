import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/pages/dashboard.dart';
import 'package:simple_budget/pages/dashboard/dashboard_add.dart';
import 'package:simple_budget/pages/dashboard/dashboard_edit.dart';
import 'package:simple_budget/pages/login.dart';
import 'package:simple_budget/themes/themes.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  final _router = 
    GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        GoRoute(
          name: 'default',
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: 'dashboard',
          path: '/dashboard/:id',
          builder: (context, state) {
            debugPrint("here!");
            final String id = (state.pathParameters["id"] ?? '');
            if (id.isEmpty) {
              // TODO: show invalid ID dashboard
              return const DashboardPage(id: 'empty',);
            }
            else {
              return DashboardPage(id: id,);
            }
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'add',
              builder: (context, state) {
                return const DashboardAddPage();
              },
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                return const DashboardEditPage();
              },
            ),
          ],
        ),
      ],
    );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: themeData,
      routerConfig: _router,
    );
  }
}