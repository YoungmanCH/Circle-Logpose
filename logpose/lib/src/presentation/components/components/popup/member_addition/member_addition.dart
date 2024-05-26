import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/invitation_link/copy_invitation_link_button.dart';
import 'components/search_field_section/user_search_field_section.dart';
import 'components/user_profile/user_profile_button.dart';

class MemberAddition extends ConsumerStatefulWidget {
  const MemberAddition({super.key, required this.groupId});

  final String? groupId;

  @override
  ConsumerState<MemberAddition> createState() => _MemberAdditionState();
}

class _MemberAdditionState extends ConsumerState<MemberAddition> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final groupId = widget.groupId;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: SizedBox(
          width: deviceWidth * 0.8,
          height: deviceHeight * 0.35,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFF5F3FE),
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  UserSearchFieldSection(groupId: groupId),
                  UserProfileButton(groupId: groupId),
                  if (groupId != null)
                    CopyInvitationLinkButton(groupId: groupId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}