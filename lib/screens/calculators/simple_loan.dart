import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import 'loan_calculator/components/build_result_card.dart';
import 'loan_calculator/components/loan_type_picker.dart';



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

  String mortgageAmount, monthlyPayment, interestRate, period, mortgageType;
  double totalCostResult, monthlyPaymentResult, youCouldBorrow;


  @override
  void initState() {
    totalCostResult = 0.0;
    monthlyPaymentResult = 0.0;
    youCouldBorrow = 0.0;
    mortgageType = 'Monthly Cost';
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
      months = months * 12;

      double monthlyTop = _interestRate * pow((1 + _interestRate), months);
      double monthlyBottom = pow(1 + _interestRate, months) - 1;

      if(mortgageType == 'Monthly Cost'){

        double monthlyRate = _mortgageAmount * (monthlyTop / monthlyBottom);
        double totalPayment = monthlyRate * months;
        //result
        totalCostResult = totalPayment;
        monthlyPaymentResult = monthlyRate;

      }else if(mortgageType == 'Maximum Loan'){

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


    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
            child: CalculatorAppBar(
              title: "Simple\nLoan",
              historyButtonClick: () {  },
              saveButtonClick: () {  },
            )
        ),
        body: Column(
          children: [
            SizedBox(height: 15,),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    LoanTypePicker(
                      title: 'Loan Type',
                      valueChanged: (String value) {
                        setState(() {
                          print(value);
                          mortgageType = value;
                          updateResult();
                        });
                      },
                    ),

                    resultCard(),


                    Container(
                      // margin: EdgeInsets.all(10),
                      // padding: EdgeInsets.all(5),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(5),
                      //     boxShadow: [
                      //       BoxShadow(
                      //           color: Colors.grey.withOpacity(0.9),
                      //           blurRadius: 0.5,
                      //           spreadRadius: 0.5,
                      //           offset: Offset.zero
                      //       )
                      //     ]
                      // ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // LoanTypePicker(
                          //   title: 'Mortgage Type',
                          //   valueChanged: (String value) {
                          //     setState(() {
                          //       print(value);
                          //       mortgageType = value;
                          //       updateResult();
                          //     });
                          //   },
                          // ),
                          BuildTextField(
                            title: mortgageType == 'Monthly Cost'?'Mortgage Amount (\$)':'Monthly Payment (\$)',
                            hint: '0.0',
                            isEnabled: true,
                            textController: mortgageType == 'Monthly Cost'?mortgageAmountController:monthlyPaymentController,
                            onPressedAction: null,
                            widget: Text('\$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: (16)),),),
                          BuildTextField(
                            title: 'Interest Rate',
                            hint: '0.0',
                            isEnabled: true,
                            textController: interestRateController,
                            onPressedAction: null,
                            widget: Text('%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: (16)),),),

                          BuildTextField(
                            title: 'Period',
                            hint: '0',
                            isEnabled: true,
                            textController: periodController,
                            onPressedAction: null,
                            widget: Text('yrs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: (16)),),),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        BuildResultCard(title: 'Total Cost', value: totalCostResult.toStringAsFixed(2),),
                        mortgageType == 'Monthly Cost'?
                        BuildResultCard(title: 'Monthly Payments', value: monthlyPaymentResult.toStringAsFixed(2),):
                        BuildResultCard(title: 'You Could Borrow', value: youCouldBorrow.toStringAsFixed(2),),
                      ],
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



  Widget resultCard() {

    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Loan Type",
                style: TextStyle(
                    fontSize: 16, ),
              ),
              Spacer(),
              Text(
                "Monthly Cost",
                style: TextStyle(
                    fontSize: 16,),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(
                "Loan Amount",
                style: TextStyle(
                    fontSize: 16,),
              ),
              Spacer(),
              Text(
                "5000 \$",
                style: TextStyle(
                    fontSize: 16,),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(
                "Interest Rate",
                style: TextStyle(
                    fontSize: 16, ),
              ),
              Spacer(),
              Text(
                "5 %",
                style: TextStyle(
                    fontSize: 16, ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(
                "Period",
                style: TextStyle(
                    fontSize: 16,),
              ),
              Spacer(),
              Text(
                "12 years",
                style: TextStyle(
                    fontSize: 16, ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
            child: Divider(),
          ),
          Row(
            children: [
              Text(
                "Total Cost",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                "500 \$",
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(
                "Monthly Payment",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                "100 \$",
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );

  }




}
