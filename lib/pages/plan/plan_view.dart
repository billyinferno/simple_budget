import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';

class PlanViewPage extends StatefulWidget {
  final Object uid;
  const PlanViewPage({
    super.key,
    required this.uid,
  });

  @override
  State<PlanViewPage> createState() => _PlanViewPageState();
}

class _PlanViewPageState extends State<PlanViewPage> {
  late String _planUid;
  late PlanModel _planData;
  late bool _isLogin;
  late double _maxAmount;

  late Future<bool> _getData;

  @override
  void initState() {
    // get the dashboard UID
    _planUid = widget.uid as String;
    
    // get the data for this UID
    _getData = _getPlanData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _body();
        }
        else if (snapshot.hasError) {
          // show error screen
          return ErrorTemplatePage(
            title: "Unable to get plan $_planUid",
            message: "Unable to get plan detail information from backend, this might be due to some backend error or your internet connection is not available. Please check your internet connection or try again in a few minutes."
          );
        }
        else {
          return const LoadingPage();
        }
      },
    );
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Plan View",
            style: TextStyle(
              color: MyColor.backgroundColor,
            ),
          ),
        ),
        leading: _leadingAppBar(),
        actions: _actionAppBar(),
      ),
      body: MyBody(
        child: RefreshIndicator(
          color: MyColor.primaryColorDark,
          backgroundColor: MyColor.backgroundColor,
          onRefresh: () async {
            _getData = _getPlanData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10,),
                Text(
                  "ID: $_planUid",
                  style: const TextStyle(
                    color: MyColor.textColorSecondary
                  ),
                ),
                Text(
                  (_planData.name).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyIconLabel(icon: LucideIcons.user, text: "3"),
                    MyIconLabel(icon: LucideIcons.dollar_sign, text: "36M (80%)"),
                    MyIconLabel(
                      icon: LucideIcons.calendar,
                      text: "${Globals.dfMMyy.format(_planData.startDate.toLocal())} - ${Globals.dfMMyy.format(_planData.endDate.toLocal())}",
                      addPadding: false,
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                //TODO: to fill the correct value for the bar chart
                MyBarChart(
                  value: 80,
                  maxValue: 100,
                  text: "36,000,000/$_maxAmount (80%)",
                ),
                const SizedBox(height: 10,),
                Visibility(
                  visible: _planData.description.isNotEmpty,
                  child: Text(_planData.description)
                ),
                Visibility(
                  visible: _planData.description.isNotEmpty,
                  child: const SizedBox(height: 10,)
                ),
                MyMonthCalendar(
                  startDate: DateTime(2024, 7, 1),
                  endDate: DateTime(2025, 7, 1),
                  payment: {
                    DateTime(2024,7,1):true,
                    DateTime(2024,8,1):false,
                  },
                  onTap: (date) async {
                    await _getPlanItem(date: date).then((_) async {
                      _showPlanModal(date: date);
                    }).onError((error, stackTrace) {
                      // showed error
                      Log.error(
                        message: 'Error when get plan item for $date',
                        error: error,
                        stackTrace: stackTrace,
                      );
                      _showErrorPlanItem(uid: _planUid, date: date);
                    },);
                  },
                  onDoubleTap: (date) {
                    context.go('/plan/$_planUid/item/${Globals.dfyyyyMMdd.format(date)}');
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _leadingAppBar() {
    //TODO: check if user logon or not here, if logon then we can show the edit menu
    return IconButton(
      onPressed: () {
        context.go('/plan/$_planUid/edit');
      },
      icon: const Icon(
        LucideIcons.pencil,
        color: Colors.white,
      )
    );
  }

  List<Widget> _actionAppBar() {
    List<Widget> ret = [];

    if(_isLogin) {
      ret.add(
        IconButton(
          onPressed: (() {
            context.go('/user');
          }),
          icon: const Icon(
            LucideIcons.user,
            color: MyColor.backgroundColor,
          )
        )
      );
    }

    // add the URL copy
    ret.add(
      IconButton(
        onPressed: (() async {
          await MyClipboard.copyToClipboard(
            text: Uri.base.toString()
          ).then((_) {
            //TODO: to handle success with alert box showing success
            Log.success(message: "🌍 URL copied to the clipboard");
          }).onError((error, stackTrace) {
            //TODO: to handle clipboard error with alert box
            debugPrint("Got error, handle with alert box");
          },);
        }),
        icon: const Icon(
          LucideIcons.share,
          color: MyColor.backgroundColor,
        )
      )
    );

    ret.add(const SizedBox(width: 10,));

    return ret;
  }

  Future<bool> _getPlanData() async {
    String? securedPin;
    
    // first check whether we login or not?
    _isLogin = await UserStorage.isLogin();

    // check if jwtToken is empty or not?
    if (!_isLogin) {
      // check if we have secured PIN?
      String pinData = await SecureBox.get(key: _planUid);

      // if this secured pin is empty then it means that the user doesn't have
      // credentials to check this Plan, just return false.
      if (pinData.isEmpty) {
        return false;
      }
      else {
        // convert the pin data to PIN verify model
        PinVerifyModel pin = PinVerifyModel.fromJson(jsonDecode(pinData));
        securedPin = pin.pin;
      }
    }

    // log info
    Log.info(message: "🖥️ Get plan data for $_planUid");
    
    // call the Plan API to get the plan data
    await PlanAPI.findSecure(
      uid: _planUid,
      pin: securedPin
    ).then((result) {
      _planData = result;

      // calculate all the necessary data for plan view
      _maxAmount = (MyDateUtils.monthDifference(
        startDate: _planData.startDate,
        endDate: _planData.endDate
      )) * _planData.amount;
    },);
    
    return true;
  }

  Future<void> _getPlanItem({required DateTime date}) async {
    // TODO: perform API call to get item here
    Log.info(message: "🖥️ Get plan item for $date");
  }

  Future<void> _showPlanModal({required DateTime date}) async {
    await showModalBottomSheet(
      isDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      context: context,
      builder: (context) {
        return PlanItemModal(
          uid: _planUid,
          date: date,
          isLogin: _isLogin,
        );
      },
    );
  }

  Future<void> _showErrorPlanItem({required String uid, required DateTime date}) async {
    return MyDialog.showAlert(
      context: context,
      text: "Unable to get Plan Item date ${Globals.dfyyyyMMdd.format(date)} for Plan UID $uid.\nThis is might be due to error on the backend service or your internet is not available, please try again in a few minutes.",
      okayLabel: "Ok",
      okayColor: MyColor.errorColor,
    );
  }
}