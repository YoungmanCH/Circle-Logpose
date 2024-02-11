import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../src/group/create/group_create_page.dart';

class GroupCreateTab extends ConsumerStatefulWidget {
  const GroupCreateTab({super.key});

  @override
  ConsumerState createState() => GroupCreateTabState();
}

class GroupCreateTabState extends ConsumerState<GroupCreateTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute<CupertinoPageRoute<dynamic>>(
            builder: (context) => const GroupCreatePage(),
          ),
          (_) => false,
        );
      },
      child: Container(
        width: 180,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 33,
              height: 33,
              decoration: BoxDecoration(
                color: const Color.fromARGB(210, 229, 236, 157),
                borderRadius: BorderRadius.circular(33),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 5,
              ),
              child: const Text(
                '団体作成',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(210, 8, 86, 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}