import 'package:flutter/material.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';

class BuildResultItem extends StatelessWidget {
  const BuildResultItem({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final title, value;

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Container(
      margin: EdgeInsets.all(2),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: responsiveText(14), color: Colors.black87),
          ),
          SizedBox(height: responsiveText(3),),
          Text(
            '$value',
            style: TextStyle(fontSize: responsiveText(18), color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
