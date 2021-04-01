import 'package:flutter/material.dart';
import 'package:mortgage_calculator/models/row_data.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';

class BuildTableHeader extends StatelessWidget {

  final double textSize;
  final FontWeight fontWeight;
  final Color textColor, backgroundColor;
  final EdgeInsetsGeometry padding;
  const BuildTableHeader({
    Key key,
    @required this.textSize,
    @required this.textColor,
    @required this.backgroundColor,
    @required this.padding,
    @required this.fontWeight,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Payment',
              textAlign: TextAlign.start,
               style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Interest',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Principal',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Balance',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
        ],
      ),
    );
  }
}


class BuildTableRow extends StatelessWidget {

  final double textSize;
  final FontWeight fontWeight;
  final Color textColor, backgroundColor;
  final EdgeInsetsGeometry padding;
  final RowData rowData;
  const BuildTableRow({
    Key key,
    @required this.textSize,
    @required this.textColor,
    @required this.backgroundColor,
    @required this.padding,
    @required this.fontWeight,
    @required this.rowData,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              rowData.payment,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              rowData.interest,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              rowData.principal,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              rowData.balance,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: responsiveText(textSize), color: textColor, fontWeight: fontWeight),
            ),
          ),
        ],
      ),
    );
  }
}
