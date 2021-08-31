import 'package:flutter/material.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class LoanTypePicker extends StatefulWidget {
  final String title;
  final ValueChanged<String> valueChanged;

  LoanTypePicker({
    @required this.title,
    @required this.valueChanged,
  });

  @override
  _LoanTypePickerState createState() => _LoanTypePickerState();
}

class _LoanTypePickerState extends State<LoanTypePicker> {
  bool isMonthlyCost, isMaximumLoan;

  @override
  void initState() {
    isMonthlyCost = true;
    isMaximumLoan = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    ScreenConfig().init(context);

    return Container(
      margin: EdgeInsets.fromLTRB(responsiveWidth(8.0), 0, responsiveWidth(8.0), 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: responsiveWidth(16), fontWeight: FontWeight.bold),
              ),
              //Spacer(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: responsiveWidth(8.0), bottom: responsiveWidth(5.0)),
            child: Row(
              children: [
                buildButton(
                  title: 'Monthly Cost',
                  onPressed: (){
                    setState(() {
                      isMonthlyCost = true;
                      isMaximumLoan = false;
                    });
                    widget.valueChanged('Monthly Cost');
                  },
                  active:isMonthlyCost,
                ),
                SizedBox(
                  width: responsiveWidth(8.0),
                ),
                buildButton(
                  title: 'Maximum Loan',
                  onPressed: (){
                    setState(() {
                      isMonthlyCost = false;
                      isMaximumLoan = true;
                    });
                    widget.valueChanged('Maximum Loan');
                  },
                  active:isMaximumLoan,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded buildButton({String title, VoidCallback onPressed, bool active}) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: responsiveWidth(2.0), horizontal: responsiveWidth(5.0)),
            height: responsiveWidth(40),
            width: responsiveWidth(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(active ? 1 : 0.07),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsiveWidth(16),
                  color: active ? Colors.white: Colors.black
                )
            )
          ),
        ),
      ),
    );
  }
}
