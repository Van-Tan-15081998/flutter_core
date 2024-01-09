import 'package:flutter/material.dart';
import 'CoreBottomAppBar.dart';

class CoreBottomNavigationBar extends StatefulWidget {
  Widget child;
  Color backgroundColor;

  CoreBottomNavigationBar({super.key, required this.child, required this.backgroundColor});

  @override
  State<CoreBottomNavigationBar> createState() =>
      _CoreBottomNavigationBarState();
}

class _CoreBottomNavigationBarState extends State<CoreBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
        child: CoreBottomAppBar(
          color: widget.backgroundColor,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          notchMargin: 5.0,
          child: widget.child,
        ));
  }
}
