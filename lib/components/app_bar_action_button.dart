import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const AppBarActionButton({Key key, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Container(
      child: new Material(
        child: new InkWell(
          highlightColor: Colors.blueAccent,
          borderRadius: BorderRadius.circular(responsiveWidth(8.0)),
          onTap: onPressed,
          child: Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(responsiveWidth(8.0)),
            alignment: Alignment.center,
            child: FaIcon(
              icon,
              size: responsiveWidth(18),
              color: Colors.black,
            ),
          ),
        ),
        color: Colors.transparent,
      ),
      height: 40,
      width: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: responsiveWidth(8.0), horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveWidth(8.0)),
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
