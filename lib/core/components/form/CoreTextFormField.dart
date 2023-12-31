import 'package:flutter/material.dart';

class CoreTextFormField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  final FocusNode focusNode;
  final Function onValidator;
  final Icon icon;
  final String label;
  final String placeholder;
  final String helper;
  final int maxLength;

  const CoreTextFormField(
      {super.key,
      required this.onChanged,
      required this.controller,
        required this.focusNode,
        required this.onValidator,
        required this.icon,
        required this.label,
        required this.placeholder,
        required this.helper,
        required this.maxLength
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
            maxLength: widget.maxLength,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                helperText: widget.helper,
                hintText: widget.placeholder,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   widget.icon,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.label),
                    )
                  ],
                )),
          ),
        ));
  }
}
