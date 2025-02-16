// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/group_creator_params_model.dart';

import '../components/common/loading_progress.dart';
import '../controllers/group/group_creation_and_update_controller.dart';

import '../navigations/to_schedule_list_and_joined_group_tab_slider.dart';

import '../notifiers/group_member_list_setter_notifier.dart';
import '../notifiers/image_path_set_notifier.dart';

import '../providers/text_field/name_field_provider.dart';

class GroupCreationSaveButtonHandler {
  GroupCreationSaveButtonHandler(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  Future<void> handleToCreate() async {
    _loadingProgress(true);
    final errorMessage = await _createGroup();
    _loadingProgress(false);

    if (errorMessage != null) {
      _displayErrorMessage(errorMessage);
      return;
    }

    await _moveToPage();
  }

  void _loadingProgress(bool loading) {
    ref.read(loadingProgressControllerProvider).loadingProgress = loading;
  }

  Future<String?> _createGroup() {
    final groupData = GroupCreatorParams(
      groupName: ref.read(nameFieldProvider('')).text,
      image: ref.read(imagePathSetNotifierProvider),
      description: null,
      memberList: ref.read(groupMemberListSetterNotifierProvider),
    );
    final groupController = ref.read(groupCreationAndUpdateControllerProvider);
    
    return groupController.createGroup(groupData);
  }

  void _displayErrorMessage(String errorMessage) {
    ref.read(loadingProgressControllerProvider).loadingErrorMessage =
        errorMessage;
  }

  Future<void> _moveToPage() async {
    if (context.mounted) {
      final navigator = ToScheduleListAndJoinedGroupTabSliderNavigator(context);
      await navigator.moveToPage();
    }
  }
}
