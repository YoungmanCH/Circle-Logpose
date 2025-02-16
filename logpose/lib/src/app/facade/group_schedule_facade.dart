import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/group_schedule.dart';
import '../../domain/entity/user_profile.dart';

import '../../domain/interface/group_schedule/i_group_id_with_schedule_id_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_and_id_list_listen_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_and_id_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_creation_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_delete_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_id_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_listen_id_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_update_use_case.dart';
import '../../domain/interface/group_schedule/i_group_schedule_use_case.dart';

import '../../domain/model/group_schedule_and_id_model.dart';
import '../../domain/model/schedule_params_model.dart';

import '../../domain/usecase/usecase_group_schedule/group_id_with_schedule_id_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_and_id_list_listen_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_and_id_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_creation_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_delete_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_id_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_listen_id_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_update_use_case.dart';
import '../../domain/usecase/usecase_group_schedule/group_schedule_use_case.dart';

final groupScheduleFacadeProvider = Provider<GroupScheduleFacade>(
  (ref) => GroupScheduleFacade(ref: ref),
);

class GroupScheduleFacade {
  GroupScheduleFacade({required this.ref})
      : _groupScheduleCreationUseCase =
            ref.read(groupScheduleCreationUseCaseProvider),
        _groupScheduleIdUseCase = ref.read(groupScheduleIdUseCaseProvider),
        _groupScheduleAndIdUseCase =
            ref.read(groupScheduleAndIdUseCaseProvider),
        _groupScheduleUseCase = ref.read(groupScheduleUseCaseProvider),
        _groupIdWithScheduleIdUseCase =
            ref.read(groupIdWithScheduleIdUseCaseProvider),
        _groupScheduleUpdateUseCase =
            ref.read(groupScheduleUpdateUseCaseProvider),
        _groupScheduleDeleteUseCase =
            ref.read(groupScheduleDeleteUseCaseProvider),
        _groupScheduleIdListenUseCase =
            ref.read(groupScheduleListenIdUseCaseProvider),
        _groupScheduleAndIdListListenUseCase =
            ref.read(groupScheduleAndIdListListenUseCaseProvider);

  final Ref ref;
  final IGroupScheduleCreationUseCase _groupScheduleCreationUseCase;
  final IGroupScheduleIdUseCase _groupScheduleIdUseCase;
  final IGroupScheduleAndIdUseCase _groupScheduleAndIdUseCase;
  final IGroupScheduleUseCase _groupScheduleUseCase;
  final IGroupIdWithScheduleIdUseCase _groupIdWithScheduleIdUseCase;
  final IGroupScheduleUpdateUseCase _groupScheduleUpdateUseCase;
  final IGroupScheduleDeleteUseCase _groupScheduleDeleteUseCase;
  final IGroupScheduleListenIdUseCase _groupScheduleIdListenUseCase;
  final IGroupScheduleAndIdListListenUseCase
      _groupScheduleAndIdListListenUseCase;

  Future<String?> createSchedule(ScheduleParams scheduleViewParams) async {
    return _groupScheduleCreationUseCase.createSchedule(scheduleViewParams);
  }

  Future<List<String?>> fetchAllGroupScheduleId(String groupId) async {
    return _groupScheduleIdUseCase.fetchAllGroupScheduleId(groupId);
  }

  Future<GroupSchedule> fetchGroupSchedule(String groupScheduleId) async {
    return _groupScheduleUseCase.fetchGroupSchedule(groupScheduleId);
  }

  Future<GroupScheduleAndId?> fetchGroupScheduleAndId(String scheduleId) async {
    return _groupScheduleAndIdUseCase.fetchGroupScheduleAndId(scheduleId);
  }

  Future<List<GroupScheduleAndId?>> fetchGroupScheduleAndIdList(
    List<String?> scheduleIdList,
  ) async {
    return _groupScheduleAndIdUseCase
        .fetchGroupScheduleAndIdList(scheduleIdList);
  }

  Future<String> fetchGroupIdWithScheduleId(String scheduleId) async {
    return _groupIdWithScheduleIdUseCase.fetchGroupIdWithScheduleId(scheduleId);
  }

  Future<String?> updateSchedule(
    String docId,
    ScheduleParams scheduleParams,
  ) async {
    return _groupScheduleUpdateUseCase.updateSchedule(docId, scheduleParams);
  }

  Future<void> deleteSchedule(
    List<UserProfile?> groupMemberList,
    String groupScheduleId,
  ) async {
    return _groupScheduleDeleteUseCase.deleteSchedule(
      groupMemberList,
      groupScheduleId,
    );
  }

  Stream<List<String?>> listenAllScheduleId(String groupId) async* {
    yield* _groupScheduleIdListenUseCase.listenAllScheduleId(groupId);
  }

  Stream<List<GroupScheduleAndId?>> listenAllGroupScheduleAndIdList(
    String groupId,
  ) {
    return _groupScheduleAndIdListListenUseCase.listenAllGroupScheduleAndIdList(
      groupId,
    );
  }
}
