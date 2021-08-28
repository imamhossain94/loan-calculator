import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/app_banner_ads.dart';

class HomeScreen extends StatefulWidget {
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
        Navigator.of(context).pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    "Loan\nCalculator",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                //height: 40,
                width: 50,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: IconButton(
                    onPressed: () async {

                    },
                    icon: FaIcon(
                      FontAwesomeIcons.cog,
                      color: Theme.of(context).textTheme.headline1.color,
                    )),
              ),
              Container(
                //height: 40,
                width: 50,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: IconButton(
                    onPressed: () async {

                    },
                    icon: FaIcon(
                      FontAwesomeIcons.shareAlt,
                      color: Theme.of(context).textTheme.headline1.color,
                    )),
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //AppBannerAds(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width/2 - 15,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  // Colors.red,
                                  // Colors.blue,
                                  Color(0xffF96CD3),
                                  Color(0xffC76CF8),
                                ]
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(8.0)),
                                child: FaIcon(
                                  FontAwesomeIcons.home,
                                  color: Color(0xffF96CD3),
                                ),
                              ),
                              Text(
                                "Simple Loan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width/2 - 15,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  // Colors.red,
                                  // Colors.blue,
                                  Color(0xff00EFFB),
                                  Color(0xff42B1FF),
                                ]
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(8.0)),
                                child: FaIcon(
                                  FontAwesomeIcons.handHoldingUsd,
                                  color: Color(0xff42B1FF),
                                ),
                              ),
                              Text(
                                "Advanced Loan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width/2 - 15,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  // Colors.red,
                                  // Colors.blue,
                                  Color(0xff00E5A7),
                                  Color(0xff8BE454),
                                ]
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(8.0)),
                                child: FaIcon(
                                  FontAwesomeIcons.piggyBank,
                                  color: Color(0xff00E5A7),
                                ),
                              ),
                              Text(
                                "Savings Calculator",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width/2 - 15,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  // Colors.red,
                                  // Colors.blue,
                                  Color(0xffFF7BB0),
                                  Color(0xffFF758A),
                                ]
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(8.0)),
                                child: FaIcon(
                                  FontAwesomeIcons.fileInvoiceDollar,
                                  color: Color(0xffFF758A),
                                ),
                              ),
                              Text(
                                "Tax Calculator",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           ),
        )
      )
    );
  }


}
