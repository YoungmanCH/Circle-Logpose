import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../validation/validator/validator_controller.dart';

import '../../domain/entity/user_profile.dart';

import '../controllers/auth/auth_management_controller.dart';
import '../controllers/group_membership/group_membership_management_controller.dart';
import '../controllers/user/user_management_controller.dart';

final searchUserNotifierProvider =
    StateNotifierProvider.family<_SearchUserNotifier, UserProfile?, String?>(
  _SearchUserNotifier.new,
);

class _SearchUserNotifier extends StateNotifier<UserProfile?> {
  _SearchUserNotifier(this.ref, this.groupId)
      : _authController = ref.read(authManagementControllerProvider),
        _userManagementController = ref.read(userManagementControllerProvider),
        _membershipController =
            ref.read(groupMembershipManagementControllerProvider),
        _validator = ref.read(validatorControllerProvider),
        super(null) {
    _init();
  }

  final Ref ref;
  final String? groupId;
  final AuthManagementController _authController;
  final UserManagementController _userManagementController;
  final GroupMembershipManagementController _membershipController;
  final ValidatorController _validator;

  final TextEditingController accountIdController = TextEditingController();
  UserProfile? _user;
  Set<String> addedMemberIds = {};

  void setMemberState() {
    final accountId = accountIdController.text;
    addedMemberIds.add(accountId);
    accountIdController.clear();
  }

  void removeMemberState(String accountId) {
    addedMemberIds.remove(accountId);
    accountIdController.clear();
  }

  Future<void> _init() async {
    accountIdController.addListener(_onAccountIdChanged);
  }

  Future<void> _onAccountIdChanged() async {
    final validationError = _validateAccountId();
    if (validationError != null) {
      state = null;
      return;
    }

    await _memberAddController();
  }

  String? _validateAccountId() {
    final accountId = accountIdController.text;
    return _validator.validateAccountId(accountId);
  }

  Future<void> _memberAddController() async {
    final userId = await _authController.fetchCurrentUserId();
    final myAccountProfile =
        await _userManagementController.fetchUserProfile(userId);
    final accountId = accountIdController.text;
    _user = await _userManagementController
        .fetchUserProfileWithAccountId(accountId);

    // アカウントIDが見つからない場合は、nullを返す。
    if (_user == null) {
      state = null;
      return;
    }

    // 自分のアカウントを検索した場合は、何も返さない。
    if (myAccountProfile == null ||
        myAccountProfile.accountId == _user!.accountId) {
      state = null;
      return;
    }

    // 既にGroup memberの場合は何も返さない。
    if (groupId != null) {
      final isAlreadyMember = await _noReturnIfUserIsMember(accountId);
      if (isAlreadyMember) {
        state = null;
        return;
      }
    }

    // 既に追加済みのメンバーの場合は何も返さない。
    if (addedMemberIds.contains(accountId)) {
      state = null;
      return;
    }

    _setUserProfile();
  }

  Future<bool> _noReturnIfUserIsMember(String accountId) async {
    final userId =
        await _userManagementController.fetchUserDocIdWithAccountId(accountId);
    return await _membershipController.doesMemberExist(groupId!, userId);
  }

  void _setUserProfile() {
    state = _user;
  }
}
