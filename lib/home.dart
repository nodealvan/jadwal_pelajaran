import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sekolah/header_timeline.dart';
import 'package:sekolah/schedul.dart';
import 'package:sekolah/schedul_provider.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context);
    DateTime selectedDate = provider.selectedDate;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.cyan,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Calender',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              HeaderDateTimeline(
                selectedDate: selectedDate,
                onDateSelected: (DateTime date) {
                  provider.setSelectedDate(date);
                },
              ),
              const SizedBox(
                height: 70,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = provider.schedules[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _getDayImage(schedule.day)
                                .image, // Ambil image dari Image widget
                            fit: BoxFit
                                .cover, // Sesuaikan gambar agar cover seluruh area
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.6), // Untuk memberikan efek gelap pada background
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                schedule.day,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: schedule.subjects
                                    .map((subject) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            '${subject.subject} (${subject.time})',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    onPressed: () => _showEditDialog(
                                        context, index, schedule),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        provider.deleteSchedule(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Positioned(
            top: 125,
            left: MediaQuery.of(context).size.width / 7 - 25,
            child: Row(
              children: [
                const Text('Jadwal pelajaran'),
                const SizedBox(
                  width: 100,
                ),
                GestureDetector(
                    onTap: () => _showAddDialog(context),
                    child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Buat jadwal',
                              style: TextStyle(color: Colors.white),
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Image _getDayImage(String day) {
    switch (day) {
      case 'Senin':
        return Image.asset('assets/1.jpg');
      case 'Selasa':
        return Image.asset('assets/2.jpg');
      case 'Rabu':
        return Image.asset('assets/4.jpg');
      case 'Kamis':
        return Image.asset('assets/3.jpg');
      case 'Jumat':
        return Image.asset('assets/5.jpg');
      case 'Sabtu':
        return Image.asset('assets/6.jpg');
      default:
        return Image.asset('assets/7.jpg');
    }
  }

  void _showAddDialog(BuildContext context) {
    final provider = Provider.of<ScheduleProvider>(context, listen: false);
    final dayController = TextEditingController();
    final subjectControllers = <TextEditingController>[];
    final timeControllers = <TextEditingController>[];

    showDialog(
      
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white12,
          insetAnimationCurve: Curves.bounceIn,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20.0),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: ['Senin', 'Selasa', 'Rabu'].map((day) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dayController.text = day;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: dayController.text == day
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: dayController.text == day
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: ['Kamis', 'Jumat', 'Sabtu'].map((day) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dayController.text = day;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: dayController.text == day
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: dayController.text == day
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      ...List.generate(subjectControllers.length, (index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: TextField(
                                    controller: subjectControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Mata Pelajaran',
                                      labelStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: timeControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Waktu',
                                      labelStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  subjectControllers.removeAt(index);
                                  timeControllers.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              subjectControllers.add(TextEditingController());
                              timeControllers.add(TextEditingController());
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset.infinite,
                                      spreadRadius: 0.7,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(child: Icon(Icons.add))),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (dayController.text.isNotEmpty &&
                                  subjectControllers.isNotEmpty &&
                                  timeControllers.length ==
                                      subjectControllers.length &&
                                  subjectControllers.every((controller) =>
                                      controller.text.isNotEmpty) &&
                                  timeControllers.every((controller) =>
                                      controller.text.isNotEmpty)) {
                                try {
                                  final subjects = List.generate(
                                      subjectControllers.length, (index) {
                                    return Subject(
                                      subject: subjectControllers[index].text,
                                      time: timeControllers[index].text,
                                    );
                                  });

                                  provider.addSchedule(
                                    Schedule(
                                      day: dayController.text,
                                      subjects: subjects,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Harap lengkapi semua input!')),
                                );
                              }
                            },
                            child: const Text('simpan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

void _showEditDialog(BuildContext context, int index, Schedule schedule) {
  final provider = Provider.of<ScheduleProvider>(context, listen: false);
  final dayController = TextEditingController(text: schedule.day);
  final subjectControllers = schedule.subjects
      .map((subject) => TextEditingController(text: subject.subject))
      .toList();
  final timeControllers = schedule.subjects
      .map((subject) => TextEditingController(text: subject.time))
      .toList();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['Senin', 'Selasa', 'Rabu'].map((day) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  dayController.text = day;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: dayController.text == day
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: dayController.text == day
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['Kamis', 'Jumat', 'Sabtu'].map((day) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  dayController.text = day;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: dayController.text == day
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: dayController.text == day
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ...List.generate(subjectControllers.length, (index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: TextField(
                                  controller: subjectControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Mata Pelajaran',
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600]),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: timeControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Waktu',
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600]),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                subjectControllers.removeAt(index);
                                timeControllers.removeAt(index);
                              });
                            },
                          ),
                        ],
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            subjectControllers.add(TextEditingController());
                            timeControllers.add(TextEditingController());
                          });
                        },
                        child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset.infinite,
                                    spreadRadius: 0.7,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(child: Icon(Icons.add))),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (dayController.text.isNotEmpty &&
                                subjectControllers.isNotEmpty &&
                                timeControllers.length ==
                                    subjectControllers.length &&
                                subjectControllers.every((controller) =>
                                    controller.text.isNotEmpty) &&
                                timeControllers.every((controller) =>
                                    controller.text.isNotEmpty)) {
                              try {
                                final subjects = List.generate(
                                    subjectControllers.length, (index) {
                                  return Subject(
                                    subject: subjectControllers[index].text,
                                    time: timeControllers[index].text,
                                  );
                                });

                                provider.updateSchedule(
                                  index,
                                  Schedule(
                                    day: dayController.text,
                                    subjects: subjects,
                                  ),
                                );
                                Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Harap lengkapi semua input!')),
                              );
                            }
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
