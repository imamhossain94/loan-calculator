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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loan_calculator/screens/home_screen.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/service/pref_service.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/themes.dart';
import 'package:loan_calculator/utils/themes_mode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'provider/theme_provider.dart';

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
  await PrefService().init();

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.white,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarColor: Colors.white,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // ));




  return runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier> (
          create: (_) {
            if(getAppPurchase()){
              String theme = getAPPTheme();
              if (theme == null || theme == "" || theme == systemDefault) {
                setAPPTheme(systemDefault);
                return ThemeNotifier(ThemeMode.system);
              }
              return ThemeNotifier(theme == dark ? ThemeMode.dark : ThemeMode.light);
            }else{
              setAPPTheme(light);
              return ThemeNotifier(ThemeMode.light);
            }
          },
        ),
      ],
      child: MyApp()//OurApp()//MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //closeHive();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemesMode().init(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: AppTheme().lightTheme(),
      darkTheme: AppTheme().darkTheme(),
      themeMode: themeNotifier.getThemeMode(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/home': (context) => HomePage(),
        '/result': (context) => ResultPage(),
        '/pdf': (context) => PdfPreviewPage(),
        '/history': (context) => HistoryPage(),
        '/help': (context) => HelpPage(),
        '/feedback': (context) => FeedbackPage(),
        '/about': (context) => AboutPage(),
      },
      // builder: (BuildContext context, Widget child) {
      //   return FlutterSmartDialog(child: child);
      // },
      debugShowCheckedModeBanner: false,
    );

  }


}

