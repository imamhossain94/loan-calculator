import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 2,
            title: Text(
              'Feedback',
              style: TextStyle(
                  fontSize: responsiveText(22),
                  fontFamily: 'Audiowide',
                  color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Container(
            padding: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '◑︵◐',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 60, color: Colors.black),
                ),
                Text(
                  'Your rating is too low. '
                  'Please let us know how we can improve this app to meet your need.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: responsiveText(18),
                      //fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                CupertinoButton(
                  color: Colors.blueAccent.withOpacity(0.8),
                  onPressed: () async {
                    String url = dotenv.env['FEEDBACK_MAIL'];

                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text('Send Mail'),
                )
              ],
            ),
          )),
    );
  }
}
