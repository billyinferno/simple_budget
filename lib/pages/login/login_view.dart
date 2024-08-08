import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class LoginViewPage extends StatefulWidget {
  const LoginViewPage({super.key});

  @override
  State<LoginViewPage> createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginViewPage> {
  final TextEditingController _dashboardIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dashboardIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            await _validateDashboardID();
          },
        ),
      ],
    );
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

  Future<bool> _checkPlanUID({required String uid}) async {
    bool checkResult = false;

    // show the loading overload
    LoadingScreen.instance().show(context: context);

    // call Plan API to see if this UID is exists or not?
    await PlanAPI.check(uid: uid).then((result) {
      checkResult = result;
    }).whenComplete(() {
      LoadingScreen.instance().hide();
    },);
    
    return checkResult;
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
    debugPrint("eh?");
    // go to pin input page
    context.go('/pin/$uid');
  }
}