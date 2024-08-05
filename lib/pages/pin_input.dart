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
  late String pinData;

  @override
  void initState() {
    // default the pin data into empty
    pinData = '';

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
                      return _pinBox(id: (index+1), pinData: pinData);
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
      onTap: (() {
        if (!(disabled ?? false)) {
          // check if pinData is less than 6 or not?
          if (pinData.length < 6) {
            setState(() {
              pinData = "${pinData}1";
            });
          }
          
          if (pinData.length == 6) {
            // this is means the pin data already 6
            // TODO: perform API call to verify the PIN
            context.go('/dashboard/${widget.id}');
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
        if (pinData.isNotEmpty) {
          setState(() {
            pinData = pinData.substring(0, (pinData.length - 1));
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
}