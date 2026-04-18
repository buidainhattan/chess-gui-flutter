import 'package:chess_app/core/styles/text.dart';
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
                            1 => _SecondTabSettings(viewmodel),
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

class _SecondTabSettings extends StatelessWidget {
  final SettingsMenuViewmodel viewmodel;

  const _SecondTabSettings(this.viewmodel);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Text("Color: "),
            Expanded(
              child: Container(
                color: viewmodel.themeColor,
                width: double.infinity,
                height: 50.0,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => _ThemeColorPickerDialog(
                    initialColor: viewmodel.themeColor,
                    onColorConfirm: (Color newColor) {
                      viewmodel.updateThemeColor(newColor.toARGB32());
                    },
                  ),
                );
              },
              icon: Icon(Icons.edit_attributes),
            ),
          ],
        ),
      ],
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
