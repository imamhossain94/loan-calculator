import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class BuildSlider extends StatefulWidget {
  final String title;
  final double width, height, max, min, value;
  final ValueChanged<double> rate;
  final bool numberResult;
  const BuildSlider({
    @required this.title,
    @required this.height,
    @required this.min,
    @required this.max,
    @required this.rate,
    @required this.numberResult,
    @required this.value,
    this.width,
  })  :assert(height != null);

  @override
  _BuildSliderState createState() => _BuildSliderState();
}

class _BuildSliderState extends State<BuildSlider> {
  double _value;

  @override
  void initState(){
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              //BuildHelpButton(toolTipKey: GlobalKey(), symbol: '%', message: 'US dollar sign', color: Colors.black54,),
            ],
          ),
          Container(
            height: widget.height,
            margin: EdgeInsets.only(top: 8, bottom: 5),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  widget.numberResult || _value == 0 || _value == 100 ?'${_value.toInt()}':
                  '${_value.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Slider(
                    max: widget.max,
                    min: widget.min,
                    value: _value,
                    activeColor: Colors.black87,
                    inactiveColor: Colors.black38,
                    onChanged: (double newValue) {
                      setState(() {
                        _value = newValue;
                      });
                      widget.rate(_value);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
