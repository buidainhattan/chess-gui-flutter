import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/services/session_service.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.isMobile ? 0 : AppTheme.spaceM,
      children: [
        _ExpandingDropdown<TimeMode>(
          initialSelection: selectedMode!,
          items: TimeMode.values,
          labelBuilder: (mode) => mode.name.toUpperCase(),
          onSelected: (value) {
            setState(() {
              selectedMode = value;
              selectedSetting = value.settings.values.first;
            });
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppTheme.spaceS,
          children: [
            for (var entry in selectedMode!.settings.entries) ...[
              Builder(
                builder: (context) {
                  final bool isSelected = selectedSetting == entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceS,
                    ),
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
                },
              ),
              if (entry.value != selectedMode!.settings.values.last)
                SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ],
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

class _ExpandingDropdown<T> extends StatefulWidget {
  final T initialSelection;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  const _ExpandingDropdown({
    required this.initialSelection,
    required this.items,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  State<_ExpandingDropdown<T>> createState() => _ExpandingDropdownState<T>();
}

class _ExpandingDropdownState<T> extends State<_ExpandingDropdown<T>>
    with SingleTickerProviderStateMixin {
  late T selectedItem;
  bool isExpanded = false;
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();

  late AnimationController controller;
  late Animation<double> expandAnimation;
  late Animation<double> rotateAnimation;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialSelection;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    expandAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(expandAnimation);
  }

  void _toggleMenu() {
    if (isExpanded) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);
    controller.forward();
    setState(() => isExpanded = true);
  }

  void _closeMenu() {
    controller.reverse().then((_) {
      overlayEntry?.remove();
      overlayEntry = null;
      if (mounted) setState(() => isExpanded = false);
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height - 1), // -1 to overlap borders
          child: Material(
            color: Colors.transparent,
            child: SizeTransition(
              sizeFactor: expandAnimation,
              axisAlignment: -1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.inversePrimary,
                  border: Border(
                    left: BorderSide(color: colorScheme.primary),
                    right: BorderSide(color: colorScheme.primary),
                    bottom: BorderSide(color: colorScheme.primary),
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var item in widget.items)
                      if (item != selectedItem) ...[
                        Divider(
                          height: 1,
                          thickness: 1,
                          indent: AppTheme.spaceS,
                          endIndent: AppTheme.spaceS,
                          color: colorScheme.primary,
                        ),
                        _HoveringWrapper(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() => selectedItem = item);
                              widget.onSelected(item);
                              _toggleMenu();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              child: Center(
                                child: Text(
                                  widget.labelBuilder(item),
                                  style: context.menuText(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return CompositedTransformTarget(
      link: layerLink,
      child: _HoveringWrapper(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
          bottom: isExpanded ? Radius.zero : Radius.circular(8),
        ),
        isPersisted: isExpanded,
        child: GestureDetector(
          onTap: _toggleMenu,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.inversePrimary,
              // Animate border radius: bottom becomes square when expanded
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: isExpanded ? Radius.zero : Radius.circular(8),
              ),
              border: Border.all(
                color: isExpanded
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  widget.labelBuilder(selectedItem),
                  style: context.menuText(),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RotationTransition(
                      turns: rotateAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    controller.dispose();
    super.dispose();
  }
}

class _HoveringWrapper extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final bool isPersisted;

  const _HoveringWrapper({
    required this.child,
    this.borderRadius,
    this.isPersisted = false,
  });

  @override
  State<_HoveringWrapper> createState() => _HoveringWrapperState();
}

class _HoveringWrapperState extends State<_HoveringWrapper> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color hoveringColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.08);

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: Stack(
          children: [
            Center(child: widget.child),
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: isHovering || widget.isPersisted
                      ? hoveringColor
                      : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
