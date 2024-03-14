import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.distance,
    this.children = const [],
  });

  final double? distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widget.children.map((child) {
        return _open
            ? Column(
                children: [
                  child,
                  const SizedBox(height: 10),
                ],
              )
            : Container();
      }).toList()
        ..add(
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              setState(() {
                _open = !_open;
              });
            },
            backgroundColor: Colors.cyan,
            child: _open ? const Icon(Icons.close) : const Icon(Icons.add),
          ),
        ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.tooltip,
      required this.heroTag,
      required this.foregroundColor,
      required this.backgroundColor});

  final VoidCallback onPressed;
  final Widget icon;
  final String? tooltip;
  final String heroTag;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: icon,
    );
  }
}
