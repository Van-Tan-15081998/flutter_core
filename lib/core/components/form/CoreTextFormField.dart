import 'package:flutter/material.dart';

class CoreTextFormField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  final FocusNode focusNode;
  final Function onValidator;

  const CoreTextFormField(
      {super.key,
      required this.onChanged,
      required this.controller,
        required this.focusNode,
        required this.onValidator
      });

  @override
  State<CoreTextFormField> createState() => _CoreTextFormFieldState();
}

class _CoreTextFormFieldState extends State<CoreTextFormField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        // TextFormField đang được focus
        // Thực hiện các hành động cần thiết khi TextFormField được focus
      } else {
        // TextFormField không được focus
        // Thực hiện các hành động cần thiết khi TextFormField không được focus
      }
    });
  }

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
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                helperText: 'Helper text',
                hintText: 'Text Field',
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_alarm_outlined),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Labels can be a widget'),
                    )
                  ],
                )),
          ),
        ));
  }
}
