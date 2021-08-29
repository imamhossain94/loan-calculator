import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildResultCard extends StatelessWidget {
  final String title, value;

  const BuildResultCard({
    @required this.title,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  offset: Offset.zero
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            Divider(thickness: 0.09,),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );

  }
}
