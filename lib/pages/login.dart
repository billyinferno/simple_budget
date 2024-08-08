import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _dashboardIdController = TextEditingController();
  
  late Future<bool> _getMe;
  late String _currentTab;
  final Map<String, String> _tab = {
    "L":"Login",
    "V":"View",
  };

  @override
  void initState() {
    _getMe = _getUserMe();

    // set current tab defaulted to login
    _currentTab = "L";

    super.initState();
  }

  @override
  void dispose() {
    _dashboardIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getMe,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            return _generateBody();
          }
          else {
            return const LoadingPage();
          }
        },
      ),
    );
  }

  Widget _generateBody() {
    return Container(
      color: MyColor.primaryColorDark,
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyTabBar(
            tab: _tab,
            initialTab: _currentTab,
            onTap: ((value) {
              setState(() {              
                _currentTab = value;
              });
            })
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColor.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: _showPage()
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            "simple budget - ${Globals.appVersion}",
            style: const TextStyle(
              color: MyColor.backgroundColorDark,
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }

  Widget _showPage() {
    if (_currentTab.toUpperCase() == "L") {
      return const LoginFormPage();
    }
    else {
      return const LoginViewPage();
    }
  }

  Future<bool> _getUserMe() async {
    // check if we have JWT in the secure storage first
    String jwt = await UserStorage.jwt();
    if (jwt.isEmpty) {
      // no JWT, means user not login
      Log.info(message: "👤 User not yet login");
      return false;
    }

    // if reach here, it means that JWT is exists, set the JWT we want to use
    NetUtils.setJWT(bearerToken: jwt);

    // users/me API to get the user information
    Log.info(message: "👤 Get users/me information");
    await UserAPI.me().then((user) async {
      // user login already, stored the user information model in the storage
      await UserStorage.setUserInfo(user);

      // we can go to the dashboard instead stay in login screen
      if (mounted) {
        Log.info(message: "🔐 User login already navigate to dashboard");
        context.go('/dashboard');
      }
    },).onError((error, stackTrace) {
      // user JWT token is expired
      Log.error(
        message: "👤 User JWT token is expired",
        error: error,
        stackTrace: stackTrace,
      );
    },);

    // default this to return false so we can show the login screen
    return false;
  }
}