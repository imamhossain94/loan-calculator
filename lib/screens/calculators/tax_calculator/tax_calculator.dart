import 'package:flutter/material.dart';
import 'package:loan_calculator/utils/screen_config.dart';


class SalesTaxCalcPage extends StatefulWidget {
  @override
  _SalesTaxCalcPageState createState() => _SalesTaxCalcPageState();
}

class _SalesTaxCalcPageState extends State<SalesTaxCalcPage> {


  TextEditingController taxRateController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();

  String taxRate, originalPrice;
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
        appBar: AppBar(
          title: Text('Sales Tax Calculator',
            style: TextStyle(
                fontFamily: fontAudioWide,
                fontSize: responsiveWidth(18)
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await showInterstitialAd();
                resetPage(context, salesTaxCalcPage);
              },
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: ThemesMode.isDarkMode?Colors.black:textWhite,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                blurRadius: 0.5,
                                spreadRadius: 0.5,
                                offset: Offset.zero
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BuildTextField(
                            title: 'Tax Rate',
                            hint: '0.0',
                            isEnabled: true,
                            textController: taxRateController,
                            onPressedAction: null,
                            widget: Text('%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveText(16)),),),
                          BuildTextField(
                            title: 'Original Price',
                            hint: '0.0',
                            isEnabled: true,
                            textController: originalPriceController,
                            onPressedAction: null,
                            widget: Text('\$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsiveText(16)),),),

                        ],
                      ),
                    ),
                    //Result
                    Row(
                      children: [
                        BuildResultCard(title: 'Tax', value: tax.toStringAsFixed(2),),
                        BuildResultCard(title: 'Total Price', value: totalPrice.toStringAsFixed(2),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            BuildBannerAd(),
          ],
        ),
      ),
    );
  }



}
