import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriorityWidget extends StatefulWidget {
  int priority;
  Request? request;
  bool readOnly;
  Color fillColor;

  PriorityWidget(this.priority,
      {Key? key,
      this.request,
      this.readOnly = false,
      this.fillColor = Colors.white})
      : super(key: key);

  @override
  _PriorityWidgetState createState() => _PriorityWidgetState();
}

class _PriorityWidgetState extends State<PriorityWidget> {
  List<Color> colors = [
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.redAccent
  ];
  List<String> values = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    if (widget.request == null) {
      widget.request = Provider.of<Request>(context);
    }
    return GestureDetector(
      onTap: () {
        if (!widget.readOnly) {
          widget.request?.setPriority(widget.priority);
        }
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const SizedBox(
                width: 15,
                height: 15,
              ),
              decoration: BoxDecoration(
                  color: colors[widget.priority],
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(7.5))),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                values[widget.priority],
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.fillColor,
          border: Border.all(
              color: widget.request?.priority == widget.priority
                  ? Colors.black
                  : kBorderColor,
              width: widget.request?.priority == widget.priority ? 2 : 1),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
