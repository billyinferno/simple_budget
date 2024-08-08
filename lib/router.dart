import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> with TickerProviderStateMixin {
  late GoRouter _router;

  @override
  void initState() {
    _router = GoRouter(
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
            if (id.isEmpty) {
              return const ErrorTemplatePage(
                title: "Plan UID Empty",
                message: "The Plan UID is empty, please ensure to check and input the correct UID for the plan."
              );
            }

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
          name: 'plan-add',
          path: '/plan/add',
          builder: (context, state) {
            return const PlanAddPage();
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
      redirect: (context, state) async {
        String path = '';
        if (state.uri.pathSegments.isNotEmpty) {
          path = state.uri.pathSegments[0].toLowerCase();
        }

        // now check whether path is part of public or not?
        bool isPublic = false;
        bool isPin = false;
        switch(path) {
          case "":
          case "pin":
          case "login":
            isPublic = true;
            isPin = true;
            break;
          case "plan":
            // check the 2nd path
            // TODO: to check why plan add is not secured with JWT
            if (state.uri.pathSegments.length > 1) {
              String uid = (state.uri.pathSegments[1]).toUpperCase();
              // check if uid is ADD
              if (uid == "ADD") {
                isPin = false;
              }
              isPin = true;
            }
            else {
              isPin = false;
            }
            break;
        }

        if (!isPublic) {
          bool isLogin = await UserStorage.isLogin();
          bool isSecuredPin = false;
          if (isPin) {
            // this is only for plan view, the 2nd path should be the UID
            // so check whether we have the UID secured pin in the secure storage
            // or not?
            String securedPin = await UserStorage.getSecuredPin();

            if (securedPin.isNotEmpty) {
              isSecuredPin = true;
            }
          }

          if (!isLogin) {
            // check if this got secured PIN or not?
            if (!isSecuredPin) {
              return '/login';
            }
          }
        }

        // return null so we can go the the actual path
        return null;
      },
    );

    super.initState();
  }

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