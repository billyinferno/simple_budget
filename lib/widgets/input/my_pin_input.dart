import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class MyPinInput extends StatefulWidget {
  final String uid;
  final String title;
  final Function(String) onPinSubmit;
  final Color? color;
  final Color? pinColor;
  const MyPinInput({
    super.key,
    required this.uid,
    required this.title,
    required this.onPinSubmit,
    this.color,
    this.pinColor,
  });

  @override
  State<MyPinInput> createState() => _MyPinInputState();
}

class _MyPinInputState extends State<MyPinInput> {
  late String _pinData;

  @override
  void initState() {
    // initialize pin data
    _pinData = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: (widget.color ?? MyColor.primaryColor),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              widget.title,
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
        color: (pinData.length >= id ? (widget.pinColor ?? MyColor.primaryColor) : Colors.white),
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
            setState(() {
              // call the onPinSubmit
              widget.onPinSubmit(_pinData);
              // just reset back to empty again in case the call is error
              _pinData = '';
            });
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
}