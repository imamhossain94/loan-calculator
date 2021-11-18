import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/models/row_data.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/utils/extensions.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'dart:math';
import 'calculation_history.dart';
import 'calculation_result.dart';
import 'components/build_action_text_field.dart';
import 'components/calculator_action_button.dart';

class AdvancedLoanCalculator extends StatefulWidget {
  static const String idScreen = "AdvancedLoanCalculator";
  @override
  _AdvancedLoanCalculatorState createState() => _AdvancedLoanCalculatorState();
}

class _AdvancedLoanCalculatorState extends State<AdvancedLoanCalculator> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  //home value
  TextEditingController homeValueController = TextEditingController();
  //money down/equity
  TextEditingController downPaymentController = TextEditingController();
  //loan amount
  TextEditingController loanAmountController = TextEditingController();
  //insurance
  TextEditingController homeInsController = TextEditingController();
  //tax(per year)
  TextEditingController propertyTaxController = TextEditingController();
  //interest rate
  TextEditingController interestController = TextEditingController();
  //pmi (Private Mortgage Insurance)
  TextEditingController pmiController = TextEditingController();
  //loan terms in year
  TextEditingController loanTermController = TextEditingController();
  String _downPaymentSymbol;
  bool showPmi;

  Map<String, dynamic> data;
  History history = History(
    mortgageData: MortgageData(homeValue: 0.0, downPayment: 0.0, loanAmount: 0.0, loanTerm: 0.0, homeIns: 0.0, interest: 0.0, propertyTax: 0.0, pmi: 0.0),
    resultData: ResultData(monthlyPayment: "", biWeeklyPayment: "", lastPayment: "", biWeeklyLastPayment: "", totalInterest: "0 ", biWeeklyTotalInterest: "", monthlyTax: "", monthlyIns: "", monthlyPmi: "", totalPmi: "")
  );


  @override
  void initState() {

    _downPaymentSymbol = '\$';
    homeValueController.text = '300000';
    downPaymentController.text = '60000';
    loanAmountController.text = '240000';
    homeInsController.text = '1000';
    propertyTaxController.text = '2400';
    interestController.text = '3.5';
    pmiController.text = '0.85';
    loanTermController.text = '360';
    super.initState();
  }

  @override
  void dispose() {

    homeValueController.dispose();
    downPaymentController.dispose();
    loanAmountController.dispose();
    homeInsController.dispose();
    propertyTaxController.dispose();
    interestController.dispose();
    pmiController.dispose();
    loanTermController.dispose();
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CalculatorAppBar(
              title: "Advanced\nLoan",
              historyButtonClick: () async{
                dynamic result = await Navigator.pushNamed(context, CalculationHistory.idScreen);
                if (result != null) {
                  History history = result['data'];

                  showMessage(context, "Edit Calculation", "Data loaded successfully");


                  setState(() {
                    homeValueController.text =
                        history.mortgageData.homeValue.toString();
                    downPaymentController.text =
                        history.mortgageData.downPayment.toString();
                    loanAmountController.text =
                        history.mortgageData.loanAmount.toString();
                    homeInsController.text =
                        history.mortgageData.homeIns.toString();
                    propertyTaxController.text =
                        history.mortgageData.propertyTax.toString();
                    interestController.text =
                        history.mortgageData.interest.toString();
                    pmiController.text =
                        history.mortgageData.pmi.toString();
                  });
                } else {
                  print('No action needed');
                }
              },
              saveButtonClick: null,
              deleteButtonClick: null, shareButtonClick: null,
            )
        ),

        body: Column(
          children: [
            SizedBox(height: responsiveWidth(14),),
            Expanded(
              child: Container(
                //margin: EdgeInsets.all(8),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [

                    advanceLoanResultCard(history),


                    BuildTextField(
                      title: 'Home Value/ Property Price',
                      hint: '${homeValueController.text}',
                      symbol: '\$',
                      textController: homeValueController,
                    ),

                    BuildActionTextField(
                      title: 'Money Down/ Equity',
                      hint: downPaymentController.text,
                      symbol: _downPaymentSymbol,
                      textController: downPaymentController,
                      onActionPressed: () {
                        setState(() {
                          if (_downPaymentSymbol == '\$') {
                            loanAmountController.text = '0';
                            _downPaymentSymbol = '%';
                          } else {
                            loanAmountController.text = '240000';
                            _downPaymentSymbol = '\$';
                          }
                        });
                        print(_downPaymentSymbol);
                      }
                    ),

                    BuildTextField(
                      title: 'Loan Amount',
                      hint: _downPaymentSymbol == '\$'
                          ? '\$${loanAmountController.text}'
                          : '0',
                      symbol: '\$',
                      textController: loanAmountController,
                    ),

                    BuildTextField(
                      title: 'Interest Rate',
                      hint: interestController.text,
                      symbol: '%',
                      textController: interestController,
                    ),

                    BuildTextField(
                      title: 'Loan term (month)',
                      hint: loanTermController.text,
                      symbol: 'm',
                      textController: loanTermController,
                    ),

                    BuildTextField(
                      title: 'Property Tex per year',
                      hint: propertyTaxController.text,
                      symbol: '\$',
                      textController: propertyTaxController,
                    ),

                    BuildTextField(
                      title: 'Insurance per year',
                      hint: homeInsController.text,
                      symbol: '\$',
                      textController: homeInsController,
                    ),

                    BuildTextField(
                      title: 'PMI',
                      hint: pmiController.text,
                      symbol: '%',
                      textController: pmiController,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: responsiveWidth(12), horizontal: responsiveWidth(8)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: CalculatorActionButton(
                                  title: "Calculate",
                                  onPressed: startCalculation
                              )
                          ),
                          SizedBox(width: responsiveWidth(8),),
                          Expanded(
                              flex: 1,
                              child: CalculatorActionButton(
                                  title: "Reset",
                                  onPressed: () => resetPage(context, AdvancedLoanCalculator())
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void startCalculation() async {
    calculateLoanAmount();
    data = calculateMortgage();

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day, now.hour,
        now.minute, now.second, now.microsecond);

    setState(() {
      history = History(
          mortgageData: data['mortgageData'],
          resultData: data['resultData'],
          calculationDate: DateFormat.yMd().add_jm().format(date));
    });

    final box = await Hive.openBox('history');
    box.add(history);
    Hive.close();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int counter = (prefs.getInt('calculate_button_click') ?? 0);
    //
    //


    // Navigator.pushNamed(context, CalculationResult.idScreen,
    //     arguments: {
    //       'data': history,
    //       'tableData': data['tableData']
    //     }
    // );
    //
    // if(counter >= 2){
    //
    //   if(await showRewardedAd()){
    //     await prefs.setInt('calculate_button_click', 0);
    //     Navigator.pushNamed(context, CalculationResult.idScreen,
    //         arguments: {
    //           'data': history,
    //           'tableData': data['tableData']
    //         }
    //     );
    //   }else{
    //     Navigator.pushNamed(context, CalculationResult.idScreen,
    //         arguments: {
    //           'data': history,
    //           'tableData': data['tableData']
    //         }
    //     );
    //   }
    //
    // }else{
    //   counter++;
    //   await prefs.setInt('calculate_button_click', counter);
    //   Navigator.pushNamed(context, CalculationResult.idScreen,
    //       arguments: {
    //         'data': history,
    //         'tableData': data['tableData']
    //       }
    //   );
    // }

  }

  void calculateLoanAmount() {
    if (_downPaymentSymbol == '\$') {
      loanAmountController.text = (double.parse(homeValueController.text) -
          double.parse(downPaymentController.text))
          .toString();
    } else {
      loanAmountController.text = (double.parse(homeValueController.text) -
          (double.parse(homeValueController.text) *
              double.parse(downPaymentController.text) /
              100))
          .toString();
    }
    if (double.parse(loanAmountController.text) < 0) {
      loanAmountController.text = '0';
    }
    if ((double.parse(downPaymentController.text) < 20) &&
        (double.parse(downPaymentController.text) != 0)) {
      pmiController.text = pmiController.text;
      showPmi = true;
    } else {
      showPmi = false;
      pmiController.text = pmiController.text;
    }
    if (double.parse(downPaymentController.text) > 100) {
      if ((double.parse(downPaymentController.text) /
          double.parse(homeValueController.text)) <
          .2) {
        pmiController.text = pmiController.text;
        showPmi = true;
      } else {
        showPmi = false;
        pmiController.text = pmiController.text;
      }
    }
  }

  Map<String, dynamic> calculateMortgage() {
    var months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    List<RowData> _rowData = <RowData>[];

    double homeValue = double.parse(homeValueController.text);
    double downPayment = double.parse(downPaymentController.text);
    double loanAmount = double.parse(loanAmountController.text);
    double loanTerm = double.parse(loanTermController.text);

    double homeIns = double.parse(homeInsController.text);
    double interest = double.parse(interestController.text);
    double propertyTax = double.parse(propertyTaxController.text);
    double pmi = double.parse(pmiController.text);

    double currentLoanAmount = homeValue - downPayment;
    double newMortgage = loanAmount;
    double bwNewMortgage = loanAmount;
    double totalPayments = loanTerm;

    double loanTermYear = loanTerm/12;

    double biWeeklyTotalMonths = (loanTermYear <= 9)
        ? (totalPayments - 5)
        : ((loanTermYear <= 14)
        ? (totalPayments - 12)
        : (loanTermYear <= 19)
        ? (totalPayments - 19)
        : (loanTermYear <= 29)
        ? (totalPayments - 16)
        : (loanTermYear <= 39) ? (totalPayments - 39) : (totalPayments - 83));
    double biWeeklyTotalPayments = loanTermYear * 26;

    double dividedInterest = interest / 12 / totalPayments;
    double biWeeklyDividedInterest = interest / 26 / biWeeklyTotalPayments;
    double monthlyInterest = interest / 12;
    double biWeeklyMonthlyInterest = interest / 21.105039;
    double monthlyInstallment = loanAmount *
        ((monthlyInterest / 100) /
            (1 - pow(1 + monthlyInterest / 100, -totalPayments)));
    double biWeeklyMonthlyInstallment = loanAmount *
        ((biWeeklyMonthlyInterest / 100) /
            (1 -
                pow(1 + biWeeklyMonthlyInterest / 100,
                    -biWeeklyTotalPayments)));

    double monthlyPropertyTax = propertyTax / 12;
    double monthlyPMI = (loanAmount * pmi) / 12 / 100;
    double bwMonthlyPMI = (loanAmount * pmi) / 26 / 100;
    double monthlyIns = homeIns / 12;

    double yearlyInterest = 0;
    double bwYearlyInterest = 0;
    double yearlyPrincipal = 0;
    double bwYearlyPrincipal = 0;
    double monthlyPayment = 0;
    double totalPayment = 0;
    double totalPMI = 0;
    double bwTotalPMI = 0;
    double totalInterest = 0;
    double bwTotalInterest = 0;
    double countPMI = 0;
    double bwCountPMI = 0;
    double currentInterest = 0;
    double bwCurrentInterest = 0;
    double currentPrincipal = 0;
    double bwCurrentPrincipal = 0;
    double currentLTV = 0;
    double bwCurrentLTV = 0;
    double currentPMI = 0;
    double bwCurrentPMI = 0;

    var currentMonthId = new DateTime.now().month - 1;
    var bwCurrentMonthId = new DateTime.now().month - 1;
    var currentMonth = "";
    var bwCurrentMonth = "";
    var currentYear = new DateTime.now().year;
    var bwCurrentYear = new DateTime.now().year;

    for (var i = 0; i < totalPayments; i++) {
      /* Calculate data */

      currentInterest = newMortgage * monthlyInterest / 100;
      bwCurrentInterest = bwNewMortgage * biWeeklyMonthlyInterest / 100;
      currentPrincipal = monthlyInstallment - currentInterest;
      bwCurrentPrincipal = biWeeklyMonthlyInstallment - bwCurrentInterest;
      currentLTV = (newMortgage / homeValue) * 100;
      bwCurrentLTV = (bwNewMortgage / homeValue) * 100;
      totalInterest += currentInterest;
      bwTotalInterest += bwCurrentInterest;
      newMortgage -= currentPrincipal;
      bwNewMortgage -= bwCurrentPrincipal;
      yearlyInterest += currentInterest;
      bwYearlyInterest += bwCurrentInterest;
      yearlyPrincipal += currentPrincipal;
      bwYearlyPrincipal += bwCurrentPrincipal;

      if (currentLTV < 80) {
        currentPMI = 0;
      } else {
        currentPMI = monthlyPMI;
        totalPMI += currentPMI;
        countPMI++;
      }

      if (bwCurrentLTV < 80) {
        bwCurrentPMI = 0;
      } else {
        bwCurrentPMI = bwMonthlyPMI;
        bwTotalPMI += bwCurrentPMI;
        bwCountPMI++;
      }

      monthlyPayment = currentInterest +
          currentPrincipal +
          currentPMI +
          monthlyPropertyTax +
          homeIns / 12;
      totalPayment += monthlyPayment;

      currentMonthId++;

      if (currentMonthId == 12) {
        currentMonthId = 0;
        currentYear++;
      }

      currentMonth = months[currentMonthId];
      bwCurrentMonth = months[currentMonthId];

      if (currentMonthId == 0) {
        _rowData.add(RowData(
          (currentYear - 1).toString(),
          '\$${yearlyInterest.toStringAsFixed(0)}',
          '\$${yearlyPrincipal.toStringAsFixed(0)}',
          '\$${newMortgage.toStringAsFixed(0)}',
        ));
        yearlyInterest = 0;
        yearlyPrincipal = 0;
      }

      _rowData.add(RowData(
        '$currentMonth $currentYear',
        '\$${currentInterest.toStringAsFixed(0)}',
        '\$${currentPrincipal.toStringAsFixed(0)}',
        '\$${newMortgage.toStringAsFixed(0)}',
      ));

      if (i == totalPayments - 1) {
        var yearPrev = i == totalPayments - 1 ? 0 : 1;
        _rowData.add(RowData(
          currentYear.toString(),
          '\$${yearlyInterest.toStringAsFixed(0)}',
          '\$${yearlyPrincipal.toStringAsFixed(0)}',
          '\$${newMortgage.toStringAsFixed(0)}',
        ));
      }
    }

    var mgMonthlyPMI =
    '\$ ${((monthlyPMI * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    //var mgNumMonthlyPMI = '${((totalPMI / monthlyPMI * 100).round() / 100).toStringAsFixed(0)}'.replaceAll(".00", "");
    var mgMonthlyIns =
    '\$ ${((monthlyIns * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgMonthlyPayment =
    '\$ ${((monthlyPayment * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgTotalInterest =
    '\$ ${((totalInterest * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgBiWeeklyTotalInterest =
    '\$ ${((bwTotalInterest * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgTotalPMI = '\$ ${((totalPMI * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgMonthlyTax =
    '\$ ${((monthlyPropertyTax * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgBiWeeklyPayment =
    '\$ ${((monthlyPayment / 2 * 100).round() / 100).toStringAsFixed(2)}'
        .replaceAll(".00", "");
    var mgLastPayment = '$currentMonth $currentYear';
    var mgBiWeeklyLastPayment =
        '${months[((months.indexOf(bwCurrentMonth) + biWeeklyTotalMonths % 12) % 12).toInt()]} ${bwCurrentYear + (biWeeklyTotalMonths / 12).floor()}';

    MortgageData _mortgageData = MortgageData(
        homeValue: double.parse(homeValueController.text),
        downPayment: double.parse(downPaymentController.text),
        loanAmount: double.parse(loanAmountController.text),
        loanTerm: double.parse(loanTermController.text),
        homeIns: double.parse(homeInsController.text),
        interest: double.parse(interestController.text),
        propertyTax: double.parse(propertyTaxController.text),
        pmi: double.parse(pmiController.text));

    ResultData _resultData = ResultData(
        monthlyPayment: mgMonthlyPayment,
        biWeeklyPayment: mgBiWeeklyPayment,
        lastPayment: mgLastPayment,
        biWeeklyLastPayment: mgBiWeeklyLastPayment,
        totalInterest: mgTotalInterest,
        biWeeklyTotalInterest: mgBiWeeklyTotalInterest,
        monthlyTax: mgMonthlyTax,
        monthlyIns: mgMonthlyIns,
        monthlyPmi: showPmi ? mgMonthlyPMI : '\$ 0',
        totalPmi: showPmi ? mgTotalPMI : '\$ 0');

    return {
      'mortgageData': _mortgageData,
      'resultData': _resultData,
      'tableData': _rowData
    };
  }



  Widget advanceLoanResultCard(History history) {

    print("lal ${history.resultData.totalInterest}");

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
          color: Color(0xff1eb384),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            resultRow("Home Value/ Property Price", false, "${history.mortgageData.homeValue} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Money Down/ Equity", false, "${history.mortgageData.downPayment} $_downPaymentSymbol"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Loan Amount", false, "${history.mortgageData.loanAmount} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Interest Rate", false, "${history.mortgageData.interest} %"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Loan Term", false, "${history.mortgageData.loanTerm} m"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Property Tex per year", false, "${history.mortgageData.propertyTax} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Insurance per year", false, "${history.mortgageData.homeIns} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("PMI", false, "${history.mortgageData.pmi} %"),
            SizedBox(height: responsiveWidth(5),),
            SizedBox(
              height: responsiveWidth(14),
              child: Divider(),
            ),
            resultRow("Total Interest", true, "${history.resultData.totalInterest} \$"),
            if(history.resultData.totalInterest != "0 ")
            Container(
              margin: EdgeInsets.only(top: responsiveWidth(5)),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  highlightColor: Colors.white,
                  onTap: () async{

                    await showInterstitialAd();
                    Navigator.pushNamed(context, CalculationResult.idScreen,
                        arguments: {
                          'data': history,
                          'tableData': data['tableData']
                        }
                    );

                  },
                  child: Container(
                      //padding: EdgeInsets.symmetric(vertical: responsiveWidth(5), horizontal: responsiveWidth(5)),
                      height: responsiveWidth(22),
                      //width: responsiveWidth(18),
                      alignment: Alignment.center,
                      child: Text(
                          "Click here to view details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsiveWidth(12),
                          )
                      )
                  ),
                ),
              ),
            ),
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
