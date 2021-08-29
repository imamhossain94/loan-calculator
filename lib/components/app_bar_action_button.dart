import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const AppBarActionButton({Key key, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Material(
        child: new InkWell(
          highlightColor: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: FaIcon(
              icon,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
        color: Colors.transparent,
      ),
      height: 40,
      width: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
