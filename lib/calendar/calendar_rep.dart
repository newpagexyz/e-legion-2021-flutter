import 'dart:convert';

import 'package:elegionhack/api_constants.dart';
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/auth/auth_rep.dart';
import 'package:elegionhack/calendar/calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarState {
  List<CalendarEvent> events;
  PageController? controller;

  String? selectedMonth;
  DateTime focusedDay;

  bool dialogOpened;

  final caption = TextEditingController();
  final description = TextEditingController();
  final dateStart = TextEditingController();
  final timeStart = TextEditingController();
  final dateFinish = TextEditingController();
  final timeFinish = TextEditingController();

  DateTime? selectedDay;

  void dispose() {
    caption.dispose();
    description.dispose();
    dateStart.dispose();
    timeStart.dispose();
    dateFinish.dispose();
    timeFinish.dispose();
  }

  CalendarState(
      {required this.events,
      this.controller,
      this.dialogOpened = false,
      this.selectedDay,
      this.selectedMonth,
      required this.focusedDay});
}

class CalendarNotifier extends ValueNotifier<CalendarState> {
  CalendarNotifier(this.ref)
      : super(CalendarState(events: const [], focusedDay: DateTime.now())) {
    load();
  }

  final ProviderRefBase ref;

  void toggle() {
    value.dialogOpened = !value.dialogOpened;
    notifyListeners();
  }

  void load() async {
    final client = ref.watch(httpClientRepository);
    final creds = ref.watch(authStateNotifierProvider);

    final response = await client.post(Uri.parse(CalendarApi.fetchCalendar),
        body: {'token': creds.credentials!.token});

    final json = jsonDecode(response.body.toString());

    final list = <CalendarEvent>[];

    for (var month in json['body']) {
      list.add(CalendarEvent.fromJson(month));
    }

    final redmineResponse = await client.post(
        Uri.parse(CalendarApi.fetchRedmineCalendar),
        body: {'token': creds.credentials!.token});

    final redmineJson = jsonDecode(redmineResponse.body.toString());

    for (var redmineEvent in redmineJson['body'].first) {
      list.add(CalendarEvent.fromJson(redmineEvent));
    }

    value.events = list;
    notifyListeners();
  }

  void save() async {
    final client = ref.watch(httpClientRepository);
    final creds = ref.watch(authStateNotifierProvider);

    final a = await client.post(Uri.parse(CalendarApi.addEvent), body: {
      'token': creds.credentials!.token,
      'description': value.description.text,
      'name': value.caption.text,
      'start_time': '${value.dateStart} ${value.timeStart}',
      'end_time': '${value.dateFinish} ${value.timeFinish}',
      'place': 'here',
      'type': '1'
    });
    value.caption.clear();
    value.dateFinish.clear();
    value.dateStart.clear();
    value.timeFinish.clear();
    value.timeStart.clear();
    value.description.clear();
  }

  void setMonth(DateTime month) {
    value.selectedMonth = DateFormat.MMMM('ru_RU').format(month);
    value.focusedDay = month;
    notifyListeners();
  }

  void selectDay(DateTime day) {
    value.selectedDay = day;
    notifyListeners();
  }

  void setController(PageController controller) {
    value.controller = controller;
  }

  void right() {
    value.controller?.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }

  void left() {
    value.controller?.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }
}

final calendarRepository = ChangeNotifierProvider.autoDispose<CalendarNotifier>(
    (ref) => CalendarNotifier(ref));
