import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/features/main_menu/viewmodel/settings_menu_viewmodel.dart';
import 'package:flutter/material.dart';
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
                  borderRadius: BorderRadius.circular(4),
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
                            _ => _FirstTabSettings(viewmodel.playerName),
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

    return Material(
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
    );
  }
}

class _FirstTabSettings extends StatelessWidget {
  final String playerName;

  const _FirstTabSettings(this.playerName);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your name: $playerName"),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
      ],
    );
  }
}

class _SecondTabSettings extends StatelessWidget {
  const _SecondTabSettings();

  @override
  Widget build(BuildContext context) {
    return ListView(children: [Center(child: Text("No setting yet!"))]);
  }
}
