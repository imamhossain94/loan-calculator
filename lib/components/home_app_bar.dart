import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/screen_config.dart';
import 'package:share/share.dart';

import 'app_bar_action_button.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return
      Container(
        height: 45,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Loan\nCalculator",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            // AppBarActionButton(
            //     icon: FontAwesomeIcons.cog,
            //     onPressed: () {
            //
            //     }
            // ),
            // SizedBox(width: 5,),
            AppBarActionButton(
                icon: FontAwesomeIcons.shareAlt,
                onPressed: () {
                  Share.share('Hey check out this android app $appLink');
                }
            )
          ],
        )
      );
  }

}
