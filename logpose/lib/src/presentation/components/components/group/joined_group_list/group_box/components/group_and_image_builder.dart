import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../utils/responsive_util.dart';

import '../../../../../../../domain/model/group_and_id_model.dart';
import '../../../../../../providers/group/group/listen_group_and_id_provider.dart';

import '../../../../../common/custom_image/custom_image.dart';

class GroupAndImageBuilder extends ConsumerWidget {
  const GroupAndImageBuilder({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGroupAndId = ref.watch(listenGroupAndIdProvider(groupId));

    return asyncGroupAndId.when(
      data: _GroupAndImage.new,
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Text('$error'),
    );
  }
}

class _GroupAndImage extends StatelessWidget {
  const _GroupAndImage(this.data);

  final GroupAndId? data;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    if (data == null) {
      return const Text('No group data.');
    }

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
    return _buildLayout(
      imageSize: deviceWidth * 0.09,
      textSize: deviceWidth * 0.04,
    );
  }

  Widget _buildTabletLayout(double deviceWidth) {
    return _buildLayout(
      imageSize: deviceWidth * 0.09,
      textSize: deviceWidth * 0.03,
    );
  }

  Widget _buildDesktopLayout(double deviceWidth) {
    return _buildLayout(
      imageSize: deviceWidth * 0.08,
      textSize: deviceWidth * 0.06,
    );
  }

  Widget _buildLayout({
    required double imageSize,
    required double textSize,
  }) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Center(
              child: CustomImage(
                imagePath: data!.groupProfile.image,
                height: imageSize,
                width: imageSize,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Center(
              child: Text(
                data!.groupProfile.name,
                style: TextStyle(
                  fontSize: textSize,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
