import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../handlers/user_setting_save_button_handler.dart';

class UserSettingSaveButton extends ConsumerStatefulWidget {
  const UserSettingSaveButton({super.key, required this.name});

  final String name;

  @override
  ConsumerState createState() => _UserSettingSaveButtonState();
}

class _UserSettingSaveButtonState extends ConsumerState<UserSettingSaveButton> {
  Future<void> _handleUpdate() async {
    final handler = UserSettingSaveButtonHandler(
      context: context,
      ref: ref,
      name: widget.name,
    );
    await handler.handleUpdateUserSetting();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: _handleUpdate,
      color: const Color(0xFF7B61FF),
      borderRadius: BorderRadius.circular(30),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: 110,
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(0, 0, 0, 0),
              ),
              child: const Icon(
                CupertinoIcons.check_mark,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              '変更を保存',
              style: TextStyle(color: CupertinoColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
