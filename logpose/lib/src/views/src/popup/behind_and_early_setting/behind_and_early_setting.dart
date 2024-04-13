import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/group/group_profile_and_schedule_and_id_model.dart';

import '../../../../utils/color/color_exchanger.dart';
import '../../../../utils/time/time_utils.dart';

import 'components/join_time.dart';

class BehindAndEarlySetting extends ConsumerStatefulWidget {
  const BehindAndEarlySetting({
    super.key,
    required this.groupProfileAndScheduleAndId,
    required this.responseIcon,
    required this.responseText,
  });

  final GroupProfileAndScheduleAndId groupProfileAndScheduleAndId;
  final Icon responseIcon;
  final Text responseText;
  @override
  ConsumerState<BehindAndEarlySetting> createState() {
    return _BehindAndEarlySettingState();
  }
}

class _BehindAndEarlySettingState extends ConsumerState<BehindAndEarlySetting> {
  @override
  Widget build(BuildContext context) {
    final groupData = widget.groupProfileAndScheduleAndId;
    final groupSchedule = widget.groupProfileAndScheduleAndId.groupSchedule;
    final responseIcon = widget.responseIcon;
    final responseText = widget.responseText;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: SizedBox(
          width: 360,
          height: 340,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: hexToColor(groupSchedule.color),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(
                  top: 100,
                  left: 260,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: const Color(0xFFFBCEFF),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      responseIcon,
                      responseText,
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 100),
                              width: 220,
                              child: Text(
                                groupSchedule.title,
                                style: const TextStyle(
                                  fontSize: 30,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      formatDateTimeExcYearHourMinuteDay(
                                        groupSchedule.startAt,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatDateTimeExcYearMonthDay(
                                      groupSchedule.startAt,
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
                                      groupSchedule.endAt,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ScheduleJoinTime(
                        groupProfileAndScheduleAndId: groupData,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}