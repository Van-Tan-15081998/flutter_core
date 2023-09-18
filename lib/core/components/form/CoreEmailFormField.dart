import 'package:flutter/material.dart';
import 'package:flutter_core_v3/core/extensions/CoreStringExtension.dart';

class CoreEmailFormField extends StatefulWidget {
  const CoreEmailFormField({super.key});

  @override
  State<CoreEmailFormField> createState() => _CoreEmailFormFieldState();
}

class _CoreEmailFormFieldState extends State<CoreEmailFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (stringValue) {
              if (!stringValue!.isValidEmail()) {
                return 'Enter a valid email';
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email field',
              helperText: 'Helper text',
              hintText: 'email@gmail.com',
            ),
          ),
        ));
  }
}
