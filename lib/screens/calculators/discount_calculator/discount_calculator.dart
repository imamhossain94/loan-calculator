import 'package:flutter/material.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/calculator_action_button.dart';
import 'package:loan_calculator/utils/extentsons.dart';
import 'package:loan_calculator/utils/screen_config.dart';


class DiscountCalculator extends StatefulWidget {
  static const String idScreen = "DiscountCalculator";
  @override
  _DiscountCalculatorState createState() => _DiscountCalculatorState();
}

class _DiscountCalculatorState extends State<DiscountCalculator> {

  TextEditingController originalAmountController = TextEditingController();
  TextEditingController addedTaxController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController();

  String originalAmount, addedTax, discountPercentage;
  double amountSaved, finalPrice;

  @override
  void initState() {
    amountSaved = 0.0;
    finalPrice = 0.0;
    calculateDiscount();
    super.initState();
  }

  @override
  void dispose() {
    originalAmountController.dispose();
    addedTaxController.dispose();
    discountPercentageController.dispose();
    super.dispose();
  }

  void calculateDiscount() {
    originalAmountController.addListener(() {
      updateResult();
    });
    addedTaxController.addListener(() {
      updateResult();
    });
    discountPercentageController.addListener(() {
      updateResult();
    });

  }

  void updateResult() {
    originalAmount = originalAmountController.value.text;
    addedTax = addedTaxController.value.text;
    discountPercentage = discountPercentageController.value.text;
    //Make null safety
    setState(() {

      double _originalAmount = double.tryParse(originalAmount)??0.0;
      double _addedTax = double.tryParse(addedTax)??0.0;
      double _discountPercentage = double.tryParse(discountPercentage)??0.0;


      amountSaved = ((_originalAmount * _addedTax / 100) +_originalAmount) * ((_discountPercentage /100));
      finalPrice = ((_originalAmount * (_addedTax / 100)) + _originalAmount) - amountSaved;
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
              title: "Discount\nCalculator",
              historyButtonClick: null,
              saveButtonClick: () {  },
              deleteButtonClick: null,
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

                    discountResultCard(),

                    BuildTextField(
                      title: 'Original Price',
                      hint: '0.0',
                      symbol: '\$',
                      textController: originalAmountController,
                    ),

                    BuildTextField(
                      title: 'Added Tax',
                      hint: '0.0',
                      symbol: '%',
                      textController: addedTaxController,
                    ),

                    BuildTextField(
                      title: 'Discount Percentage',
                      hint: '0.0',
                      symbol: '%',
                      textController: discountPercentageController,
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
                                  onPressed: () => resetPage(context, DiscountCalculator())
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
          color: Colors.blueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            resultRow("Original Price", false, "${originalAmount.length == 0?0:originalAmount} \$"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Added Tax", false, "${addedTax.length == 0?0:addedTax} %"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Discount Percentage", false, "${discountPercentage.length == 0?0:discountPercentage} %"),
            SizedBox(height: responsiveWidth(5),),
            SizedBox(
              height: responsiveWidth(14),
              child: Divider(),
            ),
            resultRow("Amount Saved", true, "${amountSaved.toStringAsFixed(2)} \$"),
            resultRow("Final Price", true, "${finalPrice.toStringAsFixed(2)} \$"),
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
          style: TextStyle(fontSize: responsiveWidth(12), fontWeight: result?FontWeight.bold:null),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: responsiveWidth(12), fontWeight: result?FontWeight.bold:null),
        ),
      ],
    );
  }
}
