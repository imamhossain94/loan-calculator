import 'package:flutter/material.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/build_text_field.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/calculator_action_button.dart';
import 'package:loan_calculator/utils/extentsons.dart';
import 'package:loan_calculator/utils/screen_config.dart';


class TaxCalculator extends StatefulWidget {
  static const String idScreen = "TaxCalculator";
  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> {


  TextEditingController taxRateController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();

  String taxRate = "", originalPrice = "";
  double tax, totalPrice;


  @override
  void initState() {
    tax = 0.0;
    totalPrice = 0.0;
    calculateDiscount();
    super.initState();
  }

  @override
  void dispose() {
    taxRateController.dispose();
    originalPriceController.dispose();
    super.dispose();
  }

  void calculateDiscount() {
    taxRateController.addListener(() {
      updateResult();
    });
    originalPriceController.addListener(() {
      updateResult();
    });
  }

  void updateResult() {
    taxRate = taxRateController.value.text;
    originalPrice = originalPriceController.value.text;
    //Make null safety
    setState(() {

      double _taxRate = double.tryParse(taxRate)??0.0;
      double _originalPrice = double.tryParse(originalPrice)??0.0;

      tax =  _originalPrice * (_taxRate/100);
      totalPrice = _originalPrice + tax;

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
              title: "Tax\nCalculator",
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

                    taxResultCard(),

                    BuildTextField(
                      title: 'Tax Rate',
                      hint: '0.0',
                      symbol: '%',
                      textController: taxRateController,
                    ),
                    BuildTextField(
                      title: 'Original Price',
                      hint: '0.0',
                      symbol: '\$',
                      textController: originalPriceController,
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
                                  onPressed: () => resetPage(context, TaxCalculator())
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

  Widget taxResultCard() {
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
            resultRow("Tax Rate", false, "${taxRate.length == 0?0:taxRate} %"),
            SizedBox(height: responsiveWidth(5),),
            resultRow("Original Price", false, "${originalPrice.length == 0?0:originalPrice} \$"),
            SizedBox(height: responsiveWidth(5),),
            SizedBox(
              height: responsiveWidth(14),
              child: Divider(),
            ),
            resultRow("Tax", true, "${tax.toStringAsFixed(2)} \$"),
            resultRow("Total Price", true, "${totalPrice.toStringAsFixed(2)} \$"),
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
