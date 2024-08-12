import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:simple_budget/_index.g.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late int _initialPage;
  late List<MyBottomNavigationItem> _navigationItem;

  late Future<bool> _getData;
  late List<PlanModel> _plans;
  
  @override
  void initState() {
    _navigationItem = <MyBottomNavigationItem>[
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.list,
          color: Colors.white,
        ),
        text: Text(
          "List",
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ),
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.plus,
          color: Colors.white,
        ),
        text: Text(
          "Add Plan",
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ),
      const MyBottomNavigationItem(
        icon: Icon(
          LucideIcons.user,
          color: Colors.white,
        ),
        text: Text(
          "User",
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ),
    ];
    _initialPage = 0;

    // initialize plans as empty array
    _plans = [];

    // get the plan list from backend
    _getData = _getPlanList();

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
          return ErrorTemplatePage(
            title: "Unable to get plan list",
            message: "Unable to get plan list from backend, this might be due to some backend error or your internet connection is not available. Please check your internet connection or try again in a few minutes.",
            refresh: (() async {
              _getData = _getPlanList();
            }),
          );
        }
        else {
          // return the loading screen
          return const LoadingPage();
        }
      },
    );
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Center(
          child: Text(
            "Budget Dashboard",
            style: TextStyle(
              color: MyColor.backgroundColor,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: (() async {
            // ask if user want to logout?
            bool? result = await MyDialog.showConfirmation(
            context: context,
            text: "Do you want to logout from application?",
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
          }),
          icon: const Icon(
            LucideIcons.x,
            color: MyColor.backgroundColor,
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _initialPage,
        item: _navigationItem,
        onTap: ((index) {
          switch(index) {
            case 1:            
              setState(() {
                _initialPage = index;
              });
              break;
            case 2:
              // go to plan add page
              context.go('/plan/add');
              break;
            case 3:
              // go to user page
              context.go('/user');
              break;
          }
        }),
      ),
      body: RefreshIndicator(
        color: MyColor.primaryColorDark,
        onRefresh: () async {
          setState(() {
            _getData = _getPlanList();
          });
        },
        child: MyBody(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _itemList(),
            ),
          )
        ),
      ),
    );
  }

  List<Widget> _itemList() {
    List<Widget> retWidget = [];

    // loop thru all the plans and generate widget for them
    for(int i=0; i<_plans.length; i++) {
      // add the widget
      retWidget.add(
        Slidable(
          endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: <Widget>[
            SlidableAction(
              onPressed: (context) async {
                // go to the edit plan page
                context.go('/plan/edit', extra: _plans[i]);
              },
              icon: LucideIcons.pencil,
              backgroundColor: MyColor.primaryColorDark,
              foregroundColor: MyColor.backgroundColorDark,
              label: "Edit",
            ),
            SlidableAction(
              onPressed: (context) async {
                // show dialog confirmation whether user want to delete the
                // plan or not first
                await MyDialog.showConfirmation(
                  context: context,
                  text: "Do you want to delete Plan ${_plans[i].uid}?",
                  okayColor: MyColor.errorColor,
                  cancelColor: MyColor.backgroundColor,
                ).then((result) async {
                  if (result ?? false) {
                    await _deletePlan(index: i, uid: _plans[i].uid);
                  }
                },);
              },
              icon: LucideIcons.trash,
              backgroundColor: MyColor.errorColor,
              foregroundColor: MyColor.backgroundColorDark,
              label: "Del",
            ),
          ]
        ),
          child: InkWell(
            splashColor: MyColor.backgroundColorDark,
            onTap: (() {
              // go to the plan view page
              context.go('/plan/${_plans[i].uid}');
            }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: MyColor.backgroundColorDark,
                    style: BorderStyle.solid,
                    width: 1.0,
                  )
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "ID: ${_plans[i].uid}",
                          style: const TextStyle(
                            color: MyColor.textColorSecondary
                          ),
                        ),
                        Text(
                          (_plans[i].name).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            MyIconLabel(icon: LucideIcons.user, text: "${_plans[i].participations.length}"),
                            const SizedBox(width: 20,),
                            MyIconLabel(
                              icon: LucideIcons.calendar,
                              text: "${Globals.dfMMyy.format(_plans[i].startDate.toLocal())} - ${Globals.dfMMyy.format(_plans[i].endDate.toLocal())}",
                              addPadding: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Icon(
                    LucideIcons.chevron_right,
                    size: 40,
                    color: MyColor.primaryColorDark,
                  ),
                ],
              ),
            ),
          ),
        )
      );
    }

    return retWidget;
  }

  Future<bool> _getPlanList() async {
    Log.info(message: "🖥️ Get plan list for user");
    
    // call the Plan API to get the plan list for this user
    await PlanAPI.getPlanList().then((plans) {
      Log.success(message: "🖥️ Get plan list for user success");
      _plans = plans;
    },);

    return true;
  }

  Future<void> _deletePlan({
    required int index,
    required String uid
  }) async {
    // check the error occured during delete
    try {
      // show the loading screen
      LoadingScreen.instance().show(context: context);

      // log the message
      Log.info(message: "🗑️ Delete plan $uid");

      // call the Plan API to delete the plan
      await PlanAPI.deletePlan(uid: uid).then((plan) {
        Log.success(message: "🗑️ Delete plan $uid success");

        // remove the plan from the plan list
        setState(() {
          // remove the plan
          _plans.removeAt(index);
        });
      },).whenComplete(() {
        LoadingScreen.instance().hide();
      },);
    }
    on NetException catch(netError, stackTrace) {
      Log.error(
        message: "❌ Error when delete $uid with error ${netError.message}",
        error: netError,
        stackTrace: stackTrace,
      );

      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error ${netError.message} when delete plan.",
          okayColor: MyColor.errorColor,
        );
      }
    }
    on ClientException catch(clientError, stackTrace) {
      Log.error(
        message: "❌ Error when delete $uid with error ${clientError.message}",
        error: clientError,
        stackTrace: stackTrace,
      );

      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error ${clientError.message} when delete plan.",
          okayColor: MyColor.errorColor,
        );
      }
    }
    catch (error, stackTrace) {
      Log.error(
        message: "❌ Error when delete $uid with errror ${error.toString()}",
        error: error,
        stackTrace: stackTrace,
      );

      if (mounted) {
        MyDialog.showAlert(
          context: context,
          text: "Error processing on the application when delete plan.",
          okayColor: MyColor.errorColor,
        );
      }
    }
  }
}