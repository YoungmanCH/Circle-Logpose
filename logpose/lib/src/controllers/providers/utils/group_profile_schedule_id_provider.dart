
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/group/database/group.dart';
import '../../../models/group/group_profile_with_schedule_with_id_model.dart';
import '../../../services/auth/auth_controller.dart';
import '../../../services/database/crud/group_controller.dart';
import '../../../services/database/crud/group_membership_controller.dart';
import '../../../services/database/crud/group_schedule_controller.dart';

// このコードでは、BLoCパターンの構造をしたRxDartを使用している。以下リンクは参考サイトである。
// https://qiita.com/tetsufe/items/521014ddc59f8d1df581

final watchGroupProfileWithScheduleWithIdProvider =
    StreamProvider<List<GroupProfileWithScheduleWithId>>((ref) async* {
  final userDocId = await AuthController.getCurrentUserId();
  if (userDocId == null) {
    throw Exception('User not logged in.');
  }

  final groupMembershipsStream =
      GroupMembershipController.readAllWithUserId(userDocId);

  await for (final groupMembershipList in groupMembershipsStream) {
    final scheduleIdListStreamList =
        <Stream<(List<String?>, String, GroupProfile)>>[];
    for (final membership in groupMembershipList) {
      if (membership == null) {
        continue;
      }

      final groupProfile = await GroupController.readFuture(membership.groupId);
      if (groupProfile == null) {
        continue;
      }

      final scheduleIdList = GroupScheduleController.watchAllScheduleId(
        membership.groupId,
      ).map(
        (scheduleIdList) => (
          scheduleIdList,
          membership.groupId,
          groupProfile,
        ),
      );
      scheduleIdListStreamList.add(scheduleIdList);
    }

    /// <()> is named 'Record type' or 'Turple type'.
    /// To access element by $index.
    /// Example $1 is [0].
    final combStream =
        CombineLatestStream.list<(List<String?>, String, GroupProfile)>(
      scheduleIdListStreamList,
    );
    await for (final combList in combStream) {
      final combinedSchedules = <GroupProfileWithScheduleWithId>[];
      for (final record in combList) {
        final scheduleIdList = record.$1;
        final groupId = record.$2;
        final groupProfile = record.$3;
        for (final scheduleId in scheduleIdList) {
          if (scheduleId == null) {
            continue;
          }
          final schedule = await GroupScheduleController.read(scheduleId);

          if (schedule != null) {
            combinedSchedules.add(
              GroupProfileWithScheduleWithId(
                groupScheduleId: scheduleId,
                groupSchedule: schedule,
                groupId: groupId,
                groupProfile: groupProfile,
              ),
            );
          }
        }
      }
      yield combinedSchedules;
    }
  }
});