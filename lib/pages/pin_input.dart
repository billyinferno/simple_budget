import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class PinInputPage extends StatefulWidget {
  final String id;
  const PinInputPage({
    super.key,
    required this.id,
  });

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  late int _pinTries;

  @override
  void initState() {
    // set pin tries to 0
    _pinTries = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.primaryColorDark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyPinInput(
            uid: widget.id,
            title: "Input PIN for Plan ${widget.id}",
            onPinSubmit: (pinData) async {
              await _verifyPin(
                uid: widget.id,
                pin: pinData,
              ).then((result) {
                if (result) {
                  // go to the plan page
                  _goToPlanPage();
                }
              },);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _verifyPin({required String uid, required String pin}) async {
    bool verifyResult = false;

    // show the loading overlay
    LoadingScreen.instance().show(context: context);

    try {
      await PlanAPI.verifyPIN(
        uid: uid,
        pin: pin
      ).then((result) async {
        // stored the pin model result on the secure storage
        Log.info(message: "🔐 Put secure PIN for $uid in SecureBox");
        await UserStorage.putSecuredPin(data: result);

        verifyResult = true;
      }).whenComplete(() {
        // remove loading screen overload
        LoadingScreen.instance().hide();
      },);
    }
    on NetException catch (netError, stackTrace) {
      // get the status code to determine whether this is due to unathorized
      // call or else?
      if (netError.code == 403) {
        // PIN is invalid
        _showInvalidPin();

        // add the pin tries
        _pinTries = _pinTries + 1;

        // show error log
        Log.error(
          message: "🔐 Invalid PIN for plan $uid",
          error: netError,
          stackTrace: stackTrace,
        );
      }
      else {
        // Other error
        Log.error(
          message: "⛔ ${netError.message}",
          error: netError,
          stackTrace: stackTrace,
        );

        if (mounted) {
          MyDialog.showAlert(
            context: context,
            text: netError.message,
            okayColor: MyColor.errorColor,
          );
        }
      }
    }
    catch (error, stackTrace) {
      // Other error
      Log.error(
        message: "⛔ ${error.toString()}",
        error: error,
        stackTrace: stackTrace,
      );

      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error processing on the application",
          okayColor: MyColor.errorColor,
        );
      }
    }

    return verifyResult;
  }

  void _goToPlanPage() {
    context.go('/plan/${widget.id}');
  }

  void _showInvalidPin() {
    MyDialog.showAlert(
      context: context,
      title: 'Invalid PIN',
      text: 'Invalid PIN for viewing plan ${widget.id}.\nPlease check with the owner of the plan for the correct PIN.',
      okayColor: MyColor.errorColor,
    );
  }
}