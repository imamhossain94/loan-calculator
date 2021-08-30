import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class BuildHistoryCard extends StatelessWidget {
  final History history;
  final VoidCallback onEdit, onDelete;
  const BuildHistoryCard({
    @required this.history,
    @required this.onEdit,
    @required this.onDelete,
  }) : assert(history != null);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  history.calculationDate,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveText(16),
                      color: Colors.black.withOpacity(0.8)),
                ),
                Spacer(),
                SizedBox(
                  height: responsiveText(25),
                  width: responsiveText(40),
                  child: CupertinoButton(
                    onPressed: () {
                      onEdit();
                    },
                    padding: EdgeInsets.zero,
                    color: Colors.blueAccent,
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: responsiveText(18),
                    ),
                  ),
                ),
                SizedBox(
                  width: responsiveText(8),
                ),
                SizedBox(
                  height: responsiveText(25),
                  width: responsiveText(40),
                  child: CupertinoButton(
                    onPressed: () {
                      onDelete();
                    },
                    padding: EdgeInsets.zero,
                    color: Colors.redAccent,
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: responsiveText(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),

          Container(
            color: Colors.blueAccent.withOpacity(0.3),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      BuildHistoryResultItem(
                        title: 'Home Value (\$)',
                        value: history.mortgageData.homeValue,
                      ),
                      Divider(color: Colors.black12),
                      BuildHistoryResultItem(
                        title: 'Loan Amount  (\$)',
                        value: history.mortgageData.loanAmount,
                      ),
                      Divider(color: Colors.black12),
                      BuildHistoryResultItem(
                        title: 'Loan Term (years)',
                        value: history.mortgageData.loanTerm,
                      ),
                      Divider(color: Colors.black12),
                      BuildHistoryResultItem(
                        title: 'Insurance (\$)',
                        value: history.mortgageData.homeIns,
                      ),
                    ],
                  ),
                ),
                //Container(height: 100, child: VerticalDivider(color: Colors.white54)),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      BuildHistoryResultItem(
                        title: 'Money Down/Equity (${history.mortgageData.loanAmount == 0? '%': '\$'})',
                        value: history.mortgageData.downPayment,
                      ),
                      Divider(color: Colors.black12),
                      BuildHistoryResultItem(
                        title: 'Interest Rate (%)',
                        value: history.mortgageData.interest,
                      ),
                      Divider(color: Colors.black12),
                      BuildHistoryResultItem(
                        title: 'Tax (per year)',
                        value: history.mortgageData.propertyTax,
                      ),
                      Divider(color: Colors.black12),
                      BuildHistoryResultItem(
                        title: 'PMI (%)',
                        value: history.mortgageData.pmi,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class BuildHistoryResultItem extends StatelessWidget {
  const BuildHistoryResultItem({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final title, value;

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Container(
      margin: EdgeInsets.all(2),
      child: Column(
        children: [
          Text(
            title,
            style:
                TextStyle(fontSize: responsiveText(12), color: Colors.black87),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            '$value',
            style:
                TextStyle(fontSize: responsiveText(14), color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
