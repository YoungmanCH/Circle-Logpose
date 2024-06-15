import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../utils/responsive_util.dart';

import '../../../../../domain/model/group_profile_and_schedule_and_id_model.dart';

import '../../../../notifiers/group_member_schedule_notifier.dart';

import '../../../common/custom_image/custom_image.dart';

import 'components/date_label.dart';
import 'components/header/schedule_card_header.dart';
import 'components/response_buttons/response_buttons.dart';

class ScheduleCard extends ConsumerStatefulWidget {
  const ScheduleCard({super.key, required this.groupData});

  final GroupProfileAndScheduleAndId groupData;

  @override
  ConsumerState<ScheduleCard> createState() {
    return _GroupScheduleCardState();
  }
}

class _GroupScheduleCardState extends ConsumerState<ScheduleCard> {
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
    return _buildLayout(
      deviceWidth: deviceWidth,
      containerHeight: deviceWidth * 0.42,
      containerMarginTop: deviceWidth * 0.02,
      borderCircular: 35,
      dateLabelPositionTop: 0,
      dateLabelPositionLeft: 15,
      customImagePositionRight: 35,
      customImageSize: deviceWidth * 0.09,
    );
  }

  Widget _buildTabletLayout(double deviceWidth) {
    return _buildLayout(
      deviceWidth: deviceWidth,
      containerHeight: deviceWidth * 0.3,
      containerMarginTop: deviceWidth * 0.04,
      borderCircular: 55,
      dateLabelPositionTop: 5,
      dateLabelPositionLeft: 15,
      customImagePositionRight: 35,
      customImageSize: deviceWidth * 0.06,
    );
  }

  Widget _buildDesktopLayout(double deviceWidth) {
    return _buildLayout(
      deviceWidth: deviceWidth,
      containerHeight: deviceWidth * 0.25,
      containerMarginTop: deviceWidth * 0.04,
      borderCircular: 55,
      dateLabelPositionTop: deviceWidth * 0.02,
      dateLabelPositionLeft: 15,
      customImagePositionRight: 35,
      customImageSize: deviceWidth * 0.05,
    );
  }

  Widget _buildLayout({
    required double deviceWidth,
    required double containerHeight,
    required double containerMarginTop,
    required double borderCircular,
    required double dateLabelPositionTop,
    required double dateLabelPositionLeft,
    required double customImagePositionRight,
    required double customImageSize,
  }) {
    final groupProfileAndScheduleAndId = widget.groupData;
    final groupProfile = widget.groupData.groupProfile;
    final groupImage = widget.groupData.groupProfile.image;
    final groupSchedule = widget.groupData.groupSchedule;
    final groupScheduleId = widget.groupData.groupScheduleId;
    final userSchedule =
        ref.watch(groupMemberScheduleNotifierProvider(groupScheduleId));
    final isAttendance = userSchedule?.attendance ?? false;
    final isLeaveEarly = userSchedule?.leaveEarly ?? false;
    final isLateness = userSchedule?.lateness ?? false;
    final isAbsence = userSchedule?.absence ?? false;

    return Container(
      width: deviceWidth * 0.88,
      height: containerHeight,
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: containerMarginTop),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderCircular),
                color: CupertinoColors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ScheduleCardHeader(
                    groupSchedule: groupSchedule,
                    groupScheduleId: groupScheduleId,
                    groupProfile: groupProfile,
                  ),
                  ResponseButtons(
                    groupScheduleId: groupScheduleId,
                    groupProfile: groupProfile,
                    groupProfileAndScheduleAndId: groupProfileAndScheduleAndId,
                    isAttendance: isAttendance,
                    isLeaveEarly: isLeaveEarly,
                    isLateness: isLateness,
                    isAbsence: isAbsence,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: dateLabelPositionTop,
            left: dateLabelPositionLeft,
            child: DateLabel(
              groupSchedule: groupSchedule,
              deviceWidth: deviceWidth,
            ),
          ),
          Positioned(
            right: customImagePositionRight,
            child: CustomImage(
              imagePath: groupImage,
              width: customImageSize,
              height: customImageSize,
            ),
          ),
        ],
      ),
    );
  }
}
