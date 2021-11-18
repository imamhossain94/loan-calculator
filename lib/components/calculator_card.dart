import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/utils/screen_config.dart';


class CalculatorCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const CalculatorCard({
    @required this.icon,
    @required this.title,
    @required this.color,
    @required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Container(
      child: new Material(
        child: new InkWell(
          highlightColor: Colors.blueAccent.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                    child: FaIcon(
                      icon,
                      color: Colors.white,
                      size: 18,
                    ),
                ),
                SizedBox(width: 8,),
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
      //height: 120,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
    );
  }
}
