import 'package:hive/hive.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';

part 'history.g.dart';

@HiveType(typeId: 1)
class History {
  @HiveField(0)
  final MortgageData mortgageData;
  @HiveField(1)
  final ResultData resultData;
  @HiveField(2)
  final String calculationDate;

  History({this.mortgageData, this.resultData, this.calculationDate});

  History.fromJson(Map<String, dynamic> json):
    mortgageData = json['mortgageData'] != null
        ? new MortgageData.fromJson(json['mortgageData'])
        : null,
    resultData = json['resultData'] != null
        ? new ResultData.fromJson(json['resultData'])
        : null,
    calculationDate = json['calculationDate'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mortgageData != null) {
      data['mortgageData'] = this.mortgageData.toJson();
    }
    if (this.resultData != null) {
      data['resultData'] = this.resultData.toJson();
    }
    data['calculationDate'] = this.calculationDate;
    return data;
  }
}