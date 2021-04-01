import 'package:flutter/material.dart';

class BuildHelpButton extends StatefulWidget {
  const BuildHelpButton({
    Key key,
    @required GlobalKey<State<StatefulWidget>> toolTipKey,
    @required symbol,
    @required message,
    @required color,
    @required mode
  }) : _toolTipKey = toolTipKey,
  _symbol = symbol,
  _message = message,
  _color = color,
  _mode = mode,
  super(key: key);

  final GlobalKey<State<StatefulWidget>> _toolTipKey;
  final String _symbol, _message;
  final Color _color;
  final VoidCallback _mode;

  @override
  _BuildHelpButtonState createState() => _BuildHelpButtonState();
}

class _BuildHelpButtonState extends State<BuildHelpButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Tooltip(
        key: widget._toolTipKey,
        message: widget._message,
        child: Material(
          color: widget._color,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            splashColor: Colors.grey,
            child: Container(
              height: 20,
              width: 60,
              child: Center(
                  child: Text(
                    widget._symbol,
                  style: TextStyle(color: Colors.black),
                )),
            ),
            onTap: () {
              final dynamic tooltip = widget._toolTipKey.currentState;
              tooltip.ensureTooltipVisible();

              widget._mode();

            },
          ),
        ),
      ),
    );
  }
}
