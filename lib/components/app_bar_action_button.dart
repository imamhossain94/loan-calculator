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
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: onPressed,
            child: Container(
              alignment: Alignment.center,
              child: FaIcon(
                icon,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
        )
    );

  }
}
