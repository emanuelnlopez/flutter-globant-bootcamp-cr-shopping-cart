import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ThemeSwitcher({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          Icon(Icons.wb_sunny, color: isDarkMode ? Colors.grey : Colors.blue), //Sun
          SizedBox(width: 8.0), 
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              toggleTheme(); // Changes theme
            },
          ),
          SizedBox(width: 8.0), 
          Icon(Icons.nights_stay, color: isDarkMode ? Colors.blue : Colors.grey), // Moon
        ],
      ),
    );
  }
}