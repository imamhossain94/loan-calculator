import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/app_banner_ads.dart';
import 'package:loan_calculator/utils/themes_mode.dart';

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
              margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
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
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //AppBannerAds(),


                ],
              ),
            ),
           ),
        )
      )
    );
  }


}
