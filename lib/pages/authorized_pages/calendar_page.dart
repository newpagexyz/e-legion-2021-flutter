import 'package:elegionhack/calendar/calendar_model.dart';
import 'package:elegionhack/calendar/calendar_rep.dart';
import 'package:elegionhack/colors.dart';
import 'package:elegionhack/pages/authorized_pages/widgets/schedule_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreen createState() => _CreateEventScreen();
}

class _CreateEventScreen extends State<CreateEventScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> animation;

  InputDecoration _decoration(
    String caption,
  ) {
    return InputDecoration(
      filled: true,
      hintText: caption,
      isDense: true,
      isCollapsed: true,
      contentPadding: const EdgeInsets.fromLTRB(7, 10, 6, 10),
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    Tween<Offset> tween =
        Tween(begin: const Offset(0, -2), end: const Offset(0, 0.01));
    animation = tween.animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.listen<CalendarNotifier>(calendarRepository, (value) {
        if (value.value.dialogOpened) {
          controller.forward();
        } else {
          controller.reverse();
        }
      });
      final state = ref.watch(calendarRepository).value;
      return SlideTransition(
        position: animation,
        child: PhysicalModel(
            color: Colors.white,
            elevation: 16,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 420,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text('Добавить задачу'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(children: [
                        TextField(
                          controller: state.caption,
                          decoration: _decoration('Название'),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: state.description,
                          decoration: _decoration('Описание'),
                        ),
                        const Text('Назначить руководителя'),
                        const Text('Назначить ответственного'),
                        Row(children: [
                          const Expanded(child: Text('Дата начала')),
                          Expanded(
                              child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if (picked != null) {
                                      ref
                                              .read(calendarRepository)
                                              .value
                                              .dateStart
                                              .text =
                                          picked
                                              .toIso8601String()
                                              .substring(0, 10);
                                    }
                                  },
                                  controller: state.dateStart,
                                  decoration: _decoration('')))
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          const Expanded(child: Text('Время начала')),
                          Expanded(
                              child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());
                                    if (picked != null) {
                                      ref
                                          .read(calendarRepository)
                                          .value
                                          .timeStart
                                          .text = picked.format(context);
                                    }
                                  },
                                  controller: state.timeStart,
                                  decoration: _decoration('')))
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          const Expanded(child: Text('Дата окончания')),
                          Expanded(
                              child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if (picked != null) {
                                      ref
                                              .read(calendarRepository)
                                              .value
                                              .dateFinish
                                              .text =
                                          picked
                                              .toIso8601String()
                                              .substring(0, 10);
                                    }
                                  },
                                  controller: state.dateFinish,
                                  decoration: _decoration('')))
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          const Expanded(child: Text('Время окончания')),
                          Expanded(
                              child: TextField(
                                  readOnly: true,
                                  onTap: () async {
                                    final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());
                                    if (picked != null) {
                                      ref
                                          .read(calendarRepository)
                                          .value
                                          .timeFinish
                                          .text = picked.format(context);
                                      //'${picked.hour}:${picked.minute}';
                                    }
                                  },
                                  controller: state.timeFinish,
                                  decoration: _decoration('')))
                        ])
                      ]),
                    ),
                    const Divider(color: Colors.grey),
                    MaterialButton(
                      onPressed: () {
                        ref.read(calendarRepository).save();
                      },
                      child: Row(
                        children: const [
                          Text('Добавить задачу'),
                        ],
                      ),
                    )
                  ],
                ))),
      );
    });
  }
}

class CalendarPage extends ConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarRepository).value;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: ELegionColors.eLegionLightBlue,
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref.watch(calendarRepository).toggle();
                })
          ],
          title: const Text('Календарь', style: TextStyle(color: Colors.black)),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  PhysicalModel(
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.black.withAlpha(120),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              ref.read(calendarRepository).left();
                            },
                            icon: const Icon(CupertinoIcons.arrow_left,
                                color: Colors.grey)),
                        const Spacer(),
                        Text(state.selectedMonth ?? ''),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            CupertinoIcons.calendar,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              ref.read(calendarRepository).right();
                            },
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
                          return state.events
                              .where((e) =>
                                  day.day == e.startDate.day &&
                                  day.month == e.startDate.month)
                              .toList();
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
                                        color: ELegionColors.eLegionLightBlue),
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
                                              : const SizedBox(
                                                  width: 7, height: 7),
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
                                              : const SizedBox(
                                                  width: 7, height: 7),
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
                                                            BorderRadius
                                                                .circular(12)),
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
                                                            BorderRadius
                                                                .circular(12)),
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
                          ref.read(calendarRepository).selectDay(selectedDay);
                        },
                        daysOfWeekHeight: 24,
                        selectedDayPredicate: (day) =>
                            state.selectedDay?.day == day.day &&
                            state.selectedDay?.month == day.month &&
                            state.selectedDay?.year == day.year,
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          cellMargin: EdgeInsets.zero,
                          isTodayHighlighted: false,
                          rowDecoration: BoxDecoration(
                              border: Border(
                                  top:
                                      BorderSide(color: Colors.grey.shade300))),
                        ),
                        onPageChanged: (e) {
                          ref.read(calendarRepository).setMonth(e);
                        },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        locale: 'ru_RU',
                        onCalendarCreated: (controller) => ref
                            .read(calendarRepository)
                            .setController(controller),
                        focusedDay: state.focusedDay //state.selectedDay,
                        ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          border: Border(
                              top: BorderSide(color: Colors.grey.shade200))),
                      child: state.events
                              .where((element) =>
                                  element.startDate.day ==
                                  state.selectedDay?.day)
                              .isNotEmpty
                          ? ListView(
                              children: state.events
                                  .where((element) =>
                                      element.startDate.day ==
                                      state.selectedDay?.day)
                                  .map((e) => ScheduleElement(event: e))
                                  .toList())
                          : Center(
                              child: Column(
                              children: const [
                                Spacer(flex: 2),
                                Flexible(
                                    flex: 2,
                                    child:
                                        Text('В этот день у вас нет событий.')),
                                Spacer(
                                  flex: 3,
                                )
                              ],
                            )),
                    ),
                  )
                ],
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: CreateEventScreen(),
            )
          ],
        ));
  }
}
