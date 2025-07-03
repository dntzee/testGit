import 'package:get/get.dart';

import 'controller.dart';
//2345
class ContactsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsController>(() => ContactsController());
  }
}
//200