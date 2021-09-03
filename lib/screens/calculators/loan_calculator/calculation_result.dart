import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:loan_calculator/components/build_result_item.dart';
import 'package:loan_calculator/components/build_table_header.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/models/row_data.dart';
import 'package:loan_calculator/utils/screen_config.dart';

import 'calculation_result_preview.dart';



class CalculationResult extends StatefulWidget {
  static const String idScreen = "CalculationResult";
  @override
  _CalculationResultState createState() => _CalculationResultState();
}

class _CalculationResultState extends State<CalculationResult> {
  Map data = {};
  History history;
  ResultData resultData;
  List<RowData> _rowData;



  Future<bool> handleBackPress() async{

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int counter = (prefs.getInt('result_back_button_click') ?? 0) + 1;
    //
    // if(counter >= 3){
    //   if (await interstitialAd.isLoaded) {
    //     interstitialAd.show();
    //   } else {
    //     // showSnackBar(
    //     //     'Interstitial ad is still loading...');
    //   }
    //   await prefs.setInt('result_back_button_click', 0);
    // }else{
    //   await prefs.setInt('result_back_button_click', counter);
    // }
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    data = data.isEmpty ? ModalRoute.of(context).settings.arguments : data;
    history = data['data'];
    _rowData = data['tableData'];
    resultData = history.resultData;

    return WillPopScope(
      onWillPop: () async {
        return await handleBackPress();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: CalculatorAppBar(
                title: "Calculation\nResult",
                historyButtonClick: null,
                saveButtonClick: navigatePage,
                deleteButtonClick: null,
              )
          ),

          body: Container(
            margin: EdgeInsets.fromLTRB(responsiveWidth(8), responsiveWidth(14), responsiveWidth(8), responsiveWidth(20)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              margin: EdgeInsets.all(responsiveWidth(5)),
              //padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  //SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(responsiveWidth(5)),
                    decoration: BoxDecoration(
                        color: Color(0xff1eb384),//Colors.blueAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              BuildResultItem(
                                title: 'Monthly payment (PITI)',
                                value: resultData.monthlyPayment,
                              ),
                              Divider(color: Colors.black12),
                              BuildResultItem(
                                title: 'Loan payoff date',
                                value: resultData.lastPayment,
                              ),
                              Divider(color: Colors.black12),
                              BuildResultItem(
                                title: 'Total interest',
                                value: resultData.totalInterest,
                              ),
                              Divider(color: Colors.black12),
                              BuildResultItem(
                                title: 'Monthly property tax',
                                value: resultData.monthlyTax,
                              ),
                              !resultData.monthlyPmi.contains('\$ 0')
                                  ? Divider(color: Colors.black12)
                                  : SizedBox(),
                              !resultData.monthlyPmi.contains('\$ 0')
                                  ? BuildResultItem(
                                title: 'Monthly PMI',
                                value: resultData.monthlyPmi,
                              )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        //Container(height: 100, child: VerticalDivider(color: Colors.white54)),
                        Expanded(
                          child: Column(
                            children: [
                              BuildResultItem(
                                title: 'Bi-weekly payment',
                                value: resultData.biWeeklyPayment,
                              ),
                              Divider(color: Colors.black12),
                              BuildResultItem(
                                title: 'Bi-weekly payoff date',
                                value: resultData.biWeeklyLastPayment,
                              ),
                              Divider(color: Colors.black12),
                              BuildResultItem(
                                title: 'Bi-weekly total interest',
                                value: resultData.biWeeklyTotalInterest,
                              ),
                              Divider(color: Colors.black12),
                              BuildResultItem(
                                title: 'Monthly insurance',
                                value: resultData.monthlyIns,
                              ),
                              !resultData.totalPmi.contains('\$ 0')
                                  ? Divider(color: Colors.black12)
                                  : SizedBox(),
                              !resultData.totalPmi.contains('\$ 0')
                                  ? BuildResultItem(
                                title: 'Total PMI',
                                value: resultData.totalPmi,
                              )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildTableHeader(
                    backgroundColor: Colors.redAccent.withOpacity(0.3),
                    padding: EdgeInsets.all(responsiveWidth(10)),
                    textColor: Colors.black,
                    textSize: responsiveWidth(12),
                    fontWeight: FontWeight.bold,
                  ),
                  Expanded(
                      child: CupertinoScrollbar(
                        child: ListView.builder(
                            itemCount: _rowData.length,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return BuildTableRow(
                                backgroundColor: _rowData[index].payment.length == 4
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.blueAccent.withOpacity(0.1),
                                padding: EdgeInsets.all(responsiveWidth(8)),
                                textColor: Colors.black,
                                textSize: responsiveWidth(12),
                                fontWeight: FontWeight.normal,
                                rowData: _rowData[index],
                              );
                            }),
                      )
                  ),
                  //SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigatePage() async{
    Navigator.pushNamed(context, CalculationResultPreview.idScreen,
        arguments: {
          'data': history,
          'tableData': _rowData,
        }
    );
  }

}
