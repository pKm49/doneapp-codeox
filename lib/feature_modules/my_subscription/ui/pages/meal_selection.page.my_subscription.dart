import 'package:doneapp/feature_modules/my_subscription/controller/my_subscription.controller.dart';
import 'package:doneapp/feature_modules/my_subscription/services/meal_selection.helper.services.dart';
import 'package:doneapp/feature_modules/my_subscription/ui/components/meal_calendar_date_mealselection.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/ui/components/meal_selection_frozenoffday_info.page.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/ui/components/meal_selection_itemcard_selected.component.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/ui/components/meal_selection_itemsloader.component.my_subscription.dart';
import 'package:doneapp/feature_modules/my_subscription/ui/components/meal_selection_titleloader.component.my_subscription.dart';
import 'package:doneapp/shared_module/constants/app_route_names.constants.shared.dart';
import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:doneapp/shared_module/constants/style_params.constants.shared.dart';
import 'package:doneapp/shared_module/constants/valid_addressauthor_modes.constants.shared.dart';
import 'package:doneapp/shared_module/constants/valid_subscription_day_status.constants.shared.dart';
import 'package:doneapp/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:doneapp/shared_module/controllers/controller.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/calendar_utilities.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/date_conversion.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_generator.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:doneapp/shared_module/ui/components/custom_back_button.component.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticky_headers/sticky_headers.dart';

class MealSelectionPage_MySubscription extends StatefulWidget {
  const MealSelectionPage_MySubscription({super.key});

  @override
  State<MealSelectionPage_MySubscription> createState() =>
      _MealSelectionPage_MySubscriptionState();
}

