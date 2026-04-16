import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/session_service.dart';
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
  TimeMode? selectedMode = TimeMode.normal;
  TimeSetting? selectedSetting = TimeMode.normal.settings.values.first;

  void _toMatchScreen(BuildContext context, SessionService service) {
    TimeMode? mode = selectedMode;
    TimeSetting? setting = selectedSetting;
    if (mode == null || setting == null) return;

    service.updateTimeMode(mode);
    service.updateTimeSetting(setting);

    context.go("/${service.gameMode}/${mode.name}/match");
  }

  @override
  void initState() {
    super.initState();
    final SessionService sessionManagerService = context
        .read<SessionService>();
    selectedMode = sessionManagerService.timeMode;
    selectedSetting = sessionManagerService.timeSetting;
  }

  @override
  Widget build(BuildContext context) {
    final SessionService sessionService = context
        .read<SessionService>();

    return Column(
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
      children: [
        DropdownButton(
          value: selectedMode,
          items: [
            DropdownMenuItem<TimeMode>(
              value: TimeMode.blitz,
              child: Text(TimeMode.blitz.name.toUpperCase()),
            ),
            DropdownMenuItem<TimeMode>(
              value: TimeMode.rapid,
              child: Text(TimeMode.rapid.name.toUpperCase()),
            ),
            DropdownMenuItem<TimeMode>(
              value: TimeMode.normal,
              child: Text(TimeMode.normal.name.toUpperCase()),
            ),
          ],
          onChanged: (TimeMode? value) {
            setState(() {
              selectedMode = value;
              selectedSetting = selectedMode!.settings.values.first;
            });
          },
          style: context.menuText(),
          underline: Container(),
          borderRadius: BorderRadius.circular(8),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: selectedMode!.settings.entries.map((entry) {
            bool isSelected = selectedSetting == entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceS),
              child: MenuNavButton(
                label: entry.key,
                onPressed: () {
                  setState(() {
                    selectedSetting = entry.value;
                  });
                },
                textColor: isSelected ? Colors.green : Colors.black,
              ),
            );
          }).toList(),
        ),

        SizedBox(height: AppTheme.spaceS),

        MenuNavButton(
          label: "START GAME",
          onPressed: () => _toMatchScreen(context, sessionService),
          textColor: Colors.green,
        ),
        MenuNavButton(
          label: "BACK",
          onPressed: () => context.pop(),
          textColor: Theme.of(context).colorScheme.onSurface,
        ),
      ],
    );
  }
}
