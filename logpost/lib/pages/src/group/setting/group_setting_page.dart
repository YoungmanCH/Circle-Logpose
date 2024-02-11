import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controller/entities/device/image_controller.dart';
import '../../home/home_page.dart';
import '../../popup/member_add/member_add.dart';
import '../../popup/schedule_create/schedule_create.dart';
import '../../popup/schedule_create/schedule_create_controller.dart';
import '../create/parts/components/group_contents_controller.dart';
import 'group_setting_controller.dart';
import 'parts/group_member_image.dart';
import 'parts/schedule_card.dart';

class GroupSettingPage extends ConsumerStatefulWidget {
  const GroupSettingPage({
    super.key,
    required this.groupId,
  });
  final String groupId;

  @override
  ConsumerState<GroupSettingPage> createState() => _GroupSettingPageState();
}

class _GroupSettingPageState extends ConsumerState<GroupSettingPage> {
  File? image;

  ///画像を選択する関数。
  Future<String> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return 'no image';
      }
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      return 'Success: selected image.';
    } on PlatformException catch (e) {
      debugPrint('Failed: $e');
      return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupId = widget.groupId;
    final groupAdminProfileList =
        ref.watch(groupAdminProfileListProvider(groupId));
    final groupMembershipProfileList =
        ref.watch(groupMembershipProfileListProvider(groupId));

    final groupProfile = ref.watch(groupSettingProvider(groupId));
    final groupProfileNotifier =
        ref.watch(groupSettingProvider(groupId).notifier);

    final groupSchedules = ref.watch(readGroupScheduleAndIdProvider(groupId));
    final groupScheduleNotifier =
        ref.watch(createGroupScheduleProvider.notifier);

    return ColoredBox(
      color: const Color.fromARGB(255, 233, 233, 246),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 80,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // init
                      await groupProfileNotifier.initProfile();
                      ref.watch(scheduleDeleteModeProvider.notifier).state =
                          false;
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(
                        context,
                        CupertinoPageRoute<CupertinoPageRoute<dynamic>>(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.back,
                          size: 25,
                          color: Color(0xFF7B61FF),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          child: const Text(
                            '戻る',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 40,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFD9D9D9),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                      color: const Color(0xFF7B61FF),
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: const Center(
                        child: Text(
                          '団体編集',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      await showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text('団体を削除しますか?'),
                            content: const Text('削除後、元に戻すことはできません。'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.delete_forever,
                      color: Color(0xFF7B61FF),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 3),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              width: 375,
              height: 203,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 20, 60, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (groupProfile?.image != null)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: groupProfile!.image.startsWith('http')
                                    ? NetworkImage(groupProfile.image)
                                    : AssetImage(groupProfile.image)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          )
                        else
                          const Icon(
                            Icons.group,
                            size: 70,
                            color: Colors.grey,
                          ),
                        const Icon(
                          Icons.cached_sharp,
                          size: 40,
                          color: Colors.grey,
                        ),
                        CupertinoButton(
                          onPressed: () async {
                            final imageGetResult = await pickImage();
                            if (imageGetResult == 'Failed') {
                              if (!mounted) {
                                return;
                              }
                              await showPhotoAccessDeniedDialog(context);
                            }
                            if (image != null) {
                              await groupProfileNotifier.changeProfile(image!);
                            }
                          },
                          child: const SizedBox(
                            child: Icon(
                              Icons.image,
                              size: 70,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 272,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 219, 251),
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 10,
                      ),
                      child: CupertinoTextField(
                        controller: groupProfileNotifier.groupNameController,
                        prefix: const Icon(
                          Icons.create_sharp,
                          color: Color(0xFF6D6D6D),
                        ),
                        style: const TextStyle(fontSize: 16),
                        placeholder: '団体名',
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 244, 219, 251),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 95,
              width: 383,
              child: Stack(
                children: [
                  Container(
                    width: 371,
                    height: 77,
                    margin: const EdgeInsets.only(top: 10, left: 6),
                    padding: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 3,
                          offset: Offset(0, 3),
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'メンバー',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9A9A9A),
                            ),
                          ),
                          Row(
                            children: [
                              groupAdminProfileList.when(
                                data: (membershipProfiles) {
                                  return Column(
                                    children: membershipProfiles
                                        .map((membershipProfile) {
                                      return membershipProfile != null
                                          ? GroupMemberImage(
                                              userProfile: membershipProfile,
                                            )
                                          : const SizedBox.shrink();
                                    }).toList(),
                                  );
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (error, stack) => Text('$error'),
                              ),
                              groupMembershipProfileList.when(
                                data: (membershipProfiles) {
                                  return Row(
                                    children: membershipProfiles
                                        .map((membershipProfile) {
                                      return membershipProfile != null
                                          ? GroupMemberImage(
                                              userProfile: membershipProfile,
                                            )
                                          : const SizedBox.shrink();
                                    }).toList(),
                                  );
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (error, stack) => Text('$error'),
                              ),

                              //追加したユーザーを表示しています。
                              ...ref.watch(setGroupMemberListProvider).map(
                                    (member) => groupProfile != null
                                        ? GroupMemberImage(
                                            userProfile: member,
                                          )
                                        : const Text('No member'),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -15,
                    right: -15,
                    child: CupertinoButton(
                      onPressed: () async {
                        await showCupertinoModalPopup<AddMember>(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: AddMember(
                                groupId: groupId,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8EB61),
                          borderRadius: BorderRadius.circular(44),
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.person_add,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 390,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 3),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      width: 374,
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15, top: 15),
                            child: Row(
                              children: [
                                Text(
                                  '予定一覧',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              width: 330,
                              height: 180,
                              padding: const EdgeInsets.only(
                                right: 5,
                                left: 5,
                                bottom: 5,
                              ),
                              child: GridView.count(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 6,
                                mainAxisSpacing: 12,
                                children: groupSchedules.when(
                                  data: (groupSchedule) {
                                    if (groupSchedule.isEmpty) {
                                      return const [SizedBox.shrink()];
                                    }
                                    return groupSchedule.map((schedule) {
                                      return groupAdminProfileList.when(
                                        data: (membershipProfiles) {
                                          return ScheduleCard(
                                            groupId: groupId,
                                            schedule: schedule,
                                            groupName: groupProfileNotifier
                                                .groupNameController.text,
                                            groupMemberList: membershipProfiles,
                                          );
                                        },
                                        loading: () => const SizedBox.shrink(),
                                        error: (error, stack) => Text('$error'),
                                      );
                                    }).toList();
                                  },
                                  loading: () => const [SizedBox.shrink()],
                                  error: (error, stack) => [Text('$error')],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          groupScheduleNotifier.setGroupId(groupId);
                          ref.watch(groupNameProvider.notifier).state =
                              groupProfileNotifier.groupNameController.text;
                          await showCupertinoModalPopup<ScheduleCreate>(
                            context: context,
                            builder: (BuildContext context) {
                              return const ScheduleCreate();
                            },
                          );
                        },
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(scheduleDeleteModeProvider.notifier).state =
                              !ref.watch(scheduleDeleteModeProvider);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEB6161),
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.calendar_badge_minus,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () async {
                final success = await UpdateGroupSettings.update(
                  groupId,
                  groupProfileNotifier.groupNameController.text,
                  null,
                  image,
                  ref,
                );
                if (!success) {
                  return;
                }
                // init
                ref.watch(scheduleDeleteModeProvider.notifier).state = false;

                if (!mounted) {
                  return;
                }
                await Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute<CupertinoPageRoute<dynamic>>(
                    builder: (context) => const HomePage(),
                  ),
                  (_) => false,
                );
              },
              color: const Color(0xFF7B61FF),
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: 117,
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.download,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('変更を保存'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}