class _MealSelectionPage_MySubscriptionState
    extends State<MealSelectionPage_MySubscription> {
  final mySubscriptionController = Get.find<MySubscriptionController>();
  ScrollController _scrollController = ScrollController();
  bool isScrolled = false;
  DateTime threeDaysBefore = DateTime.now().add(Duration(hours: -72));
  final sharedController = Get.find<SharedController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mySubscriptionController.isMealsFetching.value &&
        mySubscriptionController.subscriptoinMealConfig.value.date == "") {
      mySubscriptionController.getMealsByDate(
          mySubscriptionController.selectedDate.value, false);
    }
  }

  //         itemScrollController.scrollTo(index: 2, duration: Duration(seconds: 2));
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (!isScrolled) {
      scrollToDate(screenwidth);
    }

    return PopScope(
      canPop: false,
      onPopInvoked : (didPop){

        if (didPop) {
          return;
        }else{
          if(ifSaveOperationAllowed() ){
            int subscriptionId = mySubscriptionController.getDaySubId(mySubscriptionController.selectedDate.value);
            mySubscriptionController.setMealsByDate(false,subscriptionId, true);
            Navigator.pop(context);
          }else{
            Navigator.pop(context);

          }
        }
      },
      child: Obx(
            () => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.0,
            backgroundColor: APPSTYLE_BackgroundWhite,
            elevation: 0.0,
            title: Row(
              children: [
                CustomBackButton(

                    onDeleteSelected:(){
                      if(ifSaveOperationAllowed() ){
                        int subscriptionId = mySubscriptionController.getDaySubId(mySubscriptionController.selectedDate.value);

                        mySubscriptionController.setMealsByDate(false,subscriptionId,true);
                        Navigator.pop(context);
                      }else{
                        Navigator.pop(context);
                      }
                    },
                    isPrimaryMode: false),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'select_meal'.tr,
                      style: getHeadlineLargeStyle(context)
                          .copyWith(fontWeight: APPSTYLE_FontWeightBold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              Visibility(
                visible: !mySubscriptionController.isDayMealSaving.value &&
                    !mySubscriptionController.isMealsFetching.value &&
                    !mySubscriptionController.isFreezing.value &&
                    !isTodayTomorrow(mySubscriptionController.selectedDate.value) &&
                    mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value)
                      != VALIDSUBSCRIPTIONDAY_STATUS.offDay &&
                    mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
                        VALIDSUBSCRIPTIONDAY_STATUS.delivered,
                child: InkWell(
                  onTap: () {
                    if (!mySubscriptionController.isDayMealSaving.value &&
                        !mySubscriptionController.isMealsFetching.value &&
                        !mySubscriptionController.isFreezing.value &&
                        !isTodayTomorrow(mySubscriptionController.selectedDate.value) &&
                        mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
                            VALIDSUBSCRIPTIONDAY_STATUS.offDay &&
                        mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
                            VALIDSUBSCRIPTIONDAY_STATUS.delivered) {
                      showFreezeConfirmDialogue(context);
                    }
                  },
                  child: Container(
                    width: screenwidth * .25,
                    decoration:
                    APPSTYLE_ShadowedContainerExtraSmallDecoration.copyWith(
                        boxShadow: [
                          const BoxShadow(
                            color: APPSTYLE_Grey80Shadow24,
                            offset: Offset(0, 3.0),
                            blurRadius: APPSTYLE_BlurRadiusLarge,
                          ),
                        ],
                        color: APPSTYLE_Black),
                    padding: EdgeInsets.symmetric(
                        vertical: APPSTYLE_SpaceSmall,
                        horizontal: APPSTYLE_SpaceSmall),
                    child: mySubscriptionController.isFreezing.value
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: APPSTYLE_BackgroundWhite,
                          size: 24,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Icon(
                            mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                VALIDSUBSCRIPTIONDAY_STATUS.freezed
                                ? Ionicons.play
                                : Ionicons.pause,
                            color: APPSTYLE_BackgroundWhite,
                            size: APPSTYLE_FontSize16),
                        addHorizontalSpace(APPSTYLE_SpaceExtraSmall),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                  VALIDSUBSCRIPTIONDAY_STATUS.freezed
                                  ? "unpause".tr
                                  : "pause".tr,
                              style: getBodyMediumStyle(context).copyWith(
                                  color: APPSTYLE_BackgroundWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              addHorizontalSpace(APPSTYLE_SpaceLarge)
            ],
          ),
          body: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: APPSTYLE_LargePaddingHorizontal,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var date in mySubscriptionController
                                .subscriptionDates)
                              InkWell(
                                  onTap: () {
                                    mySubscriptionController.getMealsByDate(
                                        date.date, false);
                                  },
                                  child:
                                  MealCalendarDateMealSelectionComponent_MySubscription(
                                      date: date.date,
                                      isSelected: isSameDay(
                                          date.date,
                                          mySubscriptionController
                                              .selectedDate.value),
                                      status: mySubscriptionController.getDayStatus(date.date)))
                          ],
                        ),
                      ),
                    ),
                    addVerticalSpace(APPSTYLE_SpaceMedium),

                    //   paused ((Not Selected || Selected) && aftertommorrow )
                    Visibility(
                      visible: !mySubscriptionController.isMealsFetching.value && !mySubscriptionController.isFreezing.value &&
                          mySubscriptionController.subscriptoinMealConfig.value.meals.isNotEmpty &&

                                  (
                                      (mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                          VALIDSUBSCRIPTIONDAY_STATUS.freezed ||
                                          mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                          VALIDSUBSCRIPTIONDAY_STATUS.mealNotSelected ||
                                          mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                              VALIDSUBSCRIPTIONDAY_STATUS.mealSelected)
                                          && !isTodayTomorrow(mySubscriptionController.selectedDate.value)
                                  ) ,
                      child: Expanded(
                          child: ScrollablePositionedList.builder(
                            itemCount: mySubscriptionController
                                .subscriptoinMealConfig.value.meals.length,
                            itemScrollController:
                            mySubscriptionController.itemScrollController,
                            itemBuilder: (BuildContext context, int index) {
                              return StickyHeader(
                                header: Container(
                                  color: APPSTYLE_PrimaryColorBgLight,
                                  padding: APPSTYLE_LargePaddingHorizontal.copyWith(
                                      top: APPSTYLE_SpaceMedium,
                                      bottom: APPSTYLE_SpaceMedium),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                Localizations.localeOf(context)
                                                    .languageCode
                                                    .toString() ==
                                                    'ar'
                                                    ? mySubscriptionController
                                                    .subscriptoinMealConfig
                                                    .value
                                                    .meals[index]
                                                    .arabicName
                                                    : mySubscriptionController
                                                    .subscriptoinMealConfig
                                                    .value
                                                    .meals[index]
                                                    .name,
                                                style: getHeadlineMediumStyle(context)
                                                    .copyWith(
                                                    fontSize: APPSTYLE_FontSize20,
                                                    fontWeight:
                                                    APPSTYLE_FontWeightBold)),
                                            Container(
                                              width: screenwidth * .25,
                                              height: 2,
                                              color: APPSTYLE_Grey80,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration:
                                        APPSTYLE_BorderedContainerLargeDecoration
                                            .copyWith(color: APPSTYLE_PrimaryColor),
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                            APPSTYLE_BorderRadiusExtraSmall * .5,
                                            horizontal: APPSTYLE_SpaceSmall),
                                        child: Text(
                                          "item_count".tr.replaceAll("1",
                                              "${mySubscriptionController.selectedMealConfig.value.meals[index].items.length}/${mySubscriptionController.subscriptoinMealConfig.value.meals[index].itemCount}"),
                                          style: getBodyMediumStyle(context)
                                              .copyWith(color: APPSTYLE_BackgroundWhite),
                                        ),
                                      ),
                                      Visibility(
                                          visible: mySubscriptionController
                                              .selectedMealConfig
                                              .value
                                              .meals[index]
                                              .items
                                              .isNotEmpty,
                                          child: addHorizontalSpace(APPSTYLE_SpaceSmall)),
                                      Visibility(
                                        visible:  mySubscriptionController
                                            .selectedMealConfig
                                            .value
                                            .meals[index]
                                            .items
                                            .isNotEmpty,
                                        child: InkWell(
                                          onTap: () {
                                            mySubscriptionController
                                                .removeSelectionPerCategory(
                                                mySubscriptionController
                                                    .selectedMealConfig
                                                    .value
                                                    .meals[index]
                                                    .id);
                                          },
                                          child: Container(
                                            decoration:
                                            APPSTYLE_BorderedContainerLargeDecoration
                                                .copyWith(
                                                border: Border.all(
                                                    color: APPSTYLE_GuideRed,
                                                    width: .5),
                                                color: APPSTYLE_BackgroundWhite),
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                APPSTYLE_BorderRadiusExtraSmall * .5,
                                                horizontal: APPSTYLE_SpaceSmall),
                                            child: Text(
                                              "clear_selection".tr,
                                              style: getBodyMediumStyle(context)
                                                  .copyWith(color: APPSTYLE_GuideRed),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                content:  Padding(
                                  padding: APPSTYLE_LargePaddingHorizontal.copyWith(
                                      top: APPSTYLE_SpaceMedium),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: mySubscriptionController
                                        .subscriptoinMealConfig
                                        .value
                                        .meals[index]
                                        .items
                                        .length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: APPSTYLE_SpaceSmall,
                                        mainAxisExtent: screenheight * 0.38),
                                    itemBuilder: (context, indx) {
                                      return MealSelectionItemCardSelectedComponent_MySubscription(
                                          isSelectable: true,
                                          selectedCount:
                                          mySubscriptionController
                                              .getMealSelectedCount(
                                              mySubscriptionController
                                                  .subscriptoinMealConfig
                                                  .value
                                                  .meals[
                                              index]
                                                  .id,
                                              mySubscriptionController
                                                  .subscriptoinMealConfig
                                                  .value
                                                  .meals[
                                              index]
                                                  .items[indx]
                                                  .id),
                                          subscriptoinDailyMealItem:
                                          mySubscriptionController
                                              .subscriptoinMealConfig
                                              .value
                                              .meals[index].items[indx],
                                          onAdded: (int count){
                                            if( mySubscriptionController.selectedDate.value.isAfter(
                                                DateTime.now().add(Duration(days: 1)))){
                                              if(count<=0){
                                                mySubscriptionController.addOrRemoveMeal(
                                                    index, mySubscriptionController
                                                    .subscriptoinMealConfig
                                                    .value
                                                    .meals[
                                                index].id, mySubscriptionController
                                                    .subscriptoinMealConfig
                                                    .value
                                                    .meals[
                                                index]
                                                    .items[indx]
                                                    .id, count);
                                              }else{
                                                if(mySubscriptionController
                                                    .subscriptoinMealConfig
                                                    .value
                                                    .meals[
                                                index]
                                                    .items[indx].isDislike){
                                                  openDislikeConfirm( index, mySubscriptionController
                                                      .subscriptoinMealConfig
                                                      .value
                                                      .meals[
                                                  index].id, mySubscriptionController
                                                      .subscriptoinMealConfig
                                                      .value
                                                      .meals[
                                                  index]
                                                      .items[indx]
                                                      .id, count,context);
                                                }else{
                                                  print("getPercentage");
                                                  print(getOriginalPercentage(
                                                      mySubscriptionController.subscriptoinMealConfig
                                                          .value.recommendedCalories,
                                                      mySubscriptionController.selectedMealConfig
                                                          .value.recommendedCalories+mySubscriptionController
                                                          .subscriptoinMealConfig
                                                          .value
                                                          .meals[
                                                      index]
                                                      .items[indx]
                                                      .calories));
                                                  if(getOriginalPercentage(
                                                      mySubscriptionController.subscriptoinMealConfig
                                                          .value.recommendedCalories,
                                                      mySubscriptionController.selectedMealConfig
                                                          .value.recommendedCalories+mySubscriptionController
                                                          .subscriptoinMealConfig
                                                          .value
                                                          .meals[
                                                      index]
                                                          .items[indx]
                                                          .calories) >100){
                                                    openExtraCaloryConfirm( index, mySubscriptionController
                                                        .subscriptoinMealConfig
                                                        .value
                                                        .meals[
                                                    index].id, mySubscriptionController
                                                        .subscriptoinMealConfig
                                                        .value
                                                        .meals[
                                                    index]
                                                        .items[indx]
                                                        .id, count,context);
                                                  }else{
                                                    mySubscriptionController.addOrRemoveMeal(
                                                        index, mySubscriptionController
                                                        .subscriptoinMealConfig
                                                        .value
                                                        .meals[
                                                    index].id, mySubscriptionController
                                                        .subscriptoinMealConfig
                                                        .value
                                                        .meals[
                                                    index]
                                                        .items[indx]
                                                        .id, count);
                                                  }

                                                }
                                              }

                                            }

                                          });
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                    ),

                    // Delivered Day Meals & Today & Tomorrow
                    Visibility(
                      visible: !mySubscriptionController.isMealsFetching.value &&
                          !mySubscriptionController.isFreezing.value &&
                          mySubscriptionController
                              .subscriptoinMealConfig.value.meals.isNotEmpty &&
                          (
                              mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                  VALIDSUBSCRIPTIONDAY_STATUS.delivered || (
                                  (mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                      VALIDSUBSCRIPTIONDAY_STATUS.mealSelected  ||
                                      mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                          VALIDSUBSCRIPTIONDAY_STATUS.mealNotSelected )
                                      && isTodayTomorrow(mySubscriptionController.selectedDate.value)
                              )
                          ),
                      child: Expanded(
                        child: ListView.builder(
                            itemCount: mySubscriptionController
                                .selectedMealConfig.value.meals.length,
                            itemBuilder: (context, index) {
                              return StickyHeader(
                                header: Container(
                                  color: APPSTYLE_PrimaryColorBgLight,
                                  padding: APPSTYLE_LargePaddingHorizontal.copyWith(
                                      top: APPSTYLE_SpaceMedium,
                                      bottom: APPSTYLE_SpaceMedium),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              Localizations.localeOf(context)
                                                  .languageCode
                                                  .toString() ==
                                                  'ar'
                                                  ? mySubscriptionController
                                                  .selectedMealConfig
                                                  .value
                                                  .meals[index]
                                                  .arabicName
                                                  : mySubscriptionController
                                                  .selectedMealConfig
                                                  .value
                                                  .meals[index]
                                                  .name,
                                              style: getHeadlineMediumStyle(context)
                                                  .copyWith(
                                                  fontSize: APPSTYLE_FontSize20,
                                                  fontWeight:
                                                  APPSTYLE_FontWeightBold)),
                                          Container(
                                            width: 30,
                                            height: 2,
                                            color: APPSTYLE_Grey80,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                content: Padding(
                                  padding: APPSTYLE_LargePaddingHorizontal.copyWith(
                                      top: APPSTYLE_SpaceMedium),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: mySubscriptionController
                                        .selectedMealConfig
                                        .value
                                        .meals[index]
                                        .items
                                        .length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: APPSTYLE_SpaceMedium,
                                        mainAxisExtent: screenheight * 0.4),
                                    itemBuilder: (context, indx) {
                                      return MealSelectionItemCardSelectedComponent_MySubscription(
                                          isSelectable: true,
                                          selectedCount:mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                              VALIDSUBSCRIPTIONDAY_STATUS.delivered && mySubscriptionController.selectedDate.value
                                              .isAfter(threeDaysBefore) ?-1:1,
                                          subscriptoinDailyMealItem:
                                      mySubscriptionController
                                          .selectedMealConfig
                                          .value
                                          .meals[index].items[indx],
                                          onAdded: (int count){
                                            if(mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                                VALIDSUBSCRIPTIONDAY_STATUS.delivered && mySubscriptionController.selectedDate.value
                                                .isAfter(threeDaysBefore)){
                                              showRateDialog( mySubscriptionController
                                                  .selectedMealConfig
                                                  .value
                                                  .meals[index].items[indx].id);
                                            }

                                          });
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),

                    // Off - Day Info
                    Visibility(
                      visible: !mySubscriptionController.isMealsFetching.value &&
                          !mySubscriptionController.isFreezing.value &&
                          mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                              VALIDSUBSCRIPTIONDAY_STATUS.offDay,
                      child: Expanded(
                          child: MealSelectionFrozenOffDayInfoPage_MySubscriptions(isFrozen: false)),
                    ),


                    // Frozen - Day Info
                    Visibility(
                      visible: !mySubscriptionController.isMealsFetching.value &&
                          !mySubscriptionController.isFreezing.value &&
                          isTodayTomorrow(mySubscriptionController.selectedDate.value) &&
                          mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                              VALIDSUBSCRIPTIONDAY_STATUS.freezed,
                      child: Expanded(
                          child: MealSelectionFrozenOffDayInfoPage_MySubscriptions(isFrozen: true)),
                    ),

                    // Title Loader
                    Visibility(
                        visible: mySubscriptionController.isMealsFetching.value ||
                            mySubscriptionController.isFreezing.value,
                        child: MealSelectionTitleLoader()),

                    //  Meals Loader
                    Visibility(
                      visible: mySubscriptionController.isMealsFetching.value ||
                          mySubscriptionController.isFreezing.value,
                      child: Expanded(
                        child: MealSelectionItemsLoader(),
                      ),
                    ),

                    // Submit BUtton with calories
                    Visibility(
                      visible: !mySubscriptionController.isMealsFetching.value &&
                          !mySubscriptionController.isFreezing.value &&
                          mySubscriptionController
                              .subscriptoinMealConfig.value.meals.isNotEmpty &&
                          (mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
                              VALIDSUBSCRIPTIONDAY_STATUS.offDay ||
                          (mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                              VALIDSUBSCRIPTIONDAY_STATUS.freezed
                          && !isTodayTomorrow(mySubscriptionController.selectedDate.value))) ,
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: APPSTYLE_ContainerTopShadow,
                            color: APPSTYLE_BackgroundWhite),
                        padding: APPSTYLE_LargePaddingHorizontal.copyWith(
                            top: APPSTYLE_SpaceSmall, bottom: APPSTYLE_SpaceSmall),
                        child: Row(
                          children: [
                            CircularPercentIndicator(
                              radius: 20.0,
                              lineWidth: 5.0,
                              percent: getPercentage(
                                  mySubscriptionController.subscriptoinMealConfig
                                      .value.recommendedCalories,
                                  mySubscriptionController.selectedMealConfig
                                      .value.recommendedCalories) /
                                  100,
                              center: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  getPercentage(
                                      mySubscriptionController
                                          .subscriptoinMealConfig
                                          .value
                                          .recommendedCalories,
                                      mySubscriptionController.selectedMealConfig
                                          .value.recommendedCalories)
                                      .toString(),
                                  style: getLabelSmallStyle(context)
                                      .copyWith(color: APPSTYLE_PrimaryColor),
                                ),
                              ),
                              progressColor: APPSTYLE_PrimaryColor,
                            ),
                            addHorizontalSpace(APPSTYLE_SpaceMedium),
                            Expanded(
                                child: Text(
                                  "${mySubscriptionController.selectedMealConfig.value.recommendedCalories} Cal",
                                  style: getHeadlineLargeStyle(context),
                                )),
                            Visibility(
                              visible: (mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                  VALIDSUBSCRIPTIONDAY_STATUS.freezed ||
                                  mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                      VALIDSUBSCRIPTIONDAY_STATUS.mealNotSelected ||
                                  mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) ==
                                      VALIDSUBSCRIPTIONDAY_STATUS.mealSelected)
                                  && !isTodayTomorrow(mySubscriptionController.selectedDate.value),
                              child: SizedBox(
                                  width: screenwidth * .4,
                                  child: ElevatedButton(
                                      child: mySubscriptionController
                                          .isDayMealSaving.value
                                          ? LoadingAnimationWidget.staggeredDotsWave(
                                        color: APPSTYLE_BackgroundWhite,
                                        size: 24,
                                      )
                                          : Text('save'.tr,
                                          style: getHeadlineMediumStyle(context)
                                              .copyWith(
                                              color: APPSTYLE_BackgroundWhite,
                                              fontWeight:
                                              APPSTYLE_FontWeightBold),
                                          textAlign: TextAlign.center),
                                      onPressed: () {
                                        if (!mySubscriptionController
                                            .isDayMealSaving.value &&
                                            !mySubscriptionController
                                                .isMealsFetching.value) {
                                          int subscriptionId = mySubscriptionController.getDaySubId(mySubscriptionController.selectedDate.value);

                                          mySubscriptionController.setMealsByDate(true,subscriptionId,false);
                                        }
                                      })),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> scrollToDate(double screenwidth) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(mySubscriptionController.subscriptionDates
            .indexWhere((element) => isSameDay(mySubscriptionController.selectedDate.value,element.date)) *
            (screenwidth * .15));
        isScrolled = true;
        setState(() {});
      }
    });
  }

  void showFreezeConfirmDialogue(BuildContext context) async {
    final dialogTitleWidget = Text(
        mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
            VALIDSUBSCRIPTIONDAY_STATUS.freezed
            ? 'sub_freeze_title'.tr
            : 'sub_unfreeze_title'.tr,
        style: getHeadlineMediumStyle(context).copyWith(
            color: APPSTYLE_Grey80, fontWeight: APPSTYLE_FontWeightBold));
    final dialogTextWidget = Text(mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
          VALIDSUBSCRIPTIONDAY_STATUS.freezed
          ? 'sub_freeze_content'.tr
          : 'sub_unfreeze_content'.tr,
      style: getBodyMediumStyle(context),
    );

    final updateButtonTextWidget = Text(
      'yes'.tr,
      style: TextStyle(color: APPSTYLE_PrimaryColor),
    );
    final updateButtonCancelTextWidget = Text(
      'no'.tr,
      style: TextStyle(color: APPSTYLE_Black),
    );

    updateLogoutAction() async {
      mySubscriptionController.freezeSubscription(
          mySubscriptionController.selectedDate.value,
          mySubscriptionController.getDayStatus(mySubscriptionController.selectedDate.value) !=
              VALIDSUBSCRIPTIONDAY_STATUS.freezed);
      Get.back();
    }

    updateAction() {
      Navigator.pop(context);
    }

    List<Widget> actions = [
      TextButton(
          onPressed: updateAction,
          style: APPSTYLE_TextButtonStylePrimary.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall))),
          child: updateButtonCancelTextWidget),
      TextButton(
          onPressed: updateLogoutAction,
          style: APPSTYLE_TextButtonStylePrimary.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall))),
          child: updateButtonTextWidget),
    ];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
              title: dialogTitleWidget,
              content: dialogTextWidget,
              actions: actions,
            ),
            onWillPop: () => Future.value(false));
      },
    );
  }

  void openDislikeConfirm(int index, int categoryId, int itemId, int count,BuildContext context) async {
    final dialogTitleWidget = Text( 'confirm_selection'.tr,
        style: getHeadlineMediumStyle(context).copyWith(
            color: APPSTYLE_Grey80, fontWeight: APPSTYLE_FontWeightBold));
    final dialogTextWidget = Text( 'confirm_selection_message'.tr,
      style: getBodyMediumStyle(context),
    );

    final updateButtonTextWidget = Text(
      'yes'.tr,
      style: TextStyle(color: APPSTYLE_PrimaryColor),
    );
    final updateButtonCancelTextWidget = Text(
      'no'.tr,
      style: TextStyle(color: APPSTYLE_Black),
    );

    updateLogoutAction() async {
      mySubscriptionController.addOrRemoveMeal(
          index,categoryId,itemId, count);
      Get.back();
    }

    updateAction() {
      Navigator.pop(context);
    }

    List<Widget> actions = [
      TextButton(
          onPressed: updateAction,
          style: APPSTYLE_TextButtonStylePrimary.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall))),
          child: updateButtonCancelTextWidget),
      TextButton(
          onPressed: updateLogoutAction,
          style: APPSTYLE_TextButtonStylePrimary.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall))),
          child: updateButtonTextWidget),
    ];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
              title: dialogTitleWidget,
              content: dialogTextWidget,
              actions: actions,
            ),
            onWillPop: () => Future.value(false));
      },
    );
  }

  void openExtraCaloryConfirm(int index, int categoryId, int itemId, int count,BuildContext context) async {
    final dialogTitleWidget = Text( 'confirm_selection'.tr,
        style: getHeadlineMediumStyle(context).copyWith(
            color: APPSTYLE_Grey80, fontWeight: APPSTYLE_FontWeightBold));
    final dialogTextWidget = Text( 'confirm_selection_message_calory'.tr,
      style: getBodyMediumStyle(context),
    );

    final updateButtonTextWidget = Text(
      'yes'.tr,
      style: TextStyle(color: APPSTYLE_PrimaryColor),
    );
    final updateButtonCancelTextWidget = Text(
      'no'.tr,
      style: TextStyle(color: APPSTYLE_Black),
    );

    updateLogoutAction() async {
      mySubscriptionController.addOrRemoveMeal(
          index,categoryId,itemId, count);
      Get.back();
    }

    updateAction() {
      Navigator.pop(context);
    }

    List<Widget> actions = [
      TextButton(
          onPressed: updateAction,
          style: APPSTYLE_TextButtonStylePrimary.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall))),
          child: updateButtonCancelTextWidget),
      TextButton(
          onPressed: updateLogoutAction,
          style: APPSTYLE_TextButtonStylePrimary.copyWith(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall))),
          child: updateButtonTextWidget),
    ];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
              title: dialogTitleWidget,
              content: dialogTextWidget,
              actions: actions,
            ),
            onWillPop: () => Future.value(false));
      },
    );
  }


  showRateDialog(int mealId) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(APPSTYLE_BorderRadiusLarge))),
          contentPadding: APPSTYLE_MediumPaddingAll,
          content: Obx(
                ()=> SizedBox(
                height: 75 + (APPSTYLE_SpaceMedium * 5),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text( 'rate_meal'.tr,
                      style: getHeadlineMediumStyle(context)
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    addVerticalSpace(APPSTYLE_SpaceSmall),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {

                                  mySubscriptionController.changeSelectedRating(i+1);
                                },
                                child: Icon(
                                  Icons.star,
                                  size: 30,
                                  color: i + 1 <= mySubscriptionController.currentSelectedRating.value
                                      ? APPSTYLE_GuideYellow
                                      : APPSTYLE_Grey40,
                                ),
                              )),
                      ],
                    ),
                    addVerticalSpace(APPSTYLE_SpaceMedium),
                    Row(
                      children: List.generate(
                          600 ~/ 10,
                              (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey,
                              height: 2,
                            ),
                          )),
                    ),
                    addVerticalSpace(APPSTYLE_SpaceMedium),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text( 'cancel'.tr,
                                style: getBodyMediumStyle(context),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Visibility(
                          visible:  mySubscriptionController.isRatingSubmitting.value,
                          child: Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: APPSTYLE_Grey80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !mySubscriptionController.isRatingSubmitting.value,
                          child: Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if (mySubscriptionController.currentSelectedRating.value > 0) {
                                    mySubscriptionController.rateMeal(mealId);
                                  }
                                },
                                child: Text('rate'.tr,
                                  style: getBodyMediumStyle(context)
                                      .copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )
                      ],
                    )
                  ],
                )
            ),
          )
      ),
    );
  }

  bool ifSaveOperationAllowed(){
    final selectedDate = mySubscriptionController.selectedDate.value;
    final subscriptionDates = mySubscriptionController.getDayStatus(selectedDate);
    final isDateBeforeTwoDays = selectedDate.isBefore(DateTime.now().add(const Duration(days: 2)));

    if (mySubscriptionController.isDayMealSaving.value ||
        mySubscriptionController.isMealsFetching.value ||
        mySubscriptionController.isFreezing.value ||
        mySubscriptionController.subscriptoinMealConfig.value.meals.isEmpty ||
        subscriptionDates == VALIDSUBSCRIPTIONDAY_STATUS.offDay ||
        subscriptionDates == VALIDSUBSCRIPTIONDAY_STATUS.delivered ||
        (subscriptionDates == VALIDSUBSCRIPTIONDAY_STATUS.freezed && isDateBeforeTwoDays) ||
        isDateBeforeTwoDays) {
      return false;
    }

    return true;
  }

}

