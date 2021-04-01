import 'package:hive/hive.dart';

part 'mortgage_data.g.dart';

@HiveType(typeId: 2)
class MortgageData {
  @HiveField(0)
  final double homeValue;
  @HiveField(1)
  final double downPayment;
  @HiveField(2)
  final double loanAmount;
  @HiveField(3)
  final double loanTerm;
  @HiveField(5)
  final double homeIns;
  @HiveField(6)
  final double interest;
  @HiveField(7)
  final double propertyTax;
  @HiveField(8)
  final double pmi;

  MortgageData(
      {this.homeValue,
        this.downPayment,
        this.loanAmount,
        this.loanTerm,
        this.homeIns,
        this.interest,
        this.propertyTax,
        this.pmi});

  MortgageData.fromJson(Map<String, dynamic> json) :
    homeValue = json['homeValue'],
    downPayment = json['downPayment'],
    loanAmount = json['loanAmount'],
    loanTerm = json['loanTerm'],
    homeIns = json['homeIns'],
    interest = json['interest'],
    propertyTax = json['propertyTax'],
    pmi = json['pmi'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeValue'] = this.homeValue;
    data['downPayment'] = this.downPayment;
    data['loanAmount'] = this.loanAmount;
    data['loanTerm'] = this.loanTerm;
    data['homeIns'] = this.homeIns;
    data['interest'] = this.interest;
    data['propertyTax'] = this.propertyTax;
    data['pmi'] = this.pmi;
    return data;
  }
}