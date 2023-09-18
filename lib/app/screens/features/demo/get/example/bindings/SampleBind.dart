import 'package:get/get.dart';

import '../mixins/ControllerX.dart';

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
  }
}