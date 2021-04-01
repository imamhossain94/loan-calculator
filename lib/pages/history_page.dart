import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:mortgage_calculator/components/build_history_card.dart';
import 'package:mortgage_calculator/models/history.dart';
import 'package:mortgage_calculator/utils/extentsons.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          title: Text(
            'History',
            style: TextStyle(
                fontSize: responsiveText(22),
                fontFamily: 'Audiowide',
                color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.black,
                ),
                tooltip: 'Clear All',
                onPressed: () async {
                  bool result = await onDeletePressed(context);
                  if (result) {
                    setState(() {
                      box.clear();
                      _history.clear();
                    });
                  }
                })
          ],
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
