import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../utils/responsive_util.dart';

import 'components/group_setting_schedule_section_panel.dart';
import 'components/switch/schedule_addition_switch.dart';
import 'components/switch/schedule_delete_switch.dart';

class GroupSettingScheduleSection extends ConsumerStatefulWidget {
  const GroupSettingScheduleSection({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  final String groupId;
  final String groupName;

  @override
  ConsumerState createState() => _GroupSettingScheduleSectionState();
}

class _GroupSettingScheduleSectionState
    extends ConsumerState<GroupSettingScheduleSection> {
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
      sizedBoxWidth: deviceWidth * 0.89,
      sizedBoxHeight: deviceHeight * 0.38,
      deletionSwitchPositionTop: deviceHeight * 0.075,
    );
  }

  Widget _buildTabletLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      sizedBoxWidth: deviceWidth * 0.89,
      sizedBoxHeight: deviceHeight * 0.42,
      deletionSwitchPositionTop: deviceHeight * 0.095,
    );
  }

  Widget _buildDesktopLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      sizedBoxWidth: deviceWidth * 0.89,
      sizedBoxHeight: deviceHeight * 0.42,
      deletionSwitchPositionTop: deviceHeight * 0.1,
    );
  }

  Widget _buildLayout({
    required double sizedBoxWidth,
    required double sizedBoxHeight,
    required double deletionSwitchPositionTop,
  }) {
    final groupId = widget.groupId;
    final groupName = widget.groupName;

    return SizedBox(
      width: sizedBoxWidth,
      height: sizedBoxHeight,
      child: Stack(
        children: [
          GroupSettingScheduleSectionPanel(
            groupId: groupId,
            groupName: groupName,
          ),
          Positioned(
            top: 10,
            right: 0,
            child: ScheduleAdditionSwitch(
              groupId: groupId,
              groupName: groupName,
            ),
          ),
          Positioned(
            top: deletionSwitchPositionTop,
            right: 0,
            child: const ScheduleDeletionSwitch(),
          ),
        ],
      ),
    );
  }
}
