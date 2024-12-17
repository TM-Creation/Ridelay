import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

Widget userDetailsContainer(String image, String firstText, String secondText,
    bool isRating) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: [
        Container(
          width: ScreenConfig.screenSizeWidth * 0.085,
          height: ScreenConfig.screenSizeWidth * 0.085,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Optional shadow
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge, // Ensures the child respects the rounded corners
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
        spaceWidth(ScreenConfig.screenSizeWidth * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
                    children: [
                      displayText(
                        firstText,
                        ScreenConfig.theme.textTheme.bodyMedium,
                        width: 0.2,
                      ),
                    ],
                  ),
            isRating
                ? Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 10,
                      ),
                      spaceWidth(3),
                      displayText(
                        secondText,
                        ScreenConfig.theme.textTheme.bodyMedium,
                        width: 0.22,
                      ),
                    ],
                  )
                : displayText(
                    secondText,
                    ScreenConfig.theme.textTheme.bodyMedium,
                    width: 0.22,
                  ),
          ],
        ),
      ],
    ),
  );
}

Widget userDetailsMiniContainer(
  String image,
  String firstText,
) {
  return Container(
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: ScreenConfig.screenSizeWidth * 0.08,
              height: ScreenConfig.screenSizeWidth * 0.08,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
            spaceWidth(ScreenConfig.screenSizeWidth * 0.02),
            displayText(
              firstText,
              ScreenConfig.theme.textTheme.labelLarge,
              width: 0.3,
            )
          ],
        ),
        // RatiangStaric()
      ],
    ),
  );
}
