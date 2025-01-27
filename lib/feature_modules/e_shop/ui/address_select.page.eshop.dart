import 'package:dietdone/feature_modules/address/controllers/address.controller.dart';
import 'package:dietdone/feature_modules/address/ui/components/address_card.component.address.dart';
import 'package:dietdone/feature_modules/e_shop/controllers/controller.eshop.dart';
import 'package:dietdone/feature_modules/e_shop/ui/components/address_card.component.eshop.dart';
import 'package:dietdone/shared_module/constants/app_route_names.constants.shared.dart';
import 'package:dietdone/shared_module/constants/style_params.constants.shared.dart';
import 'package:dietdone/shared_module/constants/valid_addressauthor_modes.constants.shared.dart';
import 'package:dietdone/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:dietdone/shared_module/services/utility-services/dropdown_selected_item_getter.service.shared.dart';
import 'package:dietdone/shared_module/services/utility-services/toaster_snackbar_shower.service.shared.dart';
import 'package:dietdone/shared_module/services/utility-services/widget_generator.service.shared.dart';
import 'package:dietdone/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:dietdone/shared_module/ui/components/custom_back_button.component.shared.dart';
import 'package:dietdone/shared_module/ui/components/dropdown_selector.component.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';

class AddressSelect_Eshop extends StatefulWidget {
  const AddressSelect_Eshop({super.key});

  @override
  State<AddressSelect_Eshop> createState() => _AddressSelect_EshopState();
}

class _AddressSelect_EshopState extends State<AddressSelect_Eshop> {
  VALIDADDRESSAUTHOR_MODES addressAuthorMode =
      VALIDADDRESSAUTHOR_MODES.complete_registration;
  int selectedAddress = -1;

