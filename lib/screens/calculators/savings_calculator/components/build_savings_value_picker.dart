import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavingsFrequencyPicker extends StatelessWidget {
  final String title, frequencyName;
  final VoidCallback onPressedAction;

  const SavingsFrequencyPicker({
    @required this.title,
    @required this.frequencyName,
    @required this.onPressedAction,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              //Spacer(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: 8, bottom: 5),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        //margin: EdgeInsets.only(top: responsiveHeight(8), bottom: responsiveHeight(5)),
                        height: 40,
                        //alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: onPressedAction,
                            child: Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  frequencyName,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ))),
                SizedBox(
                  width: 10,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: onPressedAction,
                    child: Container(
                      height: 40,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
