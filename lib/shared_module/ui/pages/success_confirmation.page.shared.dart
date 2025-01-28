import 'package:doneapp/shared_module/constants/app_route_names.constants.shared.dart';
import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:doneapp/shared_module/constants/style_params.constants.shared.dart';
import 'package:doneapp/shared_module/constants/valid_addressauthor_modes.constants.shared.dart';
import 'package:doneapp/shared_module/constants/widget_styles.constants.shared.dart';
import 'package:doneapp/shared_module/controllers/controller.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/toaster_snackbar_shower.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_generator.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/widget_properties_generator.service.shared.dart';
import 'package:doneapp/shared_module/ui/components/language_preview_button.component.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessConfirmationPage_Shared extends StatefulWidget {
  const SuccessConfirmationPage_Shared({super.key});

  @override
  State<SuccessConfirmationPage_Shared> createState() =>
      _SuccessConfirmationPage_SharedState();
}

class _SuccessConfirmationPage_SharedState
    extends State<SuccessConfirmationPage_Shared> {
  var getArguments = Get.arguments;
  String assetUrl = ASSETS_SUCCESSMARK;
  String pageTitle = "password_changed";
  String pageInfo = "password_changed_message";
  String buttonText = "back_to_login";
  String toRoute = AppRouteNames.addressAuditRoute;
  String mobile = "";
  bool isButtonPrimary = true;

  @override
  void initState() {
    // TODO: implement initState

    assetUrl = getArguments[0];
    pageTitle = getArguments[1];
    pageInfo = getArguments[2];
    buttonText = getArguments[3];
    isButtonPrimary = getArguments[4];
    toRoute = getArguments[5];
    mobile = getArguments[6];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: APPSTYLE_BackgroundWhite,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: Row(
          children: [
            Visibility(
                visible: pageTitle == 'subscription_success',
                child: Image.asset(ASSETS_NAMELOGO_PRIMARY,
                    width: screenwidth * .2))
          ],
        ),
        actions: [
          Visibility(
              visible: pageTitle != 'subscription_success',
              child: LanguagePreviewButtonComponentShared(
                  textColor: APPSTYLE_PrimaryColor)),
          Visibility(
              visible: pageTitle != 'subscription_success',
              child: addHorizontalSpace(APPSTYLE_SpaceLarge))
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: pageTitle == 'subscription_success'
            ? Container(
                height: screenheight,
                width: screenwidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  ASSETS_SUCCESSMARK_SS,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ASSETS_SUCCESSMARK_CHECK,
                                  width: pageTitle != 'subscription_success'
                                      ? screenwidth * .5
                                      : screenwidth * .4,
                                ),
                              ],
                            ),
                            addVerticalSpace(APPSTYLE_SpaceLarge),
                            Visibility(
                              visible: pageTitle != 'subscription_success',
                              child: Text(pageTitle.tr,
                                  textAlign: TextAlign.center,
                                  style: getHeadlineLargeStyle(context)
                                      .copyWith(
                                          fontSize: APPSTYLE_FontSize24 * 1.5)),
                            ),
                            Visibility(
                              visible: pageTitle == 'subscription_success',
                              child: Text("Payment Successfull",
                                  textAlign: TextAlign.center,
                                  style: getHeadlineLargeStyle(context)
                                      .copyWith(
                                          fontSize: APPSTYLE_FontSize24 * 1.2,
                                          color: APPSTYLE_WhatsappGreen)),
                            ),
                            Visibility(
                                visible: pageTitle == 'subscription_success',
                                child: addVerticalSpace(APPSTYLE_SpaceLarge)),
                            Visibility(
                              visible: pageTitle == 'subscription_success',
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Welcome to',
                                  style: getHeadlineLargeStyle(context)
                                      .copyWith(color: APPSTYLE_Grey80),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: " DONE ",
                                        style: TextStyle(
                                            fontWeight: APPSTYLE_FontWeightBold,
                                            color: APPSTYLE_PrimaryColor)),
                                    TextSpan(
                                        text: "Family", style: TextStyle()),
                                  ],
                                ),
                              ),
                            ),
                            addVerticalSpace(APPSTYLE_SpaceLarge),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: APPSTYLE_LargePaddingAll,
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: getElevatedButtonStyle(context),
                              child: Text(
                                buttonText.tr,
                                style: getHeadlineMediumStyle(context).copyWith(
                                    color: APPSTYLE_BackgroundWhite,
                                    fontWeight: APPSTYLE_FontWeightBold),
                              ),
                              onPressed: () async {
                                //       showSnackbar(Get.context!, "password_reset".tr, "info");
                                if (toRoute ==
                                    AppRouteNames.addressAuditRoute) {
                                  Get.toNamed(AppRouteNames.addressAuditRoute,
                                      arguments: [
                                        VALIDADDRESSAUTHOR_MODES
                                            .complete_registration,
                                        mobile
                                      ]);
                                } else if (toRoute ==
                                    AppRouteNames.loginRoute) {
                                  showSnackbar(
                                      Get.context!, "login_message".tr, "info");
                                  final sharedController =
                                      Get.find<SharedController>();
                                  await sharedController.handleLogout();
                                } else {
                                  Get.offAllNamed(toRoute);
                                }
                              })),
                    ),
                  ],
                ),
              )
            : Container(
                height: screenheight,
                width: screenwidth,
                padding: APPSTYLE_LargePaddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          addVerticalSpace(APPSTYLE_SpaceLarge * 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                assetUrl,
                                width: screenwidth * .5,
                              )
                            ],
                          ),
                          addVerticalSpace(APPSTYLE_SpaceLarge),
                          Text(pageTitle.tr,
                              textAlign: TextAlign.center,
                              style: getHeadlineLargeStyle(context).copyWith(
                                  fontSize: APPSTYLE_FontSize24 * 1.5)),
                          addVerticalSpace(APPSTYLE_SpaceLarge),
                          Text(pageInfo.tr,
                              textAlign: TextAlign.center,
                              style:
                                  getHeadlineMediumStyle(context).copyWith()),
                          addVerticalSpace(APPSTYLE_SpaceLarge * 3),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: getElevatedButtonStyle(context),
                            child: Text(
                              buttonText.tr,
                              style: getHeadlineMediumStyle(context).copyWith(
                                  color: APPSTYLE_BackgroundWhite,
                                  fontWeight: APPSTYLE_FontWeightBold),
                            ),
                            onPressed: () async {
                              //       showSnackbar(Get.context!, "password_reset".tr, "info");
                              if (toRoute == AppRouteNames.addressAuditRoute) {
                                Get.toNamed(AppRouteNames.addressAuditRoute,
                                    arguments: [
                                      VALIDADDRESSAUTHOR_MODES
                                          .complete_registration,
                                      mobile
                                    ]);
                              } else if (toRoute == AppRouteNames.loginRoute) {
                                showSnackbar(
                                    Get.context!, "login_message".tr, "info");
                                final sharedController =
                                    Get.find<SharedController>();
                                await sharedController.handleLogout();
                              } else {
                                Get.offAllNamed(toRoute);
                              }
                            })),
                  ],
                ),
              ),
      ),
    );
  }
}
