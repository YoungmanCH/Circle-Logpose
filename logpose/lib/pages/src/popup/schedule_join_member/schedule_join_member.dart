import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/common/color_exchanger.dart';
import '../../../../controller/common/time_controller.dart';
import '../../../../database/group/group/group.dart';
import '../../../../database/group/schedule/schedule/schedule.dart';
import '../../../../database/user/user.dart';
import 'parts/join_member.dart';

class ScheduleJoinMember extends ConsumerStatefulWidget {
  const ScheduleJoinMember({
    super.key,
    required this.groupProfile,
    required this.memberProfiles,
    required this.scheduleId,
    required this.schedule,
  });

  final String scheduleId;
  final GroupProfile groupProfile;
  final List<UserProfile?> memberProfiles;
  final GroupSchedule schedule;
  @override
  ConsumerState<ScheduleJoinMember> createState() {
    return ScheduleJoinMemberState();
  }
}

class ScheduleJoinMemberState extends ConsumerState<ScheduleJoinMember> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    final groupProfile = widget.groupProfile;
    final memberProfiles = widget.memberProfiles;
    final scheduleId = widget.scheduleId;
    final schedule = widget.schedule;

    return Padding(
      padding: EdgeInsets.only(
        bottom: deviceHeight * 0.02,
        right: 32,
        left: 32,
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: SizedBox(
            width: deviceWidth * 0.9,
            height: deviceHeight * 0.55,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: deviceHeight * 0.11,
                      color: hexToColor(schedule.color),
                    ),
                    Container(
                      height: deviceHeight * 0.44,
                      color: Colors.white,
                    ),
                  ],
                ),
                Positioned(
                  top: 80,
                  left: 24,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: groupProfile.image.startsWith('http')
                            ? NetworkImage(groupProfile.image)
                            : AssetImage(groupProfile.image) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 140),
                        child: Text(
                          schedule.title,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              formatDateTimeExcYearHourMinuteDay(
                                schedule.startAt,
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            formatDateTimeExcYearMonthDay(
                              schedule.startAt,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const Text(
                            '-',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            formatDateTimeExcYearMonthDay(
                              schedule.endAt,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.group,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '参加メンバー',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GridView.count(
                        mainAxisSpacing: 8,
                        childAspectRatio: 5.5,
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10),
                        children: [
                          ...memberProfiles
                              .whereType<UserProfile>()
                              .map((userProfile) {
                            return JoinMember(
                              scheduleId: scheduleId,
                              userProfile: userProfile,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}