import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../navigations/to_email_setting_page_navigator.dart';
import '../../../common/user_section_label.dart';

class EmailSection extends ConsumerStatefulWidget {
  const EmailSection({super.key});
  @override
  ConsumerState createState() => _EmailSectionState();
}

class _EmailSectionState extends ConsumerState<EmailSection> {
  Future<void> _handleToTap() async {
    final navigator = ToEmailSettingPageNavigator(context);
    await navigator.moveToPage();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: deviceWidth * 0.88,
      height: deviceHeight * 0.06,
      alignment: Alignment.centerLeft,
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
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _handleToTap,
        child: const UserSectionLabel(
          leftIcon: CupertinoIcons.mail,
          text: 'メールアドレス',
        ),
      ),
    );
  }
}
