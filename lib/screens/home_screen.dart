import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/app_banner_ads.dart';
import 'package:loan_calculator/components/calculator_card.dart';
import 'package:loan_calculator/components/home_app_bar.dart';
import 'package:loan_calculator/screens/calculators/discount_calculator/discount_calculator.dart';
import 'package:loan_calculator/screens/calculators/savings_calculator/savings_calculator.dart';
import 'package:loan_calculator/screens/calculators/tax_calculator/tax_calculator.dart';
import 'package:loan_calculator/screens/calculators/tip_calculator/tip_calculator.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/extensions.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'calculators/loan_calculator/advanced_loan_calculator.dart';
import 'calculators/loan_calculator/simple_loan.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "HomeScreen";
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);


    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: HomeAppBar()
          ),
          body: Container(
            //alignment: Alignment.topCenter,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //AppBannerAds(),
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.home,
                                title: 'Simple Loan',
                                onPressed: ()=>Navigator.pushNamed(context, SimpleLoan.idScreen),
                                color: Color(0xff1f577d),
                              ),
                              SizedBox(width: 10.0,),
                              CalculatorCard(
                                icon: FontAwesomeIcons.handHoldingUsd,
                                title: 'Advanced Loan',
                                onPressed: ()=> Navigator.pushNamed(context, AdvancedLoanCalculator.idScreen),
                                color: Color(0xff1eb384),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.piggyBank,
                                title: 'Savings Calculator',
                                onPressed: ()=> Navigator.pushNamed(context, SavingsCalculator.idScreen),
                                color: Color(0xff1689FC),
                              ),
                              SizedBox(width: 10.0,),
                              CalculatorCard(
                                icon: FontAwesomeIcons.fileInvoiceDollar,
                                title: 'Tax Calculator',
                                onPressed: ()=> Navigator.pushNamed(context, TaxCalculator.idScreen),
                                color: Color(0xff01B4A9),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.tags,
                                title: 'Discount Calculator',
                                onPressed: ()=> Navigator.pushNamed(context, DiscountCalculator.idScreen),
                                color: Color(0xffFF758A),
                              ),
                              SizedBox(width: 10.0,),
                              CalculatorCard(
                                icon: FontAwesomeIcons.wallet,
                                title: 'Tip Calculator',
                                onPressed: ()=> Navigator.pushNamed(context, TipCalculator.idScreen),
                                color: Color(0xffC76CF8),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.notEqual,
                                title: 'Compare Loan',
                                onPressed: () {
                                  showMessage(context, "Compare Loan", "Coming soon...");
                                },
                                color: Color(0xff1689FC),
                              ),
                              SizedBox(width: 10.0,),
                              CalculatorCard(
                                icon: FontAwesomeIcons.solidImages,
                                title: 'Gallery',
                                onPressed: () {

                                },
                                color: Color(0xff1f577d),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30,
                          child: Divider(),
                        ),

                        // About section
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.comments,
                                title: 'Feedback',
                                onPressed: () async {
                                  String url = feedbackMail;

                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                color: Colors.indigo,
                              ),
                              SizedBox(width: 10.0,),
                              CalculatorCard(
                                icon: FontAwesomeIcons.solidStar,
                                title: 'Rate The App',
                                onPressed: () async => showRatingDialogue(context),
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.googlePlay,
                                title: 'Other Apps',
                                onPressed: () async {

                                  String url = storeLink;

                                  if (await canLaunch(url)) {
                                  await launch(url);
                                  } else {
                                  throw 'Could not launch $url';
                                  }

                                },
                                color: Colors.orange,
                              ),
                              SizedBox(width: 10.0,),
                              CalculatorCard(
                                icon: FontAwesomeIcons.freeCodeCamp,
                                title: 'About Development',
                                onPressed: () async => showDevelopmentDialogue(context),
                                color: Colors.pinkAccent,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              CalculatorCard(
                                icon: FontAwesomeIcons.codeBranch,
                                title: 'Version',
                                onPressed: () async {
                                  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
                                    String version = packageInfo.version;
                                    showMessage(context, "App Version", "Version $version");
                                  });
                                },
                                color: Colors.blueAccent,
                              ),

                            ],
                          ),
                        ),

                        //AppBannerAds()

                      ],
                    ),
                  ),
                ),
                AppBannerAds(),
              ],
            ),
           ),
        )
      )
    );
  }


}
