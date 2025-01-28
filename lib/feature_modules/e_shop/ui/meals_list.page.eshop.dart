import 'dart:ffi';
import 'dart:ui';

import 'package:doneapp/feature_modules/e_shop/controllers/controller.eshop.dart';
import 'package:doneapp/feature_modules/e_shop/ui/components/meal_category_card.component.eshop.dart';
import 'package:doneapp/feature_modules/e_shop/ui/components/meal_category_card_loader.component.eshop.dart';
import 'package:doneapp/feature_modules/e_shop/ui/components/meal_itemcard.component.eshop.dart';
import 'package:doneapp/feature_modules/e_shop/ui/components/meal_itemsloader.component.eshop.dart';
import 'package:doneapp/shared_module/constants/app_route_names.constants.shared.dart';
import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:doneapp/shared_module/constants/style_params.constants.shared.dart';
import 'package:doneapp/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_generator.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:doneapp/shared_module/ui/components/custom_back_button.component.shared.dart';
import 'package:doneapp/shared_module/ui/components/language_preview_button.component.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MealsListPage_Eshop extends StatefulWidget {
  const MealsListPage_Eshop({super.key});

  @override
  State<MealsListPage_Eshop> createState() => _MealsListPage_EshopState();
}

class _MealsListPage_EshopState extends State<MealsListPage_Eshop> {
  final eshopController = Get.find<EshopController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eshopController.getCart();
    eshopController.getMealCategories();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
          bottomSheet: eshopController.cart.value.orderLine.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: APPSTYLE_SpaceLarge,
                      vertical: APPSTYLE_SpaceSmall),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRouteNames.eshopAddressRoute);
                      },
                      style: getElevatedButtonStyle(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${eshopController.cart.value.total} KD',
                              style: getHeadlineMediumStyle(context).copyWith(
                                  color: APPSTYLE_BackgroundWhite,
                                  fontWeight: APPSTYLE_FontWeightBold),
                            ),
                          ),
                          Text(
                            "checkout".tr,
                            style: getHeadlineMediumStyle(context).copyWith(
                                color: APPSTYLE_BackgroundWhite,
                                fontWeight: APPSTYLE_FontWeightBold),
                          ),
                          addHorizontalSpace(APPSTYLE_SpaceSmall),
                          const Icon(Ionicons.chevron_forward,
                              color: APPSTYLE_BackgroundWhite)
                        ],
                      ),
                    ),
                  ),
                )
              : null,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: APPSTYLE_BackgroundWhite,
            scrolledUnderElevation: 0.0,
            elevation: 0.0,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRouteNames.eshopOrdersPageRoute);
                  },
                  child: Container(
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
                    padding: APPSTYLE_MediumPaddingHorizontal.copyWith(
                      top: APPSTYLE_SpaceSmall,
                      bottom: APPSTYLE_SpaceSmall,
                    ),
                    child: Text(
                      'orders'.tr,
                      style: getBodyMediumStyle(context).copyWith(
                          color: APPSTYLE_BackgroundWhite,
                          fontWeight: APPSTYLE_FontWeightBold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'eshop'.tr,
                      style: getHeadlineLargeStyle(context)
                          .copyWith(fontWeight: APPSTYLE_FontWeightBold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRouteNames.eshopCartRoute);
                },
                child: Badge(
                    backgroundColor:
                        eshopController.cart.value.orderLine.isNotEmpty
                            ? APPSTYLE_PrimaryColor
                            : Colors.transparent,
                    child: const Icon(Ionicons.cart_outline,
                        size: APPSTYLE_FontSize24)),
              ),
              addHorizontalSpace(APPSTYLE_SpaceLarge)
            ],
          ),
          body: SafeArea(
            child: Container(
              height: screenheight,
              child: Column(
                children: [
                  addVerticalSpace(APPSTYLE_SpaceLarge),
                  Visibility(
                      visible: eshopController.isAddingToOrRemoveFromCart.value,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: APPSTYLE_SpaceSmall),
                        child: LinearProgressIndicator(),
                      )),
                  Visibility(
                    visible: eshopController.isCategoriesFetching.value,
                    child: Container(
                      height: 36,
                      width: screenwidth,
                      alignment: Alignment.center,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          addHorizontalSpace(APPSTYLE_SpaceMedium),
                          MealCategoryCardLoaderComponentEshop(),
                          addHorizontalSpace(APPSTYLE_SpaceMedium),
                          MealCategoryCardLoaderComponentEshop(),
                          addHorizontalSpace(APPSTYLE_SpaceMedium),
                          MealCategoryCardLoaderComponentEshop(),
                          addHorizontalSpace(APPSTYLE_SpaceMedium),
                          MealCategoryCardLoaderComponentEshop(),
                          addHorizontalSpace(APPSTYLE_SpaceMedium),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !eshopController.isCategoriesFetching.value &&
                        eshopController.mealCategories.isNotEmpty,
                    child: Container(
                      height: 36,
                      width: screenwidth,
                      alignment: Alignment.center,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          addHorizontalSpace(APPSTYLE_SpaceMedium),
                          for (var i = 0;
                              i < eshopController.mealCategories.length;
                              i++)
                            Container(
                              margin:
                                  EdgeInsets.only(right: APPSTYLE_SpaceSmall),
                              child: MealCategoryCardComponentEshop(
                                  label: Localizations.localeOf(context)
                                              .languageCode
                                              .toString() ==
                                          'ar'
                                      ? eshopController
                                          .mealCategories[i].arabicName
                                      : eshopController.mealCategories[i].name,
                                  isSelected: eshopController
                                          .currentMealCategoryId.value ==
                                      eshopController.mealCategories[i].id,
                                  onClick: () {
                                    eshopController.getMealsByCategory(
                                        eshopController.mealCategories[i].id);
                                  }),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: eshopController.meals.isEmpty &&
                        !eshopController.isMealsLoading.value,
                    child: Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                                color: APPSTYLE_Grey40,
                              ),
                              width: screenwidth * .4,
                              height: screenwidth * .4,
                              child: Center(
                                child: Image.asset(ASSETS_MEALS,
                                    width: screenwidth * .3),
                              ),
                            )
                          ],
                        ),
                        addVerticalSpace(APPSTYLE_SpaceLarge),
                        Text("no_meals_found".tr,
                            style: getHeadlineMediumStyle(context)),
                      ],
                    )),
                  ),
                  Visibility(
                    visible: eshopController.isMealsLoading.value,
                    child: Expanded(
                      child: MealItemsLoader_Eshop(),
                    ),
                  ),
                  Visibility(
                      visible: eshopController.meals.isNotEmpty &&
                          !eshopController.isMealsLoading.value,
                      child: Expanded(
                          child: Padding(
                        padding: APPSTYLE_LargePaddingAll,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: eshopController.meals.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: APPSTYLE_SpaceSmall,
                                  mainAxisExtent: screenheight * 0.35),
                          itemBuilder: (context, indx) {
                            return MealItemCardComponent_Eshop(
                                isSelectable: true,
                                selectedCount: getItemCount(
                                    eshopController.meals[indx].id),
                                mealItem: eshopController.meals[indx],
                                onAdded: (int count) {
                                  print("count");
                                  print(count);
                                  eshopController.updateCartItem(
                                      eshopController.meals[indx].id,
                                      count,
                                      count > 0);
                                });
                          },
                        ),
                      )))
                ],
              ),
            ),
          )),
    );
  }

  getItemCount(int id) {
    if (eshopController.cart.value.orderLine
        .where((element) => element.mealId == id)
        .toList()
        .isNotEmpty) {
      return eshopController.cart.value.orderLine
          .where((element) => element.mealId == id)
          .toList()[0]
          .quantity;
    }
    return 0;
  }
}
