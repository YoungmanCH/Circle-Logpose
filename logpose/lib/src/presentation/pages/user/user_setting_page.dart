import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/name_and_image_setting_section.dart';

import '../../components/components/navigation_bar/user_setting_navigation/user_setting_navigation_bar.dart';
import '../../components/components/user_setting/sections/account_id_section.dart';
import '../../components/components/user_setting/sections/email_section.dart';
import '../../components/components/user_setting/sections/group_section/group_section.dart';
import '../../components/components/user_setting/sections/password_section.dart';
import '../../components/components/user_setting/deletion_button/user_setting_account_deletion_button.dart';
import '../../components/components/user_setting/user_setting_save_button.dart';

import '../../notifiers/user_profile_notifier.dart';

import '../../providers/error_message/update_user_profile_error_provider.dart';

// import '../../common/progress/progress_indicator.dart';

class UserSettingPage extends ConsumerStatefulWidget {
  const UserSettingPage({super.key});
  @override
  ConsumerState<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends ConsumerState<UserSettingPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final errorMessage = ref.watch(updateUserProfileErrorMessageProvider);
    // final loadingErrorMessage = ref.watch(loadingErrorMessageProvider);

    final userProfile = ref.watch(userProfileNotifierProvider);
    if (userProfile == null) {
      return const SizedBox.shrink();
    }

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F3FE),
      navigationBar: const UserSettingNavigationBar(),
      child: SingleChildScrollView(
        child: Container(
          alignment: AlignmentDirectional.center,
          margin: EdgeInsets.only(top: deviceHeight * 0.03),
          child: Column(
            children: [
              Container(
                width: deviceWidth * 0.89,
                height: deviceHeight * 0.215,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFD9D9D9),
                      offset: Offset(1, 3),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                  color: CupertinoColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: NameAndImageSettingSection(
                  imagePath: userProfile.image,
                  name: userProfile.name,
                  loadingErrorMessage: errorMessage,
                  placeholder: 'username',
                ),
              ),
              const AccountIdSection(),
              const EmailSection(),
              const PasswordSection(),
              const GroupSection(),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Stack(
                  children: [
                    Center(
                      child: UserSettingSaveButton(name: userProfile.name),
                    ),
                    Positioned(
                      right: 25,
                      child: UserSettingAccountDeletionButton(),
                    ),
                  ],
                ),
              ),
              // const PageProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
