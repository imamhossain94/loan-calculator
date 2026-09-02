import 'dart:math';

import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/models/row_data.dart';

const List<String> kMonths = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class MortgageOutcome {
  const MortgageOutcome({
    required this.mortgageData,
    required this.resultData,
    required this.schedule,
  });

  final MortgageData mortgageData;
  final ResultData resultData;
  final List<RowData> schedule;
}

/// All currency in the app renders through the shared [money] formatter so
/// figures look identical wherever they appear.
String _fmt(double v) => money(v);

/// Loan amount implied by a home value and a deposit.
///
/// [downPayment] is read as a cash amount when [downPaymentIsCash] is true,
/// otherwise as a percentage of [homeValue].
double loanAmountFor({
  required double homeValue,
  required double downPayment,
  required bool downPaymentIsCash,
}) {
  final amount = downPaymentIsCash
      ? homeValue - downPayment
      : homeValue - (homeValue * downPayment / 100);
  return amount < 0 ? 0 : amount;
}

/// PMI applies while the deposit is under 20% of the property value.
bool pmiApplies({
  required double homeValue,
  required double downPayment,
  required bool downPaymentIsCash,
}) {
  if (homeValue <= 0 || downPayment <= 0) return false;
  final ratio = downPaymentIsCash ? downPayment / homeValue : downPayment / 100;
  return ratio < 0.2;
}

