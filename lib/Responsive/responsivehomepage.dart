import 'package:flutter/material.dart';

class ResponsiveHomepage extends StatelessWidget {
  final Widget mobilescreeen;
  final Widget desktopscreen;
  final Widget tabletscreen;

  const ResponsiveHomepage({
    super.key,
    required this.mobilescreeen,
    required this.desktopscreen,
    required this.tabletscreen,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobilescreeen;
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return tabletscreen;
        } else {
          return desktopscreen;
        }
      },
    );
  }
}
