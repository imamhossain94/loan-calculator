import 'package:flutter/material.dart';

class CalculatorActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CalculatorActionButton({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          highlightColor: title == "Reset"? Colors.redAccent:Colors.green,
          onTap: onPressed,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              height: 50,
              width: 55,
              alignment: Alignment.center,
              child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black
                  )
              )
          ),
        ),
      ),
    );
  }
}
