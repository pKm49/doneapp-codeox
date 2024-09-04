import 'dart:async';

import 'package:doneapp/feature_modules/auth/models/meal_item.model.auth.dart';
import 'package:doneapp/feature_modules/my_subscription/models/subscription_dailymeal.model.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/models/subscription_dailymeal_item.model.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/services/meal_selection.helper.services.dart';
import 'package:doneapp/shared_module/constants/style_params.constants.shared.dart';
import 'package:doneapp/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_generator.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class MealItemCardComponent_Auth extends StatefulWidget {
  MealItem subscriptoinDailyMealItem;
  final Function(int count) onAdded;      // <------------|
  int selectedCount;
  bool isSelectable;
  MealItemCardComponent_Auth({super.key, required this.subscriptoinDailyMealItem,
    required this.selectedCount,    required this.isSelectable,

    required this.onAdded});

  @override
  State<MealItemCardComponent_Auth> createState() => _MealItemCardComponent_AuthState();
}

class _MealItemCardComponent_AuthState extends State<MealItemCardComponent_Auth> {


  @override
  Widget build(BuildContext context) {

    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return InkWell(
       onTap: (){
         widget.onAdded(1);
       },
      child: AnimatedContainer(
        decoration:
        APPSTYLE_BorderedContainerSmallDecoration
            .copyWith(
          color: APPSTYLE_Grey20,
          border: Border.all(color:widget.selectedCount>0?APPSTYLE_GuideGreen: APPSTYLE_Grey40,
              width: widget.selectedCount>0? 3:.2)
        ),
        curve: Curves.bounceIn,
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(bottom: APPSTYLE_SpaceMedium),
        padding: APPSTYLE_SmallPaddingAll,
        child:
        Stack(
          children: [
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                Container(
                    decoration: APPSTYLE_BorderedContainerDarkMediumDecoration
                        .copyWith(
                        borderRadius:
                        BorderRadius
                            .circular(
                            APPSTYLE_BorderRadiusSmall),
                        color:
                        APPSTYLE_Grey20,
                        image: DecorationImage(image: getProductImage(widget.subscriptoinDailyMealItem
                            .imageUrl),fit: BoxFit.cover),
                        border: Border.all(
                            color:
                            APPSTYLE_BackgroundWhite,
                            width: 0.0)),
                    width: screenwidth * .4,
                    height: screenwidth * .35,
                    clipBehavior:
                    Clip.hardEdge ), 
                Text('${Localizations.localeOf(
                      context)
                      .languageCode
                      .toString() ==
                      'ar'
                      ? widget.subscriptoinDailyMealItem
                      .arabicName
                      : widget.subscriptoinDailyMealItem
                      .name} - ${widget.subscriptoinDailyMealItem.rating}⭐ (${widget.subscriptoinDailyMealItem.rating_count})',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: getBodyMediumStyle(
                      context)
                      .copyWith(
                      fontWeight: APPSTYLE_FontWeightBold,
                      color:
                      APPSTYLE_Grey80),
                ),
                Visibility(
                  visible: widget.subscriptoinDailyMealItem.tags !="",
                  child: Text( widget.subscriptoinDailyMealItem.tags,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: getLabelSmallStyle(
                        context)
                        .copyWith(
                        fontWeight: APPSTYLE_FontWeightBold,
                        color:
                        APPSTYLE_PrimaryColor),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                              '${widget.subscriptoinDailyMealItem.carbs} ${'carbs'.tr}',
                              style: getLabelLargeStyle(
                                  context) ),
                        )),
                    addHorizontalSpace(
                        APPSTYLE_SpaceSmall),
                    Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                              '${widget.subscriptoinDailyMealItem.protein}  ${'protein'.tr}',
                              style: getLabelLargeStyle(
                                  context) ),
                        )),
                  ],
                ),
                Row(
                  children: [

                    Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                              '${widget.subscriptoinDailyMealItem.calories} ${'calories'.tr}',
                              style: getLabelLargeStyle(
                                  context) ),
                        )),

                    addHorizontalSpace(
                        APPSTYLE_SpaceSmall),

                    Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                              '${widget.subscriptoinDailyMealItem.fat} ${'fat'.tr}',
                              style: getLabelLargeStyle(
                                  context) ),
                        )),
                  ],
                ),

              ],
            ),
            Column(
              children: [
                Visibility(
                  visible: widget.selectedCount>0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Ionicons.checkmark_circle,color: APPSTYLE_GuideGreen,size: APPSTYLE_FontSize24)
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }

}
