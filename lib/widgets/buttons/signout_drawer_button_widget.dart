import 'package:flutter/material.dart';

import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';
import '../icons/chevron_right_icon_widget.dart';

class SignOutDrawerButtonWidget extends StatelessWidget {
  const SignOutDrawerButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: ListTile(
        onTap: () async => {
          SnackBarService().successSnackBar('sign_out_snackbar_label', context),
          await AgentService().signOut()
        },
        title: Text(
            LocalizationService.of(context)?.translate('contact_link_label') ??
                '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground)),
        trailing: const ChevronRightIconWidget(),
      ),
    );
  }
}
