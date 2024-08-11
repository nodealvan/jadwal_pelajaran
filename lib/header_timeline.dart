import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HeaderDateTimeline extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HeaderDateTimeline({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  _HeaderDateTimelineState createState() => _HeaderDateTimelineState();
}

class _HeaderDateTimelineState extends State<HeaderDateTimeline> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    tz.initializeTimeZones();
    _setCurrentDate();
    _scheduleMidnightUpdate();
  }

  void _setCurrentDate() {
    final jakartaTimeZone = tz.getLocation('Asia/Jakarta');
    final jakartaNow = tz.TZDateTime.now(jakartaTimeZone);
    setState(() {
      currentDate = jakartaNow.toLocal();
    });
  }

  void _scheduleMidnightUpdate() {
    final jakartaTimeZone = tz.getLocation('Asia/Jakarta');
    final jakartaNow = tz.TZDateTime.now(jakartaTimeZone);
    final midnight = tz.TZDateTime(jakartaTimeZone, jakartaNow.year, jakartaNow.month, jakartaNow.day + 1);
    final timeUntilMidnight = midnight.difference(jakartaNow);

    Timer(timeUntilMidnight, () {
      _setCurrentDate();
      _scheduleMidnightUpdate(); // Jadwalkan lagi untuk malam berikutnya
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                DateTime date = startDate.add(Duration(days: index));
                bool isToday = date.day == currentDate.day &&
                    date.month == currentDate.month &&
                    date.year == currentDate.year;

                return GestureDetector(
                  onTap: () => widget.onDateSelected(date),
                  child: Container(
                    width: 80,
                    height: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEEE', 'id_ID').format(date),
                          style: TextStyle(
                            color: isToday ? Colors.white: Colors.white54, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('d', 'id_ID').format(date),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('MMMM', 'id_ID').format(date),
                          style: const TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
