import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
            elevation: 0.0,
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    "Loan\nCalculator",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),


                ],
              ),
            ),
            actions: [
              Container(
                //height: 40,
                width: 40,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
              )
            ],
          ),


        )
      )
    );
  }
}
