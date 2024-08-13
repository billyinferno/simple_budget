import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class PlanAddParticipantModal extends StatefulWidget {
  const PlanAddParticipantModal({super.key});

  @override
  State<PlanAddParticipantModal> createState() => _PlanAddParticipantModalState();
}

class _PlanAddParticipantModalState extends State<PlanAddParticipantModal> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: MyColor.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              color: MyColor.primaryColorDark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      "ADD PARTICIPANT",
                      style: TextStyle(
                        color: MyColor.backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      // pop with empty data
                      Navigator.pop(context, '');
                    },
                    icon: const Icon(
                      LucideIcons.x,
                      color: MyColor.backgroundColor,
                      size: 16,
                    )
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Name",
                    style: TextStyle(
                      color: MyColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  CupertinoTextField(
                    controller: _nameController,
                    cursorColor: MyColor.primaryColorDark,
                    decoration: BoxDecoration(
                      color: MyColor.backgroundColor,
                      border: Border.all(
                        color: MyColor.backgroundColorDark,
                        width: 1.0,
                       style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: MyButton(
                          color: MyColor.errorColor,
                          onTap: (() {
                            Navigator.pop(context, '');
                          }),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                LucideIcons.x,
                                color: MyColor.backgroundColor,
                                size: 16,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "Cancel",
                                style: TextStyle(
                                  color: MyColor.backgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: MyButton(
                          color: MyColor.primaryColor,
                          onTap: (() {
                            // ensure that name controller is not empty
                            String name = _nameController.text.trim();
                            if (name.isNotEmpty) {
                              Navigator.pop(context, name.toUpperCase());
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                createSnackBar(
                                  message: "Please filled participant name",
                                )
                              );
                            }
                          }),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                LucideIcons.user_plus,
                                color: MyColor.backgroundColor,
                                size: 16,
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "Add",
                                style: TextStyle(
                                  color: MyColor.backgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}