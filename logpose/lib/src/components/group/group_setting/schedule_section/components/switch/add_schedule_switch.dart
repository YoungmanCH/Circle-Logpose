import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../controllers/providers/group/group/group_setting_provider.dart';
import '../../../../../../controllers/providers/group/text/selected_group_name_provider.dart';
import '../../../../../popup/create_schedule/create_schedule.dart';

class AddScheduleSwitch extends ConsumerWidget {
  const AddScheduleSwitch({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onTap() async {
      final groupProfileNotifier =
          ref.watch(groupSettingProvider(groupId).notifier);
      ref.watch(selectedGroupNameProvider.notifier).state =
          groupProfileNotifier.groupNameController.text;
      await showCupertinoModalPopup<CreateSchedule>(
        context: context,
        builder: (BuildContext context) {
          return CreateSchedule(groupId: groupId);
        },
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFD8EB61),
          borderRadius: BorderRadius.circular(44),
        ),
        child: const Center(
          child: Icon(
            CupertinoIcons.calendar_badge_plus,
            size: 25,
            color: CupertinoColors.black,
          ),
        ),
      ),
    );
  }
}