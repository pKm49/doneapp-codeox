import 'dart:async';

import 'package:doneapp/feature_modules/my_subscription/models/subscription_dailymeal.model.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/models/subscription_dailymeal_item.model.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/services/meal_selection.helper.services.dart';
import 'package:doneapp/shared_module/constants/style_params.constants.shared.dart';
import 'package:doneapp/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_generator.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MealSelectionItemCardSelectedComponent_MySubscription extends StatefulWidget {
  SubscriptoinDailyMealItem subscriptoinDailyMealItem;
  final Function(int count) onAdded;      // <------------|
  int selectedCount;
  bool isSelectable;
  MealSelectionItemCardSelectedComponent_MySubscription({super.key, required this.subscriptoinDailyMealItem,
    required this.selectedCount,    required this.isSelectable,

    required this.onAdded});

  @override
  State<MealSelectionItemCardSelectedComponent_MySubscription> createState() => _MealSelectionItemCardSelectedComponent_MySubscriptionState();
}

class _MealSelectionItemCardSelectedComponent_MySubscriptionState extends State<MealSelectionItemCardSelectedComponent_MySubscription> {

  late Timer _timer;
  bool isLongPressed = false;
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {

    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return InkWell(
      onTapDown: (_) {
        if(widget.isSelectable){
          _startOperation();
        }
      },
      onTapUp: (_) {
        if(widget.isSelectable) {
          _timer.cancel();
          if(!isLongPressed)
          {
            if(widget.isSelectable){
              print("widget selectable");
              print(widget.selectedCount);
              if(widget.selectedCount==0){
                widget.onAdded(1);
              }else{
                widget.onAdded(-1);
              }
            }
          }else{
            isLongPressed = false;
            setState(() {
            });
          }
        }

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
        child: isFlipped?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: (){
                          isFlipped = false;
                          setState(() {

                          });
                        },
                        child: Icon(Ionicons.close_circle,color: APPSTYLE_Grey60,size: APPSTYLE_FontSize24,)),
                ],),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: (){
                          widget.onAdded(-1);
                        },
                        child: Icon(Ionicons.remove_circle,color: APPSTYLE_GuideRed,size: APPSTYLE_FontSize24*2,)),
                    addHorizontalSpace(APPSTYLE_SpaceSmall),
                    Text(widget.selectedCount.toString(),style: getHeadlineLargeStyle(context)),
                    addHorizontalSpace(APPSTYLE_SpaceSmall),
                    InkWell(
                        onTap: (){
                          widget.onAdded(1);
                        },child: Icon(Ionicons.add_circle,color: APPSTYLE_GuideGreen,size: APPSTYLE_FontSize24*2,)),

                  ],
                ),
                Expanded(child: Container()),
              ],
            ):
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
                            .image),fit: BoxFit.cover),
                        border: Border.all(
                            color:
                            APPSTYLE_BackgroundWhite,
                            width: 0.0)),
                    width: screenwidth * .4,
                    height: screenwidth * .35,
                    clipBehavior:
                    Clip.hardEdge ),
                addVerticalSpace(
                    APPSTYLE_SpaceExtraSmall),
                Text('${Localizations.localeOf(
                      context)
                      .languageCode
                      .toString() ==
                      'ar'
                      ? widget.subscriptoinDailyMealItem
                      .arabicName
                      : widget.subscriptoinDailyMealItem
                      .name} - ${widget.subscriptoinDailyMealItem.rating}⭐ (${widget.subscriptoinDailyMealItem.ratingCount})',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: getBodyMediumStyle(
                      context)
                      .copyWith(
                      fontWeight: APPSTYLE_FontWeightBold,
                      color:
                      APPSTYLE_Grey80),
                ),
                addVerticalSpace(
                    APPSTYLE_SpaceExtraSmall),
                Row(
                  children: [
                    Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                              '${widget.subscriptoinDailyMealItem.id} Carbs',
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
                              '${widget.subscriptoinDailyMealItem.protien} Prot',
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
                              '${widget.subscriptoinDailyMealItem.calories} Cal',
                              style: getLabelLargeStyle(
                                  context) ),
                        )),

                    addHorizontalSpace(
                        APPSTYLE_SpaceSmall),
                    // Expanded(
                    //     child: FittedBox(
                    //       alignment: Alignment.centerRight,
                    //       fit: BoxFit.scaleDown,
                    //       child: Text(
                    //           '${widget.subscriptoinDailyMealItem.rating}(${widget.subscriptoinDailyMealItem.ratingCount}) ⭐',
                    //           style: getBodyMediumStyle(
                    //               context)
                    //               .copyWith(
                    //               fontWeight:
                    //               APPSTYLE_FontWeightBold)),
                    //     )),
                    Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                              '${widget.subscriptoinDailyMealItem.fat} Fat',
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

  void _startOperation() {
    _timer = Timer(const Duration(seconds: 1), () {
      print('LongPress Event');
      isLongPressed = true;
      isFlipped = !isFlipped;
      setState(() {

      });
    });
  }
}
