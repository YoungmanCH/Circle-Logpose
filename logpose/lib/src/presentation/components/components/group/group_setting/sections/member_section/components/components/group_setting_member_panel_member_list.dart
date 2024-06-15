import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../../../utils/responsive_util.dart';
import '../../../../../../../../notifiers/group_member_list_setter_notifier.dart';

import '../../../../../../../common/custom_image/custom_image.dart';

import '../../../../../../../common/group_member_tile/group_member_tile.dart';
import 'components/group_member_image_list.dart';

class GroupSettingMemberPanelMemberList extends ConsumerStatefulWidget {
  const GroupSettingMemberPanelMemberList({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState createState() => _GroupSettingMemberPanelMemberListState();
}

class _GroupSettingMemberPanelMemberListState
    extends ConsumerState<GroupSettingMemberPanelMemberList> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtil.isMobile(context)) {
          return _buildMobileLayout(deviceWidth);
        } else if (ResponsiveUtil.isTablet(context)) {
          return _buildTabletLayout(deviceWidth);
        } else {
          return _buildDesktopLayout(deviceWidth);
        }
      },
    );
  }

  Widget _buildMobileLayout(double deviceWidth) {
    return _buildLayout(deviceWidth * 0.08);
  }

  Widget _buildTabletLayout(double deviceWidth) {
    return _buildLayout(deviceWidth * 0.055);
  }

  Widget _buildDesktopLayout(double deviceWidth) {
    return _buildLayout(deviceWidth * 0.045);
  }

  Widget _buildLayout(double imageSize) {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: 0.8,
        child: Row(
          children: [
            GroupMemberImageList(
              role: GroupRoleType.admin,
              groupId: widget.groupId,
            ),
            GroupMemberImageList(
              role: GroupRoleType.membership,
              groupId: widget.groupId,
            ),
            ...ref.watch(groupMemberListSetterNotifierProvider).map(
                  (memberProfile) => CustomImage(
                    imagePath: memberProfile.image,
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
