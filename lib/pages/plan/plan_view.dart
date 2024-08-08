import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_budget/_index.g.dart';
import 'package:simple_budget/utils/number.dart';

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
            message: "Unable to get plan detail information from backend, this might be due to some backend error or your internet connection is not available. Please check your internet connection or try again in a few minutes.",
            refresh: ((_) async {
              _getData = _getPlanData();
            }),
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
                    MyIconLabel(icon: LucideIcons.user, text: "${_planData.participations.length}"),
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
                  text: "36,000,000/${MyNumberUtils.formatCurrency(amount: _maxAmount)} (80%)",
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
                    if (
                      date.toLocal().isBefore(DateTime.now().toLocal()) ||
                      date.toLocal().isAtSameMomentAs(DateTime.now().toLocal())
                    ) {
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
                    }
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
    if (_isLogin) {
      return IconButton(
        onPressed: () {
          context.go('/dashboard');
        },
        icon: const Icon(
          LucideIcons.arrow_left,
          color: Colors.white,
        )
      );
    }
    else {
      return IconButton(
        onPressed: () async {
          bool? result = await MyDialog.showConfirmation(
            context: context,
            text: "Do you want to logout from this plan ($_planUid)?",
            okayColor: MyColor.errorColor,
            cancelColor: MyColor.backgroundColor,
          );

          if (result ?? false) {
            // clear the secure storage
            await SecureBox.deleteAll().then((value) {
              if (mounted) {
              // go to the login page
                context.go('/login');
              }
            },);
          }
        },
        icon: const Icon(
          LucideIcons.x,
          color: Colors.white,
        )
      );
    }
  }

  List<Widget> _actionAppBar() {
    List<Widget> ret = [];

    if(_isLogin) {
      ret.add(
        IconButton(
          onPressed: () {
            context.go('/plan/$_planUid/edit');
          },
          icon: const Icon(
            LucideIcons.pencil,
            color: Colors.white,
          )
        )
      );
    }

    // add the URL copy
    ret.add(
      IconButton(
        onPressed: (() async {
          // default the pin exists into false, assuming that the plan doesn't
          // have any PIN set yet.
          bool pinExists = false;

          // show loading screen
          LoadingScreen.instance().show(context: context);

          // check and ensure the PIN is already set for this
          await PlanAPI.check(uid: _planUid).then((check) async {
            pinExists = check;
          }).onError((error, stackTrace) {
            // plan doesn't have PIN
            _showNoPin();
          },).whenComplete(() {
            LoadingScreen.instance().hide();
          },);

          // ensure PIN is exists
          if (pinExists) {
            await MyClipboard.copyToClipboard(
              text: Uri.base.toString()
            ).then((_) {
              Log.success(message: "🌍 URL copied to the clipboard");
              _showSuccessCopy();
            }).onError((error, stackTrace) {
              Log.error(message: "🌍 Unable to copied to the clipboard");
              _showFailedCopy(url: Uri.base.host);
            },);
          }
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

    // then check if we have secured PIN?
    String pinData = await SecureBox.get(key: _planUid);

    // if this secured pin is empty then it means that the user doesn't have
    // credentials to check this Plan, just return false.
    if (pinData.isEmpty) {
      // check if jwtToken is empty or not?
      if (!_isLogin) {
        throw Exception('No authentication token or secure PIN available');
      }
    }
    else {
      // convert the pin data to PIN verify model
      PinVerifyModel pin = PinVerifyModel.fromJson(jsonDecode(pinData));
      securedPin = pin.pin;
    }

    // log info
    Log.info(message: "🖥️ Get plan data for $_planUid");
    
    // call the Plan API to get the plan data
    await Future.microtask(() async {
      Log.info(message: "🖥️ Get plan detail");
      // get the plan data first
      await PlanAPI.findSecure(
        uid: _planUid,
        pin: securedPin
      ).then((result) {
        _planData = result;
      },);

      //TODO: to get the rest of the API
    },).then((_) {
      // calculate all the necessary data for plan view
      // TODO: to add also number of participant
      _maxAmount = (MyDateUtils.monthDifference(
        startDate: _planData.startDate,
        endDate: _planData.endDate
      )) * _planData.amount * _planData.participations.length;
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
          participation: _planData.participations,
          contributions: (_planData.contributions![Globals.dfyyyyMMdd.format(date)] ?? []),
        );
      },
    );
  }

  Future <void> _showSuccessCopy() async {
    return MyDialog.showAlert(
      context: context,
      text: "Url copied to the clipboard. You can paste and share it to your friends.\nDon't forget to also give them the PIN.",
      okayColor: MyColor.primaryColor,
      okayLabel: "Ok",
    );
  }

  Future <void> _showFailedCopy({required String url}) async {
    return MyDialog.showAlert(
      context: context,
      text: "Unable access clipboard, please ask your friend to manually visit $url, and input $_planUid to access the Plan.\nDon't forget to also input the correct PIN for the plan.",
      okayColor: MyColor.errorColor,
      okayLabel: "Ok",
    );
  }

  Future <void> _showNoPin() async {
    return MyDialog.showAlert(
      context: context,
      text: "Unable to copy URL, please ensure the PIN for the plan already set before share the plan to public.",
      okayColor: MyColor.errorColor,
      okayLabel: "Ok",
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