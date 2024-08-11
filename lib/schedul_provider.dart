import 'package:flutter/material.dart';
import 'package:sekolah/schedul.dart';

class ScheduleProvider with ChangeNotifier {
  final List<Schedule> _schedules = [];
  DateTime _selectedDate = DateTime.now();

  List<Schedule> get schedules => _schedules;
  DateTime get selectedDate => _selectedDate;

  bool _isDayAlreadyScheduled(String day) {
    return _schedules.any((schedule) => schedule.day == day);
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addSchedule(Schedule schedule) {
    if (!_isDayAlreadyScheduled(schedule.day)) {
      _schedules.add(schedule);
      notifyListeners();
    } else {
      throw Exception('Jadwal sudah ada untuk hari ${schedule.day}');
    }
  }

  void updateSchedule(int index, Schedule schedule) {
    if (index >= 0 && index < _schedules.length) {
      _schedules[index] = schedule;
      notifyListeners();
    } else {
      throw Exception('Index jadwal tidak valid');
    }
  }

  void deleteSchedule(int index) {
    if (index >= 0 && index < _schedules.length) {
      _schedules.removeAt(index);
      notifyListeners();
    } else {
      throw Exception('Index jadwal tidak valid');
    }
  }
}
