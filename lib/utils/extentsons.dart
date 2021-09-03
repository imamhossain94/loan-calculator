import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/components/calculator_action_button.dart';
import 'package:loan_calculator/service/pref_service.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant.dart';

void resetPage(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) => widget,
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

Future<String> createPath(String subPath) async{

  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  String path;
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    if(int.tryParse(release) >= 10){
      path = "/storage/emulated/0/Download/LoanCalculator$subPath";
    }else{
      path = "/sdcard/download/LoanCalculator$subPath";
    }
  }

  final directory = Directory(path);

  if (!await directory.exists()){
    directory.create();
  }

  return path;
}

Future<bool> showRatingDialogue(BuildContext context) async {
  return showDialog(
    //barrierColor: Colors.white54,
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Wrap(children: [
          Container(
            clipBehavior: Clip.none,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset.zero)
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Rate The App',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsiveWidth(18),
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: ()=> Navigator.pop(context),
                        child: Container(
                          height: responsiveWidth(30),
                          width: responsiveWidth(30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: FaIcon(FontAwesomeIcons.times, color: Colors.grey[500],),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: responsiveWidth(10),
                ),
                SizedBox(
                  height: responsiveWidth(40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ratingStar(context:context,
                        value: 1,
                        color: Colors.red.withOpacity(1),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ratingStar(context:context,
                        value: 2, color: Colors.red.withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ratingStar(context:context,
                        value: 3,
                        color: Colors.red.withOpacity(0.7),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ratingStar(context:context,
                        value: 4,
                        color: Colors.green.withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ratingStar(context:context,
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

Widget ratingStar({BuildContext context, int value, Color color}) {

  return Expanded(
    child: CupertinoButton(
      onPressed: () async {
        if (value <= 3) {
          Navigator.pop(context);
          showMessage(context, "Rate The App", "Thank you");
        } else if (value <= 5) {
          Navigator.pop(context);

          String url = appLink;

          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }

        }
      },
      padding: EdgeInsets.zero,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
          padding: EdgeInsets.all(responsiveWidth(5)),
          child:
          FaIcon(FontAwesomeIcons.solidStar, color: color, size: responsiveWidth(16),)
      ),
    ),
  );
}

Future<bool> showDevelopmentDialogue(BuildContext context) async {

  ScreenConfig().init(context);

  return showDialog(
    //barrierColor: Colors.white54,
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Wrap(children: [
          Container(
            clipBehavior: Clip.none,
            margin: EdgeInsets.all(responsiveWidth(8.0)),
            padding: EdgeInsets.fromLTRB(responsiveWidth(14.0), responsiveWidth(8.0), responsiveWidth(14.0), responsiveWidth(14.0)),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset.zero)
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'About Development',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: responsiveWidth(16),
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: ()=> Navigator.pop(context),
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: FaIcon(FontAwesomeIcons.times, color: Colors.grey[500],),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        'App Developer:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: responsiveWidth(14),
                          color: Colors.black54,
                        ),
                      ),
                      Spacer(),
                      Text(
                        developerName,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                        fontSize: responsiveWidth(12),
                        color: Colors.black54,
                      ),)
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Text('Designer Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: responsiveWidth(14),
                      color: Colors.black54,
                      )),
                      Spacer(),
                      Text(designerName,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: responsiveWidth(12),
                          color: Colors.black54,))
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Text('App Icon:', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: responsiveWidth(14),
                        color: Colors.black54,),),
                      Spacer(),
                      Text("fontawesome.com,\nflaticon.com",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: responsiveWidth(12),
                          color: Colors.black54,))
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


Future<dynamic> showCapturedWidget(BuildContext context, Uint8List capturedImage, String subPath) {
  return showDialog(
    useSafeArea: true,
    context: context,
    builder: (context) => Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CalculatorAppBar(
            title: "Save\nResult",
            historyButtonClick: null,
            saveButtonClick: null,
            deleteButtonClick: null,
            shareButtonClick: null,
          )
      ),
      body: Column(
        children: [
          SizedBox(height: responsiveWidth(14),),
          capturedImage != null ? Image.memory(capturedImage) : Container(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: responsiveWidth(12), horizontal: responsiveWidth(8)),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: CalculatorActionButton(
                        title: "Save",
                        onPressed: () async{


                          String path = await createPath('/$subPath');
                          String imagePath = '$path/${subPath}_${getCounterWithPrefix()}.png';

                          File imageFile = File(imagePath);
                          if(! await imageFile.exists()){
                            imageFile.create(recursive: true);
                          }
                          imageFile.writeAsBytes(capturedImage);

                          setCounter(getCounter() + 1);

                        }
                    )
                ),
                SizedBox(width: responsiveWidth(8),),
                Expanded(
                    flex: 1,
                    child: CalculatorActionButton(
                        title: "Cancel",
                        onPressed: () => Navigator.pop(context)
                    )
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
