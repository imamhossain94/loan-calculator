import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/advanced_loan_calculator.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/calculation_history.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/calculation_result.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/calculation_result_pdf.dart';
import 'package:loan_calculator/screens/calculators/loan_calculator/simple_loan.dart';
import 'package:loan_calculator/screens/calculators/savings_calculator/savings_calculator.dart';
import 'package:loan_calculator/screens/calculators/tax_calculator/tax_calculator.dart';
import 'package:loan_calculator/screens/home_screen.dart';
import 'package:loan_calculator/service/google_ad_service.dart';
import 'package:loan_calculator/service/pref_service.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/themes.dart';
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
  await PrefService().init();


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: scaffoldBackgroundLight,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: scaffoldBackgroundLight,//appBarColorLight,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  // return runApp(MultiProvider(
  //     providers: [
  //
  //     ],
  //     child: MyApp()//OurApp()//MyApp(),
  // ));

  return runApp(MyApp());
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: AppTheme().lightTheme(),
      initialRoute: HomeScreen.idScreen,
      routes: {
        HomeScreen.idScreen: (context) => HomeScreen(),
        SimpleLoan.idScreen: (context) => SimpleLoan(),
        AdvancedLoanCalculator.idScreen: (context) => AdvancedLoanCalculator(),
        CalculationHistory.idScreen: (context) => CalculationHistory(),
        CalculationResult.idScreen: (context) => CalculationResult(),
        CalculationResultPreview.idScreen: (context) => CalculationResultPreview(),

        SavingsCalculator.idScreen: (context) => SavingsCalculator(),
        TaxCalculator.idScreen: (context) => TaxCalculator(),


      },
      // builder: (BuildContext context, Widget child) {
      //   return FlutterSmartDialog(child: child);
      // },
      debugShowCheckedModeBanner: false,
    );

  }


}

