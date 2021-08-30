import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_task_calculator/components/build_banner_ad.dart';
import 'package:multi_task_calculator/components/build_result_card.dart';
import 'package:multi_task_calculator/components/build_text_field.dart';
import 'package:multi_task_calculator/pages/savings_calc/components/build_savings_value_picker.dart';
import 'package:multi_task_calculator/services/google_ad_service.dart';
import 'package:multi_task_calculator/utils/constant.dart';
import 'package:multi_task_calculator/utils/extensions.dart';
import 'package:multi_task_calculator/utils/screen_config.dart';
import 'package:multi_task_calculator/utils/themes_mode.dart';


class SavingsCalcPage extends StatefulWidget {
  @override
  _SavingsCalcPageState createState() => _SavingsCalcPageState();
}

class _SavingsCalcPageState extends State<SavingsCalcPage> {

  TextEditingController principalController = TextEditingController();
  TextEditingController contributionController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController timePeriodController = TextEditingController();

  String principal, contribution, interestRate, timePeriod;
  MapEntry<String, int> frequencies;
  double savingsResult;

  @override
  void initState() {
    savingsResult = 0.0;
    frequencies = MapEntry('Weekly', 7);
    calculateLoan();
    super.initState();
  }

  @override
  void dispose() {
    principalController.dispose();
    contributionController.dispose();
    interestRateController.dispose();
    timePeriodController.dispose();
    super.dispose();
  }

  void calculateLoan() {
    principalController.addListener(() {
      updateResult();
    });
    contributionController.addListener(() {
      updateResult();
    });
    interestRateController.addListener(() {
      updateResult();
    });
    timePeriodController.addListener(() {
      updateResult();
    });
  }

  void updateResult() {
    principal = principalController.value.text;
    contribution = contributionController.value.text;
    interestRate = interestRateController.value.text;
    timePeriod = timePeriodController.value.text;
    //Make null safety
    setState(() {
      //Converting JS to Dart
      //https://codepen.io/cerovac/pen/xvgWrd
      double _principal = double.tryParse(principal)??0.0;
      double _contribution = double.tryParse(contribution) ?? 0.0;
      double _interestRate = double.tryParse(interestRate)??0.0;
      int _timePeriod = int.tryParse(timePeriod)??0;
      double r = _interestRate/100/365;
      double C = _contribution;
      double P = _principal;
      int y = _timePeriod;
      int d = 365 * y;
      int n = frequencies.value;
      var nn = (365/n).floor();
      double total = P+C;
      double ri = 0;
      DateTime yr = DateTime.now(), z, zz;
      int count = 0;
      bool initialDeposit = true;

      while (count++ < d) {
        int ny = yr.year, nm = yr.month, nd = yr.day;
        z = DateTime(ny, nm, count);
        zz = DateTime(ny, nm, count+1);
        if (count % n == 0) {
          if (!initialDeposit) {
            total += C;
          } else {
            initialDeposit = false;
          }
        }
        if (zz.day < z.day) {
          total = total + ri;
          ri = 0;
        }
        ri += (total * r);
      }
      savingsResult = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    ThemesMode().init(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Savings Calculator',
            style: TextStyle(
              fontFamily: fontAudioWide,
              fontSize: responsiveWidth(18)
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await showInterstitialAd();
                resetPage(context, savingCalcPage);
              },
              icon: Icon(Icons.refresh_rounded),
              tooltip: 'Reset',
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: ThemesMode.isDarkMode?Colors.black:textWhite,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                blurRadius: 0.5,
                                spreadRadius: 0.5,
                                offset: Offset.zero
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BuildSavingsValuePicker(
                            title: 'Frequency',
                            frequencyName: frequencies.key,
                            onPressedAction: () {
                              pickFrequency(
                                context: context,
                                  valueChanged:(value){
                                    setState(() {
                                      frequencies = value;
                                    });
                                  }
                              );
                            },
                          ),
                          BuildTextField(
                            title: 'Principle',
                            hint: '0.0',
                            isEnabled: true,
                            textController: principalController,
                            onPressedAction: null,
                            widget: Text('\$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveText(16)),),),
                          BuildTextField(
                            title: 'Contribution',
                            hint: '0.0',
                            isEnabled: true,
                            textController: contributionController,
                            onPressedAction: null,
                            widget: Text('\$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveText(16)),),),
                          BuildTextField(
                            title: 'Interest Rate',
                            hint: '0.0',
                            isEnabled: true,
                            textController: interestRateController,
                            onPressedAction: null,
                            widget: Text('%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveText(16)),),),
                          BuildTextField(
                            title: 'Time Period',
                            hint: '0',
                            isEnabled: true,
                            textController: timePeriodController,
                            onPressedAction: null,
                            widget: Text('yrs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveText(16)),),),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        BuildResultCard(title: 'Savings Result', value: savingsResult.toStringAsFixed(2),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BuildBannerAd(),
          ],
        ),
      ),
    );
  }


  //Home Page Back Press
  Future<bool> pickFrequency(
      {BuildContext context, ValueChanged<MapEntry<String, int>> valueChanged}) async {

    List<Map<String, int>> frequencyList = [
      {'Weekly':7},
      {'Bi-Weekly':14},
      {'Monthly':30},
      {'Quarterly':91},
      {'Annually':364},
    ];

    return showModalBottomSheet(
      context: context,
      elevation: 0.0,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: ThemesMode.isDarkMode?Colors.black54:Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.97,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.only(top: 5,),
              decoration: BoxDecoration(
                  color: ThemesMode.isDarkMode?backgroundDark:backgroundLight,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.9),
                        blurRadius: responsiveWidth(3),
                        spreadRadius: responsiveWidth(3),
                        offset: Offset.zero)
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text('Select Frequency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Spacer(),
                          IconButton(icon: Icon(Icons.close), onPressed: (){
                            Navigator.pop(context, false);
                          })
                        ],
                      )
                  ),
                  Expanded(
                      child:
                      ListView.builder(
                        controller: controller,
                        physics: BouncingScrollPhysics(),
                        itemCount: frequencyList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            child: InkWell(
                                onTap: (){
                                  valueChanged(frequencyList[index].entries.elementAt(0));
                                  Navigator.pop(context, true);
                                },
                                child:
                                Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(frequencyList[index].entries.elementAt(0).key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      Spacer(),
                                      Text(frequencyList[index].entries.elementAt(0).value.toString() + ' Days', style: TextStyle()),
                                    ],
                                  ),
                                )
                            ),
                          );
                        },
                      )
                  ),
                ],
              ),
            );
          },
        );
      },
    );


  }



}
