import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/providers/error/password_error_message_provider.dart';
import '../../controllers/providers/user/account/password_provider.dart';
import '../../views/user/user_setting_page.dart';

class SaveButton extends ConsumerStatefulWidget {
  const SaveButton({super.key});
  @override
  ConsumerState<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<SaveButton> {
  Future<String?> _updatePassword() async {
    return ref.watch(passwordSettingProvider).update(ref);
  }

  Future<void> _pushAndRemoveUntil() async {
    await Navigator.push(
      context,
      CupertinoPageRoute<CupertinoPageRoute<dynamic>>(
        builder: (context) => const UserSettingPage(),
      ),
    );
  }

  Future<void> _save() async {
    final errorMessage = await _updatePassword();
    if (errorMessage != null) {
      ref.watch(passwordErrorMessageProvider.notifier).state = errorMessage;
      return;
    }

    if (!mounted) {
      return;
    }
    await _pushAndRemoveUntil();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 196,
      height: 58,
      margin: const EdgeInsets.only(top: 50),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: const Color.fromARGB(255, 123, 97, 255),
        onPressed: _save,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.download, size: 30),
            ),
            const Text(
              '変更を保存',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
