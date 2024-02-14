import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../schedule_create_controller.dart';
import 'modal_controller.dart';

class GroupPickerModal extends ConsumerStatefulWidget {
  const GroupPickerModal({
    super.key,
    required this.groupIdList,
  });
  final List<String> groupIdList;
  @override
  ConsumerState createState() => _GroupPickerModalState();
}

class _GroupPickerModalState extends ConsumerState<GroupPickerModal> {
  @override
  void initState() {
    super.initState();
    // 選択肢が1つだけの場合、自動的にその選択肢を選択。
    if (widget.groupIdList.length == 1) {
      final id = widget.groupIdList[0];
      final scheduleNotifier = ref.read(createGroupScheduleProvider.notifier);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        scheduleNotifier.setGroupId(id);
        final asyncGroupWithIdList = await ref
            .read(readGroupWithIdModalProvider(widget.groupIdList).future);

        ref.read(groupNameProvider.notifier).state =
            asyncGroupWithIdList[0].groupProfile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupIdList = widget.groupIdList;
    final scheduleNotifier = ref.watch(createGroupScheduleProvider.notifier);
    final asyncGroupWithIdList =
        ref.watch(readGroupWithIdModalProvider(groupIdList));

    return Container(
      height: 200,
      width: 360,
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Column(
        children: [
          asyncGroupWithIdList.when(
            data: (groupDataList) {
              if (groupDataList.isEmpty) {
                return const SizedBox.shrink();
              }
              return CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  final id = groupDataList[index].groupId;
                  final name = groupDataList[index].groupProfile.name;
                  scheduleNotifier.setGroupId(id);
                  ref.watch(groupNameProvider.notifier).state = name;
                },
                children: groupDataList
                    .map(
                      (groupWithId) => Center(
                        child: Text(
                          groupWithId.groupProfile.name,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Text('$error'),
          ),
          CupertinoButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
