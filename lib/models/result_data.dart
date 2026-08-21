import 'package:hive_ce/hive.dart';

part 'result_data.g.dart';

@HiveType(typeId: 3)
class ResultData {
  @HiveField(0)
  final String? monthlyPayment;
  @HiveField(1)
  final String? biWeeklyPayment;
  @HiveField(2)
  final String? lastPayment;
  @HiveField(3)
  final String? biWeeklyLastPayment;
  @HiveField(4)
  final String? totalInterest;
  @HiveField(5)
  final String? biWeeklyTotalInterest;
  @HiveField(6)
  final String? monthlyTax;
  @HiveField(7)
  final String? monthlyIns;
  @HiveField(8)
  final String? monthlyPmi;
  @HiveField(9)
  final String? totalPmi;

  ResultData({
    this.monthlyPayment,
    this.biWeeklyPayment,
    this.lastPayment,
    this.biWeeklyLastPayment,
    this.totalInterest,
    this.biWeeklyTotalInterest,
    this.monthlyTax,
    this.monthlyIns,
    this.monthlyPmi,
    this.totalPmi,
  });

  ResultData.fromJson(Map<String, dynamic> json)
      : monthlyPayment = json['monthlyPayment'],
        biWeeklyPayment = json['biWeeklyPayment'],
        lastPayment = json['lastPayment'],
        biWeeklyLastPayment = json['biWeeklyLastPayment'],
        totalInterest = json['totalInterest'],
        biWeeklyTotalInterest = json['biWeeklyTotalInterest'],
        monthlyTax = json['monthlyTax'],
        monthlyIns = json['monthlyIns'],
        monthlyPmi = json['monthlyPmi'],
        totalPmi = json['totalPmi'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'monthlyPayment': monthlyPayment,
      'biWeeklyPayment': biWeeklyPayment,
      'lastPayment': lastPayment,
      'biWeeklyLastPayment': biWeeklyLastPayment,
      'totalInterest': totalInterest,
      'biWeeklyTotalInterest': biWeeklyTotalInterest,
      'monthlyTax': monthlyTax,
      'monthlyIns': monthlyIns,
      'monthlyPmi': monthlyPmi,
      'totalPmi': totalPmi,
    };
  }
}
