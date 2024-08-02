import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_budget/globals.dart';
import 'package:simple_budget/themes/colors.dart';
import 'package:simple_budget/widgets/tab/my_tab_bar.dart';

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
            // TODO: still loading, generate splash screen
            return const Placeholder();
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
              child: _showForm()
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "DASHBOARD ID",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5,),
        CupertinoTextField(
          controller: _dashboardIdController,
          decoration: BoxDecoration(
            color: MyColor.backgroundColor,
            borderRadius: BorderRadius.circular(25)
          ),
        ),
        const Expanded(child: SizedBox(),),
        Text("BUTTON"),
      ],
    );
  }

  Future<bool> _getUserMe() async {
    // TODO: to change with api call
    return false;
  }
}