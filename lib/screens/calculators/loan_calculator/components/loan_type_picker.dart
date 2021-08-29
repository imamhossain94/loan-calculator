import 'package:flutter/material.dart';

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

    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              //Spacer(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: 8, bottom: 5),
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
                  width: 10,
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
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 50,
            width: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(active ? 1 : 0.07),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: active ? Colors.white: Colors.black
                )
            )
          ),
        ),
      ),
    );
  }
}
