import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
  late String _pinData;

  @override
  void initState() {
    // default the pin data into empty
    _pinData = '';

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
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    "Input PIN for plan with UID ${widget.id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 80,),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(6, (index) {
                      return _pinBox(id: (index+1), pinData: _pinData);
                    }),
                  ),
                ),
                const SizedBox(height: 40,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _inputButton(num: "1"),
                    _inputButton(num: "2"),
                    _inputButton(num: "3"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _inputButton(num: "4"),
                    _inputButton(num: "5"),
                    _inputButton(num: "6"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _inputButton(num: "7"),
                    _inputButton(num: "8"),
                    _inputButton(num: "9"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _inputButton(num: " ", disabled: true),
                    _inputButton(num: "0"),
                    _deleteButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pinBox({
    required int id,
    required String pinData,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: (pinData.length >= id ? MyColor.primaryColor : Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _inputButton({
    required String num,
    bool? disabled,
  }) {
    return GestureDetector(
      onTap: (() async {
        if (!(disabled ?? false)) {
          // check if pinData is less than 6 or not?
          if (_pinData.length < 6) {
            setState(() {
              _pinData = "$_pinData$num";
            });
          }
          
          if (_pinData.length == 6) {
            // this is means the pin data already 6
            await _verifyPin(uid: widget.id, pin: _pinData).then((result) {
              if (result) {
                _goToPlanPage();
              }
            },);
          }
        }
      }),
      child: Container(
        margin: const EdgeInsets.all(20),
        width: 60,
        height: 60,
        color: Colors.transparent,
        child: Center(
          child: Text(
            num,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return GestureDetector(
      onTap: (() {
        // check if pinData is less than 6 or not?
        if (_pinData.isNotEmpty) {
          setState(() {
            _pinData = _pinData.substring(0, (_pinData.length - 1));
          });
        }
      }),
      child: Container(
        margin: const EdgeInsets.all(20),
        width: 60,
        height: 60,
        color: Colors.transparent,
        child: const Center(
          child: Icon(
            LucideIcons.circle_arrow_left,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool> _verifyPin({required String uid, required String pin}) async {
    bool verifyResult = false;

    // show the loading overlay
    LoadingScreen.instance().show(context: context);

    await PlanAPI.verifyPIN(
      uid: uid,
      pin: pin
    ).then((result) async {
      // stored the pin model result on the secure storage
      Log.info(message: "🔐 Put secure PIN for $uid in SecureBox");
      await UserStorage.putSecuredPin(data: result);

      verifyResult = true;
    }).onError((error, stackTrace) {
      // reset the pin data into blank again
      setState(() {
        _pinData = '';
      });
      
      // convert error to NetException
      NetException netError = error as NetException;

      // get the status code to determine whether this is due to unathorized
      // call or else?
      if (netError.code == 403) {
        // PIN is invalid
        _showInvalidPin();
        Log.error(message: "🔐 Invalid PIN for plan $uid");
      }
      else {
        // Other error
        //TODO: show the error dialog
        Log.error(message: "⛔ ${netError.message}");
      }
    },).whenComplete(() {
      // remove loading screen overload
      LoadingScreen.instance().hide();
    },);

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