import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../group/setting/group_setting_page.dart';
import 'controller/joined_group_controller.dart';

class GroupBox extends ConsumerStatefulWidget {
  const GroupBox({super.key, required this.groupId});

  final String groupId;
  @override
  ConsumerState createState() => GroupBoxState();
}

class GroupBoxState extends ConsumerState<GroupBox> {
  @override
  Widget build(BuildContext context) {
    final groupId = widget.groupId;
    final asyncGroupProfileList = ref.watch(readGroupWithIdProvider(groupId));

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute<CupertinoPageRoute<dynamic>>(
            builder: (context) => GroupSettingPage(groupId: groupId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white,
        ),
        child: asyncGroupProfileList.when(
          data: (groupData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: groupData.groupProfile.image,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    groupData.groupProfile.name,
                    style: const TextStyle(
                      fontSize: 20,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => Text('$error'),
        ),
      ),
    );
  }
}
