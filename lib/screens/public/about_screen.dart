import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../constants/drop_downs/language_header_dropdown_widget.dart';
import '../../constants/headers/public_menu_header.dart';
import '../../constants/icons/public_menu_icon.dart';
import '../../constants/icons/theme_header_icon.dart';
import '../../constants/links/about_drawer_link.dart';
import '../../constants/links/about_header_link.dart';
import '../../constants/links/faq_drawer_link.dart';
import '../../constants/links/faq_header_link.dart';
import '../../constants/links/features_drawer_link.dart';
import '../../constants/links/features_header_link.dart';
import '../../constants/links/logo_header_link.dart';
import '../../constants/links/pricing_drawer_link.dart';
import '../../constants/links/pricing_header_link.dart';
import '../../services/localization_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  leftSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      //hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Odit veritatis '),
                )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  middleSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('This is a big block of information'),
                )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  rightSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('This is a big block of information'),
                )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          PublicMenuHeader(),
          SizedBox(height: 20.0),
          FeaturesDrawerLink(highlight: false),
          SizedBox(height: 5.0),
          PricingDrawerLink(highlight: false),
          SizedBox(height: 5.0),
          FaqDrawerLink(highlight: false),
          SizedBox(height: 5.0),
          AboutDrawerLink(highlight: true)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: const <Widget>[PublicMenuIcon(), LogoHeaderLink()],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [
          FeaturesHeaderLink(highlight: false),
          PricingHeaderLink(highlight: false),
          AboutUsHeaderLink(highlight: true),
          FaqHeaderLink(highlight: false),
          LanguageHeaderDropdown(),
          ThemeHeaderIcon(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
              LocalizationService.of(context)
                      ?.translate('about_us_header_label') ??
                  '',
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onBackground)),
          ResponsiveRowColumn(
              layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.center,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              rowPadding: const EdgeInsets.all(20),
              columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              children: [
                leftSection(),
                middleSection(),
                rightSection(),
              ]),
        ],
      ),
      drawer: drawer(),
    );
  }
}
