import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/responsive_util.dart';

import '../../components/common/loading_progress.dart';
import '../../components/common/name_and_image_setting_section.dart';

import '../../components/components/group/group_setting/group_setting_save_button.dart';
import '../../components/components/group/group_setting/sections/member_section/group_setting_member_section.dart';
import '../../components/components/group/group_setting/sections/schedule_section/group_setting_schedule_section.dart';
import '../../components/components/navigation_bar/group_setting_navigation/group_setting_navigation_bar.dart';

import '../../notifiers/group_setting_notifier.dart';

class GroupSettingPage extends ConsumerStatefulWidget {
  const GroupSettingPage({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupSettingPage> createState() => _GroupSettingPageState();
}

class _GroupSettingPageState extends ConsumerState<GroupSettingPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtil.isMobile(context)) {
          return _buildMobileLayout(deviceWidth, deviceHeight);
        } else if (ResponsiveUtil.isTablet(context)) {
          return _buildTabletLayout(deviceWidth, deviceHeight);
        } else {
          return _buildDesktopLayout(deviceWidth, deviceHeight);
        }
      },
    );
  }

  Widget _buildMobileLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      containerMarginTop: deviceHeight * 0.03,
    );
  }

  Widget _buildTabletLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      containerMarginTop: deviceHeight * 0.05,
    );
  }

  Widget _buildDesktopLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      containerMarginTop: deviceHeight * 0.05,
    );
  }

  Widget _buildLayout({required double containerMarginTop}) {
    final groupId = widget.groupId;
    final groupProfile = ref.watch(groupSettingNotifierProvider(groupId));
    if (groupProfile == null) {
      return const SizedBox.shrink();
    }
    final loadingErrorMessage = ref.watch(loadingErrorMessageProvider);

    return CupertinoPageScaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 246),
      navigationBar: GroupSettingNavigationBar(groupId: groupId),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            child: Container(
              alignment: AlignmentDirectional.center,
              margin: EdgeInsets.only(top: containerMarginTop),
              child: Column(
                children: [
                  NameAndImageSettingSection(
                    loadingErrorMessage: loadingErrorMessage,
                    imagePath: groupProfile.image,
                    name: groupProfile.name,
                    placeholder: 'group name',
                  ),
                  const SizedBox(height: 10),
                  GroupSettingMemberSection(groupId: groupId),
                  const SizedBox(height: 20),
                  GroupSettingScheduleSection(
                    groupId: groupId,
                    groupName: groupProfile.name,
                  ),
                  const SizedBox(height: 20),
                  GroupSettingSaveButton(
                    groupId: groupId,
                    groupName: groupProfile.name,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
