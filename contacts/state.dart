import 'package:get/get.dart';
import 'package:learning_officer_oa/common/models/message/cloud_school_model.dart';
import 'package:learning_officer_oa/pages/administration_pages/pages/work_indicators/pages/tasktypes/index.dart';

class ContactsState {
  // 通讯录数据列表
  final RxList<CloudSchoolModel> _contactsList = <CloudSchoolModel>[].obs;
  List<CloudSchoolModel> get contactsList => _contactsList;
  set contactsList(List<CloudSchoolModel> value) => _contactsList.value = value;

  // 展开状态映射 - 记录每个节点的展开状态
  final RxMap<int, bool> _expandedMap = <int, bool>{}.obs;
  Map<int, bool> get expandedMap => _expandedMap;

  // 加载状态
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  // 设置节点展开状态
  void setExpanded(int id, bool expanded) {
    final newMap = Map<int, bool>.from(_expandedMap);
    newMap[id] = expanded;
    _expandedMap.value = newMap;
  }

  // 获取节点展开状态
  bool isExpanded(int id) {
    return _expandedMap[id] ?? false;
  }

  // 切换节点展开状态
  void toggleExpanded(int id) {
    final newMap = Map<int, bool>.from(_expandedMap);
    newMap[id] = !(newMap[id] ?? false);
    _expandedMap.value = newMap;
  }
}
