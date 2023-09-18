import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoreGetReactiveComponent extends StatefulWidget {

  final Function builder;

  const CoreGetReactiveComponent({
    super.key,
    required this.builder
  });

  @override
  State<CoreGetReactiveComponent> createState() => _CoreGetReactiveComponentState();
}

class _CoreGetReactiveComponentState extends State<CoreGetReactiveComponent> {

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => widget.builder(),
    );
  }
}