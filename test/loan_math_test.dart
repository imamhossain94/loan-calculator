import 'package:flutter_test/flutter_test.dart';
import 'package:loan_calculator/domain/loan_math.dart';

void main() {
  group('monthlyPayment', () {
    test('matches the standard amortization formula', () {
      final p =
          monthlyPayment(principal: 250000, annualRate: 6.5, months: 360);
      expect(p, closeTo(1580.17, 0.01));
    });

    test('handles a zero interest rate as straight division', () {
      final p = monthlyPayment(principal: 1200, annualRate: 0, months: 12);
      expect(p, closeTo(100, 0.001));
    });

    test('returns 0 for a zero-length or zero-value loan', () {
      expect(monthlyPayment(principal: 0, annualRate: 5, months: 60), 0);
      expect(monthlyPayment(principal: 1000, annualRate: 5, months: 0), 0);
    });
  });

  group('affordablePrincipal', () {
    test('is the inverse of monthlyPayment', () {
      final principal = affordablePrincipal(
          payment: 1580.17, annualRate: 6.5, months: 360);
      expect(principal, closeTo(250000, 5));
    });
  });

  group('LoanComparison', () {
    test('ranks by total cost including up-front fees', () {
      final a = LoanOption(
          label: 'A', principal: 250000, annualRate: 6.5, months: 360);
      final b = LoanOption(
          label: 'B',
          principal: 250000,
          annualRate: 6.0,
          months: 360,
          fees: 4000);

      final c = LoanComparison.of([a, b]);
      expect(c.cheapest?.label, 'B');
      expect(c.lowestPaymentIndex, 1);
      expect(c.maxSaving, closeTo(25265.75, 1));
    });

    test('a large fee can outweigh a lower rate', () {
      final a = LoanOption(
          label: 'A', principal: 100000, annualRate: 5.0, months: 120);
      final b = LoanOption(
          label: 'B',
          principal: 100000,
          annualRate: 4.9,
          months: 120,
          fees: 20000);

      expect(LoanComparison.of([a, b]).cheapest?.label, 'A');
    });

    test('ignores incomplete offers', () {
      final blank =
          LoanOption(label: 'blank', principal: 0, annualRate: 0, months: 0);
      final real = LoanOption(
          label: 'real', principal: 1000, annualRate: 5, months: 12);
      expect(LoanComparison.of([blank, real]).cheapest?.label, 'real');
    });
  });

  group('everyday calculators', () {
    test('tip splits the total across people', () {
      final r =
          calculateTip(bill: 120, tipPercent: 15, taxPercent: 0, people: 4);
      expect(r.tip, closeTo(18, 0.001));
      expect(r.total, closeTo(138, 0.001));
      expect(r.perPerson, closeTo(34.5, 0.001));
    });

    test('tip with zero people does not divide by zero', () {
      final r =
          calculateTip(bill: 100, tipPercent: 10, taxPercent: 0, people: 0);
      expect(r.perPerson, 0);
      expect(r.total.isFinite, isTrue);
    });

    test('tax adds the rate to the price', () {
      final r = calculateTax(price: 200, ratePercent: 7.5);
      expect(r.tax, closeTo(15, 0.001));
      expect(r.total, closeTo(215, 0.001));
    });

    test('discount applies after tax', () {
      final r =
          calculateDiscount(price: 100, discountPercent: 20, taxPercent: 10);
      expect(r.taxAmount, closeTo(10, 0.001));
      expect(r.saved, closeTo(22, 0.001));
      expect(r.finalPrice, closeTo(88, 0.001));
    });

    test('savings grows the balance above what was contributed', () {
      final r = calculateSavings(
        principal: 1000,
        contribution: 100,
        annualRatePercent: 5,
        years: 10,
        contributionEveryDays: 30,
      );
      expect(r.totalContributed, greaterThan(1000));
      expect(r.futureValue, greaterThan(r.totalContributed));
      expect(r.interestEarned,
          closeTo(r.futureValue - r.totalContributed, 0.001));
    });

    test('savings with zero years returns the principal', () {
      final r = calculateSavings(
        principal: 500,
        contribution: 100,
        annualRatePercent: 5,
        years: 0,
        contributionEveryDays: 30,
      );
      expect(r.futureValue, 500);
      expect(r.interestEarned, 0);
    });
  });

  group('money', () {
    test('groups thousands and keeps two decimals', () {
      expect(money(1234.5), r'$1,234.50');
      expect(money(1000000), r'$1,000,000.00');
      expect(money(-42), r'-$42.00');
    });

    test('renders non-finite values as a dash', () {
      expect(money(double.infinity), '--');
      expect(money(double.nan), '--');
    });
  });
}
