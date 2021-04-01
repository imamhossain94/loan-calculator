import 'package:flutter/material.dart';

class BuildQNA extends StatelessWidget {
  final String question, answer;
  const BuildQNA({
    @required this.question,
    @required this.answer,
  });

  @override
  Widget
  build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            answer,
            style: TextStyle(fontSize: 14,),
          ),
        ],
      ),
    );
  }
}

