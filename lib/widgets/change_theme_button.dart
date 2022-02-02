import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vacation_planner/theme_provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        const Align(
            alignment: Alignment.centerLeft, child: Text("Dark-Mode: ")),
        Checkbox(
          value: (themeProvider.isDarkMode) ? true : false,
          onChanged: (value) {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.toggleTheme(value!);
          },
        ),
      ],
    );
  }
}
