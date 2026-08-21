import 'dart:math';

/// Pure calculation helpers. No Flutter, no I/O -- everything here is a
/// function of its inputs so the numbers can be unit-tested independently of
/// the screens.

/// Formats a number as a currency amount, e.g. 1234.5 -> "$1,234.50".
String money(double v, {String symbol = '\$', int decimals = 2}) {
  if (v.isNaN || v.isInfinite) return '--';
  final negative = v < 0;
  final s = v.abs().toStringAsFixed(decimals);
  final parts = s.split('.');
  final buf = StringBuffer();
  for (var i = 0; i < parts[0].length; i++) {
    if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
    buf.write(parts[0][i]);
  }
  final body = parts.length > 1 ? '$buf.${parts[1]}' : buf.toString();
  return '${negative ? '-' : ''}$symbol$body';
}

/// Canonical "no amount" string, used as the sentinel for a disabled figure.
final String zeroMoney = money(0);

String percent(double v, {int decimals = 2}) {
  if (v.isNaN || v.isInfinite) return '--';
  return '${v.toStringAsFixed(decimals)}%';
}

double _safe(double v) => (v.isNaN || v.isInfinite) ? 0 : v;

/// Standard amortized payment for [principal] at [annualRate]% over [months].
double monthlyPayment({
  required double principal,
  required double annualRate,
  required double months,
}) {
  if (principal <= 0 || months <= 0) return 0;
  final r = annualRate / 100 / 12;
  if (r == 0) return _safe(principal / months);
  return _safe(principal * (r / (1 - pow(1 + r, -months))));
}

/// Largest principal affordable at a given [payment].
double affordablePrincipal({
  required double payment,
  required double annualRate,
  required double months,
}) {
  if (payment <= 0 || months <= 0) return 0;
  final r = annualRate / 100 / 12;
  if (r == 0) return _safe(payment * months);
  return _safe(payment * ((1 - pow(1 + r, -months)) / r));
}

// ---------------------------------------------------------------------------
// Compare Loan
// ---------------------------------------------------------------------------

class LoanOption {
  const LoanOption({
    required this.label,
    required this.principal,
    required this.annualRate,
    required this.months,
    this.fees = 0,
  });

  final String label;
  final double principal;
  final double annualRate;
  final double months;

  /// Up-front fees / closing costs, added to the total cost of the loan.
  final double fees;

  double get payment =>
      monthlyPayment(principal: principal, annualRate: annualRate, months: months);

  double get totalPaid => _safe(payment * months);

  double get totalInterest => _safe(totalPaid - principal);

  /// Everything the borrower parts with: interest plus up-front fees.
  double get totalCost => _safe(totalInterest + fees);

  bool get isValid => principal > 0 && months > 0;
}

class LoanComparison {
  const LoanComparison({
    required this.options,
    required this.cheapestIndex,
    required this.lowestPaymentIndex,
  });

  final List<LoanOption> options;

  /// Index of the option with the lowest total cost (interest + fees).
  final int cheapestIndex;

  /// Index of the option with the lowest monthly payment.
  final int lowestPaymentIndex;

  LoanOption? get cheapest =>
      cheapestIndex >= 0 ? options[cheapestIndex] : null;

  /// How much the cheapest option saves against the most expensive one.
  double get maxSaving {
    final valid = options.where((o) => o.isValid).toList();
    if (valid.length < 2) return 0;
    final costs = valid.map((o) => o.totalCost).toList()..sort();
    return costs.last - costs.first;
  }

  static LoanComparison of(List<LoanOption> options) {
    var cheapest = -1;
    var lowestPayment = -1;
    for (var i = 0; i < options.length; i++) {
      if (!options[i].isValid) continue;
      if (cheapest < 0 || options[i].totalCost < options[cheapest].totalCost) {
        cheapest = i;
      }
      if (lowestPayment < 0 ||
          options[i].payment < options[lowestPayment].payment) {
        lowestPayment = i;
      }
    }
    return LoanComparison(
      options: options,
      cheapestIndex: cheapest,
      lowestPaymentIndex: lowestPayment,
    );
  }
}

// ---------------------------------------------------------------------------
// Simple calculators
// ---------------------------------------------------------------------------

class TipResult {
  const TipResult({
    required this.tip,
    required this.tax,
    required this.total,
    required this.perPerson,
  });
  final double tip, tax, total, perPerson;
}

TipResult calculateTip({
  required double bill,
  required double tipPercent,
  required double taxPercent,
  required int people,
}) {
  final tax = _safe(bill * taxPercent / 100);
  final tip = _safe(bill * tipPercent / 100);
  final total = _safe(bill + tax + tip);
  final perPerson = people > 0 ? _safe(total / people) : 0.0;
  return TipResult(tip: tip, tax: tax, total: total, perPerson: perPerson);
}

class TaxResult {
  const TaxResult({required this.tax, required this.total});
  final double tax, total;
}

TaxResult calculateTax({required double price, required double ratePercent}) {
  final tax = _safe(price * ratePercent / 100);
  return TaxResult(tax: tax, total: _safe(price + tax));
}

class DiscountResult {
  const DiscountResult({
    required this.saved,
    required this.finalPrice,
    required this.taxAmount,
  });
  final double saved, finalPrice, taxAmount;
}

DiscountResult calculateDiscount({
  required double price,
  required double discountPercent,
  required double taxPercent,
}) {
  final taxAmount = _safe(price * taxPercent / 100);
  final priceWithTax = price + taxAmount;
  final saved = _safe(priceWithTax * discountPercent / 100);
  return DiscountResult(
    saved: saved,
    finalPrice: _safe(priceWithTax - saved),
    taxAmount: taxAmount,
  );
}

class SavingsResult {
  const SavingsResult({
    required this.futureValue,
    required this.totalContributed,
    required this.interestEarned,
  });
  final double futureValue, totalContributed, interestEarned;
}

/// Compound growth of [principal] plus a recurring [contribution] made every
/// [contributionEveryDays] days, compounded daily for [years].
SavingsResult calculateSavings({
  required double principal,
  required double contribution,
  required double annualRatePercent,
  required int years,
  required int contributionEveryDays,
}) {
  if (years <= 0) {
    return SavingsResult(
      futureValue: principal,
      totalContributed: principal,
      interestEarned: 0,
    );
  }
  final dailyRate = annualRatePercent / 100 / 365;
  final days = 365 * years;
  var balance = principal;
  var contributed = principal;

  for (var day = 1; day <= days; day++) {
    balance += balance * dailyRate;
    if (contributionEveryDays > 0 && day % contributionEveryDays == 0) {
      balance += contribution;
      contributed += contribution;
    }
  }
  return SavingsResult(
    futureValue: _safe(balance),
    totalContributed: _safe(contributed),
    interestEarned: _safe(balance - contributed),
  );
}
