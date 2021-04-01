import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_calculator/components/build_help_button.dart';


class BuildTextField extends StatefulWidget {
  final String title, hint, symbol;
  final double height;
  final TextInputType inputType;
  final TextEditingController textController;
  final VoidCallback onActionPress;

  const BuildTextField({
    @required this.title,
    @required this.hint,
    @required this.height,
    @required this.symbol,
    @required this.textController,
    this.onActionPress,
    this.inputType,
  })  :assert(title != null),
        assert(hint != null),
        assert(height != null),
        assert(symbol != null),
        assert(textController != null);

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {


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
                widget.onActionPress != null?
                '${widget.title} (${widget.symbol})':
                widget.title.contains('Tax')?
                widget.title:
                '${widget.title} (${widget.symbol})',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              //BuildHelpButton(toolTipKey: GlobalKey(), symbol: widget.symbol, message: widget.symbolMessage, color: Colors.black54,),
              //widget.validate?SizedBox():BuildHelpButton(toolTipKey: GlobalKey(), symbol: 'i', message: 'Invalid number', color: Colors.redAccent,),
              widget.onActionPress != null?BuildHelpButton(
                toolTipKey: GlobalKey(),
                symbol:  widget.symbol == '\$'? '%' : '\$',
                message: 'Invalid number',
                color: Colors.grey.withOpacity(0.3),
                mode: (){
                  widget.onActionPress();
                },
              ):SizedBox(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 5),
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: widget.textController,
              decoration: InputDecoration(
                prefix: SizedBox(
                  width: 20,
                ),
                border: InputBorder.none,
                hintText: widget.hint,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              obscureText: false,
            ),
          )
        ],
      ),
    );
  }
}
