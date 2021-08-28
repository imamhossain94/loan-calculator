import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CalculatorCard extends StatelessWidget {

  final FaIcon icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onPressed;

  const CalculatorCard({
    @required this.icon,
    @required this.title,
    @required this.gradient,
    @required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    return

      Container(
        child: new Material(
          child: new InkWell(
            highlightColor: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8.0),
            onTap: onPressed,
            child: Container(
              width: MediaQuery.of(context).size.width/2 - 16,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(8.0)),
                      child: icon
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          color: Colors.transparent,
        ),
        height: 120,
        width: MediaQuery.of(context).size.width/2 - 16,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: gradient,
        ),
      );

  }
}
