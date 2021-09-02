import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loan_calculator/components/app_banner_ads.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_action_text_field.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/calculator_action_button.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/utils/extensions.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'package:screenshot/screenshot.dart';


class SavingsCalculator extends StatefulWidget {
  static const String idScreen = "SavingsCalculator";
  @override
  _SavingsCalculatorState createState() => _SavingsCalculatorState();
}

class _SavingsCalculatorState extends State<SavingsCalculator> {

  ScreenshotController screenshotController = ScreenshotController();

  TextEditingController principalController = TextEditingController();
  TextEditingController contributionController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController timePeriodController = TextEditingController();

  String principal = "", contribution = "", interestRate = "", timePeriod = "";
  MapEntry<String, int> frequencies;
  double savingsResult;

  @override
  void initState() {
    savingsResult = 0.0;
    frequencies = MapEntry('Weekly', 7);
    calculateLoan();
    GoogleAdService().init();
    super.initState();
  }

  @override
  void dispose() {
    principalController.dispose();
    contributionController.dispose();
    interestRateController.dispose();
    timePeriodController.dispose();
    disposeGoogleAdService();
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

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: CalculatorAppBar(
              title: "Savings\nCalculator",
              historyButtonClick: null,
              saveButtonClick: () async{
                await showInterstitialAd();
                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
                  showCapturedWidget(context, capturedImage, SavingsCalculator.idScreen);
                }).catchError((onError) {
                  print(onError);
                });
              },
              deleteButtonClick: null, shareButtonClick: null,
            )
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    SizedBox(height: responsiveWidth(14),),

                    Screenshot(
                        controller: screenshotController,
                        child: savingsResultCard()
                    ),


                    //------
                    BuildActionTextField(
                      title: 'Frequency',
                      hint: frequencies.key,
                      symbol: '▾',
                      textController: null,
                      onActionPressed: () {
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
                      symbol: '\$',
                      textController: principalController,
                    ),
                    BuildTextField(
                      title: 'Contribution',
                      hint: '0.0',
                      symbol: '\$',
                      textController: contributionController,
                    ),
                    BuildTextField(
                      title: 'Interest Rate',
                      hint: '0.0',
                      symbol: '%',
                      textController: interestRateController,
                    ),
                    BuildTextField(
                      title: 'Time Period (years)',
                      hint: '0',
                      symbol: 'y',
                      textController: contributionController,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: responsiveWidth(12), horizontal: responsiveWidth(8)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: CalculatorActionButton(
                                  title: "Calculate",
                                  onPressed: updateResult
                              )
                          ),
                          SizedBox(width: responsiveWidth(8),),
                          Expanded(
                              flex: 1,
                              child: CalculatorActionButton(
                                  title: "Reset",
                                  onPressed: () => resetPage(context, SavingsCalculator())
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            AppBannerAds(),
          ],
        ),
      ),
    );
  }


  //Home Page Back Press
  Future<bool> pickFrequency({BuildContext context, ValueChanged<MapEntry<String, int>> valueChanged}) async {

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
      barrierColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.97,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.only(top: responsiveWidth(5),),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.3),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: Offset.zero)
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: responsiveWidth(14), top: responsiveWidth(8), bottom: responsiveWidth(3),),
                      child: Row(
                        children: [
                          Text('Select Frequency', style: TextStyle(fontSize: responsiveWidth(16), fontWeight: FontWeight.bold)),
                          Spacer(),
                          // TextButton(
                          //     onPressed: ()=>Navigator.pop(context, false),
                          //     style: ButtonStyle(
                          //       backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent.withOpacity(0.3))
                          //     ),
                          //     child: Text("×", style: TextStyle(color:Colors.redAccent, fontSize: responsiveWidth(18)),)
                          // ),
                          SizedBox(width: responsiveWidth(5),)
                        ],
                      )
                  ),
                  Divider(),
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
                                  margin: EdgeInsets.all(responsiveWidth(8)),
                                  padding: EdgeInsets.fromLTRB(responsiveWidth(8), responsiveWidth(14), responsiveWidth(8), responsiveWidth(14)),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(frequencyList[index].entries.elementAt(0).key, style: TextStyle(fontSize: responsiveWidth(14), fontWeight: FontWeight.bold)),
                                      Spacer(),
                                      Text(frequencyList[index].entries.elementAt(0).value.toString() + ' Days', style: TextStyle(fontSize: responsiveWidth(14),)),
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

  Widget savingsResultCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(responsiveWidth(8), 0, responsiveWidth(8), responsiveWidth(8)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        margin: EdgeInsets.all(responsiveWidth(5)),
        padding: EdgeInsets.all(responsiveWidth(10)),
        decoration: BoxDecoration(
          color: Color(0xff1689FC),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            resultRow("Frequency", false, frequencies.key),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Principal", false, "${principal.length == 0?0:principal} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Contribution", false, "${contribution.length == 0?0:contribution } \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Interest Rate", false, "${interestRate.length == 0?0:interestRate} %"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Time Period", false, "${timePeriod.length == 0?0:timePeriod} y"),

            SizedBox(
              height: responsiveWidth(14),
              child: Divider(),
            ),

            resultRow("Savings Result", true, "${savingsResult.toStringAsFixed(2)} \$"),
          ],
        ),
      ),
    );
  }


  Widget resultRow(String title, bool result, String value){
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: responsiveWidth(14), fontWeight: result?FontWeight.bold:null),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: responsiveWidth(14), fontWeight: result?FontWeight.bold:null),
        ),
      ],
    );
  }

}
