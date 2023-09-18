import 'package:flutter/material.dart';

class CoreMultilineFormField extends StatefulWidget {
  const CoreMultilineFormField({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.focusNode,
    required this.onValidator
  });

  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  final FocusNode focusNode;
  final Function onValidator;

  @override
  State<CoreMultilineFormField> createState() => _CoreMultilineFormFieldState();
}

class _CoreMultilineFormFieldState extends State<CoreMultilineFormField> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: widget.focusNode,
            controller: widget.controller,
            onChanged: (value) {
              widget.onChanged(value); // Gửi sự thay đổi tới trang cha
            },
            validator: (value) {
              return widget.onValidator(value);
            },
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              helperText: 'Helper text',
              hintText: 'Multiline',

              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_alarm_outlined),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Labels can be a widget'),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}