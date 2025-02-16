import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../handlers/copy_invitation_link_button_handler.dart';

class CopyInvitationLinkButton extends ConsumerStatefulWidget {
  const CopyInvitationLinkButton({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<CopyInvitationLinkButton> createState() =>
      _CopyInvitationLinkButtonState();
}

class _CopyInvitationLinkButtonState
    extends ConsumerState<CopyInvitationLinkButton> {
  Future<void> _handleToCopyInvitationLink() async {
    final handler = CopyInvitationLinkButtonHandler(
      context: context,
      ref: ref,
      groupId: widget.groupId,
    );

    await handler.handleToCopyInvitationLink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF7B61FF),
        borderRadius: BorderRadius.circular(80),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD9D9D9),
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CupertinoButton(
        onPressed: _handleToCopyInvitationLink,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.doc_on_clipboard,
              size: 12,
              color: CupertinoColors.white,
            ),
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                '招待リンクのコピー',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
