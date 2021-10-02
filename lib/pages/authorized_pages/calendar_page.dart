import 'package:elegionhack/calendar/calendar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  void _prevPage() {}
  void _nextPage() {}

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverAppBar(
        pinned: true,
        title: Text('Календарь'),
      ),
      SliverAppBar(
          pinned: true,
          flexibleSpace: Column(
            children: [
              PhysicalModel(
                color: Colors.white,
                elevation: 2,
                shadowColor: Colors.black.withAlpha(120),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: _prevPage,
                        icon: const Icon(CupertinoIcons.arrow_left,
                            color: Colors.grey)),
                    const Spacer(),
                    const Text(
                      'Сентябрь',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        CupertinoIcons.calendar,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: _nextPage,
                        icon: const Icon(CupertinoIcons.arrow_right,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: TableCalendar<CalendarEvent>(
                    firstDay: DateTime(2010),
                    lastDay: DateTime(2050),
                    eventLoader: (day) {
                      return [];
                    },
                    headerVisible: false,
                    rowHeight: 48,
                    holidayPredicate: (day) {
                      return (day.weekday == DateTime.sunday);
                    },
                    calendarBuilders: CalendarBuilders(
                      holidayBuilder: (context, day, focusedDay) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                day.day.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                padding: day.day < 10
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2.5)
                                    : const EdgeInsets.symmetric(
                                        vertical: 2.5, horizontal: 3.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  day.day.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                day.day.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                      markerBuilder: (context, day, events) {
                        final types = events.map((event) => event.type);
                        final containsViolet =
                            types.contains(CalendarEventType.deadline);
                        final containsDarkBlue =
                            types.contains(CalendarEventType.meeting);
                        final containsRed =
                            types.contains(CalendarEventType.next);
                        final containsOrange =
                            types.contains(CalendarEventType.prev);
                        if (events.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                                width: 14,
                                height: 14,
                                child: Column(
                                  children: [
                                    Row(children: [
                                      containsViolet
                                          ? Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            )
                                          : const SizedBox(width: 7, height: 7),
                                      containsDarkBlue
                                          ? Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            )
                                          : const SizedBox(width: 7, height: 7),
                                    ]),
                                    Row(
                                      children: [
                                        containsRed
                                            ? Container(
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              )
                                            : const SizedBox(
                                                width: 7, height: 7),
                                        containsOrange
                                            ? Container(
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              )
                                            : const SizedBox(
                                                width: 7, height: 7),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        }
                      },
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      // context.read<SchedulerCubit>().selectDay(selectedDay);
                    },
                    daysOfWeekHeight: 24,
                    // selectedDayPredicate: (day) =>
                    //     state.selectedDay.day == day.day &&
                    //     state.selectedDay.month == day.month &&
                    //     state.selectedDay.year == day.year,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      cellMargin: EdgeInsets.zero,
                      isTodayHighlighted: false,
                      rowDecoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey.shade300))),
                    ),
                    // onCalendarCreated: (controller) => _controller = controller,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    focusedDay: DateTime.now() //state.selectedDay,
                    ),
              ),
            ],
          ))
    ]);
  }
}
