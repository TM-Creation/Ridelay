import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class GenericAppBars {
  static PreferredSizeWidget appBarWithBackButtonOnly(
          BuildContext context, bool isIconCross) =>
      AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Buttons.backButton(context, isIconCross,),
        ),
      );
  static PreferredSizeWidget appBarWithBackButtonAndTitle(
          String title, BuildContext context, bool isIconCross) =>
      AppBar(
        backgroundColor: Colors.white,
        title: displayNoSizedText(
          title,
          ScreenConfig.theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Buttons.backButton(context, isIconCross),
        ),
      );

  // static PreferredSizeWidget createProfileAppbar(
  //         BuildContext context, String appbarTitle, List<Widget> actions) =>
  //     AppBar(
  //       title: Text(
  //         appbarTitle,
  //         style: robotheme.textTheme.headline4
  //             ?.copyWith(fontWeight: FontWeight.w600),
  //       ),
  //       centerTitle: false,
  //       actions: actions,
  //       leadingWidth: 70,
  //       leading: generalisedBackButton(context),
  //     );

  // static PreferredSizeWidget createProfileAppbarOnlyAction(
  //         BuildContext context, List<Widget> actions) =>
  //     AppBar(
  //       centerTitle: false,
  //       actions: actions,
  //       automaticallyImplyLeading: false,
  //     );
  // static PreferredSizeWidget createProfileAppbarTitleAndActionOnly(
  //         BuildContext context, String appbarTitle, List<Widget> actions) =>
  //     AppBar(
  //       title: Text(
  //         appbarTitle,
  //         style: robotheme.textTheme.headline4
  //             ?.copyWith(fontWeight: FontWeight.w600),
  //       ),
  //       centerTitle: false,
  //       actions: actions,
  //       automaticallyImplyLeading: false,
  //     );
}
