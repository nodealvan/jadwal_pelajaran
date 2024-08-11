import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sekolah/home.dart';
import 'package:sekolah/schedul_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleProvider(),
      child: MaterialApp(
        title: 'Jadwal Pelajaran',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ScheduleScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
