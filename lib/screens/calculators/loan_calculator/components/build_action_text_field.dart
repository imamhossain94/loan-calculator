import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loan_calculator/utils/screen_config.dart';

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
    ScreenConfig().init(context);

    return Container(
      margin: EdgeInsets.all(responsiveWidth(8)),
      height: responsiveWidth(50),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        margin: EdgeInsets.all(responsiveWidth(5)),
        padding: EdgeInsets.only(left: responsiveWidth(8),),
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
                    fontSize: responsiveWidth(14), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: responsiveWidth(8),),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: responsiveWidth(8)),
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
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            prefix: SizedBox(
                              width: responsiveWidth(8),
                            ),
                            border: InputBorder.none,
                            hintText: hint,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          obscureText: false,
                          style: TextStyle(fontSize: responsiveWidth(16), fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: responsiveWidth(5),),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, responsiveWidth(5), responsiveWidth(5), responsiveWidth(5)),
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
                              padding: EdgeInsets.symmetric(vertical: responsiveWidth(5), horizontal: responsiveWidth(5)),
                              height: responsiveWidth(30),
                              width: responsiveWidth(18),
                              alignment: Alignment.center,
                              child: Text(
                                  symbol,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: responsiveWidth(16),
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
