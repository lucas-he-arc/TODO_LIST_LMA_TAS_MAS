
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'utilities.dart';

/*
* Author(s) : Lucas Martinez
*/

  Future<void> createReminderNotification(
      NotificationWeekAndTime notificationSchedule) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        icon: "resource://drawable/google_keep_logo",
        channelKey: 'basic_channel',
        title: 'Rappel pour ta todo',
        body: 'N\'oublies toi de traiter cette Todo !',
        notificationLayout: NotificationLayout.Messaging,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
      schedule: NotificationCalendar(
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }
