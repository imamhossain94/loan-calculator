import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mortgage_calculator/utils/extentsons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mortgage_calculator/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:mortgage_calculator/components/build_result_item.dart';
import 'package:mortgage_calculator/components/build_table_header.dart';
import 'package:mortgage_calculator/models/result_data.dart';
import 'package:mortgage_calculator/models/row_data.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';



class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Map data = {};
  History history;
  ResultData resultData;
  List<RowData> _rowData;

  AdmobInterstitial interstitialAd;
  bool isLoading = false;

  @override
  void initState() {
    interstitialAd = AdmobInterstitial(
      adUnitId: env['INTERSTITIAL_AD_UNIT_ID'],
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
    super.initState();
  }

  Future<bool> handleStoragePermission() async{
    var status = await Permission.storage.status;
    if(!status.isGranted){
      var _status = await Permission.storage.request();
      if(_status.isGranted){
        return true;
      }else{
        return false;
      }
    } else{
      return true;
    }
  }

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
      child: isLoading?Center(
        child: CircularProgressIndicator(),
      ):
      SafeArea(
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

                    bool isGranted = await handleStoragePermission();
                    if(isGranted){
                      navigatePage();
                    }else{
                      showMessage(context, 'Permission Denied', 'To save pdf file we need the storage permission.');
                    }

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
    setState(() {
      isLoading = true;
    });
    bool adsLoaded = await interstitialAd.isLoaded;
    if (adsLoaded) {
      interstitialAd.show();
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, '/pdf',
          arguments: {
            'data': history,
            'tableData': _rowData,
          }
      );
    }else{
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, '/pdf',
          arguments: {
            'data': history,
            'tableData': _rowData,
          }
      );
    }
  }

  void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        setState(() {
          isLoading = false;
        });
        break;
      case AdmobAdEvent.opened:
        setState(() {
          isLoading = false;
        });
        break;
      case AdmobAdEvent.closed:
        setState(() {
          isLoading = false;
        });
        break;
      case AdmobAdEvent.failedToLoad:
        setState(() {
          isLoading = false;
        });
        break;
      default:
        setState(() {
          isLoading = false;
        });
    }
  }

}
