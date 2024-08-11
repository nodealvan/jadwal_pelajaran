class Schedule {
  String day;
  List<Subject> subjects;

  Schedule({required this.day, required this.subjects});

  @override
  String toString() => 'Jadwal: $day, Subjects: ${subjects.map((s) => '${s.subject} (${s.time})').join(', ')}';
}

class Subject {
  String subject;
  String time;

  Subject({required this.subject, required this.time});
}
