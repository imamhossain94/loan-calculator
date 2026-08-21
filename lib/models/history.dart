import 'package:hive_ce/hive.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';

part 'history.g.dart';

@HiveType(typeId: 1)
class History {
  @HiveField(0)
  final MortgageData? mortgageData;
  @HiveField(1)
  final ResultData? resultData;
  @HiveField(2)
  final String? calculationDate;

  History({this.mortgageData, this.resultData, this.calculationDate});

  History.fromJson(Map<String, dynamic> json)
      : mortgageData = json['mortgageData'] != null
            ? MortgageData.fromJson(json['mortgageData'])
            : null,
        resultData = json['resultData'] != null
            ? ResultData.fromJson(json['resultData'])
            : null,
        calculationDate = json['calculationDate'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (mortgageData != null) {
      data['mortgageData'] = mortgageData!.toJson();
    }
    if (resultData != null) {
      data['resultData'] = resultData!.toJson();
    }
    data['calculationDate'] = calculationDate;
    return data;
  }
}
