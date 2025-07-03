import 'package:learning_officer_oa/common/models/message/cloud_school_user_model.dart';
import 'package:learning_officer_oa/utils/global.dart';
import 'package:learning_officer_oa/common/models/message/cloud_school_model.dart';
import 'package:learning_officer_oa/utils/common_widget/custom_widget.dart';
//2345
import 'index.dart';

/// 通讯录页面
class ContactsPage extends GetView<ContactsController> {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('通讯录'),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        if (controller.state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.state.contactsList.isEmpty) {
          return const Center(
            child: Text(
              "暂无通讯录数据",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: Column(
            children: [
              SizedBox(height: 24.h),
              // 我的群组部分
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/message/icon_msg_group.webp',
                    width: 110.w,
                    height: 110.w,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    "我的群组",
                    style: TextStyle(
                      color: Themes.font2e3238,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "查看群组列表",
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Color(0xFF8F97A3),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // 处理我的群组点击事件
                  },
                ),
              ),
              SizedBox(height: 24.h),
              // 通讯录列表
              Expanded(
                child: ListView.builder(
                  itemCount: controller.state.contactsList.length,
                  itemBuilder: (context, index) {
                    final school = controller.state.contactsList[index];
                    return Obx(() => _buildSchoolItem(controller, school));
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // 构建学校项目
  Widget _buildSchoolItem(
      ContactsController controller, CloudSchoolModel school) {
    final hasChildren = school.children != null && school.children!.isNotEmpty;
    final hasUsers = school.users != null && school.users!.isNotEmpty;
    final isExpandable = hasChildren || hasUsers;
    // 默认隐藏，点击后展开
    final isExpanded = controller.state.isExpanded(school.id);

    return Container(
      key: ValueKey('school_${school.id}'),
      // margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: Column(
        children: [
          // 自定义学校项目布局
          InkWell(
            onTap: () {
              if (isExpandable) {
                controller.toggleExpanded(school.id);
              } else {
                // 如果没有子项，直接跳转到联系人列表页面
                controller.onSchoolTap(school);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 22.h),
              child: Row(
                children: [
                  // 头像
                  Container(
                    width: 66.w,
                    height: 66.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0F7FFF),
                          Color(0xFF146CFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    child: Center(
                      child: Text(
                        school.schoolName.isNotEmpty
                            ? school.schoolName[0]
                            : '学',
                        style: TextStyle(
                          color: Color(0xFFACD0FF),
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 27.w),
                  // 学校名称和数量
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          school.schoolName,
                          style: TextStyle(
                            color: Themes.font2e3238,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 17.w),
                        Text(
                          "（${school.count}）",
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Themes.font8f97a3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 展开图标和联系人按钮
                  Row(
                    children: [
                      // 联系人按钮
                      GestureDetector(
                        onTap: () => controller.onSchoolTap(school),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Themes.btn66A9FF.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '联系人',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Themes.btn66A9FF,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // 展开图标
                      if (isExpandable)
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.chevron_right,
                          color: Themes.fontC7cbd1,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 展开的子项
          if (isExpanded && hasChildren)
            ...school.children!.map(
                (child) => Obx(() => _buildChildItem(controller, child, 1))),
          // 显示用户列表
          if (isExpanded && school.users != null && school.users!.isNotEmpty)
            ...school.users!.map((user) => _buildUserItem(controller, user, 1)),
        ],
      ),
    );
  }

  // 构建子学校项目
  Widget _buildChildItem(
      ContactsController controller, CloudSchoolModel child, int level) {
    final hasChildren = child.children != null && child.children!.isNotEmpty;
    final hasUsers = child.users != null && child.users!.isNotEmpty;
    // 默认隐藏，点击后展开
    final isExpanded = controller.state.isExpanded(child.id);
    final leftPadding = 90.w * level;

    return Container(
      key: ValueKey('child_${child.id}'),
      color: Colors.white,
      child: Column(
        children: [
          // 自定义子学校项目布局
          InkWell(
            onTap: () {
              if (hasChildren || hasUsers) {
                controller.toggleExpanded(child.id);
              } else {
                // 如果没有子项，直接跳转到联系人列表页面
                controller.onSchoolTap(child);
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                left: leftPadding + 36.w,
                right: 37.w,
                top: 22.h,
                bottom: 22.h,
              ),
              child: Row(
                children: [
                  // 头像
                  Container(
                    width: 66.w,
                    height: 66.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFD9EBFF),
                          Color(0xFFC3DAFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    child: Center(
                      child: Text(
                        child.schoolName.isNotEmpty ? child.schoolName[0] : '校',
                        style: TextStyle(
                          color: Themes.btn66A9FF,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 31.w),
                  // 学校名称和数量
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          child.schoolName,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w400,
                            color: Themes.font2e3238,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          "（${child.count}）",
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Themes.font8f97a3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 展开图标和联系人按钮
                  Row(
                    children: [
                      // 联系人按钮
                      GestureDetector(
                        onTap: () => controller.onSchoolTap(child),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Themes.btn66A9FF.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '联系人',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Themes.btn66A9FF,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // 展开图标
                      if (hasChildren || hasUsers)
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.chevron_right,
                          color: Themes.fontC7cbd1,
                          size: 42.w,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 递归展开子项
          if (isExpanded && hasChildren)
            ...child.children!.map((grandChild) =>
                Obx(() => _buildChildItem(controller, grandChild, level + 1))),
          // 显示用户列表
          if (isExpanded && hasUsers)
            ...child.users!
                .map((user) => _buildUserItem(controller, user, level + 1)),
        ],
      ),
    );
  }

  // 构建用户项目
  Widget _buildUserItem(
      ContactsController controller, CloudSchoolUser user, int level) {
    final leftPadding = 90.w * level;

    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () => controller.onContactTap(user),
        child: Container(
          padding: EdgeInsets.only(
            left: leftPadding + 36.w,
            right: 37.w,
            top: 22.h,
            bottom: 22.h,
          ),
          child: Row(
            children: [
              // 用户头像
              Container(
                width: 66.w,
                height: 66.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFD9EBFF),
                      Color(0xFFC3DAFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26.r),
                ),
                child: user.headImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(26.r),
                        child: Image.network(
                          user.headImage,
                          width: 66.w,
                          height: 66.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                user.userName.isNotEmpty
                                    ? user.userName[0]
                                    : '用',
                                style: TextStyle(
                                  color: Themes.btn66A9FF,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          user.userName.isNotEmpty ? user.userName[0] : '用',
                          style: TextStyle(
                            color: Themes.btn66A9FF,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 27.w),
              // 用户名称
              Expanded(
                child: Text(
                  user.userName,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w400,
                    color: Themes.font2e3238,
                  ),
                ),
              ),
              // 箭头图标
              // Icon(
              //   Icons.chevron_right,
              //   color: Themes.fontC7cbd1,
              //   size: 42.w,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
