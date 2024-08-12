import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class PlanPINCreateModal extends StatefulWidget {
  final String uid;
  const PlanPINCreateModal({
    super.key,
    required this.uid,
  });

  @override
  State<PlanPINCreateModal> createState() => _PlanPINCreateModalState();
}

class _PlanPINCreateModalState extends State<PlanPINCreateModal> {
  late int _pinStage;
  late String _pinData1;
  late String _pinData2;

  @override
  void initState() {
    // set the default _pinStage as 1
    _pinStage = 1;

    // empty all pin data
    _pinData1 = '';
    _pinData2 = '';
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: (MediaQuery.of(context).size.height),
        color: MyColor.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: MyColor.primaryColorDark,
              child: IconButton(
                onPressed: (() {
                  // return empty string to the main page
                  Navigator.pop(context, '');
                }),
                icon: const Icon(
                  LucideIcons.x,
                  color: MyColor.backgroundColor,
                )
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: MyPinInput(
                uid: widget.uid,
                title: _pinTitle(),
                color: MyColor.primaryColor,
                pinColor: MyColor.primaryColorDark,
                onPinSubmit: (pin) async {
                  // check which pin stage we are now?
                  if (_pinStage == 1) {
                    setState(() {                      
                      // set _pinData1 as pin
                      _pinData1 = pin;
                      // add the pin stage
                      _pinStage = 2;
                    });
                  }
                  else {
                    // set _pinData2 as pin
                    _pinData2 = pin;
      
                    // as we already got both 1st and 2nd pin data, we can perform
                    // comparison and check.
                    if (_pinData1 == _pinData2) {
                      // same PIN, then we can call API to create PIN in the main
                      // page
                      Navigator.pop(context, _pinData1);
                    }
                    else {
                      // wrong or different PIN
                      // show scaffold messenger tell that the pin is wrong
                      ScaffoldMessenger.of(context).showSnackBar(
                        createSnackBar(
                          message: "1st and 2nd PIN doesn't match."
                        )
                      );
      
                      // reset both the 1st and 2nd pin and set the pin stage
                      // back to 1
                      setState(() {                        
                        _pinData1 = '';
                        _pinData2 = '';
                        _pinStage = 1;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _pinTitle() {
    if (_pinStage == 1) {
      return "Enter PIN for ${widget.uid}";
    }
    else {
      return "Confirm PIN for ${widget.uid}";
    }
  }
}