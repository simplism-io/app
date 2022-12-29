import 'package:base/widgets/screens/private/create_organisation_and_widget.dart';
import 'package:flutter/material.dart';

import '../../models/agent_model.dart';
import '../../services/agent_service.dart';
import '../loaders/loader_spinner_widget.dart';
import '../screens/private/home_screen_widget.dart';

class HomeScreenFutureBuilderWidget extends StatelessWidget {
  const HomeScreenFutureBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const CreateOrganisationScreenWidget();
          } else {
            final AgentModel agent = snapshot.data!;
            return HomeScreenWidget(agent: agent);
          }
        }
        return const LoaderSpinnerWidget();
      },
      future: AgentService().loadAgent(),
    );
  }
}
