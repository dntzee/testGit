import 'package:get/get.dart';

import 'controller.dart';
//m1
class ContactsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsController>(() => ContactsController());
  }
}
//200