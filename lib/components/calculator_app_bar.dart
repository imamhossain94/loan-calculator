import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'app_bar_action_button.dart';

class CalculatorAppBar extends StatelessWidget {
  final String title;
  final VoidCallback saveButtonClick, historyButtonClick, deleteButtonClick, shareButtonClick;
  const CalculatorAppBar({Key key, @required this.title,  @required this.saveButtonClick,  @required this.historyButtonClick, @required this.deleteButtonClick, @required this.shareButtonClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Container(
        height: 45,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
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
                    fontSize: responsiveWidth(17),
                    letterSpacing: responsiveWidth(1.5),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            if(saveButtonClick!=null)
            AppBarActionButton(
                icon: FontAwesomeIcons.solidSave,
                onPressed: saveButtonClick
            ),
            if(historyButtonClick!=null)
            SizedBox(width: responsiveWidth(5),),
            if(historyButtonClick!=null)
            AppBarActionButton(
                icon: FontAwesomeIcons.history,
                onPressed: historyButtonClick
            ),
            if(deleteButtonClick!=null)
            SizedBox(width: responsiveWidth(5),),
            if(deleteButtonClick!=null)
            AppBarActionButton(
                icon: FontAwesomeIcons.solidTrashAlt,
                onPressed: historyButtonClick
            ),
            if(shareButtonClick!=null)
            SizedBox(width: responsiveWidth(5),),
            if(shareButtonClick!=null)
            AppBarActionButton(
                icon: FontAwesomeIcons.shareAlt,
                onPressed: shareButtonClick
            ),
          ],
        )
      );
  }
}
