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
  final ScrollController _scrollController = ScrollController();

  late String _planUid;
  late PlanModel _planData;
  late bool _isLogin;
  late double _currentAmount;
  late double _maxAmount;
  late int _currentPercentage;

  late Future<bool> _getData;
  late Map<DateTime, ContributionStatus> _paymentData;

  @override
  void initState() {
    // get the dashboard UID
    _planUid = widget.uid as String;

    // initialize data
    _currentAmount = 0;
    _maxAmount = 1;
    _currentPercentage = 0;
    _paymentData = {};

    // get the data for this UID
    _getData = _getPlanData();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          debugPrintStack(stackTrace: snapshot.stackTrace);
          ErrorInformation error  = snapshot.error as ErrorInformation;

          // check if this is 403 or not?
          if (error.status == 403) {
            // show error screen without refresh
            return ErrorTemplatePage(
              title: "Unable to get plan $_planUid",
              message: error.message,
            );
          }
          else {
            // show error screen with refresh
            return ErrorTemplatePage(
              title: "Unable to get plan $_planUid",
              message: error.message,
              refresh: (() async {
                setState(() {
                  _getData = _getPlanData();
                });
              }),
            );
          }
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
      body: RefreshIndicator(
        color: MyColor.primaryColorDark,
        onRefresh: () async {
          setState(() {            
            _getData = _getPlanData();
          });
        },
        child: MyBody(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: SingleChildScrollView(
            controller: _scrollController,
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
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MyIconLabel(icon: LucideIcons.user, text: "${_planData.participations.length}"),
                    MyIconLabel(icon: LucideIcons.dollar_sign, text: "${MyNumberUtils.formatCurrencyWithNull(amount: _currentAmount)} ($_currentPercentage%)"),
                    MyIconLabel(
                      icon: LucideIcons.calendar,
                      text: "${Globals.dfMMyy.format(_planData.startDate.toLocal())} - ${Globals.dfMMyy.format(_planData.endDate.toLocal())}",
                      addPadding: false,
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                MyBarChart(
                  value: _currentPercentage,
                  maxValue: 100,
                  text: "${MyNumberUtils.formatCurrencyWithNull(amount: _currentAmount)}/${MyNumberUtils.formatCurrency(amount: _maxAmount)} ($_currentPercentage%)",
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
                  startDate: _planData.startDate,
                  endDate: _planData.endDate,
                  payment: _paymentData,
                  onTap: (date) async {
                    await _showPlanModal(date: date);
                  },
                ),
                const SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: MyColor.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              LucideIcons.check,
                              color: MyColor.backgroundColor,
                              size: 12,
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Text(
                                "Fully Paid",
                                style: TextStyle(
                                  color: MyColor.backgroundColor,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: MyColor.errorColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              LucideIcons.x,
                              color: MyColor.backgroundColor,
                              size: 12,
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Text(
                                "Not Yet Paid",
                                style: TextStyle(
                                  color: MyColor.backgroundColor,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: MyColor.warningColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              LucideIcons.ungroup,
                              color: MyColor.backgroundColor,
                              size: 12,
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Text(
                                "Partially Paid",
                                style: TextStyle(
                                  color: MyColor.backgroundColor,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                const Center(
                  child: Text(
                    "Press on the calendar month to view detail.",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
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
          LucideIcons.chevron_left,
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
            context.go('/plan/edit', extra: _planData);
          },
          icon: const Icon(
            LucideIcons.pencil,
            color: Colors.white,
          )
        )
      );

      // check if pin already setup or not?
      if (_planData.pin.isNotEmpty) {
        ret.add(
          IconButton(
            onPressed: () async {
              await MyDialog.showConfirmation(
                context: context,
                text: "Do you want to remove PIN for $_planUid?",
                okayColor: MyColor.primaryColorDark,
                cancelColor: MyColor.backgroundColor,
              ).then((result) async {
                if (result ?? false) {
                  try {                    
                    await _deletePin();
                  }
                  on NetException catch (netError, stackTrace) {
                    Log.error(
                      message: "❌ ${netError.message}",
                      error: netError,
                      stackTrace: stackTrace,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        createSnackBar(message: netError.message)
                      );
                    }
                  }
                  catch (error, stackTrace) {
                    Log.error(
                      message: "❌ ${error.toString()}",
                      error: error,
                      stackTrace: stackTrace,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        createSnackBar(message: "Error occured on the application")
                      );
                    }
                  }
                }
              });
            },
            icon: const Icon(
              LucideIcons.lock,
              color: Colors.white,
            )
          )
        );
      }
      else {
        ret.add(
          IconButton(
            onPressed: () async {
              // show general dialog to add PIN
              await showGeneralDialog(
                barrierColor: Colors.black.withValues(alpha: 0.9),
                context: context,
                transitionBuilder: bottomToTopTransition,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return PlanPINCreateModal(
                    uid: _planUid
                  );
                },
              ).then((pop) async {
                String pin = pop as String;
                // check if result is not empty
                if (pin.isNotEmpty) {
                  // PIN is set we can call the function to set PIN for this
                  try {                    
                    await _setPin(
                      uid: _planUid,
                      pin: pin,
                    );
                  }
                  on NetException catch (netError, stackTrace) {
                    Log.error(
                      message: "❌ ${netError.message}",
                      error: netError,
                      stackTrace: stackTrace,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        createSnackBar(message: netError.message)
                      );
                    }
                  }
                  catch (error, stackTrace) {
                    Log.error(
                      message: "❌ ${error.toString()}",
                      error: error,
                      stackTrace: stackTrace,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        createSnackBar(message: "Error occured on the application")
                      );
                    }
                  }
                }
              },);
            },
            icon: const Icon(
              LucideIcons.lock_open,
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
            await _copyPlanURL();
          }),
          icon: const Icon(
            LucideIcons.share,
            color: MyColor.backgroundColor,
          )
        )
      );

      ret.add(const SizedBox(width: 10,));
    }

    return ret;
  }

  Future<bool> _getPlanData() async {
    String? securedPin;
    
    // first check whether we login or not?
    _isLogin = await UserStorage.isLogin();

    // then check if we have secured PIN?
    String pinData = await UserStorage.getSecuredPin();

    // if this secured pin is empty then it means that the user doesn't have
    // credentials to check this Plan, just return false.
    if (pinData.isEmpty) {
      // check if jwtToken is empty or not?
      if (!_isLogin) {
        throw ErrorInformation(
          status: 403,
          name: 'Unauthorized',
          message: 'No authentication token or secure PIN available'
        );
      }
    }
    else {
      // convert the pin data to PIN verify model
      PinVerifyModel pin = PinVerifyModel.fromJson(jsonDecode(pinData));
      securedPin = pin.pin;

      // ensure that the UID is the same as the one we got from the URL
      if (_planUid.toUpperCase() != pin.uid.toUpperCase()) {
        throw ErrorInformation(
          status: 403,
          name: 'Unauthorized',
          message: 'Accessing different UID with the one on secure PIN',
        );
      }
    }

    // log info
    Log.info(message: "🖥️ Get plan data for $_planUid");
    
    // call the Plan API to get the plan data
    Log.info(message: "🖥️ Get plan detail");
    // get the plan data first
    await PlanAPI.findSecure(
      uid: _planUid,
      pin: securedPin
    ).then((result) {
      _planData = result;
      _calculateData();
    },).onError((error, stackTrace) {
      Log.error(
        message: "Error when get the Plan information",
        error: error,
        stackTrace: stackTrace,
      );

      // convert error as NetException
      NetException netError = error as NetException;
      throw ErrorInformation(
        status: netError.code,
        name: netError.message,
        message: 'Unable to get data from the backend, please help to check if your internet is active, and please try again.',
      );
    },);
    
    return true;
  }

  void _calculateData() {
    // calculate all the necessary data for plan view
    _maxAmount = (MyDateUtils.monthDifference(
      startDate: _planData.startDate,
      endDate: _planData.endDate
    )) * _planData.amount * _planData.participations.length;

    // clear the payment data first
    _paymentData.clear();
    _currentAmount = 0;
    
    // calculate the current amount
    // we can do this by loop thru the contributon map, whil we doing this
    // we can also generate the payment map data based on the contributions
    for(String date in _planData.contributions!.keys) {
      // convert this date from string to DateTime
      DateTime dt = DateTime.parse(date);

      if (_planData.contributions![date]!.length == _planData.participations.length) {
        _paymentData[dt] = ContributionStatus.full;
      }
      else{
        if (_planData.contributions![date]!.isNotEmpty) {
          _paymentData[dt] = ContributionStatus.partial;
        }
        else {
          _paymentData[dt] = ContributionStatus.none;
        }
      }

      // calculate the current amount
      _currentAmount = _currentAmount + (_planData.contributions![date]!.length * _planData.amount);
    }

    // once got the current and max amount, we can calculate the percentage
    if (_maxAmount > 0) {
      _currentPercentage = ((_currentAmount / _maxAmount) * 100).toInt();
    }
  }

  Future<void> _showPlanModal({required DateTime date}) async {
    await showModalBottomSheet(
      isDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
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
    ).then((result) {
      if (result && !_planData.readOnly) {
        // get the data again
        setState(() {        
          _getData = _getPlanData();
        });
      }
    },);
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

  Future<void> _copyPlanURL() async {
    bool pinExists = false;

    try {
      // show loading screen
      LoadingScreen.instance().show(context: context);

      // check and ensure the PIN is already set for this
      await PlanAPI.check(uid: _planUid).then((check) async {
        pinExists = check;
      }).whenComplete(() {
        LoadingScreen.instance().hide();
      },);

      // ensure PIN is exists
      if (pinExists) {
        await MyClipboard.copyToClipboard(
          text: 'You can visit ${Uri.base.scheme}://${Uri.base.host}${Uri.base.hasPort ? ":${Uri.base.port}" : ""}, press View tab and put below id $_planUid, after that press VIEW and input the PIN.'
        ).then((_) {
          Log.success(message: "🌍 URL copied to the clipboard");
          _showSuccessCopy();
        }).onError((error, stackTrace) {
          Log.error(message: "🌍 Unable to copied to the clipboard");
          _showFailedCopy(url: Uri.base.host);
        },);
      }
    }
    on NetException catch(netError, stackTrace) {
      // check if the error is due to 404
      if (netError.code == 404) {
        // plan doesn't have PIN
        _showNoPin();
      }
      else {
        Log.error(
          message: (netError.body ?? "Unknown error from server"),
          error: netError,
          stackTrace: stackTrace,
        );

        // show error dialog
        if (mounted) {
          MyDialog.showAlert(
            context: context,
            text: "Error ${netError.message} from backend.",
            okayColor: MyColor.errorColor,
          );
        }
      }
    }
    catch (error, stackTrace) {
      Log.error(
        message: (error.toString()),
        error: error,
        stackTrace: stackTrace,
      );
      
      // show error dialog
      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error occured oin the applicatin.",
          okayColor: MyColor.errorColor,
        );
      }
    }
  }

  Future<void> _deletePin() async {
    // show loading screen
    LoadingScreen.instance().show(context: context);
    
    // call Plan API to remove the PIN
    await PlanAPI.deletePin(uid: _planUid).then((_) {
      // recreate the _planData instead of calling again the
      // findSecure API as we just need to remove the PIN data
      final PlanModel newPLan = PlanModel(
        uid: _planData.uid,
        name: _planData.name,
        startDate: _planData.startDate,
        endDate: _planData.endDate,
        description: _planData.description,
        amount: _planData.amount,
        readOnly: _planData.readOnly,
        pin: '',
        participations: _planData.participations,
        contributions: _planData.contributions,
      );

      // set the _planData with newPlan
      setState(() {
        _planData = newPLan;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          createSnackBar(
            message: "PIN removed",
            icon: const Icon(
              LucideIcons.check,
              color: MyColor.backgroundColor,
              size: 20,
            )
          )
        );
      }
    }).whenComplete(() {
      // remove loading screen
      LoadingScreen.instance().hide();
    },);
  }

  Future<void> _setPin({required String uid, required String pin}) async {
    // show loading screen
    LoadingScreen.instance().show(context: context);
    
    await PlanAPI.createPin(
      uid: uid,
      pin: pin
    ).then((result) {
      // PIN creation success
      // recreate the _planData instead of calling again the
      // findSecure API as we just need to add the PIN data
      final PlanModel newPLan = PlanModel(
        uid: _planData.uid,
        name: _planData.name,
        startDate: _planData.startDate,
        endDate: _planData.endDate,
        description: _planData.description,
        amount: _planData.amount,
        readOnly: _planData.readOnly,
        pin: result.pin,
        participations: _planData.participations,
        contributions: _planData.contributions,
      );

      // set the _planData with newPlan
      setState(() {
        _planData = newPLan;
      });

      // show success dialog
      if (mounted) {
        MyDialog.showAlert(
          context: context,
          title: "PIN Setup",
          text: "PIN successfully setup for Plan $uid",
          okayColor: MyColor.primaryColor,
        );
      }
    },).whenComplete(() {
      LoadingScreen.instance().hide();
    },);
  }
}