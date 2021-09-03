import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:loan_calculator/components/build_history_card.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/utils/extensions.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class CalculationHistory extends StatefulWidget {
  static const String idScreen = "CalculationHistory";
  @override
  _CalculationHistoryState createState() => _CalculationHistoryState();
}

class _CalculationHistoryState extends State<CalculationHistory> {
  List _history = <History>[];
  //List get inventoryList => _history;
  Box box;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void initializeData() async {
    box = await Hive.openBox('history');
    _history = box.values.toList();
    setState(() {
      _history = _history.reversed.toList();
    });

    print(_history);
  }


  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: CalculatorAppBar(
              title: "Calculation\nHistory",
              historyButtonClick: null,
              saveButtonClick: null,
              deleteButtonClick: () async{
                bool result = await onDeletePressed(context);
                if (result) {
                  setState(() {
                    box.clear();
                    _history.clear();
                  });
                }
              },
            )
        ),

        body: _history.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                      child: CupertinoScrollbar(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        itemCount: _history.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return BuildHistoryCard(
                            history: _history[index],
                            onEdit: () {
                              Navigator.pop(context, {
                                'data': _history[index],
                              });
                            },
                            onDelete: () {
                              setState(() {
                                box.deleteAt(index);
                                _history.removeAt(index);
                              });
                            },
                          );
                        }),
                  ))
                ],
              )
            : Center(
                child: Text(
                  'Empty',
                  style: TextStyle(
                      fontSize: responsiveText(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
      ),
    );
  }
}
