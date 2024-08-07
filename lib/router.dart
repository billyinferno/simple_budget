import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';
import 'package:simple_budget/pages/user.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  final _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
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
        name: 'pin_input',
        path: '/pin/:id',
        builder: (context, state) {
          final String id = (state.pathParameters["id"] ?? '');
          return PinInputPage(id: id);
        },
      ),
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (context, state) {
          return const DashboardPage();
        },
      ),
      GoRoute(
        name: 'user',
        path: '/user',
        builder: (context, state) {
          return const UserPage();
        },
      ),
      GoRoute(
        path: '/plan/:uid',
        builder: (context, state) {
          final String uid = (state.pathParameters["uid"] ?? '');
          if (uid.isEmpty) {
            return const ErrorTemplatePage(
              title: "Plan UID Empty",
              message: "The Plan UID is empty, please ensure to check and input the correct UID for the plan."
            );
          }
          else {
            return PlanViewPage(uid: uid,);
          }
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final String uid = (state.pathParameters["uid"] ?? '');
              return PlanEditPage(uid: uid);
            },
          ),
          GoRoute(
            path: 'item/:date',
            builder: (context, state) {
              final String date = (state.pathParameters["date"] ?? '');
              return PlanItemPage(date: date,);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return ErrorTemplatePage(
        title: 'Page Not Found',
        message: 'The "${state.uri}" page that you looking for is not found. Please us arrow to return back to the main page.',
      );
    },
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