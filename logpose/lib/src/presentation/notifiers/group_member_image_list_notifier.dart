import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/responsive_util.dart';

import '../../domain/entity/user_profile.dart';

import '../components/common/custom_image/custom_image.dart';
import '../components/common/group_member_tile/group_member_tile.dart';

import '../providers/group/members/listen_group_admin_profile_list_provider.dart';
import '../providers/group/members/listen_group_member_profile_list_provider.dart';

final groupMemberImageListNotifierProvider = StateNotifierProvider.family<
    _GroupMemberImageListNotifier,
    List<Widget>,
    (GroupRoleType role, String groupId)>(
  (ref, args) => _GroupMemberImageListNotifier(ref, args.$1, args.$2),
);

class _GroupMemberImageListNotifier extends StateNotifier<List<Widget>> {
  _GroupMemberImageListNotifier(this.ref, this.role, this.groupId) : super([]) {
    _memberProfileList();
  }

  final Ref ref;
  final GroupRoleType role;
  final String groupId;

  Future<void> _memberProfileList() async {
    if (role == GroupRoleType.admin) {
      await _buildAdminProfileList();
    } else if (role == GroupRoleType.membership) {
      await _buildMembershipProfileList();
    }
  }

  Future<void> _buildAdminProfileList() async {
    final asyncGroupAdminProfileList =
        await ref.watch(listenGroupAdminProfileListProvider(groupId).future);

    state = _buildProfileImages(asyncGroupAdminProfileList);
  }

  Future<void> _buildMembershipProfileList() async {
    final asyncGroupMembershipProfileList = await ref
        .watch(listenGroupMembershipProfileListProvider(groupId).future);

    state = _buildProfileImages(asyncGroupMembershipProfileList);
  }

  List<Widget> _buildProfileImages(List<UserProfile?> profiles) {
    return profiles.map((profile) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final deviceWidth = MediaQuery.of(context).size.width;
          if (ResponsiveUtil.isMobile(context)) {
            return _buildMobileLayout(profile, deviceWidth);
          } else if (ResponsiveUtil.isTablet(context)) {
            return _buildTabletLayout(profile, deviceWidth);
          } else {
            return _buildDesktopLayout(profile, deviceWidth);
          }
        },
      );
    }).toList();
  }

  Widget _buildMobileLayout(UserProfile? profile, double deviceWidth) {
    return _buildLayout(profile, deviceWidth * 0.08);
  }

  Widget _buildTabletLayout(UserProfile? profile, double deviceWidth) {
    return _buildLayout(profile, deviceWidth * 0.055);
  }

  Widget _buildDesktopLayout(UserProfile? profile, double deviceWidth) {
    return _buildLayout(profile, deviceWidth * 0.045);
  }

  Widget _buildLayout(UserProfile? profile, double imageSize) {
    return profile != null
        ? CustomImage(
            imagePath: profile.image,
            width: imageSize,
            height: imageSize,
          )
        : const SizedBox.shrink();
  }
}
