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
    final SessionService sessionManagerService = context.read<SessionService>();
    selectedMode = sessionManagerService.timeMode;
    selectedSetting = sessionManagerService.timeSetting;
  }

  @override
  Widget build(BuildContext context) {
    final SessionService sessionService = context.read<SessionService>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
      children: [
        DropdownMenu<TimeMode>(
          initialSelection: selectedMode,
          selectOnly: true,
          width: 400,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.transparent, // Subtle glass effect
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          // Styling the text inside the field
          textStyle: context.menuText(),
          textAlign: TextAlign.center,
          // Styling the pop-up menu
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(colorScheme.inversePrimary),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.primary),
              ),
            ),
          ),
          onSelected: (TimeMode? value) {
            if (value != null) {
              setState(() {
                selectedMode = value;
                selectedSetting = selectedMode!.settings.values.first;
              });
            }
          },
          dropdownMenuEntries: TimeMode.values.map<DropdownMenuEntry<TimeMode>>(
            (TimeMode mode) {
              return DropdownMenuEntry<TimeMode>(
                value: mode,
                label: mode.name.toUpperCase(),
                style: MenuItemButton.styleFrom(
                  foregroundColor:
                      colorScheme.onPrimary, // Text color in the menu
                ),
              );
            },
          ).toList(),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppTheme.spaceS,
          children: selectedMode!.settings.entries.map((entry) {
            bool isSelected = selectedSetting == entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceS),
              child: SelectableButton(
                label: entry.key,
                isSelected: isSelected,
                onPressed: () {
                  setState(() {
                    selectedSetting = entry.value;
                  });
                },
              ),
            );
          }).toList(),
        ),

        PrimaryNavButton(
          label: "START GAME",
          onPressed: () => _toMatchScreen(context, sessionService),
        ),
        TertiaryNavButton(label: "BACK", onPressed: () => context.pop()),
      ],
    );
  }
}
