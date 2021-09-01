import 'package:flutter/material.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class CalculatorActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CalculatorActionButton({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ScreenConfig().init(context);

    return Container(
      decoration: BoxDecoration(
        color: title == "Reset"? Colors.redAccent:Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          highlightColor: Colors.blueAccent,
          onTap: onPressed,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: responsiveWidth(4), horizontal: responsiveWidth(4)),
              height: responsiveWidth(40),
              width: responsiveWidth(55),
              alignment: Alignment.center,
              child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: responsiveWidth(14),
                      color: Colors.white
                  )
              )
          ),
        ),
      ),
    );
  }
}
