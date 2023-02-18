import 'package:flutter/material.dart';

import '../../services/localization_service.dart';
import '../../services/util_service.dart';
import '../icons/chevron_right_icon.dart';

class GithubDrawerLink extends StatelessWidget {
  const GithubDrawerLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: ListTile(
        onTap: () => {UtilService().launchSimplismGithub()},
        title: Text(
            LocalizationService.of(context)?.translate('github_link_label') ??
                '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            )),
        trailing: const ChevronRightIcon(size: 15),
      ),
    );
  }
}
