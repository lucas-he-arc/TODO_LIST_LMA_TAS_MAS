import 'package:flutter/material.dart';
/*
* Author(s) : Lucas Martinez
*/

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class NotificationWeekAndTime {
  final DateTime date;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.date,
    required this.timeOfDay,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(
    BuildContext context,
    ) async {

  TimeOfDay? timeOfDay;
  DateTime? now = DateTime.now();
  int? selectedDay;

  DateTime? newDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(2010),
    lastDate: DateTime(2025),
  );

  if (newDate != null) {
    timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          now.add(
            Duration(minutes: 1),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.teal,
              ),
            ),
            child: child!,
          );
        });

    if (timeOfDay != null) {
      return NotificationWeekAndTime(
          date: newDate, timeOfDay: timeOfDay);
    }
  }
  return null;
}
