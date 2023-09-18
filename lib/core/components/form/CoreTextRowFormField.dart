import 'package:flutter/material.dart';

class CoreTextRowFormField extends StatefulWidget {
  const CoreTextRowFormField({
    super.key
  });

  @override
  State<CoreTextRowFormField> createState() => _CoreTextRowFormFieldState();
}

class _CoreTextRowFormFieldState extends State<CoreTextRowFormField> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      helperText: 'Helper text',
                      hintText: 'Row',

                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_alarm_outlined),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Labels'),
                          )
                        ],
                      )
                  ),
                ),
              ),

              Flexible(
                flex: 1,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      helperText: 'Helper text',
                      hintText: 'Row',

                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_alarm_outlined),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Labels'),
                          )
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}