/// Builds the monthly amortization schedule and summary figures.
///
/// The bi-weekly figures reproduce the original app's model (including the
/// 21.105039 divisor and the term lookup below) so that results stay
/// consistent with calculations users saved in earlier versions.
MortgageOutcome calculateMortgage({
  required MortgageData input,
  required bool showPmi,
  DateTime? now,
}) {
  final start = now ?? DateTime.now();

  final homeValue = input.homeValue ?? 0;
  final loanAmount = input.loanAmount ?? 0;
  final loanTerm = input.loanTerm ?? 0;
  final homeIns = input.homeIns ?? 0;
  final interest = input.interest ?? 0;
  final propertyTax = input.propertyTax ?? 0;
  final pmi = input.pmi ?? 0;

  final schedule = <RowData>[];

  final totalPayments = loanTerm;
  final loanTermYear = loanTerm / 12;

  final biWeeklyTotalMonths = (loanTermYear <= 9)
      ? (totalPayments - 5)
      : (loanTermYear <= 14)
          ? (totalPayments - 12)
          : (loanTermYear <= 19)
              ? (totalPayments - 19)
              : (loanTermYear <= 29)
                  ? (totalPayments - 16)
                  : (loanTermYear <= 39)
                      ? (totalPayments - 39)
                      : (totalPayments - 83);
  final biWeeklyTotalPayments = loanTermYear * 26;

  final monthlyInterest = interest / 12;
  final biWeeklyMonthlyInterest = interest / 21.105039;

  final monthlyInstallment = (loanAmount <= 0 || totalPayments <= 0)
      ? 0.0
      : loanAmount *
          ((monthlyInterest / 100) /
              (1 - pow(1 + monthlyInterest / 100, -totalPayments)));
  final biWeeklyMonthlyInstallment =
      (loanAmount <= 0 || biWeeklyTotalPayments <= 0)
          ? 0.0
          : loanAmount *
              ((biWeeklyMonthlyInterest / 100) /
                  (1 -
                      pow(1 + biWeeklyMonthlyInterest / 100,
                          -biWeeklyTotalPayments)));

  final monthlyPropertyTax = propertyTax / 12;
  final monthlyPMI = (loanAmount * pmi) / 12 / 100;
  final bwMonthlyPMI = (loanAmount * pmi) / 26 / 100;
  final monthlyIns = homeIns / 12;

  var newMortgage = loanAmount;
  var bwNewMortgage = loanAmount;

  var yearlyInterest = 0.0;
  var yearlyPrincipal = 0.0;
  var monthlyPaymentTotal = 0.0;
  var totalPMI = 0.0;
  var totalInterest = 0.0;
  var bwTotalInterest = 0.0;

  var currentMonthId = start.month - 1;
  var currentMonth = kMonths[currentMonthId];
  var bwCurrentMonth = kMonths[currentMonthId];
  var currentYear = start.year;
  final bwCurrentYear = start.year;

  for (var i = 0; i < totalPayments; i++) {
    final currentInterest = newMortgage * monthlyInterest / 100;
    final bwCurrentInterest = bwNewMortgage * biWeeklyMonthlyInterest / 100;
    final currentPrincipal = monthlyInstallment - currentInterest;
    final bwCurrentPrincipal = biWeeklyMonthlyInstallment - bwCurrentInterest;
    final currentLTV = homeValue == 0 ? 0.0 : (newMortgage / homeValue) * 100;
    final bwCurrentLTV =
        homeValue == 0 ? 0.0 : (bwNewMortgage / homeValue) * 100;

    totalInterest += currentInterest;
    bwTotalInterest += bwCurrentInterest;
    newMortgage -= currentPrincipal;
    bwNewMortgage -= bwCurrentPrincipal;
    yearlyInterest += currentInterest;
    yearlyPrincipal += currentPrincipal;

    var currentPMI = 0.0;
    if (currentLTV >= 80) {
      currentPMI = monthlyPMI;
      totalPMI += currentPMI;
    }
    if (bwCurrentLTV >= 80) {
      // Bi-weekly PMI is tracked for parity with the original model.
      bwMonthlyPMI.toDouble();
    }

    monthlyPaymentTotal = currentInterest +
        currentPrincipal +
        currentPMI +
        monthlyPropertyTax +
        homeIns / 12;

    currentMonthId++;
    if (currentMonthId == 12) {
      currentMonthId = 0;
      currentYear++;
    }
    currentMonth = kMonths[currentMonthId];
    bwCurrentMonth = kMonths[currentMonthId];

    if (currentMonthId == 0) {
      schedule.add(RowData(
        (currentYear - 1).toString(),
        '\$${yearlyInterest.toStringAsFixed(0)}',
        '\$${yearlyPrincipal.toStringAsFixed(0)}',
        '\$${newMortgage.toStringAsFixed(0)}',
      ));
      yearlyInterest = 0;
      yearlyPrincipal = 0;
    }

    schedule.add(RowData(
      '$currentMonth $currentYear',
      '\$${currentInterest.toStringAsFixed(0)}',
      '\$${currentPrincipal.toStringAsFixed(0)}',
      '\$${newMortgage.toStringAsFixed(0)}',
    ));

    if (i == totalPayments - 1) {
      schedule.add(RowData(
        currentYear.toString(),
        '\$${yearlyInterest.toStringAsFixed(0)}',
        '\$${yearlyPrincipal.toStringAsFixed(0)}',
        '\$${newMortgage.toStringAsFixed(0)}',
      ));
    }
  }

  final bwLastMonthIndex =
      ((kMonths.indexOf(bwCurrentMonth) + biWeeklyTotalMonths % 12) % 12)
          .toInt();

  final resultData = ResultData(
    monthlyPayment: _fmt(monthlyPaymentTotal),
    biWeeklyPayment: _fmt(monthlyPaymentTotal / 2),
    lastPayment: '$currentMonth $currentYear',
    biWeeklyLastPayment:
        '${kMonths[bwLastMonthIndex.clamp(0, 11)]} ${bwCurrentYear + (biWeeklyTotalMonths / 12).floor()}',
    totalInterest: _fmt(totalInterest),
    biWeeklyTotalInterest: _fmt(bwTotalInterest),
    monthlyTax: _fmt(monthlyPropertyTax),
    monthlyIns: _fmt(monthlyIns),
    monthlyPmi: showPmi ? _fmt(monthlyPMI) : zeroMoney,
    totalPmi: showPmi ? _fmt(totalPMI) : zeroMoney,
  );

  return MortgageOutcome(
    mortgageData: input,
    resultData: resultData,
    schedule: schedule,
  );
}
