import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/pages/about_page.dart';
import 'package:loan_calculator/pages/feedback_page.dart';
import 'package:loan_calculator/pages/help_page.dart';
import 'package:loan_calculator/pages/history_page.dart';
import 'package:loan_calculator/pages/home_page.dart';
import 'package:loan_calculator/pages/pdf_preview_page.dart';
import 'package:loan_calculator/pages/result_page.dart';
import 'package:loan_calculator/pages/splash_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive..init(appDocDir.path)
    ..registerAdapter(HistoryAdapter())
    ..registerAdapter(MortgageDataAdapter())
    ..registerAdapter(ResultDataAdapter());

  //await Hive.openBox('history');
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  await GoogleAdService().init();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashPage(),
      '/home': (context) => HomePage(),
      '/result': (context) => ResultPage(),
      '/pdf': (context) => PdfPreviewPage(),
      '/history': (context) => HistoryPage(),
      '/help': (context) => HelpPage(),
      '/feedback': (context) => FeedbackPage(),
      '/about': (context) => AboutPage(),
    },
    debugShowCheckedModeBanner: false,
  ));

}


// void confirmPurchase() async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//  // bool isAdsPurchased = await SharedPreferences.getInstance().then((value) => value.getBool('ads_purchase_status') ?? false);
//   bool isAdsPurchased = prefs.getBool('ads_purchase_status') ?? false;
//   await prefs.setBool('ads_purchase_status', true);
// }


