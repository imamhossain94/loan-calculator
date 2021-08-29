import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'app_bar_action_button.dart';

class CalculatorAppBar extends StatelessWidget {
  final String title;
  final VoidCallback saveButtonClick, historyButtonClick;
  const CalculatorAppBar({Key key, @required this.title,  @required this.saveButtonClick,  @required this.historyButtonClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 55,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
        child: Row(
          children: [
            AppBarActionButton(
                icon: FontAwesomeIcons.arrowLeft,
                onPressed: ()=> Navigator.pop(context),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            AppBarActionButton(
                icon: FontAwesomeIcons.solidSave,
                onPressed: saveButtonClick
            ),
            SizedBox(width: 5,),
            AppBarActionButton(
                icon: FontAwesomeIcons.history,
                onPressed: historyButtonClick
            )
          ],
        )
      );
  }
}