  final GlobalKey<FormState> addressAuditFormKey = GlobalKey<FormState>();
  final addressController = Get.find<EshopController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController.getCustomerAddressList();
    addressController.getShiftList();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          title: Row(
            children: [
              CustomBackButton(isPrimaryMode: false),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'shipping_address'.tr,
                    style: getHeadlineLargeStyle(context)
                        .copyWith(fontWeight: APPSTYLE_FontWeightBold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => Container(
              child: Column(
                children: [
                  Visibility(
                    visible:
                        addressController.isCustomerAddressListFetching.value ||
                            addressController.isShiftFetching.value,
                    child: Expanded(
                        child: ListView(
                      children: [
                        Container(
                            padding: APPSTYLE_MediumPaddingAll,
                            margin: APPSTYLE_LargePaddingAll,
                            decoration:
                                APPSTYLE_ShadowedContainerMediumDecoration,
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: APPSTYLE_Grey20,
                                    highlightColor: APPSTYLE_Grey40,
                                    child: Container(
                                      height: 30,
                                      width: screenwidth * .15,
                                      decoration:
                                          APPSTYLE_BorderedContainerExtraSmallDecoration
                                              .copyWith(
                                        border: null,
                                        color: APPSTYLE_Grey20,
                                        borderRadius: BorderRadius.circular(
                                            APPSTYLE_BlurRadiusSmall),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              addVerticalSpace(APPSTYLE_SpaceSmall),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Shimmer.fromColors(
                                      baseColor: APPSTYLE_Grey20,
                                      highlightColor: APPSTYLE_Grey40,
                                      child: Container(
                                        height: screenwidth * .15,
                                        decoration:
                                            APPSTYLE_BorderedContainerExtraSmallDecoration
                                                .copyWith(
                                          border: null,
                                          color: APPSTYLE_Grey20,
                                          borderRadius: BorderRadius.circular(
                                              APPSTYLE_BlurRadiusSmall),
                                        ),
                                      ),
                                    ),
                                  ),
                                  addHorizontalSpace(APPSTYLE_SpaceSmall),
                                  Shimmer.fromColors(
                                    baseColor: APPSTYLE_Grey20,
                                    highlightColor: APPSTYLE_Grey40,
                                    child: Container(
                                      height: screenwidth * .15,
                                      width: screenwidth * .15,
                                      decoration:
                                          APPSTYLE_BorderedContainerExtraSmallDecoration
                                              .copyWith(
                                        border: null,
                                        color: APPSTYLE_Grey20,
                                        borderRadius: BorderRadius.circular(
                                            APPSTYLE_BlurRadiusSmall),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                      ],
                    )),
                  ),
                  Visibility(
                    visible: addressController.customerAddressList.isNotEmpty &&
                        !addressController
                            .isCustomerAddressListFetching.value &&
                        !addressController.isShiftFetching.value,
                    child: Expanded(
                      child: ListView.builder(
                          itemCount:
                              addressController.customerAddressList.length,
                          itemBuilder: (context, index) {
                            return AddressCardComponentEshop(
                              selectedId: getSelectedAddress(),
                              onSelected: () {
                                addressController.changeAddressId(
                                    addressController
                                        .customerAddressList[index].id);
                              },
                              shippingAddress:
                                  addressController.customerAddressList[index],
                            );
                          }),
                    ),
                  ),
                  Visibility(
                    visible: addressController.customerAddressList.isEmpty &&
                        !addressController
                            .isCustomerAddressListFetching.value &&
                        !addressController.isShiftFetching.value,
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
                                color: APPSTYLE_Grey20,
                              ),
                              width: screenwidth * .3,
                              height: screenwidth * .3,
                              child: Center(
                                child: Icon(Ionicons.location_sharp,
                                    size: screenwidth * .15,
                                    color: APPSTYLE_PrimaryColorBg),
                              ),
                            )
                          ],
                        ),
                        addVerticalSpace(APPSTYLE_SpaceLarge),
                        Text("no_address".tr,
                            style: getHeadlineMediumStyle(context)),
                      ],
                    )),
                  ),
                  Visibility(
                    visible: addressController.shiftList.isNotEmpty &&
                        !addressController.isShiftFetching.value,
                    child: Container(
                      margin: APPSTYLE_LargePaddingHorizontal.copyWith(
                          bottom: APPSTYLE_SpaceMedium),
                      padding: APPSTYLE_MediumPaddingHorizontal,
                      decoration:
                          APPSTYLE_ShadowedContainerSmallDecoration.copyWith(
                        color: APPSTYLE_BackgroundWhite,
                        boxShadow: [
                          const BoxShadow(
                            color: APPSTYLE_Grey80Shadow24,
                            offset: Offset(0, 2.0),
                            blurRadius: APPSTYLE_BlurRadiusLarge,
                          ),
                        ],
                      ),
                      child: DropDownSelector(
                        titleText: 'shift'.tr,
                        selected: addressController.shiftId.value,
                        items: addressController.shiftList,
                        hintText: 'select_shift'.tr,
                        valueChanged: (newAreaId) {
                          addressController.changeShiftId(int.parse(newAreaId));
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !addressController
                            .isCustomerAddressListFetching.value &&
                        addressController.customerAddressList.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: APPSTYLE_SpaceLarge,
                          vertical: APPSTYLE_SpaceSmall),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (addressController.addressId.value != -1 &&
                                addressController.shiftId.value != -1) {
                              Get.toNamed(AppRouteNames.eshopCheckoutRoute);
                            } else {
                              if (addressController.addressId.value == -1) {
                                showSnackbar(context,
                                    "please_select_address".tr, "info");
                              } else {
                                showSnackbar(
                                    context, "please_select_time".tr, "info");
                              }
                            }
                          },
                          style: getElevatedButtonStyle(context),
                          child: Text(
                            "continue".tr,
                            style: getHeadlineMediumStyle(context).copyWith(
                                color: APPSTYLE_BackgroundWhite,
                                fontWeight: APPSTYLE_FontWeightBold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  getSelectedAddress() {
    return addressController.addressId.value;
  }
}
