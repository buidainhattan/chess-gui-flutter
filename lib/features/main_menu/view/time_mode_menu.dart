import 'dart:io';

import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TimeModeMenu extends StatefulWidget {
  final String? gameMode;

  const TimeModeMenu({super.key, required this.gameMode});

  @override
  State<TimeModeMenu> createState() => _TimeModeMenuState();
}

class _TimeModeMenuState extends State<TimeModeMenu> {
  String? _selectedMode;
  String? _selectedTime;

  void _toMatchScreen(BuildContext context) {
    context.go("/${widget.gameMode}/$_selectedMode/$_selectedTime/match");
  }

  TableRow _buildOptionRow(
    BuildContext context,
    String buttonText,
    Map<String, TimeSetting> settings,
  ) {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            buttonText.toUpperCase(),
            style: context.menuText(color: AppCustomColors.purple),
          ),
        ),
        ...settings.entries.map((entry) {
          String displayText = entry.value.label;
          String value = entry.key;
          bool isSelected = _selectedTime == value;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceS),
              child: TextButton(
                child: Text(
                  displayText,
                  style: context.menuText(
                    color: isSelected ? Colors.green : Colors.black,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedMode = buttonText.toLowerCase();
                    _selectedTime = value;
                  });
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: (screenHeight / 2),
          width: (6 / 12 * screenWidth),
          left: screenWidth * 0.02,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.black, width: 2),
                ),
                children: [
                  _buildOptionRow(
                    context,
                    TimeDuration.blitz.name,
                    TimeDuration.blitz.options,
                  ),
                  _buildOptionRow(
                    context,
                    TimeDuration.rapid.name,
                    TimeDuration.rapid.options,
                  ),
                  _buildOptionRow(
                    context,
                    TimeDuration.normal.name,
                    TimeDuration.normal.options,
                  ),
                ],
              ),

              SizedBox(height: screenHeight / 96),

              TextButton(
                onPressed: () {
                  if (_selectedMode == null || _selectedTime == null) return;
                  _toMatchScreen(context);
                },
                child: Text(
                  "START GAME",
                  style: context.menuText(color: Colors.green),
                ),
              ),

              SizedBox(height: screenHeight / 48),

              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  "BACK",
                  style: context.menuText(color: Colors.black),
                ),
              ),

              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("QUIT", style: context.menuText(color: Colors.red)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
