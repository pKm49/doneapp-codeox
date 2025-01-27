import 'package:dietdone/feature_modules/plan_purchase/models/plan.model.plan_purchase.dart';
import 'package:dietdone/shared_module/constants/style_params.constants.shared.dart';
import 'package:dietdone/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:dietdone/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

class SubscriptionPlanCardComponent_PlanPurchase extends StatelessWidget {
  bool isSelected;
  SubscriptionPlan subscriptionPlan;
  SubscriptionPlanCardComponent_PlanPurchase(
      {super.key, required this.isSelected, required this.subscriptionPlan});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Container(
      decoration: APPSTYLE_BorderedContainerSmallDecoration.copyWith(
          color: Colors.transparent,
          border: Border.all(
              color: isSelected ? APPSTYLE_PrimaryColor : Colors.transparent,
              width: 4)),
      height: screenheight * .28,
      width: screenwidth,
      padding: APPSTYLE_ExtraSmallPaddingAll,
      margin: EdgeInsets.only(
          bottom: APPSTYLE_SpaceExtraSmall,
          top: APPSTYLE_SpaceExtraSmall,
          left: APPSTYLE_SpaceLarge,
          right: APPSTYLE_SpaceLarge),
      child: Container(
        foregroundDecoration: subscriptionPlan.offerDescription != ""
            ? RotatedCornerDecoration.withGradient(
                gradient: const LinearGradient(
                    colors: [Color(0xFFF46A6A), APPSTYLE_PrimaryColor],
                    tileMode: TileMode.clamp),
                spanBaselineShift: 4,
                badgeSize: Size(80, 80),
                badgeCornerRadius: Radius.circular(8),
                badgePosition:
                    Localizations.localeOf(context).languageCode.toString() ==
                            'ar'
                        ? BadgePosition.topStart
                        : BadgePosition.topEnd,
                textSpan: TextSpan(
                    text: subscriptionPlan.offerDescription,
                    style: getLabelSmallStyle(context)
                        .copyWith(color: Colors.white, shadows: [
                      BoxShadow(color: Colors.yellowAccent, blurRadius: 8),
                    ])),
              )
            : null,
        decoration: APPSTYLE_BorderedContainerSmallDecoration.copyWith(
            color: isSelected ? APPSTYLE_Grey80 : APPSTYLE_Black,
            boxShadow: APPSTYLE_ContainerShadow),
        padding: APPSTYLE_MediumPaddingVertical,
        height: (screenheight * .28) - (APPSTYLE_SpaceExtraSmall * 2),
        width: screenwidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: APPSTYLE_MediumPaddingHorizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      subscriptionPlan.name,
                      style: getHeadlineLargeStyle(context)
                          .copyWith(color: APPSTYLE_BackgroundWhite),
                    ),
                  ),
                  Visibility(
                    visible: subscriptionPlan.strikePrice != 0.0 &&
                        subscriptionPlan.offerDescription == "",
                    child: Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Localizations.localeOf(context)
                                    .languageCode
                                    .toString() ==
                                'ar'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          "${subscriptionPlan.strikePrice} KWD",
                          style: getHeadlineLargeStyle(context).copyWith(
                              fontSize: APPSTYLE_FontSize20,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: APPSTYLE_BackgroundWhite,
                              decorationStyle: TextDecorationStyle.solid,
                              color: APPSTYLE_BackgroundWhite),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: APPSTYLE_MediumPaddingHorizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: subscriptionPlan.strikePrice != 0.0 &&
                        subscriptionPlan.offerDescription != "",
                    child: Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Localizations.localeOf(context)
                                    .languageCode
                                    .toString() ==
                                'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          "${subscriptionPlan.strikePrice} KWD",
                          style: getHeadlineLargeStyle(context).copyWith(
                              fontSize: APPSTYLE_FontSize20,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: APPSTYLE_BackgroundWhite,
                              decorationStyle: TextDecorationStyle.solid,
                              color: APPSTYLE_BackgroundWhite),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${subscriptionPlan.price} KWD",
                    style: getHeadlineLargeStyle(context).copyWith(
                        fontSize: APPSTYLE_FontSize24 * 1.3,
                        color: APPSTYLE_BackgroundWhite),
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: subscriptionPlan.offerDescription != "",
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           decoration: APPSTYLE_ShadowedContainerLargeDecoration.
            //           copyWith(
            //             borderRadius: BorderRadius.circular(0),
            //             gradient: const LinearGradient(
            //                 colors: [Color(0xFFF46A6A), APPSTYLE_PrimaryColor],
            //                 tileMode: TileMode.clamp),
            //           ),
            //             padding: APPSTYLE_MediumPaddingHorizontal,
            //             child: Text(subscriptionPlan.offerDescription)
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: APPSTYLE_MediumPaddingHorizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subscriptionPlan.protein} ${"protein".tr}',
                    style: getBodyMediumStyle(context)
                        .copyWith(color: APPSTYLE_BackgroundWhite),
                  ),
                  Container(
                    decoration:
                        APPSTYLE_ShadowedContainerLargeDecoration.copyWith(
                      gradient: const LinearGradient(
                          colors: [Color(0xFFF46A6A), APPSTYLE_PrimaryColor],
                          tileMode: TileMode.clamp),
                    ),
                    padding: APPSTYLE_MediumPaddingHorizontal,
                    child: Text(
                      subscriptionPlan.durationType,
                      style: getBodyMediumStyle(context)
                          .copyWith(color: APPSTYLE_BackgroundWhite),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: APPSTYLE_MediumPaddingHorizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subscriptionPlan.carbohydrates} ${"carbs".tr}',
                    style: getBodyMediumStyle(context)
                        .copyWith(color: APPSTYLE_BackgroundWhite),
                  ),
                  Container(
                    decoration:
                        APPSTYLE_ShadowedContainerLargeDecoration.copyWith(
                      gradient: const LinearGradient(
                          colors: [Color(0xFFF46A6A), APPSTYLE_PrimaryColor],
                          tileMode: TileMode.clamp),
                    ),
                    padding: APPSTYLE_MediumPaddingHorizontal,
                    child: Text(
                      '${subscriptionPlan.days} ${"days".tr}',
                      style: getBodyMediumStyle(context)
                          .copyWith(color: APPSTYLE_BackgroundWhite),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
