import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:simple_budget/_index.g.dart';

class PlanTransactionAddPage extends StatefulWidget {
  final Object uid;
  final Object plan;
  const PlanTransactionAddPage({
    super.key,
    required this.uid,
    required this.plan,
  });

  @override
  State<PlanTransactionAddPage> createState() => _PlanTransactionAddPageState();
}

class _PlanTransactionAddPageState extends State<PlanTransactionAddPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late String _planUid;
  late PlanModel _plan;

  late DateTime _selectedDate;

  late TransactionType _transactionType;

  @override
  void initState() {
    super.initState();

    // get the plan UID
    _planUid = widget.uid as String;
    // get the plan
    _plan = widget.plan as PlanModel;
    // default the transaction type as expense
    _transactionType = TransactionType.expense;

    // initialize variable
    _selectedDate = DateTime.now().toLocal();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        title: Center(child: Text("Add Transaction"),),
        leading: IconButton(
          onPressed: () {
            // go back to plan view page
            context.pop();
          },
          icon: const Icon(
            LucideIcons.chevron_left,
            color: MyColor.backgroundColor,
          )
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _addTransaction();
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
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "UID",
                style: TextStyle(
                  color: MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              Text(
                _planUid,
                style: TextStyle(
                  color: MyColor.textColor,
                ),
              ),
              Text(
                _plan.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const TextSmall(text: "Type"),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: CupertinoSlidingSegmentedControl<TransactionType>(
                      children: _cupertinoSegmentChildren(),
                      thumbColor: (_transactionType == TransactionType.expense ? MyColor.errorColor : MyColor.successColor),
                      groupValue: _transactionType,
                      onValueChanged: <TransactionType>(value) {
                        setState(() {
                          _transactionType = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
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
                          color: MyColor.primaryColor,
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
              const TextSmall(text: "Date"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColor.primaryColor,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                height: 200,
                child: ScrollDatePicker(
                  barColor: MyColor.primaryColor,
                  borderColor: MyColor.primaryColor,
                  selectedColor: MyColor.backgroundColor,
                  padding: 5,
                  initialDate: _selectedDate,
                  onDateChange: ((date) {
                    _selectedDate = date.toLocal();
                  }),
                ),
              ),
              const SizedBox(height: 5,),
              const TextSmall(text: "Description (optional)"),
              CupertinoTextField(
                controller: _descriptionController,
                cursorColor: MyColor.primaryColorDark,
                decoration: BoxDecoration(
                  color: MyColor.backgroundColor,
                  border: Border.all(
                    color: MyColor.primaryColor,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 30,),
              MyButton(
                onTap: () async {
                  await _addTransaction();
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

  Map<TransactionType, Widget> _cupertinoSegmentChildren() {
    return <TransactionType, Widget> {
      TransactionType.expense: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Expense',
          style: TextStyle(
            color: (_transactionType == TransactionType.expense ? MyColor.backgroundColor : MyColor.errorColor),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TransactionType.income: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Income',
          style: TextStyle(
            color: (_transactionType == TransactionType.income ? MyColor.backgroundColor : MyColor.successColor),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    };
  }

  Future<void> _addTransaction() async {
    // validate all the data is already filled before we submit the create
    // first ensure the name is not empty
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
      await PlanAPI.addTransaction(
        uid: _planUid,
        description: description,
        date: _selectedDate,
        amount: amount,
        type: _transactionType,
      ).then((transaction) {
        if (transaction) {
          // success creating plan, put it on the log
          Log.success(message: "✅ Success add transaction for plan $_planUid");

          // go back to the dashboar
          if (mounted) {
            // return back the result to the plan view
            context.pop(true);
          }
        }
        else {
          Log.error(message: "❌ Unable to add transaction for plan $_planUid");

          // show error
          if (mounted) {
            MyDialog.showAlert(
              context: context,
              text: "Unable to add transaction, please try again.",
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
          text: "Error of ${netError.message} when adding transaction.",
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
          text: "Error of ${clientError.message} when adding transaction.",
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
          text: "Error processing on application when adding transaction.",
          okayColor: MyColor.errorColor,
        );
      }
    }
  }
}