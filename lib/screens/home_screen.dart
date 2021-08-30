import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/app_banner_ads.dart';
import 'package:loan_calculator/components/calculator_card.dart';
import 'package:loan_calculator/components/home_app_bar.dart';

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
  Widget build(BuildContext context) {
    //ThemesMode().init(context);


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
                          icon: FaIcon(
                            FontAwesomeIcons.home,
                            color: Colors.white,
                          ),
                          title: 'Simple Loan',
                          onPressed: ()=>Navigator.pushNamed(context, SimpleLoan.idScreen),
                          color: Color(0xff1f577d),
                        ),
                        SizedBox(width: 10.0,),
                        CalculatorCard(
                          icon: FaIcon(
                            FontAwesomeIcons.handHoldingUsd,
                            color: Colors.white,
                          ),
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
                          icon: FaIcon(
                            FontAwesomeIcons.piggyBank,
                            color: Colors.white,
                          ),
                          title: 'Savings Calculator',
                          onPressed: () {  },
                          color: Color(0xff1689FC),
                        ),
                        SizedBox(width: 10.0,),
                        CalculatorCard(
                          icon: FaIcon(
                            FontAwesomeIcons.fileInvoiceDollar,
                            color: Colors.white,
                          ),
                          title: 'Tax Calculator',
                          onPressed: () {  },
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
                          icon: FaIcon(
                            FontAwesomeIcons.tags,
                            color: Colors.white,
                          ),
                          title: 'Discount Calculator',
                          onPressed: () {  },
                          color: Color(0xffFF758A),
                        ),
                        SizedBox(width: 10.0,),
                        CalculatorCard(
                          icon: FaIcon(
                            FontAwesomeIcons.wallet,
                            color: Colors.white,
                          ),
                          title: 'Tip Calculator',
                          onPressed: () {  },
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
                          icon: FaIcon(
                            FontAwesomeIcons.balanceScale,
                            color: Colors.white,
                          ),
                          title: 'Unit Price Calculator',
                          onPressed: () {  },
                          color: Color(0xff055f90),
                        ),
                        SizedBox(width: 10.0,),
                        CalculatorCard(
                          icon: FaIcon(
                            FontAwesomeIcons.notEqual,
                            color: Colors.white,
                          ),
                          title: 'Compare Loan',
                          onPressed: () {  },
                          color: Color(0xff1689FC),
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
                          icon: FaIcon(
                            FontAwesomeIcons.comments,
                            color: Colors.white,
                          ),
                          title: 'Feedback',
                          onPressed: () {  },
                          color: Colors.indigo,
                        ),
                        SizedBox(width: 10.0,),
                        CalculatorCard(
                          icon: FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: Colors.white,
                          ),
                          title: 'Rate The App',
                          onPressed: () {  },
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
                          icon: FaIcon(
                            FontAwesomeIcons.googlePlay,
                            color: Colors.white,
                          ),
                          title: 'Other Apps',
                          onPressed: () {  },
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10.0,),
                        CalculatorCard(
                          icon: FaIcon(
                            FontAwesomeIcons.freeCodeCamp,
                            color: Colors.white,
                          ),
                          title: 'About Development',
                          onPressed: () {  },
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
                          icon: FaIcon(
                            FontAwesomeIcons.codeBranch,
                            color: Colors.white,
                          ),
                          title: 'Version',
                          onPressed: () {  },
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
        )
      )
    );
  }


}
