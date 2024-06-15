import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../../../utils/responsive_util.dart';

import 'components/group_schedule_tile_list_builder.dart';

class GroupSettingScheduleSectionTileList extends ConsumerStatefulWidget {
  const GroupSettingScheduleSectionTileList({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  final String groupId;
  final String groupName;

  @override
  ConsumerState<GroupSettingScheduleSectionTileList> createState() =>
      _GroupSettingScheduleSectionTileListState();
}

class _GroupSettingScheduleSectionTileListState
    extends ConsumerState<GroupSettingScheduleSectionTileList> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

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
      containerWidth: deviceWidth * 0.7,
      containerHeight: deviceHeight * 0.34,
    );
  }

  Widget _buildTabletLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      containerWidth: deviceWidth * 0.7,
      containerHeight: deviceHeight * 0.38,
    );
  }

  Widget _buildDesktopLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      containerWidth: deviceWidth * 0.7,
      containerHeight: deviceHeight * 0.38,
    );
  }

  Widget _buildLayout({
    required double containerWidth,
    required double containerHeight,
  }) {
    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: const EdgeInsets.only(bottom: 5),
      child: GroupScheduleTileListBuilder(
        groupId: widget.groupId,
        groupName: widget.groupName,
      ),
    );
  }
}
