import 'package:flutter/material.dart';
import 'package:loan_calculator/components/app_banner_ads.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/calculator_action_button.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/utils/extensions.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'package:screenshot/screenshot.dart';


class TipCalculator extends StatefulWidget {
  static const String idScreen = "TipCalculator";
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {

  ScreenshotController screenshotController = ScreenshotController();

  TextEditingController billAmountController = TextEditingController();
  TextEditingController numberOfPeopleController = TextEditingController();
  TextEditingController tipAmountController = TextEditingController();
  TextEditingController taxAmountController = TextEditingController();

  String billAmount = "", numberOfPeople = "", tipAmount = "", taxAmount = "";
  double finalAmount, amountPerPerson, tipPercentage, taxPercentage;
  bool tipAmountDollar = true, taxAmountDollar = true;


  @override
  void initState() {
    finalAmount = 0.0;
    amountPerPerson = 0.0;
    calculateTip();
    GoogleAdService().init();
    super.initState();
  }

  @override
  void dispose() {
    billAmountController.dispose();
    numberOfPeopleController.dispose();
    tipAmountController.dispose();
    taxAmountController.dispose();
    disposeGoogleAdService();
    super.dispose();
  }

  void calculateTip() {
    billAmountController.addListener(() {
      updateResult();
    });
    numberOfPeopleController.addListener(() {
      updateResult();
    });
    tipAmountController.addListener(() {
      updateResult();
    });
    taxAmountController.addListener(() {
      updateResult();
    });
  }

  void updateResult() {
    billAmount = billAmountController.value.text;
    numberOfPeople = numberOfPeopleController.value.text;
    tipAmount = tipAmountController.value.text;
    taxAmount = taxAmountController.value.text;
    //Make null safety
    setState(() {

      double _billAmount = double.tryParse(billAmount)??0.0;
      int _numberOfPeople = int.tryParse(numberOfPeople) ?? 0;
      double _tipAmount = double.tryParse(tipAmount)??0.0;
      double _taxAmount = double.tryParse(taxAmount)??0.0;

      if(_tipAmount == 0.0 && _taxAmount == 0.0){
        finalAmount = _billAmount;
        amountPerPerson = _billAmount / _numberOfPeople;
      }else if( _taxAmount == 0.0){

        if(tipAmountDollar){
          finalAmount = _billAmount + _tipAmount;
          amountPerPerson = finalAmount / _numberOfPeople;
        }else{
          finalAmount = _billAmount + (_billAmount * _tipAmount/100);
          amountPerPerson = finalAmount / _numberOfPeople;
        }

      }
      //else if(_billAmount != 0.0 && _taxAmount != 0.0 && _taxAmount != 0.0){
      //   if(taxAmountDollar){
      //
      //
      //     double _tempBillAmount = _billAmount - _taxAmount;
      //     double _tipPercent = (_taxAmount * 100) / _tempBillAmount;
      //     double _tipAmnt = _tempBillAmount * (_tipPercent/100);
      //     //_tipAmount = _tempBillAmount * (((_tipAmount * 100) / _tempBillAmount)/100);
      //
      //     finalAmount = _billAmount + _tipAmnt;
      //     amountPerPerson = finalAmount / _numberOfPeople;
      //     print(_tempBillAmount);
      //     print(_tipPercent);
      //     print(_tipAmnt);
      //
      //
      //   }
      //   // else{
      //   //   print('heat: ${_billAmount * _tipAmount/100}');
      //   //   finalAmount = _billAmount + (_billAmount * _tipAmount/100);
      //   //   amountPerPerson = finalAmount / _numberOfPeople;
      //   // }
      //
      // }

    });
  }

  void tipAmountToTipPercent(){

  }



  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: CalculatorAppBar(
              title: "Tip\nCalculator",
              historyButtonClick: null,
              saveButtonClick: () async {
                await showInterstitialAd();
                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
                  showCapturedWidget(context, capturedImage, TipCalculator.idScreen);
                }).catchError((onError) {
                  print(onError);
                });
              },
              deleteButtonClick: null,
              shareButtonClick: null,
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
                        child: discountResultCard()
                    ),

                    BuildTextField(
                      title: 'Bill Amount',
                      hint: '0.0',
                      symbol: '\$',
                      textController: billAmountController,
                    ),

                    BuildTextField(
                      title: 'Number of People',
                      hint: '0.0',
                      symbol: 'P',
                      textController: numberOfPeopleController,
                    ),

                    BuildTextField(
                      title: 'Tip Amount',
                      hint: '0.0',
                      symbol: '%',
                      textController: tipAmountController,
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
                                  onPressed: () => resetPage(context, TipCalculator())
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

  Widget discountResultCard() {
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
          color: Color(0xffC76CF8),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            resultRow("Bill Amount", false, "${billAmount.length == 0?0:billAmount} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Number of People", false, "${numberOfPeople.length == 0?0:numberOfPeople} P"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Tip Amount", false, "${tipAmount.length == 0?0:tipAmount} \$"),
            SizedBox(height: responsiveWidth(5),),
            SizedBox(
              height: responsiveWidth(14),
              child: Divider(),
            ),
            resultRow("Final Amount", true, "${finalAmount.toStringAsFixed(2)} \$"),
            resultRow("Amount per Person", true, "${amountPerPerson.toStringAsFixed(2)} \$"),
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
