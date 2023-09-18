import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_v3/core/extensions/CoreStringExtension.dart';

class CoreNumberFormField extends StatefulWidget {
  const CoreNumberFormField({super.key});

  @override
  State<CoreNumberFormField> createState() => _CoreNumberFormFieldState();
}

class _CoreNumberFormFieldState extends State<CoreNumberFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (stringValue) {
            if (!stringValue!.isValidDouble()) {
              return 'Enter a valid floating point number';
            }
          },
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
              labelText: 'Number field',
              helperText: 'Helper text',
              hintText: '98',
              suffix: Text('year')),
        ),
      ),
    );
  }
}
