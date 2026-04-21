import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/features/main_menu/viewmodel/settings_menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsMenuViewmodel viewmodel = context
        .read<SettingsMenuViewmodel>();

    return Stack(
      children: [
        Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth * 2 / 3;
              final double height = constraints.maxHeight * 4 / 5;

              final double optionWidth = width * 2 / 7;
              final double verticalStripWidth = 1;

              final double vPadding = height * 1 / 14;

              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Selector<SettingsMenuViewmodel, int>(
                  selector: (context, viewmodel) => viewmodel.selectedTabIndex,
                  builder: (context, selectedIndex, child) {
                    return Row(
                      children: [
                        SizedBox(
                          width: optionWidth,
                          child: ListView(
                            children: [
                              ...viewmodel.options.asMap().entries.map((entry) {
                                return _SettingTab(
                                  index: entry.key,
                                  selectedIndex: selectedIndex,
                                  text: entry.value,
                                  vPadding: vPadding,
                                  callBack: () => viewmodel
                                      .updateSelectedTabIndex(entry.key),
                                );
                              }),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          width: verticalStripWidth,
                          height: double.infinity,
                        ),
                        Expanded(
                          child: switch (selectedIndex) {
                            1 => _SecondTabSettings(),
                            _ => _FirstTabSettings(viewmodel),
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuNavButton(
                label: "BACK",
                onPressed: () {
                  context.pop();
                },
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingTab extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String text;
  final double vPadding;
  final VoidCallback? callBack;

  const _SettingTab({
    required this.index,
    required this.selectedIndex,
    required this.text,
    required this.vPadding,
    this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;

    return ClipRRect(
      borderRadius: index == 0
          ? BorderRadiusGeometry.only(topLeft: Radius.circular(8))
          : BorderRadius.zero,
      child: Material(
        shape: UnderlineInputBorder(borderSide: BorderSide(strokeAlign: 0)),
        color: isSelected ? Colors.lightBlue : Colors.transparent,
        child: InkWell(
          onTap: callBack ?? () {},
          onHover: (value) {},
          hoverColor: Colors.lightBlue,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding),
            child: Center(child: Text(text, style: context.menuText())),
          ),
        ),
      ),
    );
  }
}

class _FirstTabSettings extends StatefulWidget {
  final SettingsMenuViewmodel viewmodel;

  const _FirstTabSettings(this.viewmodel);

  @override
  State<_FirstTabSettings> createState() => _FirstTabSettingsState();
}

class _FirstTabSettingsState extends State<_FirstTabSettings> {
  final TextEditingController editPlayerNameController =
      TextEditingController();
  bool isEditPlayerName = false;

  @override
  Widget build(BuildContext context) {
    final String playerName = widget.viewmodel.playerName;
    editPlayerNameController.text = playerName;

    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isEditPlayerName) ...{
              Expanded(
                child: TextFormField(
                  controller: editPlayerNameController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Your Name"),
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.viewmodel.updatePlayerName(
                    editPlayerNameController.text,
                  );
                  setState(() {
                    isEditPlayerName = false;
                  });
                },
                icon: Icon(Icons.check),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEditPlayerName = false;
                  });
                },
                icon: Icon(Icons.cancel),
              ),
            } else ...{
              Text("Your Name: $playerName"),
              IconButton(
                onPressed: () {
                  setState(() {
                    isEditPlayerName = true;
                  });
                },
                icon: Icon(Icons.edit),
              ),
            },
          ],
        ),
      ],
    );
  }
}

class _SecondTabSettings extends StatefulWidget {
  const _SecondTabSettings();

  @override
  State<_SecondTabSettings> createState() => _SecondTabSettingsState();
}

class _SecondTabSettingsState extends State<_SecondTabSettings> {
  bool deleteMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppTheme.spaceS,
            horizontal: AppTheme.spaceS,
          ),
          child: Consumer<SettingsMenuViewmodel>(
            builder: (context, viewmodel, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Color: "),
                  _ThemeColorPicker(
                    deleteMode: deleteMode,
                    pickerColor: Color(viewmodel.themeColorHexValue),
                    colorHexList: viewmodel.colorHexList,
                    onColorChanged: (selectedColor) => viewmodel
                        .updateActiveThemeColor(selectedColor.toARGB32()),
                    onAddColor: (addedColor) =>
                        viewmodel.addThemeColor(addedColor.toARGB32()),
                    onDeleteColor: (value) => viewmodel.deleteThemeColor(value),
                    pickerSize: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        deleteMode = !deleteMode;
                      });
                    },
                    icon: Icon(deleteMode ? Icons.cancel : Icons.delete),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeColorPicker extends StatelessWidget {
  final bool deleteMode;
  final Color pickerColor;
  final List<int> colorHexList;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<Color> onAddColor;
  final void Function(int value)? onDeleteColor;
  final double pickerSize;

  const _ThemeColorPicker({
    this.deleteMode = false,
    required this.pickerColor,
    required this.colorHexList,
    required this.onColorChanged,
    required this.onAddColor,
    this.onDeleteColor,
    this.pickerSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<Color> colors = colorHexList.map((e) => Color(e)).toList();

    return Flexible(
      child: Wrap(
        spacing: AppTheme.spaceS,
        runSpacing: AppTheme.spaceS,
        children: [
          ...colors.map((color) {
            final isCurrentColor = color.toARGB32() == pickerColor.toARGB32();
            final brightness = ThemeData.estimateBrightnessForColor(color);
            final iconColor = brightness == Brightness.light
                ? Colors.black
                : Colors.white;

            return Material(
              color: color,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: (deleteMode && !isCurrentColor)
                    ? () => onDeleteColor!(color.toARGB32())
                    : () => onColorChanged(color),
                hoverColor: iconColor.withValues(alpha: 0.15),
                child: Container(
                  width: pickerSize,
                  height: pickerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: (isCurrentColor && !deleteMode)
                        ? Border.all(
                            color: iconColor.withValues(alpha: 0.5),
                            width: 3,
                          )
                        : null,
                  ),
                  child: isCurrentColor
                      ? Icon(Icons.check, color: iconColor, size: 16)
                      : deleteMode
                      ? Icon(Icons.delete_forever, color: iconColor, size: 16)
                      : null,
                ),
              ),
            );
          }),
          if (!deleteMode)
            Material(
              color: colorScheme.surfaceContainer,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => _ThemeColorPickerDialog(
                      initialColor: pickerColor,
                      onColorConfirm: onAddColor,
                    ),
                  );
                },
                hoverColor: colorScheme.outline.withValues(alpha: 0.15),
                child: SizedBox(
                  width: pickerSize,
                  height: pickerSize,
                  child: Icon(Icons.add, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemeColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorConfirm;

  const _ThemeColorPickerDialog({
    required this.initialColor,
    required this.onColorConfirm,
  });

  @override
  State<_ThemeColorPickerDialog> createState() =>
      _ThemeColorPickerDialogState();
}

class _ThemeColorPickerDialogState extends State<_ThemeColorPickerDialog> {
  late Color pickerColor;

  @override
  void initState() {
    super.initState();
    pickerColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pick your new theme color!"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (Color newColor) {
            setState(() {
              pickerColor = newColor;
            });
          },
        ),
      ),
      actions: [
        TextButton(child: const Text("CANCEL"), onPressed: () => context.pop()),
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            widget.onColorConfirm(pickerColor);
            context.pop();
          },
        ),
      ],
    );
  }
}
