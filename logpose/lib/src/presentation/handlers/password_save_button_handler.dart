// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth/auth_update_controller.dart';
import '../navigations/to_user_setting_page_navigator.dart';

import '../providers/error_message/password_error_message_provider.dart';
import '../providers/text_field/new_password_field_provider.dart';
import '../providers/text_field/password_field_provider.dart';

class PasswordSaveButtonHandler {
  const PasswordSaveButtonHandler({required this.context, required this.ref});

  final BuildContext context;
  final WidgetRef ref;

  Future<void> handlePassword() async {
    final errorMessage = await _updatePassword();

    if (errorMessage != null) {
      _setErrorMessage(errorMessage);
      return;
    }

    await _moveToPage();
  }

  Future<String?> _updatePassword() async {
    final password = ref.read(passwordFieldProvider('')).text;
    final newPassword = ref.read(newPasswordFieldProvider).text;
    final passwordController = ref.read(authUpdateControllerProvider);

    return passwordController.updateUserPassword(password, newPassword);
  }

  void _setErrorMessage(String errorMessage) {
    ref.watch(passwordErrorMessageProvider.notifier).state = errorMessage;
  }

  Future<void> _moveToPage() async {
    if (context.mounted) {
      final navigator = ToUserSettingPageNavigator(context);
      await navigator.moveToPage();
    }
  }
}
