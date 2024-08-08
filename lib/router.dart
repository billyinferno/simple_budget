import 'package:flutter/cupertino.dart';
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
  late AnimationController _primary;
  late AnimationController _secondary;
  late Animation<double> _primaryAnimation;
  late Animation<double> _secondaryAnimation;
  
  late GoRouter _router;

  @override
  void initState() {
    _primary = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _secondary = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _primaryAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _primary, curve: Curves.easeOut));
    _secondaryAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _secondary, curve: Curves.easeOut));
    _primary.forward();

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
              return CupertinoFullscreenDialogTransition(
                primaryRouteAnimation: _primaryAnimation,
                secondaryRouteAnimation: _secondaryAnimation,
                linearTransition: false,
                child: PlanViewPage(uid: uid,),
              );
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
        //TODO: to check for specific page only
        bool isLogin = await UserStorage.isLogin();
        if (!isLogin) return '/login';
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