import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/library/common/styles/CommonStyles.dart';
import '../../../../app/library/common/utils/CommonAudioOnPressButton.dart';
import '../../actions/common_buttons/CoreButtonStyle.dart';
import '../../actions/common_buttons/CoreElevatedButton.dart';

class CoreConfirmDialog extends StatefulWidget {

  final Widget confirmTitle;
  final bool initialData;
  final ValueChanged<bool> onChanged;
  final bool? isOnlyWarning;

  const CoreConfirmDialog({
    super.key,
    required this.confirmTitle,
    required this.initialData,
    required this.onChanged,
    required this.isOnlyWarning
  });

  @override
  State<CoreConfirmDialog> createState() => _CoreConfirmDialogState();
}

class _CoreConfirmDialogState extends State<CoreConfirmDialog> {
  CommonAudioOnPressButton commonAudioOnPressButton = CommonAudioOnPressButton();

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

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
              widget.isOnlyWarning == true ? const FaIcon(FontAwesomeIcons.twitch, size: 25.0)  :  const FaIcon(FontAwesomeIcons.triangleExclamation, size: 25.0),
              const SizedBox(width: 10.0),
              Expanded(child: widget.confirmTitle),
            ],
          ),
          const SizedBox(height: 12.0),
          widget.isOnlyWarning == true ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CoreElevatedButton.icon(
                buttonAudio: commonAudioOnPressButton,
                icon: const FaIcon(FontAwesomeIcons.handPeace, size: 18.0),
                label: Text('I got it', style: CommonStyles.labelTextStyle),
                onPressed: () {
                  widget.onChanged(true);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.filled,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitBorderColorOption: Colors.black,
                    kitForegroundColorOption: Colors.black,
                    coreFixedSizeButton: CoreFixedSizeButton.medium_48),
              ),
              ]
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CoreElevatedButton.icon(
                buttonAudio: commonAudioOnPressButton,
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 18.0),
                label: Text('Cancel', style: CommonStyles.labelTextStyle),
                onPressed: () {
                  widget.onChanged(true);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.filled,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitBorderColorOption: Colors.black,
                    kitForegroundColorOption: Colors.black,
                    coreFixedSizeButton: CoreFixedSizeButton.medium_48),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton.icon(
                buttonAudio: commonAudioOnPressButton,
                icon: const FaIcon(FontAwesomeIcons.check, size: 18.0),
                label: Text('Yes, I\'m', style: CommonStyles.labelTextStyle),
                onPressed: () {
                  widget.onChanged(false);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.filled,
                    coreColor: CoreColor.danger,
                    coreRadius: CoreRadius.radius_6,
                    kitBorderColorOption: Colors.black,
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
