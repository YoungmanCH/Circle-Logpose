import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/loading_progress.dart';

import '../../components/components/group/group_creation/group_creation_button.dart';
import '../../components/components/group/group_creation/group_name_and_image_section.dart';
import '../../components/components/group/group_creation/member_section/member_section.dart';
import '../../components/components/group/switch/add_member_switch.dart';
import '../../components/components/group/switch/delete_member_switch.dart';
import '../../components/components/progress/progress_indicator.dart';

class GroupCreationPage extends ConsumerStatefulWidget {
  const GroupCreationPage({super.key});
  @override
  ConsumerState<GroupCreationPage> createState() => _GroupCreationPageState();
}

class _GroupCreationPageState extends ConsumerState<GroupCreationPage> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final loadingErrorMessage = ref.watch(loadingErrorMessageProvider);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F3FE),
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: deviceHeight * 0.176,
              child: GroupNameAndImageSection(
                loadingErrorMessage: loadingErrorMessage,
              ),
            ),
            Positioned(
              top: deviceHeight * 0.38,
              child: const MemberSection(),
            ),
            Positioned(
              top: deviceHeight * 0.86,
              left: deviceWidth * 0.26,
              child: const GroupCreationButton(),
            ),
            Positioned(
              top: deviceHeight * 0.45,
              left: deviceWidth * 0.84,
              child: const AddMemberSwitch(),
            ),
            Positioned(
              top: deviceHeight * 0.505,
              left: deviceWidth * 0.84,
              child: const DeleteMemberSwitch(mode: 'create'),
            ),
            const PageProgressIndicator(),
          ],
        ),
      ),
    );
  }
}