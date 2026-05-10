import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/animation_wrapper/hovering.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/features/main_menu/viewmodel/settings_menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------------
// SettingsMenu — full-screen redesign
// Viewmodel is unchanged. New gameplay/sound toggles are local UI state for
// now; wire them into SettingsService when you're ready.
// ---------------------------------------------------------------------------

const List<IconData> _presetIcons = [
  Icons.person_outline,
  Icons.face_outlined,
  Icons.face_2_outlined,
  Icons.face_3_outlined,
  Icons.face_4_outlined,
  Icons.face_5_outlined,
  Icons.face_6_outlined,
  Icons.psychology_outlined,
  Icons.smart_toy_outlined,
  Icons.sports_esports_outlined,
  Icons.emoji_events_outlined,
  Icons.star_outline,
];

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: colorScheme.primary,
          onPressed: () => context.pop(),
        ),
        title: Center(
          child: Text('Settings'.toUpperCase(), style: context.screenTitle()),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const _SectionLabel(label: 'Profile'),
          const _ProfileSection(),
          const SizedBox(height: 20),

          _SectionLabel(label: 'Gameplay'),
          const _GameplaySection(),
          const SizedBox(height: 20),

          _SectionLabel(label: 'Appearance'),
          const _AppearanceSection(),
          const SizedBox(height: 20),

          _SectionLabel(label: 'Sound'),
          const _SoundSection(),
          const SizedBox(height: 20),

          _SectionLabel(label: 'Notifications'),
          const _NotificationsSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section label
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(label.toUpperCase(), style: context.screenSubtitle()),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared card wrapper — groups rows with dividers
// ---------------------------------------------------------------------------

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 0,
                thickness: 0.5,
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row types
// ---------------------------------------------------------------------------

/// A row with a leading icon, title, optional subtitle, and a trailing widget.
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? child;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.child,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(
                  width: 0.5,
                  color: colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: child != null ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.itemLevelOne(fontWeight: FontWeight.w500),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: context.itemLevelThree(alpha: 0.6)),
                  ],
                ],
              ),
            ),
            if (child != null) Expanded(child: Center(child: child!)),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// Toggle row
