import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:loan_calculator/utils/extentsons.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/build_result_card.dart';
import 'components/calculator_action_button.dart';
import 'components/loan_type_picker.dart';



class SimpleLoan extends StatefulWidget {
  static const String idScreen = "SimpleLoan";
  @override
  _SimpleLoanState createState() => _SimpleLoanState();
}

class _SimpleLoanState extends State<SimpleLoan> {

  TextEditingController mortgageAmountController = TextEditingController();
  TextEditingController monthlyPaymentController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController periodController = TextEditingController();

  String mortgageAmount = "", monthlyPayment = "", interestRate = "", period = "", loanType;
  double totalCostResult, monthlyPaymentResult, youCouldBorrow;


  @override
  void initState() {
    totalCostResult = 0.0;
    monthlyPaymentResult = 0.0;
    youCouldBorrow = 0.0;
    loanType = 'Monthly Cost';
    calculateLoan();
    super.initState();
  }

  @override
  void dispose() {
    mortgageAmountController.dispose();
    monthlyPaymentController.dispose();
    interestRateController.dispose();
    periodController.dispose();
    super.dispose();
  }

  void calculateLoan() {
    mortgageAmountController.addListener(() {
      updateResult();
    });
    monthlyPaymentController.addListener(() {
      updateResult();
    });
    interestRateController.addListener(() {
      updateResult();
    });
    periodController.addListener(() {
      updateResult();
    });
  }

  void updateResult() {
    mortgageAmount = mortgageAmountController.value.text;
    monthlyPayment = monthlyPaymentController.value.text;
    interestRate = interestRateController.value.text;
    period = periodController.value.text;
    //Make null safety
    setState(() {

      double _mortgageAmount = double.tryParse(mortgageAmount)??0.0;
      double _monthlyPayment = double.tryParse(monthlyPayment) ?? 0.0;
      double _interestRate = double.tryParse(interestRate)??0.0;
      int months = int.tryParse(period)??0;

      _interestRate = _interestRate / 100 / 12;
      //months = months * 12;

      double monthlyTop = _interestRate * pow((1 + _interestRate), months);
      double monthlyBottom = pow(1 + _interestRate, months) - 1;

      if(loanType == 'Monthly Cost'){

        double monthlyRate = _mortgageAmount * (monthlyTop / monthlyBottom);
        double totalPayment = monthlyRate * months;
        //result
        totalCostResult = totalPayment;
        monthlyPaymentResult = monthlyRate;

      }else if(loanType == 'Maximum Loan'){

        double borrowAmount = _monthlyPayment / (monthlyTop / monthlyBottom);
        double totalPayment = _monthlyPayment * months;
        //result
        totalCostResult = totalPayment;
        youCouldBorrow = borrowAmount;

      }



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
          preferredSize: Size.fromHeight(55),
            child: CalculatorAppBar(
              title: "Simple\nLoan",
              historyButtonClick: null,
              saveButtonClick: () {  },
              deleteButtonClick: null,
            )
        ),
        body: Column(
          children: [
            //------
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    SizedBox(height: responsiveWidth(15),),
                    LoanTypePicker(
                      title: 'Loan Type',
                      valueChanged: (String value) {
                        setState(() {
                          print(value);
                          loanType = value;
                          updateResult();
                        });
                      },
                    ),
                    SizedBox(height: responsiveWidth(10),),
                    loanResultCard(),


                    //------
                    BuildTextField(
                      title: loanType == 'Monthly Cost'?'Loan Amount':'Monthly Payment',
                      hint: '0.0',
                      symbol: '\$',
                      textController: loanType == 'Monthly Cost'?mortgageAmountController:monthlyPaymentController,
                    ),
                    BuildTextField(
                      title: 'Interest Rate',
                      hint: '0.0',
                      symbol: '%',
                      textController: interestRateController,
                    ),
                    BuildTextField(
                      title: 'Period',
                      hint: '0',
                      symbol: 'm',
                      textController: periodController,
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
                                onPressed: () => resetPage(context, SimpleLoan())
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget loanResultCard() {
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
          color: Colors.blueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Loan Type",
                  style: TextStyle(fontSize: responsiveWidth(14), ),
                ),
                Spacer(),
                Text(
                  loanType,
                  style: TextStyle(fontSize: responsiveWidth(14),),
                ),
              ],
            ),
            SizedBox(height: responsiveWidth(5),),
            Row(
              children: [
                Text(
                  "Loan Amount",
                  style: TextStyle(fontSize: responsiveWidth(14),),
                ),
                Spacer(),
                Text(
                  "${mortgageAmount.length == 0?0:mortgageAmount} \$",
                  style: TextStyle(fontSize: responsiveWidth(14),),
                ),
              ],
            ),
            SizedBox(height: responsiveWidth(5),),
            Row(
              children: [
                Text(
                  "Interest Rate",
                  style: TextStyle(fontSize: responsiveWidth(14), ),
                ),
                Spacer(),
                Text(
                  "${interestRate.length == 0?0:interestRate} %",
                  style: TextStyle(fontSize: responsiveWidth(14), ),
                ),
              ],
            ),
            SizedBox(height: responsiveWidth(5),),
            Row(
              children: [
                Text(
                  "Period",
                  style: TextStyle(fontSize: responsiveWidth(14),),
                ),
                Spacer(),
                Text(
                  "${period.length == 0?0:period } m",
                  style: TextStyle(fontSize: responsiveWidth(14), ),
                ),
              ],
            ),
            SizedBox(
              height: responsiveWidth(15),
              child: Divider(),
            ),
            Row(
              children: [
                Text(
                  "Total Cost",
                  style: TextStyle(fontSize: responsiveWidth(14), fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "${totalCostResult.toStringAsFixed(2)} \$",
                  style: TextStyle(fontSize: responsiveWidth(14), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: responsiveWidth(5),),
            Row(
              children: [
                Text(
                  loanType == 'Monthly Cost'?"Monthly Payment":"You Can Borrow",
                  style: TextStyle(fontSize: responsiveWidth(14), fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "${loanType == 'Monthly Cost'?monthlyPaymentResult.toStringAsFixed(2): youCouldBorrow.toStringAsFixed(2)} \$",
                  style: TextStyle(fontSize: responsiveWidth(14), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
