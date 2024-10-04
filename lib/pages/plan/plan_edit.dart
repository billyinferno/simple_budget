import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:simple_budget/_index.g.dart';

enum EditType {
  noChanges,
  delete,
  add
}

class PlanEditPage extends StatefulWidget {
  final Object? plan;
  const PlanEditPage({
    super.key,
    required this.plan,
  });

  @override
  State<PlanEditPage> createState() => _PlanEditPageState();
}

class _PlanEditPageState extends State<PlanEditPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late PlanModel _plan;
  late String _planUid;
  late DateTime _startDate;
  late DateTime _endDate;
  late Map<ParticipationModel, EditType> _participants;

  @override
  void initState() {
    // default plan uid as empty space
    _planUid = '';
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _participants = {};

    if (widget.plan == null) {
      Log.warning(message: "🫗 Plan data is empty, return back to dashboard");
      context.go('/dashboard');
    }
    else {
      _plan = widget.plan as PlanModel;
      
      _nameController.text = _plan.name;
      _descriptionController.text = _plan.description;
      _amountController.text = _plan.amount.toString();

      _planUid = _plan.uid;
      _startDate = _plan.startDate;
      _endDate = _plan.endDate;

      // generate participants map, as we will need to knew the status we will
      // need to do for each participants
      for(ParticipationModel participant in _plan.participations) {
        _participants[participant] = EditType.noChanges;
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        foregroundColor: Colors.white,
        title: Center(child: Text("Edit Plan $_planUid"),),
        leading: IconButton(
          onPressed: () {
            // go back to dashboard
            context.go('/dashboard');
          },
          icon: const Icon(
            LucideIcons.chevron_left,
            color: MyColor.backgroundColor,
          )
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _updatePlan();
            },
            icon: const Icon(
              LucideIcons.save,
              color: MyColor.backgroundColor,
            )
          ),
          const SizedBox(width: 15,),
        ],
      ),
      body: MyBody(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const TextSmall(text: "UID"),
              Text(_planUid),
              const SizedBox(height: 5,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColor.primaryColorLight,
                    width: 1.0,
                    style: BorderStyle.solid,
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const TextSmall(text: "Name"),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: CupertinoTextField(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const TextSmall(text: "Description (optional)"),
                    const SizedBox(height: 5,),
                    CupertinoTextField(
                      controller: _descriptionController,
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
                      maxLines: 5,
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const TextSmall(text: "Start Date"),
                              InkWell(
                                onTap: (() async {
                                  await MyDateUtils.monthPicker(
                                    context: context,
                                    initialDate: _startDate
                                  ).then((value) {
                                    if (value != null) {
                                      // ensure that start date is lesser than
                                      // end date.
                                      if (value.isBefore(_endDate)) {
                                        setState(() {
                                          _startDate = value;
                                        });
                                      }
                                      else {
                                        // show error that the start date is more
                                        // than end date
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            createSnackBar(
                                              message: "Start date cannot be after end date"
                                            )
                                          );
                                        }
                                      }
                                    }
                                  },);
                                }),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MyColor.backgroundColorDark,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: Text(Globals.dfyyMon.format(_startDate))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const TextSmall(text: "End Date"),
                              InkWell(
                                onTap: (() async {
                                  await MyDateUtils.monthPicker(
                                    context: context,
                                    initialDate: _endDate
                                  ).then((value) {
                                    if (value != null) {
                                      // ensure that start date is lesser than
                                      // end date.
                                      if (value.isAfter(_startDate)) {
                                        setState(() {
                                          _endDate = value;
                                        });
                                      }
                                      else {
                                        // show error that the start date is more
                                        // than end date
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            createSnackBar(
                                              message: "End date cannot be before start date"
                                            )
                                          );
                                        }
                                      }
                                    }
                                  },);
                                }),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MyColor.backgroundColorDark,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(child: Text(Globals.dfyyMon.format(_endDate))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const TextSmall(text: "Amount"),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: CupertinoTextField(
                            controller: _amountController,
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
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextSmall(text: "Participants"),
                  IconButton(
                    onPressed: (() async {
                      await showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        backgroundColor: Colors.black,
                        builder: (context) {
                          return const PlanAddParticipantModal();
                        },
                      ).then((participant) {
                        if (participant != null) {
                          // convert participant to string
                          String name = participant as String;
                          if (name.isNotEmpty) {
                            _checkAndAddParticipant(name: name);
                          }
                        }
                      },);
                    }),
                    icon: const Icon(
                      LucideIcons.user_plus,
                      color: MyColor.primaryColorDark,
                      size: 18,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColor.primaryColorLight,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _showParticipant(),
                ),
              ),
              const SizedBox(height: 20,),
              MyButton(
                onTap: () async {
                  await _updatePlan();
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      LucideIcons.save,
                      color: MyColor.backgroundColor,
                      size: 16,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "Save Plan",
                      style: TextStyle(
                        color: MyColor.backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _showParticipant() {
    List<Widget> ret = [];

    // check whether _participants is empty or not?
    if (_participants.isEmpty) {
      ret.add(
        const Center(child: Text("No participants added"),)
      );
    }
    else {
      for(ParticipationModel participant in _participants.keys) {
        ret.add(
          MyParticpatList(
            name: participant.name,
            edit: _participants[participant],
            onDelete: () {
              _changeParticipantStatus(participant: participant);
            }
          )
        );
      }
    }
    return ret;
  }

  void _changeParticipantStatus({required ParticipationModel participant}) {
    setState(() {                    
      if (_participants[participant] == EditType.delete) {
        // if the edit type is delete, it means that this is existsing
        // participant, so change back the type value to noChanges 
        _participants[participant] = EditType.noChanges;
      }
      else if (_participants[participant] == EditType.add) {
        // if the edit type is add, it means that this is new data
        // we can just remove it from the map.
        _participants.remove(participant);
      }
      else {
        // else, it means that this is existsing participant that
        // we want to delete, so just change the status for this
        // participant to delete
        _participants[participant] = EditType.delete;
      }
    });
  }

  Future<void> _updatePlan() async {
    // validate all the data is already filled before we submit the create
    // first ensure the name is not empty
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        createSnackBar(message: "Name is empty")
      );
      return;
    }

    String amountString = _amountController.text.trim();
    double amount = 0;
    if (amountString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        createSnackBar(message: "Amount is empty")
      );
      return;
    }
    else {
      // ensure this is number
      amount = (double.tryParse(amountString) ?? 0);

      // check if amount is zero or not?
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
        createSnackBar(message: "Invalid amount number")
      );
      return;
      }
    }

    String description = _descriptionController.text.trim();

    // if we reach here, it means all the data is read call the Plan API to
    // update the plan data
    try {
      LoadingScreen.instance().show(context: context);
      await PlanAPI.updatePlan(
        uid: _planUid,
        name: name,
        description: description,
        startDate: _startDate,
        endDate: _endDate,
        amount: amount,
        participants: _participants
      ).then((plan) {
        if (plan) {
          // success creating plan, put it on the log
          Log.success(message: "✅ Success updating plan $_planUid");

          // go back to the dashboar
          if (mounted) {
            context.go('/dashboard');
          }
        }
        else {
          Log.error(message: "❌ Unable to updating plan $_planUid");

          // show error
          if (mounted) {
            MyDialog.showAlert(
              context: context,
              text: "Unable to create plan, please try again.",
              okayColor: MyColor.errorColor,
            );
          }
        }
      },).whenComplete(() {
        LoadingScreen.instance().hide();
      },);
    }
    on NetException catch(netError, stackTrace) {
      Log.error(
        message: "❌ ${netError.message}",
        error: netError,
        stackTrace: stackTrace,
      );

      // show error
      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error of ${netError.message} when creating plan.",
          okayColor: MyColor.errorColor,
        );
      }
    }
    on ClientException catch(clientError, stackTrace) {
      Log.error(
        message: "❌ ${clientError.message}",
        error: clientError,
        stackTrace: stackTrace,
      );

      // show error
      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error of ${clientError.message} when creating plan.",
          okayColor: MyColor.errorColor,
        );
      }
    }
    catch (error, stackTrace) {
      Log.error(
        message: "❌ ${error.toString()}",
        error: error,
        stackTrace: stackTrace,
      );

      // show error
      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error processing on application when creating plan.",
          okayColor: MyColor.errorColor,
        );
      }
    }
  }

  void _checkAndAddParticipant({required String name}) {
    // check ont he participants list
    for(ParticipationModel currentParticipant in _participants.keys) {
      if (name.toUpperCase() == currentParticipant.name) {
        // already exists, showed error
        ScaffoldMessenger.of(context).showSnackBar(
          createSnackBar(
            message: "Participant $name already exists."
          )
        );   

        return;
      }
    }

    setState(() {      
      // if reach here, it means the participant is not exists
      _participants[ParticipationModel(
        id: -1,
        name: name
      )] = EditType.add;
    });
  }
}