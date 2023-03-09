import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../constants/drop_downs/language_header_dropdown_widget.dart';
import '../../constants/headers/public_menu_header.dart';
import '../../constants/icon_buttons/github_icon_button.dart';
import '../../constants/icon_buttons/public_menu_icon_button.dart';
import '../../constants/icon_buttons/theme_header_icon_button.dart';
import '../../constants/links/github_drawer_link.dart';
import '../../constants/links/auth_header_link.dart';
import '../../constants/links/faq_drawer_link.dart';
import '../../constants/links/faq_header_link.dart';
import '../../constants/links/features_drawer_link.dart';
import '../../constants/links/features_header_link.dart';
import '../../constants/links/logo_header_link.dart';
import '../../constants/links/pricing_drawer_link.dart';
import '../../constants/links/pricing_header_link.dart';
import '../../services/localization_service.dart';

final supabase = Supabase.instance.client;

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? organisation;

  bool loader = false;
  bool reset = false;
  bool signup = false;

  bool obscureText = true;

// If the requirement is just to play a single video.
  final _controller = YoutubePlayerController.fromVideoId(
    videoId: '_x5AnAmJLAA',
    autoPlay: false,
    params: const YoutubePlayerParams(showFullscreenButton: false),
  );

  toggleObscure() {
    setState(() => obscureText = !obscureText);
  }

  toggleReset() {
    setState(() => reset = !reset);
  }

  toggleSignUp() {
    setState(() => signup = !signup);
  }

  drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          PublicMenuHeader(),
          SizedBox(height: 20.0),
          FeaturesDrawerLink(highlight: false),
          PricingDrawerLink(highlight: false),
          FaqDrawerLink(highlight: false),
          GithubDrawerLink()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(
              ResponsiveValue(context, defaultValue: 15.0, valueWhen: const [
                    Condition.smallerThan(name: TABLET, value: 5.0)
                  ]).value ??
                  15.0,
              0.0,
              0.0,
              0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[PublicMenuIconButton(), LogoHeaderLink()],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          const FeaturesHeaderLink(highlight: false),
          const PricingHeaderLink(highlight: false),
          const FaqHeaderLink(highlight: false),
          const GithubIconButton(),
          const ThemeHeaderIconButton(),
          const LanguageHeaderDropdown(),
          (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android)
              ? Container()
              : const AuthLink()
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                    LocalizationService.of(context)
                            ?.translate('main_tagline') ??
                        '',
                    style: TextStyle(
                        fontFamily: 'OpenSansExtraBold',
                        fontSize: ResponsiveValue(context,
                            defaultValue: 50.0,
                            valueWhen: const [
                              Condition.smallerThan(name: DESKTOP, value: 40.0),
                            ]).value,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                child: Text(
                    LocalizationService.of(context)?.translate('sub_tagline') ??
                        '',
                    style: TextStyle(
                        fontSize: ResponsiveValue(context,
                            defaultValue: 25.0,
                            valueWhen: const [
                              Condition.smallerThan(name: DESKTOP, value: 20.0),
                            ]).value,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 800,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: drawer(),
    );
  }
}
