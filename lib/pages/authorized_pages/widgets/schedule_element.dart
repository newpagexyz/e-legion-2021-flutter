import 'package:elegionhack/calendar/calendar_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ScheduleElement extends StatefulWidget {
  const ScheduleElement({Key? key, required this.event}) : super(key: key);

  final CalendarEvent event;

  @override
  _ScheduleElementState createState() => _ScheduleElementState();
}

class _ScheduleElementState extends State<ScheduleElement> {
  final _controller = ExpandableController(initialExpanded: false);

  final _contentStyle = TextStyle(color: Colors.grey.shade600, fontSize: 12);

  Widget _contentColumn(bool collapsed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.event.name,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(widget.event.description, style: _contentStyle),
        ),
        if (!collapsed)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.event.place,
              style: _contentStyle,
            ),
          ),
      ],
    );
  }

  Color _mapEventTypeToColor(CalendarEvent event) {
    switch (event.type) {
      case CalendarEventType.deadline:
        return Colors.black;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _controller.toggle();
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                  '${widget.event.startDate.toString().substring(0, 5)} - ${widget.event.finishDate.toString().substring(0, 5)}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _mapEventTypeToColor(widget.event),
                ),
                height: 60,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: ExpandablePanel(
                    controller: _controller,
                    collapsed: _contentColumn(true),
                    expanded: _contentColumn(false),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
