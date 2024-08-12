import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:simple_budget/_index.g.dart';

class PlanItemModal extends StatefulWidget {
  final String uid;
  final DateTime date;
  final bool isLogin;
  final List<ParticipationModel> participation;
  final List<ContributionModel> contributions;
  const PlanItemModal({
    super.key,
    required this.uid,
    required this.date,
    required this.isLogin,
    required this.participation,
    required this.contributions,
  });

  @override
  State<PlanItemModal> createState() => _PlanItemModalState();
}

class _PlanItemModalState extends State<PlanItemModal> {
  final ScrollController _scrollController = ScrollController();
  late Map<int, bool> _contributionsMap;
  late bool _result;

  @override
  void initState() {
    // default result as false
    _result = false;

    // initialize contribution map as {}
    _contributionsMap = {};

    // generate the contributions map
    _generateContributionMap();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height * 0.5),
      color: MyColor.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: MyColor.primaryColorDark,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Globals.dfyyMon.format(widget.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 5,),
                IconButton(
                  onPressed: (() {
                    // dismiss modal dialog
                    Navigator.pop(context, _result);
                  }),
                  icon: const Icon(
                    LucideIcons.circle_x,
                    color: MyColor.warningColor,
                    size: 18,
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List<Widget>.generate(widget.participation.length, (index) {
                    return MyUserList(
                      uid: widget.uid,
                      date: widget.date,
                      name: widget.participation[index].name,
                      paid: (_contributionsMap[widget.participation[index].id] ?? false),
                      enableSlide: widget.isLogin,
                      onAdd: (() async {
                        await ContributionAPI.create(
                          uid: widget.uid,
                          participationId: widget.participation[index].id,
                          date: widget.date
                        ).then((_) {
                          Log.success(message: '👤 Add participation for ${widget.participation[index].name} on plan ${widget.uid} for ${widget.date}');

                          setState(() {
                            _result = true;
                            _contributionsMap[widget.participation[index].id] = true;
                          });
                        },).onError((error, stackTrace) {
                          Log.error(
                            message: "👤 Error when add participation",
                            error: error,
                            stackTrace: stackTrace,
                          );

                          _showAlert(
                            text: 'Error when add participation for ${widget.participation[index].name} on plan ${widget.uid} for ${widget.date}'
                          );
                        },);
                      }),
                      onRemove: (() async {
                        await ContributionAPI.delete(
                          uid: widget.uid,
                          participationId: widget.participation[index].id,
                          date: widget.date
                        ).then((_) {
                          Log.success(message: '👤 Remove participation for ${widget.participation[index].name} on plan ${widget.uid} for ${widget.date}');

                          setState(() {
                            _result = true;
                            _contributionsMap[widget.participation[index].id] = false;
                          });
                        }).onError((error, stackTrace) {
                          Log.error(
                            message: "👤 Error when remove participation",
                            error: error,
                            stackTrace: stackTrace,
                          );

                          _showAlert(
                            text: 'Error when remove participation for ${widget.participation[index].name} on plan ${widget.uid} for ${widget.date}'
                          );
                        },);
                      }),
                    );
                  },),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  void _generateContributionMap() {
    // loop thru participations first to generate the map
    for(int i=0; i<widget.participation.length; i++) {
      _contributionsMap[widget.participation[i].id] = false;
    }

    // now loop thru contributions and set the one that already contribute
    // into true
    for(int i=0; i<widget.contributions.length; i++) {
      _contributionsMap[widget.contributions[i].participationId] = true;
    }
  }

  void _showAlert({required String text}) {
    MyDialog.showAlert(
      context: context,
      text: text,
      okayColor: MyColor.errorColor,
    );
  }
}