import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mortgage_calculator/utils/app_constants.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeData() async {}

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
              'About',
              style: TextStyle(
                  fontSize: responsiveText(22),
                  fontFamily: 'Audiowide',
                  color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 48,
                  child: Row(
                    // crossAxisAlignment : CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/ic_launcher.png',
                        height: responsiveHeight(55),
                        width: responsiveHeight(55),
                      ),
                      SizedBox(
                        width: responsiveHeight(10),
                      ),
                      Text(
                        'Mortgage\nCalculator',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Audiowide',
                          fontSize: responsiveText(24),
                          decoration: TextDecoration.none,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 41,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildHeader('Feature'),
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'The app can save your calculation history.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: responsiveText(14)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'The app can generate amortization schedule pdf.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: responsiveText(14)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              // Text(
                              //   'Mail Calculation Result.',
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(fontSize: 14),
                              // ),
                              // SizedBox(
                              //   height: 8,
                              // ),
                            ],
                          ),
                        ),
                        buildHeader('Development'),
                        buildDescription('Android Engineering', env['APP_DEVELOPER_NAME']),
                        buildDescription('UI Design', env['APP_UI_DESIGNER']),
                        //buildHeader('Reference'),
                        buildHeaderClickable('More App', () async{
                          String url = env['OTHER_APPS_LINK'];

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                        SizedBox(height: 5,),
                        //buildDescription('Other App', env['OTHER_APPS_LINK']),
                        //buildDescription('Operation Followed', env['APP_OPERATION_FOLLOWED']),
                        buildHeaderClickable('${AppConstants.appName}: ${env['APP_VERSION']}', () async{
                          String url = env['RATE_THE_APP_LINK'];

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                        //buildHeader('${AppConstants.appName}: ${env['APP_VERSION']}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Container buildHeader(String title) {
    return Container(
      height: responsiveHeight(50),
      color: Colors.grey.withOpacity(0.12),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: responsiveText(18), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container buildHeaderClickable(String title, VoidCallback onPressed) {
    return Container(
      height: responsiveHeight(50),
      color: Colors.grey.withOpacity(0.12),
      child: CupertinoButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
              fontSize: responsiveText(18), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildDescription(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          text: '$title: ',
          style: TextStyle(fontSize: responsiveText(14), color: Colors.black87, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            new TextSpan(text: description, style: TextStyle(fontSize: responsiveText(14), color: Colors.black87, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }


}


//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mortgage_calculator/utils/app_constants.dart';
// import 'package:mortgage_calculator/utils/screen_config.dart';
//
// class AboutPage extends StatefulWidget {
//   @override
//   _AboutPageState createState() => _AboutPageState();
// }
//
// class _AboutPageState extends State<AboutPage> {
//   @override
//   void initState() {
//     initializeData();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void initializeData() async {}
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenConfig().init(context);
//
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             centerTitle: true,
//             elevation: 2,
//             title: Text(
//               'About',
//               style: TextStyle(
//                   fontSize: responsiveText(22),
//                   fontFamily: 'Audiowide',
//                   color: Colors.black),
//             ),
//             backgroundColor: Colors.white,
//             iconTheme: IconThemeData(color: Colors.black),
//           ),
//           body: Container(
//             padding: EdgeInsets.only(top: 15),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   // crossAxisAlignment : CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image.asset(
//                       'assets/images/ic_launcher.png',
//                       height: 55,
//                       width: 55,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       'Mortgage\nCalculator',
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontFamily: 'Audiowide',
//                         fontSize: 24,
//                         decoration: TextDecoration.none,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                     child: Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.only(top: 15, bottom: 15),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.0),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child:
//
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.withOpacity(0.0),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: SingleChildScrollView(
//                           physics: BouncingScrollPhysics(),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               buildHeader('Feature'),
//                               Container(
//                                 padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'The app save your calculation history.',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     Text(
//                                       'The app can generate amortization schedule pdf.',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     Text(
//                                       'Mail Calculation Result.',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               buildHeader('Development'),
//                               buildDescription('Android Engineering', env['APP_DEVELOPER_NAME']),
//                               buildDescription('UI Design', env['APP_UI_DESIGNER']),
//                               buildHeader('Reference'),
//                               buildDescription('Developed By', env['APP_DEVELOPED_BY']),
//                               //buildDescription('Operation Followed', env['APP_OPERATION_FOLLOWED']),
//                               buildHeader('${AppConstants.appName}: ${env['APP_VERSION']}'),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
//
//   Container buildHeader(String title) {
//     return Container(
//       height: 50,
//       color: Colors.grey.withOpacity(0.5),
//       child: Center(
//         child: Text(
//           title,
//           style: TextStyle(
//               fontSize: responsiveText(18), fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDescription(String title, String description) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       alignment: Alignment.center,
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: new TextSpan(
//           text: '$title: ',
//           style: TextStyle(fontSize: responsiveText(14), color: Colors.black87, fontWeight: FontWeight.bold),
//           children: <TextSpan>[
//             new TextSpan(text: description, style: TextStyle(fontSize: responsiveText(14), color: Colors.black87, fontWeight: FontWeight.normal)),
//           ],
//         ),
//       ),
//     );
//   }
// }
