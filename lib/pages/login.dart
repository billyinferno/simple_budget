import 'package:flutter/material.dart';
import 'package:simple_budget/widgets/tab/my_tab_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getMe,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            return _generateBody();
          }
          else {
            // TODO: still loading, generate splash screen
            return const Placeholder();
          }
        },
      ),
    );
  }

  Widget _generateBody() {
    return Container(
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
          _showForm(),
        ],
      ),
    );
  }

  Widget _showForm() {
    if (_currentTab.toUpperCase() == "L") {
      return _showLoginForm();
    }
    else {
      return _showViewForm();
    }
  }

  Widget _showLoginForm() {
    // TODO: to do login form
    return Text("Login form");
  }

  Widget _showViewForm() {
    // TODO: to do view form
    return Text("View form");
  }

  Future<bool> _getUserMe() async {
    // TODO: to change with api call
    return false;
  }
}