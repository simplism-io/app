import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/agent_model.dart';
import '../../services/localization_service.dart';
import '../screens/private/profile_screen_widget.dart';

class ProfileDrawerLinkWidget extends StatelessWidget {
  final AgentModel? agent;
  const ProfileDrawerLinkWidget({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: Row(children: [
        Text(
            LocalizationService.of(context)?.translate('profile_link_label') ??
                '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          icon: Icon(FontAwesomeIcons.circleChevronRight,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreenWidget(agent: agent),
              ),
            );
          },
        ),
      ]),
    );
  }
}
