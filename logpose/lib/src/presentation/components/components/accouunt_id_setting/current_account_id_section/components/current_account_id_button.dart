import 'package:flutter/cupertino.dart';

import '../../../../../../../utils/copy_to_clipboard.dart';

class CurrentAccountIdButton extends StatelessWidget {
  const CurrentAccountIdButton({super.key, required this.accountId});

  final String accountId;

  void _copyToClipboard(String accountId) {
    copyToClipboard(accountId);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoButton(
      onPressed: () => _copyToClipboard(accountId),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: deviceWidth * 0.7),
            child: Text(
              accountId,
              style: const TextStyle(
                color: Color.fromARGB(255, 124, 122, 122),
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
