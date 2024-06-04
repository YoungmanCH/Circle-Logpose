import 'package:flutter/cupertino.dart';

import '../../../../../../../../../../utils/responsive_util.dart';

import '../../../../../../../common/custom_text.dart';

class GroupSettingScheduleSectionPanelLabel extends StatelessWidget {
  const GroupSettingScheduleSectionPanelLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtil.isMobile(context)) {
          return _buildMobileLayout(deviceWidth);
        } else if (ResponsiveUtil.isTablet(context)) {
          return _buildTabletLayout(deviceWidth);
        } else {
          return _buildDesktopLayout(deviceWidth);
        }
      },
    );
  }

  Widget _buildMobileLayout(double deviceWidth) {
    return _buildLayout(deviceWidth * 0.03);
  }

  Widget _buildTabletLayout(double deviceWidth) {
    return _buildLayout(deviceWidth * 0.02);
  }

  Widget _buildDesktopLayout(double deviceWidth) {
    return _buildLayout(deviceWidth * 0.015);
  }

  Widget _buildLayout(double textSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: CustomText(
        text: '予定一覧',
        textColor: CupertinoColors.systemGrey,
        fontSize: textSize,
      ),
    );
  }
}