import 'package:flutter/material.dart';
import 'package:flutter_core_v3/core/extensions/CoreStringExtension.dart';

class CorePasswordFormField extends StatefulWidget {
  const CorePasswordFormField({super.key});

  @override
  State<CorePasswordFormField> createState() => _CorePasswordFormFieldState();
}

class _CorePasswordFormFieldState extends State<CorePasswordFormField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (stringValue) {
            if (stringValue!.isWhitespace()) {
              return 'This is a required field';
            }
          },
          obscureText: obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              labelText: 'Password field',
              helperText: 'Helper text',
              hintText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  obscurePassword = !obscurePassword;
                }),
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue,
                ),
              )),
        ),
      ),
    );
  }
}
