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
          return const Placeholder();
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
                  ("Plan Goes to Korea").toUpperCase(),
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
                    MyIconLabel(icon: LucideIcons.calendar, text: "07/24 - 07/25", addPadding: false,),
                  ],
                ),
                const SizedBox(height: 10,),
                //TODO: to fill the correct value for the bar chart
                const MyBarChart(
                  value: 80,
                  maxValue: 100,
                  text: "36,000,000 (80%)",
                ),
                const SizedBox(height: 10,),
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                const SizedBox(height: 10,),
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

                      //TODO: give alert dialog
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

    //TODO: to check if user logon or not here, if logon then we can show the user menu
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
    // TODO: perform API call to get the plan
    Log.info(message: "🖥️ Get plan data for $_planUid");
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
        );
      },
    );
  }
}