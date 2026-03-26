import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/session_data.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/features/main_menu/model/time_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TimeModeMenu extends StatefulWidget {
  const TimeModeMenu({super.key});

  @override
  State<TimeModeMenu> createState() => _TimeModeMenuState();
}

class _TimeModeMenuState extends State<TimeModeMenu> {
  String? _selectedMode;
  String? _selectedSetting;

  void _toMatchScreen(BuildContext context, SessionDataService service) {
    String? mode = _selectedMode;
    String? setting = _selectedSetting;
    if (mode == null || setting == null) return;

    service.updateTimeMode(mode);
    service.updateTimeSetting(setting);

    context.go("/${service.gameMode}/$_selectedMode/match");
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
          String displayText = entry.key;
          bool isSelected = _selectedSetting == displayText;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceS),
              child: MenuNavButton(
                label: displayText,
                onPressed: () {
                  setState(() {
                    _selectedMode = buttonText.toLowerCase();
                    _selectedSetting = displayText;
                  });
                },
                textColor: isSelected ? Colors.green : Colors.black,
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    final SessionDataService sessionDataService =
        Provider.of<SessionDataService>(context, listen: false);
    _initializeDefaultChoice(sessionDataService);
  }

  void _initializeDefaultChoice(SessionDataService service) {
    _selectedMode = service.timeMode;
    _selectedSetting = service.timeSetting;
  }

  @override
  Widget build(BuildContext context) {
    final SessionDataService sessionDataService =
        Provider.of<SessionDataService>(context, listen: false);

    return Column(
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
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
              TimeMode.blitz.name,
              TimeMode.blitz.settings,
            ),
            _buildOptionRow(
              context,
              TimeMode.rapid.name,
              TimeMode.rapid.settings,
            ),
            _buildOptionRow(
              context,
              TimeMode.normal.name,
              TimeMode.normal.settings,
            ),
          ],
        ),

        SizedBox(height: AppTheme.spaceS),

        MenuNavButton(
          label: "START GAME",
          onPressed: () => _toMatchScreen(context, sessionDataService),
          textColor: Colors.green,
        ),
        MenuNavButton(
          label: "BACK",
          onPressed: () => context.pop(),
          textColor: Colors.black,
        ),
      ],
    );
  }
}
