import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:loan_calculator/hive_registrar.g.dart';
import 'package:loan_calculator/screens/calculators/advanced_loan_screen.dart';
import 'package:loan_calculator/screens/calculators/compare_loan_screen.dart';
import 'package:loan_calculator/screens/calculators/discount_screen.dart';
import 'package:loan_calculator/screens/calculators/savings_screen.dart';
import 'package:loan_calculator/screens/calculators/simple_loan_screen.dart';
import 'package:loan_calculator/screens/calculators/tax_screen.dart';
import 'package:loan_calculator/screens/calculators/tip_screen.dart';
import 'package:loan_calculator/screens/history_screen.dart';
import 'package:loan_calculator/screens/home_screen.dart';
import 'package:loan_calculator/screens/result_screen.dart';
import 'package:loan_calculator/screens/result_pdf_screen.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/utils/constant.dart';

/// Name of the Hive box holding saved calculations. Opened once at startup and
/// kept open for the process lifetime -- calling Hive.close() mid-session
/// clears Hive's home path and breaks every later openBox().
const String historyBox = 'history';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive lives in the app's own documents directory: no permission needed.
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox(historyBox);

  // Draw behind the status and navigation bars. From Android 15 the system
  // enforces edge-to-edge and ignores bar colours, so the app only declares
  // icon brightness (see AppTheme) and pads content with SafeArea.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Clear anything a previous session left in the share cache.
  ShareService.clearExports();

  runApp(const LoanCalculatorApp());
}

class LoanCalculatorApp extends StatelessWidget {
  const LoanCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        SimpleLoanScreen.route: (_) => const SimpleLoanScreen(),
        AdvancedLoanScreen.route: (_) => const AdvancedLoanScreen(),
        CompareLoanScreen.route: (_) => const CompareLoanScreen(),
        SavingsScreen.route: (_) => const SavingsScreen(),
        TaxScreen.route: (_) => const TaxScreen(),
        DiscountScreen.route: (_) => const DiscountScreen(),
        TipScreen.route: (_) => const TipScreen(),
        HistoryScreen.route: (_) => const HistoryScreen(),
        ResultScreen.route: (_) => const ResultScreen(),
        ResultPdfScreen.route: (_) => const ResultPdfScreen(),
      },
    );
  }
}
