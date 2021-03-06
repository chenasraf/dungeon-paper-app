import 'package:dungeon_paper/src/flutter_utils/input_formatters.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NumberController extends StatefulWidget {
  final num value;
  final VoidCallbackDelegate<num> onChange;
  final double height;
  final num min;
  final num max;
  final FormatType formatType;
  final bool autoFocus;
  final bool enabled;
  final InputDecoration decoration;

  const NumberController({
    Key key,
    @required this.value,
    @required this.onChange,
    this.height = 80,
    this.min = -double.infinity,
    this.max = double.infinity,
    this.formatType = FormatType.Integer,
    this.autoFocus = false,
    this.enabled = true,
    this.decoration,
  }) : super(key: key);

  @override
  _NumberControllerState createState() => _NumberControllerState();
}

class _NumberControllerState extends State<NumberController> {
  num get controlledStat => widget.formatType == FormatType.Decimal
      ? double.tryParse(_controller.value.text)
      : int.tryParse(_controller.value.text);
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value.toString());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NumberController oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            shape: CircleBorder(side: BorderSide.none),
            color: Colors.red[300],
            textColor: Colors.white,
            child: Icon(Icons.remove, size: 30),
            onPressed: widget.enabled == true
                ? () => _update(
                    controlledStat > widget.min
                        ? controlledStat - 1
                        : widget.min,
                    true)
                : null,
          ),
          Expanded(
            child: TextField(
              enabled: widget.enabled,
              onChanged: (val) {
                var intVal = widget.formatType == FormatType.Integer
                    ? int.tryParse(val)
                    : double.tryParse(val);
                _update(intVal);
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                BetweenValuesTextFormatter(
                  widget.min,
                  widget.max,
                  formatType: widget.formatType,
                ),
              ],
              decoration: (widget.decoration ?? InputDecoration()).copyWith(
                errorText: !_validate
                    ? widget.decoration.errorText ??
                        '${widget.min}-${widget.max}'
                    : null,
                labelStyle: TextStyle(
                  fontSize:
                      Get.theme.inputDecorationTheme.labelStyle.fontSize ??
                          Get.theme.textTheme.subtitle1.fontSize,
                ),
              ),
              controller: _controller,
              autofocus: widget.autoFocus,
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.left,
            ),
          ),
          RaisedButton(
            shape: CircleBorder(side: BorderSide.none),
            color: Colors.green[300],
            textColor: Colors.white,
            child: Icon(Icons.add, size: 30),
            onPressed: widget.enabled == true
                ? () => _update(
                      controlledStat < widget.max
                          ? controlledStat + 1
                          : widget.max,
                      true,
                    )
                : null,
          ),
        ],
      ),
    );
  }

  bool get _validate {
    num intVal = int.tryParse(_controller.text);
    if (widget.min > -double.infinity) {
      return intVal != null && intVal >= widget.min;
    }
    if (widget.max < double.infinity) {
      return intVal != null && intVal <= widget.max;
    }
    return true;
  }

  void _update(num val, [bool updateText = false]) {
    if (updateText) _controller.text = val.toString();
    if (widget.onChange != null) {
      widget.onChange(val);
    }
  }
}
