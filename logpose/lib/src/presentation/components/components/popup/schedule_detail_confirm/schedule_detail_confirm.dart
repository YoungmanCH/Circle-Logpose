import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../utils/responsive_util.dart';
import '../../../../../../utils/schedule_response.dart';

import '../../../../../domain/entity/group_profile.dart';
import '../../../../../domain/entity/group_schedule.dart';

import '../../../common/custom_image/custom_image.dart';
import '../../../common/popup_background.dart';
import '../../../common/popup_header_color.dart';
import '../../../common/response_icon_and_text.dart';
import '../../../common/schedule_time_view.dart';
import '../../../common/schedule_title_view.dart';

import 'components/member/responsed_members.dart';
import 'components/schedule_detail_view.dart';
import 'components/schedule_place_view.dart';

class ScheduleDetailConfirm extends ConsumerStatefulWidget {
  const ScheduleDetailConfirm({
    super.key,
    required this.responseType,
    required this.group,
    required this.scheduleId,
    required this.schedule,
  });

  final ResponseType? responseType;
  final GroupProfile group;
  final String scheduleId;
  final GroupSchedule schedule;

  @override
  ConsumerState createState() => _ScheduleDetailConfirmState();
}

class _ScheduleDetailConfirmState extends ConsumerState<ScheduleDetailConfirm> {
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
      horizontalPadding: deviceWidth * 0.06,
      sizedBoxWidth: deviceWidth * 0.88,
      sizedBoxHeight: deviceHeight * 0.55,
      customImageSize: deviceWidth * 0.12,
    );
  }

  Widget _buildTabletLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      horizontalPadding: deviceWidth * 0.06,
      sizedBoxWidth: deviceWidth * 0.88,
      sizedBoxHeight: deviceHeight * 0.55,
      customImageSize: deviceWidth * 0.06,
    );
  }

  Widget _buildDesktopLayout(double deviceWidth, double deviceHeight) {
    return _buildLayout(
      horizontalPadding: deviceWidth * 0.06,
      sizedBoxWidth: deviceWidth * 0.88,
      sizedBoxHeight: deviceHeight * 0.55,
      customImageSize: deviceWidth * 0.05,
    );
  }

  Widget _buildLayout({
    required double horizontalPadding,
    required double sizedBoxWidth,
    required double sizedBoxHeight,
    required double customImageSize,
  }) {
    final responseType = widget.responseType;
    final group = widget.group;
    final groupSchedule = widget.schedule;
    final groupScheduleId = widget.scheduleId;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: CupertinoPopupSurface(
            child: SizedBox(
              width: sizedBoxWidth,
              height: sizedBoxHeight,
              child: Stack(
                children: [
                  const PopupBackground(),
                  PopupHeaderColor(color: groupSchedule.color),
                  Positioned(
                    top: 70,
                    left: 30,
                    child: CustomImage(
                      imagePath: group.image,
                      width: customImageSize,
                      height: customImageSize,
                    ),
                  ),
                  ResponseIconAndText(responseType: responseType),
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScheduleTitleView(title: groupSchedule.title),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ScheduleTimeView(groupSchedule: groupSchedule),
                        ),
                        ResponsedMembers(
                          groupProfile: group,
                          scheduleId: groupScheduleId,
                          groupSchedule: groupSchedule,
                        ),
                        SchedulePlaceView(place: groupSchedule.place),
                        ScheduleDetailView(detail: groupSchedule.detail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
