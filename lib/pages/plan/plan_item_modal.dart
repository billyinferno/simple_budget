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

  @override
  void initState() {
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
                    Navigator.pop(context);
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
                      paid: (index % 3 == 0 ? true : false),
                      enableSlide: widget.isLogin,
                      onAdd: (() async {
                        //TODO: to call API to add participation
                        Log.success(message: '👤 Add participation for "nama teman" on plan ${widget.uid} for ${widget.date}');
                      }),
                      onRemove: (() async {
                        //TODO: to call API to add participation
                        Log.success(message: '👤 Remove participation for "nama teman" on plan ${widget.uid} for ${widget.date}');
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
}