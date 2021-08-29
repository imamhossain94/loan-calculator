import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CalculatorCard extends StatelessWidget {

  final FaIcon icon;
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
    return Container(
      child: new Material(
        child: new InkWell(
          highlightColor: Colors.blueAccent.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8.0),
          onTap: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width/2 - 16,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.0)),
                    child: icon
                ),
                SizedBox(width: 8,),
                Container(
                  width: MediaQuery.of(context).size.width/2 - 90,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
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
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
    );
  }
}
