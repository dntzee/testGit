import 'package:get/get.dart';
import 'package:learning_officer_oa/common/mixins/request_tool_mixin.dart';
import 'package:learning_officer_oa/common/models/message/cloud_school_model.dart';
import 'package:learning_officer_oa/common/models/message/cloud_school_user_model.dart';
import 'package:learning_officer_oa/utils/toast_utils.dart';
//m2
import 'index.dart';

class ContactsController extends GetxController with RequestToolMixin {
  ContactsController();

  final state = ContactsState();

  @override
  void onInit() {
    super.onInit();
    loadContactsList();
  }

  // 加载通讯录列表
  Future<void> loadContactsList() async {
    await universalRequest<List<CloudSchoolModel>>(
      request: () => getClient().getCloudSchoolList(),
      onSuccess: (data) {
        if (data != null) {
          state.contactsList = data;
        }
      },
      onError: (e) {
        // 错误处理已在universalRequest中自动处理
      },
    );
  }

  // 切换展开/收起状态
  void toggleExpanded(int id) {
    state.toggleExpanded(id);
  }

  // 刷新数据
  Future<void> onRefresh() async {
    await loadContactsList();
  }

  // 点击联系人
  void onContactTap(CloudSchoolUser user) {
    // 这里可以添加点击联系人的逻辑，比如跳转到聊天页面
    ToastUtils.showSuccess('点击了联系人：${user.userName}');
  }
  
  // 点击学校，跳转到联系人列表页面
  void onSchoolTap(CloudSchoolModel school) {
    Get.toNamed('/message/contact_list', arguments: {
      'schoolId': school.id,
      'schoolName': school.schoolName,
    });
  }
}
