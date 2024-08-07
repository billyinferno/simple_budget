import 'package:flutter/cupertino.dart';
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
          textAlign: TextAlign.center,
          maxLength: 6,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: MyColor.primaryColorDark,
        ),
        const Expanded(child: SizedBox(),),
        MyButton(
          color: MyColor.primaryColorDark,
          child: const Center(
            child: Text(
              "VIEW",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () async {
            _validateDashboardID();
          },
        ),
      ],
    );
  }

  Future<bool> _getUserMe() async {
    // TODO: to change with api call
    return false;
  }

  Future<bool> _checkPlanUID({required String uid}) async {
    bool checkResult = false;

    // show the loading overload
    LoadingScreen.instance().show(context: context);

    // call Plan API to see if this UID is exists or not?
    await PlanAPI.check(uid: uid).then((result) {
      debugPrint("Result $result");
      checkResult = result;
    }).whenComplete(() {
      LoadingScreen.instance().hide();
    },);
    
    return checkResult;
  }

  Future<void> _validateDashboardID() async {
    String dashboardId = _dashboardIdController.text.toUpperCase();
    if (dashboardId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        createSnackBar(
          message: "Please fill dashboard ID",
          color: MyColor.primaryColor,
        )
      );
      // stop processing
      return;
    }
    
    await _checkPlanUID(uid: dashboardId).then((result) {
      if (result) {
        _goToPINPage(uid: dashboardId);
      }
      else {
        _showSnackBar(errorMessage: "Plan with UID $dashboardId not found");
      }
    }).onError((error, stackTrace) {
      Log.error(
        message: "Error when call check plan UID",
        error: error,
        stackTrace: stackTrace,
      );
    },);
  }

  void _showSnackBar({required String errorMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      createSnackBar(
        message: errorMessage,
        color: MyColor.primaryColor,
      ),
    );
  }

  void _goToPINPage({required String uid}) {
    // go to pin input page
    context.go('/pin/$uid');
  }
}