import 'package:flutter/material.dart';

import '../models/subject_model.dart';

class SubjectDetailScreen extends StatefulWidget {
  final SubjectModel subject;

  const SubjectDetailScreen({
    super.key,
    required this.subject
  });

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return const Text('_Core');
  }
}
