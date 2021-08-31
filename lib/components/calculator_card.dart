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
          borderRadius: BorderRadius.circular(responsiveWidth(8.0)),
          onTap: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width/2 - responsiveWidth(16),
            padding: EdgeInsets.all(responsiveWidth(8.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: responsiveWidth(40),
                    width: responsiveWidth(40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(responsiveWidth(8.0))),
                    child: FaIcon(
                      icon,
                      color: Colors.white,
                      size: responsiveWidth(18.0),
                    ),
                ),
                SizedBox(width: responsiveWidth(8.0),),
                Container(
                  width: MediaQuery.of(context).size.width/2 - responsiveWidth(91.3),
                  height: responsiveWidth(40),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveWidth(16.0),
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
      width: MediaQuery.of(context).size.width/2 - 16,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveWidth(8.0)),
        color: Colors.white,
      ),
    );
  }
}
