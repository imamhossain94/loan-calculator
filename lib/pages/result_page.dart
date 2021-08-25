import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/utils/app_constants.dart';
import 'package:loan_calculator/utils/extentsons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:loan_calculator/components/build_result_item.dart';
import 'package:loan_calculator/components/build_table_header.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/models/row_data.dart';
import 'package:loan_calculator/utils/screen_config.dart';



class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 1,
            title: Text(
              'Result',
              style: TextStyle(
                  fontSize: responsiveText(22),
                  fontFamily: 'Audiowide',
                  color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                handleBackPress();
              },
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.save,
                    color: Colors.black,
                  ),
                  tooltip: 'Save',
                  onPressed: () async{

                    navigatePage();

                  }
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                color: Color(0xffF2F3F5),
                padding: EdgeInsets.all(5),
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
                backgroundColor: Colors.blueAccent.withOpacity(0.3),
                padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                textColor: Colors.black,
                textSize: 16,
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
                                : Colors.white,
                            padding: EdgeInsets.all(8),
                            textColor: Colors.black,
                            textSize: 14,
                            fontWeight: FontWeight.normal,
                            rowData: _rowData[index],
                          );
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void navigatePage() async{

    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    var platform = const MethodChannel('flutter.native/helper');
    try {
      var data = {
        "dirName": "${AppConstants.appName}/PDF",
      };

      if(await platform.invokeMethod('graterThenQ')) {
        await platform.invokeMethod('createDirectory', data).then((value) async{

          if(value){
            if(await onSavePdf(context)){
              if(await showRewardedAd()){
                Navigator.pushNamed(context, '/pdf',
                    arguments: {
                      'data': history,
                      'tableData': _rowData,
                    }
                );
              }else{
                showMessage(context, "Try Again", "Failed to load an ads");
              }
            }
          }else{
            showMessage(context, "Permission Required", "Without external storage permission you can't save file.");
          }

        });
      }else{
        if(await onSavePdf(context)){
          if(await showRewardedAd()){
            Navigator.pushNamed(context, '/pdf',
                arguments: {
                  'data': history,
                  'tableData': _rowData,
                }
            );
          }else{
            showMessage(context, "Try Again", "Failed to load an ads");
          }
        }
      }


    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }

  }

}
