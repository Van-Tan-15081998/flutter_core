import 'package:flutter/material.dart';

import '../models/label_model.dart';

class LabelDetailScreen extends StatefulWidget {
  final LabelModel label;

  const LabelDetailScreen({
    super.key,
    required this.label
  });

  @override
  State<LabelDetailScreen> createState() => _LabelDetailScreenState();
}

class _LabelDetailScreenState extends State<LabelDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return const Text('_Core');
  }
}
