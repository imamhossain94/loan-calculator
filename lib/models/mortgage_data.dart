import 'package:hive_ce/hive.dart';

part 'mortgage_data.g.dart';

@HiveType(typeId: 2)
class MortgageData {
  @HiveField(0)
  final double? homeValue;
  @HiveField(1)
  final double? downPayment;
  @HiveField(2)
  final double? loanAmount;
  @HiveField(3)
  final double? loanTerm;
  @HiveField(5)
  final double? homeIns;
  @HiveField(6)
  final double? interest;
  @HiveField(7)
  final double? propertyTax;
  @HiveField(8)
  final double? pmi;

  MortgageData({
    this.homeValue,
    this.downPayment,
    this.loanAmount,
    this.loanTerm,
    this.homeIns,
    this.interest,
    this.propertyTax,
    this.pmi,
  });

  MortgageData.fromJson(Map<String, dynamic> json)
      : homeValue = json['homeValue'],
        downPayment = json['downPayment'],
        loanAmount = json['loanAmount'],
        loanTerm = json['loanTerm'],
        homeIns = json['homeIns'],
        interest = json['interest'],
        propertyTax = json['propertyTax'],
        pmi = json['pmi'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'homeValue': homeValue,
      'downPayment': downPayment,
      'loanAmount': loanAmount,
      'loanTerm': loanTerm,
      'homeIns': homeIns,
      'interest': interest,
      'propertyTax': propertyTax,
      'pmi': pmi,
    };
  }
}
