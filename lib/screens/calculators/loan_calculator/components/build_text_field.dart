import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final String title, hint;
  final TextEditingController textController;
  final VoidCallback onPressedAction;
  final bool isEnabled;
  final Widget widget;

  const BuildTextField(
      {@required this.title,
      @required this.hint,
      @required this.widget,
      @required this.textController,
      @required this.onPressedAction,
      @required this.isEnabled});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(8),
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.only(left: 10,),
        //height: 44,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    enabled: isEnabled,
                    controller: textController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      prefix: SizedBox(
                        width: 10,
                      ),
                      border: InputBorder.none,
                      hintText: hint,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    obscureText: false,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      )
    );
  }
}
