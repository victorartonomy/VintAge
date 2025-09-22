import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final bool isDarkMode;
  const Header({super.key, required this.isDarkMode});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  static const ColorFilter _inversionColorFilter = ColorFilter.matrix(<double>[
    -1,  0,  0, 0, 255, // Red channel
    0, -1,  0, 0, 0, // Green channel
    0,  0, -1, 0, 0, // Blue channel
    0,  0,  0, 1,   0, // Alpha channel
  ]);

  static const ColorFilter _colorFilter = ColorFilter.matrix(<double>[
    -1,  0,  0, 0, 255, // Red channel
    0, -1,  0, 0, 0, // Green channel
    0,  0, -1, 0, 0, // Blue channel
    0,  0,  0, 1,   0, // Alpha channel
  ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 260,
          width: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo2.png"),
              fit: BoxFit.fitWidth,
              colorFilter: widget.isDarkMode? _inversionColorFilter:_colorFilter,
            ),
          ),
        ),

        // Icon(
        //   Icons.flutter_dash,
        //   size: 120,
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        // SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A Kare Nursing Services initiative",
              style: TextStyle(
                  fontSize: 16,
                  // color: Colors.red,
                  // color: Theme.of(context).colorScheme.primary,
                  color: widget.isDarkMode? Colors.white:Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        SizedBox(height: 25),

        // Welcome
        Text(
          "Welcome",
          style: TextStyle(
            fontSize: 40,
            color: Colors.red,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
