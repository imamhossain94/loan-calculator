import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildActionTextField extends StatelessWidget {
  final String title, hint, symbol;
  final TextEditingController textController;
  final VoidCallback onActionPressed;

  const BuildActionTextField({
    @required this.title,
    @required this.hint,
    @required this.textController,
    @required this.symbol,
    @required this.onActionPressed,});

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
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          enabled: true,
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
                    SizedBox(width: 5,),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          highlightColor: Colors.blueAccent,
                          onTap: onActionPressed,
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              height: 50,
                              width: 20,
                              alignment: Alignment.center,
                              child: Text(
                                  symbol,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                  )
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
