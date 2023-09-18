import 'package:flutter/material.dart';

class CoreDisableFormField extends StatefulWidget {
  const CoreDisableFormField({
    super.key
  });

  @override
  State<CoreDisableFormField> createState() => _CoreDisableFormFieldState();
}

class _CoreDisableFormFieldState extends State<CoreDisableFormField> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              enabled: false,
              labelText: 'Disabled field',
              helperText: 'Helper text',
              hintText: 'Disabled',
            ),
          ),
        ));
  }
}