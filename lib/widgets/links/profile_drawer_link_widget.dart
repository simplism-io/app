import 'package:base/widgets/icons/chevron_right_icon_widget.dart';
import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class ProfileDrawerLinkWidget extends StatelessWidget {
  final dynamic agent;
  const ProfileDrawerLinkWidget({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
        child: ListTile(
          onTap: () => {},
          title: Text(
              LocalizationService.of(context)
                      ?.translate('profile_link_label') ??
                  '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const ChevronRightIconWidget(),
        ));
  }
}
