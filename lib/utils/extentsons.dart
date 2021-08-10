import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/components/build_rating_view.dart';
import 'package:mortgage_calculator/pages/home_page.dart';


void resetHome(BuildContext context) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) => HomePage(),
    ),
  );
}

void showMessage(BuildContext context, String title, String message){
  Flushbar(
    flushbarPosition: FlushbarPosition.BOTTOM,
    borderRadius: 10,
    margin: EdgeInsets.all(10),
    title: title,
    message: message,
    duration: Duration(seconds: 3),
  )..show(context);
}

Future<bool> onRatingPressed(BuildContext context) async {
  return showDialog(
    barrierColor: Colors.white54,
    context: context,
    builder: (context) {
      return Center(
        child: Wrap(children: [
          Container(
            clipBehavior: Clip.none,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 3,
                      spreadRadius: 3,
                      offset: Offset.zero)
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Rate The App',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Audiowide',
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'If you like this app, please take a little bit of time to review it!\n'
                  'It really help us and it shouldn\'t take you more than one minute',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: null,
                    //fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BuildRatingValue(
                        value: 1,
                        color: Colors.red.withOpacity(1),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      BuildRatingValue(
                          value: 2, color: Colors.red.withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      BuildRatingValue(
                        value: 3,
                        color: Colors.red.withOpacity(0.7),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      BuildRatingValue(
                        value: 4,
                        color: Colors.green.withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      BuildRatingValue(
                        value: 5,
                        color: Colors.green.withOpacity(1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    },
  );
}

Future<bool> onBackPressed(BuildContext context) async {
  return showModalBottomSheet(
    backgroundColor: Colors.white54,
    barrierColor: Colors.white54,
    context: context,
    elevation: 0.0,
    builder: (context) {
      return Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
        decoration: BoxDecoration(
            color: Colors.white,
            //border: Border.all(width: 0.5, color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: Offset.zero)
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/ic_launcher.png',
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Mortgage Calculator',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Audiowide',
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Are you sure, You want to EXIT?',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      padding: EdgeInsets.zero,
                      color: Colors.blueAccent,
                      child: Text('No'),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      padding: EdgeInsets.zero,
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text('Yes'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<bool> onDeletePressed(BuildContext context) async {
  return showDialog(
    barrierColor: Colors.white54,
    context: context,
    builder: (context) {
      return Center(
        child: Wrap(children: [
          Container(
            clipBehavior: Clip.none,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
            decoration: BoxDecoration(
                color: Colors.white,
                //border: Border.all(width: 0.5, color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 3,
                      spreadRadius: 3,
                      offset: Offset.zero)
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.warning_rounded,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Clear All History',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Audiowide',
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Are you sure you want to clear all data?\nBe careful, the process cannot be undone.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          padding: EdgeInsets.zero,
                          color: Colors.blueAccent,
                          child: Text('No'),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          padding: EdgeInsets.zero,
                          color: Colors.redAccent,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 30, right: 30),
                            child: Text('Yes'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    },
  ).then((value) => value == null?false:value);

}



Future<bool> onSavePdf(BuildContext context) async {
  return showDialog(
    barrierColor: Colors.white54,
    context: context,
    builder: (context) {
      return Center(
        child: Wrap(children: [
          Container(
            clipBehavior: Clip.none,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
            decoration: BoxDecoration(
                color: Colors.white,
                //border: Border.all(width: 0.5, color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 3,
                      spreadRadius: 3,
                      offset: Offset.zero)
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.save,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Save Pdf',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Audiowide',
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'To generate pdf WAIT and WATCH',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            showMessage(context, "Operation Canceled", "You must WAIT and WATCH to generate pdf");
                          },
                          padding: EdgeInsets.zero,
                          color: Colors.blueAccent,
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          padding: EdgeInsets.zero,
                          color: Colors.redAccent,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 30, right: 30),
                            child: Text('Continue'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    },
  ).then((value) => value == null?false:value);

}