class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsRow(
      icon: icon,
      label: label,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// Chip group row — shows a row of selectable chips inline
class _ChipGroupRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ChipGroupRow({
    required this.icon,
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _SettingsRow(
      icon: icon,
      label: label,
      trailing: Wrap(
        spacing: 6,
        children: List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return HoveringWrapper(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  options[i],
                  style: context.itemLevelThree(
                    color: selected ? colorScheme.onPrimary : null,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _EditNameDialog extends StatefulWidget {
  final String currentName;
  final SettingsMenuViewmodel viewmodel;
  const _EditNameDialog({required this.currentName, required this.viewmodel});

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: 24,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Player name', style: tt.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Shown during local games',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Input
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLength: 20,
                style: tt.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  counterStyle: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (value) {
                  widget.viewmodel.updatePlayerName(value.trim());
                  context.pop();
                },
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryNavButton(
                      label: 'Cancel',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryNavButton(
                      label: 'Save',
                      onPressed: () {
                        widget.viewmodel.updatePlayerName(
                          _controller.text.trim(),
                        );
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileIconDialog extends StatefulWidget {
  final int currentIndex;
  final SettingsMenuViewmodel viewmodel;
  const _ProfileIconDialog({
    required this.currentIndex,
    required this.viewmodel,
  });

  @override
  State<_ProfileIconDialog> createState() => _ProfileIconDialogState();
}

class _ProfileIconDialogState extends State<_ProfileIconDialog> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(
                      _presetIcons[_selectedIndex],
                      size: 24,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Profile picture', style: tt.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Pick an icon to represent you',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Icon grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(_presetIcons.length, (i) {
                  final selected = i == _selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected
                            ? cs.primaryContainer
                            : cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? cs.primary : cs.outlineVariant,
                          width: selected ? 1.5 : 0.5,
                        ),
                      ),
                      child: Icon(
                        _presetIcons[i],
                        size: 28,
                        color: selected
                            ? cs.onPrimaryContainer
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryNavButton(
                      label: 'Cancel',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryNavButton(
                      label: 'Save',
                      onPressed: () {
                        widget.viewmodel.updateProfileIconIndex(_selectedIndex);
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile section
// ---------------------------------------------------------------------------

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  void _showEditNameDialog(BuildContext context, String currentName) {
    final viewmodel = context.read<SettingsMenuViewmodel>();
    showDialog<void>(
      context: context,
      builder: (_) =>
          _EditNameDialog(currentName: currentName, viewmodel: viewmodel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return _SettingsCard(
      children: [
        Selector<SettingsMenuViewmodel, String>(
          selector: (_, viewmodel) => viewmodel.playerName,
          builder: (context, name, child) => _SettingsRow(
            icon: Icons.person_outline,
            label: 'Player name',
            subtitle: 'Shown during local games',
            trailing: GestureDetector(
              onTap: () => _showEditNameDialog(context, name),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: context.itemLevelTwo()),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
            onTap: () => _showEditNameDialog(context, name),
          ),
        ),
        Selector<SettingsMenuViewmodel, int>(
          selector: (context, viewmodel) => viewmodel.profileIconIndex,
          builder: (context, index, child) => _SettingsRow(
            icon: Icons.face_outlined,
            label: 'Profile picture',
            subtitle: 'Choose a preset icon',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_presetIcons[index], size: 20, color: colorScheme.primary),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: colorScheme.primary),
              ],
            ),
            onTap: () {
              final viewmodel = context.read<SettingsMenuViewmodel>();
              showDialog<void>(
                context: context,
                builder: (_) => _ProfileIconDialog(
                  currentIndex: index,
                  viewmodel: viewmodel,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Gameplay section
// ---------------------------------------------------------------------------

class _GameplaySection extends StatefulWidget {
  const _GameplaySection();

  @override
  State<_GameplaySection> createState() => _GameplaySectionState();
}

class _GameplaySectionState extends State<_GameplaySection> {
  bool confirmMoves = false;
  bool autoPromote = false;
  bool showLegalMoves = true;
  int movementStyle = 1; // 0=Drag, 1=Tap, 2=Both

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _ToggleRow(
          icon: Icons.touch_app_outlined,
          label: 'Confirm moves',
          subtitle: 'Tap again to confirm before submitting',
          value: confirmMoves,
          onChanged: (v) => setState(() => confirmMoves = v),
        ),
        _ToggleRow(
          icon: Icons.auto_awesome_outlined,
          label: 'Auto-promote to queen',
          subtitle: 'Skip the promotion dialog',
          value: autoPromote,
          onChanged: (v) => setState(() => autoPromote = v),
        ),
        _ToggleRow(
          icon: Icons.circle_outlined,
          label: 'Show legal moves',
          subtitle: 'Highlight valid squares on select',
          value: showLegalMoves,
          onChanged: (v) => setState(() => showLegalMoves = v),
        ),
        _ChipGroupRow(
          icon: Icons.open_with,
          label: 'Piece movement',
          options: const ['Drag', 'Tap', 'Both'],
          selectedIndex: movementStyle,
          onSelected: (i) => setState(() => movementStyle = i),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Appearance section — theme color picker (wired to viewmodel)
// ---------------------------------------------------------------------------

class _AppearanceSection extends StatefulWidget {
  const _AppearanceSection();

  @override
  State<_AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<_AppearanceSection> {
  int animSpeed = 1; // 0=Off, 1=Normal, 2=Slow
  bool deleteMode = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<SettingsMenuViewmodel>(
      builder: (context, viewmodel, child) {
        return _SettingsCard(
          children: [
            _SettingsRow(
              icon: Icons.palette_outlined,
              label: 'Theme color',
              subtitle: 'Change the entire app theme color',
              trailing: IconButton(
                onPressed: () => setState(() {
                  deleteMode = !deleteMode;
                }),
                icon: Icon(
                  deleteMode ? Icons.cancel_outlined : Icons.delete_outline,
                  size: 18,
                  color: deleteMode
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
                tooltip: deleteMode ? 'Cancel' : 'Remove a color',
                visualDensity: VisualDensity.compact,
              ),
              child: _ThemeColorPicker(
                deleteMode: deleteMode,
                pickerColor: Color(viewmodel.themeColorHexValue),
                colorHexList: viewmodel.colorHexList,
                onColorChanged: (c) =>
                    viewmodel.updateActiveThemeColor(c.toARGB32()),
                onAddColor: (c) => viewmodel.addThemeColor(c.toARGB32()),
                onDeleteColor: viewmodel.deleteThemeColor,
                pickerSize: 36,
              ),
            ),
            _ChipGroupRow(
              icon: Icons.animation,
              label: 'Move animation',
              options: const ['Off', 'Normal', 'Slow'],
              selectedIndex: animSpeed,
              onSelected: (i) => setState(() => animSpeed = i),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sound section
// ---------------------------------------------------------------------------

class _SoundSection extends StatefulWidget {
  const _SoundSection();

  @override
  State<_SoundSection> createState() => _SoundSectionState();
}

class _SoundSectionState extends State<_SoundSection> {
  bool moveSounds = true;
  bool captureSounds = true;
  bool gameEndSound = true;
  bool lowTimeWarning = false;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _ToggleRow(
          icon: Icons.volume_up_outlined,
          label: 'Move sounds',
          value: moveSounds,
          onChanged: (v) => setState(() => moveSounds = v),
        ),
        _ToggleRow(
          icon: Icons.sports_martial_arts_outlined,
          label: 'Capture sounds',
          value: captureSounds,
          onChanged: (v) => setState(() => captureSounds = v),
        ),
        _ToggleRow(
          icon: Icons.emoji_events_outlined,
          label: 'Game end sound',
          value: gameEndSound,
          onChanged: (v) => setState(() => gameEndSound = v),
        ),
        _ToggleRow(
          icon: Icons.timer_outlined,
          label: 'Low time warning',
          subtitle: 'Sound when clock drops below 10s',
          value: lowTimeWarning,
          onChanged: (v) => setState(() => lowTimeWarning = v),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Notifications section
// ---------------------------------------------------------------------------

class _NotificationsSection extends StatefulWidget {
  const _NotificationsSection();

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  bool opponentMoved = true;
  bool gameReminders = false;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _ToggleRow(
          icon: Icons.notifications_outlined,
          label: 'Opponent moved',
          subtitle: 'For correspondence games',
          value: opponentMoved,
          onChanged: (v) => setState(() => opponentMoved = v),
        ),
        _ToggleRow(
          icon: Icons.alarm_outlined,
          label: 'Game reminders',
          subtitle: "Nudge when it's your turn",
          value: gameReminders,
          onChanged: (v) => setState(() => gameReminders = v),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ThemeColorPicker
// ---------------------------------------------------------------------------

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
    this.pickerSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = colorHexList.map((e) => Color(e)).toList();

    return Wrap(
      spacing: AppTheme.spaceS,
      runSpacing: AppTheme.spaceS,
      children: [
        for (final color in colors)
          if (!(deleteMode && color.toARGB32() == pickerColor.toARGB32()))
            Builder(
              builder: (context) {
                final isCurrentColor =
                    color.toARGB32() == pickerColor.toARGB32();
                final brightness = ThemeData.estimateBrightnessForColor(color);
                final iconColor = brightness == Brightness.light
                    ? Colors.black
                    : Colors.white;

                return HoveringWrapper(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(25),
                  child: GestureDetector(
                    onTap: deleteMode
                        ? () => onDeleteColor!(color.toARGB32())
                        : () => onColorChanged(color),
                    child: Container(
                      width: pickerSize,
                      height: pickerSize,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isCurrentColor
                            ? Border.all(
                                color: iconColor.withValues(alpha: 0.5),
                                width: 3,
                              )
                            : null,
                      ),
                      child: isCurrentColor
                          ? Icon(Icons.check, color: iconColor, size: 14)
                          : deleteMode
                          ? Icon(
                              Icons.delete_forever,
                              color: iconColor,
                              size: 14,
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
        if (!deleteMode)
          Material(
            color: colorScheme.surfaceContainerHighest,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => _ThemeColorPickerDialog(
                    initialColor: pickerColor,
                    onColorConfirm: onAddColor,
                  ),
                );
              },
              hoverColor: colorScheme.outline.withValues(alpha: 0.15),
              child: SizedBox(
                width: pickerSize,
                height: pickerSize,
                child: Icon(
                  Icons.add,
                  color: colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _ThemeColorPickerDialog
// ---------------------------------------------------------------------------

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
      title: const Text('Pick your new theme color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (color) => setState(() => pickerColor = color),
        ),
      ),
      actions: [
        TextButton(child: const Text('Cancel'), onPressed: () => context.pop()),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            widget.onColorConfirm(pickerColor);
            context.pop();
          },
        ),
      ],
    );
  }
}
