import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../actions/common_buttons/CoreButtonStyle.dart';
import '../../actions/common_buttons/CoreElevatedButton.dart';

class CoreConfirmDialog extends StatefulWidget {

  final Widget confirmTitle;
  final bool initialData;
  final ValueChanged<bool> onChanged;

  const CoreConfirmDialog({
    super.key,
    required this.confirmTitle,
    required this.initialData,
    required this.onChanged,
  });

  @override
  State<CoreConfirmDialog> createState() => _CoreConfirmDialogState();
}

class _CoreConfirmDialogState extends State<CoreConfirmDialog> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.triangleExclamation, size: 18.0),
              const SizedBox(width: 10.0),
              widget.confirmTitle,
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CoreElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 18.0),
                label: const Text('Cancel'),
                onPressed: () {
                  widget.onChanged(true);
                  Navigator.pop(context);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.filled,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black,
                    coreFixedSizeButton: CoreFixedSizeButton.medium_48),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.check, size: 18.0),
                label: const Text('Yes, I\'m'),
                onPressed: () {
                  widget.onChanged(false);
                  Navigator.pop(context);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.filled,
                    coreColor: CoreColor.danger,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black,
                    coreFixedSizeButton: CoreFixedSizeButton.medium_48),
              )
            ],
          ),
        ],
      ),
    );
  }
}