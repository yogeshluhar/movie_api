import 'package:flutter/material.dart';
import 'package:movieapp/Responsive/responsivehomepage.dart';
import 'package:movieapp/Tablet/tabletscreen.dart';
import 'package:movieapp/desktop/desktophomescreen.dart';
import 'package:movieapp/mobile/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      debugShowCheckedModeBanner: false,
      title: "Movie",
      home: ResponsiveHomepage(
          mobilescreeen: MobileScreen(),
          desktopscreen: DesktopScreen(),
          tabletscreen: TabletScreen()
      ),
    );
  }
}