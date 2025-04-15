import 'dart:ffi';

import 'package:doneapp/feature_modules/plan_purchase/models/discount_data.model.plan_purchase.dart';
import 'package:doneapp/feature_modules/plan_purchase/models/payment_data.model.plan_purchase.dart';
import 'package:doneapp/feature_modules/plan_purchase/models/plan.model.plan_purchase.dart';
import 'package:doneapp/feature_modules/plan_purchase/models/plan_category.model.plan_purchase.dart';
import 'package:doneapp/feature_modules/plan_purchase/models/purchase_data.model.plan_purchase.dart';
import 'package:doneapp/feature_modules/plan_purchase/services/http.services.plan_purchase.dart';
import 'package:doneapp/shared_module/constants/app_route_names.constants.shared.dart';
import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:doneapp/shared_module/constants/default_values.constants.shared.dart';
import 'package:doneapp/shared_module/controllers/controller.shared.dart';
import 'package:doneapp/shared_module/models/subscription_date.model.my_subscription.dart';
import 'package:doneapp/shared_module/services/utility-services/toaster_snackbar_shower.service.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

import '../../my_subscription/models/buffer_response.dart';
import '../../my_subscription/services/http.my_subscription.service.dart';

class PlanPurchaseController extends GetxController {
  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  final sharedController = Get.find<SharedController>();

  var subscriptionCategories = <SubscriptionPlanCategory>[].obs;
  var subscriptionDurations = <int>[].obs;
  var subscriptions = <SubscriptionPlan>[].obs;
  var isSubscriptionsFetching = false.obs;
  var isCategoriesFetching = false.obs;
  Rx<SubscriptionPlanCategory> currentCategory =
      mapSubscriptionCategory({}).obs;
  Rx<SubscriptionPlan> currentSubscription = mapSubscriptionItem({}).obs;

  var paymentData = mapPaymentData({}).obs;
  var subTotal = (0.0).obs;
  var discount = (0.0).obs;
  var total = (0.0).obs;
  var subscriptionId = (-1).obs;
  var isCouponChecking = false.obs;
  var isCouponCodeValid = false.obs;
  var isOrderCreating = false.obs;
  var isDateChecking = false.obs;
  var isPaymentGatewayLoading = false.obs;
  var paymentGatewayIsLoading = false.obs;
  int? bufferBeforeFourThirty;
  int? bufferAfterFourThirty;
  int? bufferAfterFourThirtyWednesday;
  int? bufferBeforeFourThirtyWednesday;

  var subscriptionDates = <SubscriptoinDate>[].obs;

  // calendar
  var firstWeekDays = <DateTime>[].obs;
  var secondWeekDays = <DateTime>[].obs;
  var thirdWeekDays = <DateTime>[].obs;
  var fourthWeekDays = <DateTime>[].obs;
  var fifthWeekDays = <DateTime>[].obs;
  var sixthWeekDays = <DateTime>[].obs;
  var minimumPossibleDate = DateTime.now().obs;
  var selectedDate = DefaultInvalidDate.obs;
  var currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getBufferTime();
    setMinimumPossibleDate();
    setCurrentMonthWeekDays();

    couponCodeController.value.addListener(() {
      resetCouponCode();
    });
  }
  void setMinimumPossibleDate() {
    tz.initializeTimeZones();
    final kuwaitTimeZone = tz.getLocation('Asia/Kuwait');
    final nowInKuwait = tz.TZDateTime.now(kuwaitTimeZone);

    print("Current Kuwait time: $nowInKuwait");

    // Create 4:30 AM threshold for today
    final today430AM = tz.TZDateTime(
      kuwaitTimeZone,
      nowInKuwait.year,
      nowInKuwait.month,
      nowInKuwait.day,
      4,
      30,
    );

    print("Today's 4:30 AM threshold: $today430AM");
    print("Is before 4:30 AM? ${nowInKuwait.isBefore(today430AM)}");

    // Calculate days to add based on current time and day
    Duration durationToAdd;
    bool isWednesday = nowInKuwait.weekday == 2;

    if (isWednesday) {
      durationToAdd = nowInKuwait.isBefore(today430AM)
          ? Duration(hours: bufferBeforeFourThirtyWednesday??72)
          :  Duration(hours: bufferAfterFourThirtyWednesday??96);
    } else {
      durationToAdd = nowInKuwait.isBefore(today430AM)
          ?  Duration(hours: bufferBeforeFourThirty??48)
          :  Duration(hours: bufferAfterFourThirty??72);
    }
    // Calculate the minimum date
    final minSelectableDate = nowInKuwait.add(durationToAdd);

    // Create date-only version (midnight) in Kuwait timezone
    final minSelectableDateOnly = tz.TZDateTime(
      kuwaitTimeZone,
      minSelectableDate.year,
      minSelectableDate.month,
      minSelectableDate.day,
    );

    minimumPossibleDate.value = minSelectableDateOnly;

    print("📅 Calculated minimum date: ${minimumPossibleDate.value}");
  }

  Future<void> getBufferTime()async{
    var mySubsHttpService = MySubsHttpService();
    BufferDetailsResponse response= await mySubsHttpService.getBufferTime();
    bufferBeforeFourThirty=response.payload?.bufferBefore430??48;
    bufferAfterFourThirty=response.payload?.bufferAfter430??72;
    bufferAfterFourThirtyWednesday=response.payload?.wednesdayBufferAfter430??96;
    bufferBeforeFourThirtyWednesday=response.payload?.wednesdayBufferBefore430??72;

  }

  void setMinimumPossibleDateForPlan(String? planStartDate) {
    tz.initializeTimeZones();
    final kuwaitTimeZone = tz.getLocation('Asia/Kuwait');
    final nowInKuwait = tz.TZDateTime.now(kuwaitTimeZone);

    print("\n🕒 Calculating dates:");
    print("Current Kuwait time: $nowInKuwait");
    print("Raw plan start date string: $planStartDate");

    // 1. Calculate system minimum date based on 4:30 AM rule
    final today430AM = tz.TZDateTime(
      kuwaitTimeZone,
      nowInKuwait.year,
      nowInKuwait.month,
      nowInKuwait.day,
      4,
      30,
    );

    print("Today's 4:30 AM threshold: $today430AM");
    print("Is before 4:30 AM? ${nowInKuwait.isBefore(today430AM)}");

    Duration durationToAdd;
    bool isWednesday = nowInKuwait.weekday == 2;

    if (isWednesday) {
      durationToAdd = nowInKuwait.isBefore(today430AM)
          ? Duration(hours: bufferBeforeFourThirtyWednesday??72)
          :  Duration(hours: bufferAfterFourThirtyWednesday??96);
    } else {
      durationToAdd = nowInKuwait.isBefore(today430AM)
          ?  Duration(hours: bufferBeforeFourThirty??48)
          :  Duration(hours: bufferAfterFourThirty??72);
    }

    final systemMinDate = tz.TZDateTime(
        kuwaitTimeZone,
        nowInKuwait.add(durationToAdd).year,
        nowInKuwait.add(durationToAdd).month,
        nowInKuwait.add(durationToAdd).day,
        0, 0, 0, 0
    );

    print("System calculated minimum date: $systemMinDate");

    // 2. Parse and validate plan start date
    if (planStartDate != null && planStartDate.isNotEmpty) {
      // Remove the UTC conversion and directly parse to Kuwait timezone
      try {
        // Parse the date string directly
        List<int> dateParts = planStartDate.split('-').map(int.parse).toList();

        // Create date in Kuwait timezone
        DateTime planStartDateTime = tz.TZDateTime(
            kuwaitTimeZone,
            dateParts[0],  // year
            dateParts[1],  // month
            dateParts[2],  // day
            0, 0, 0, 0
        );

        print("Parsed plan start date (Kuwait): $planStartDateTime");

        if (systemMinDate.isAfter(planStartDateTime)) {
          print("Using system minimum date as it's later than plan start date");
          minimumPossibleDate.value = systemMinDate;
        } else {
          print("Using plan start date as it's later than system minimum date");
          minimumPossibleDate.value = planStartDateTime;
        }
      } catch (e) {
        print("Error parsing plan start date: $e");
        print("Using system minimum date due to parsing error");
        minimumPossibleDate.value = systemMinDate;
      }
    } else {
      print("No plan start date provided, using system minimum date");
      minimumPossibleDate.value = systemMinDate;
    }

    print("📅 Final minimum possible date: ${minimumPossibleDate.value}");
  }
  getSubscriptionDates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tMobile = prefs.getString('mobile');
    if (tMobile != null && tMobile != '') {
      var planPurchaseHttpService = new PlanPurchaseHttpService();
      subscriptionDates.value =
          await planPurchaseHttpService.getSubscriptionDates(tMobile);
      if (subscriptionDates.isNotEmpty) {
        DateTime dateTime = subscriptionDates.last.date;
        currentMonth.value = DateTime(dateTime.year, dateTime.month, 1);
      }
      setCurrentMonthWeekDays();
    }
  }

  Future<void> getSubscriptionCategories() async {
    getSubscriptionDates();
    isCategoriesFetching.value = true;
    subscriptionCategories.value = [];
    isPaymentGatewayLoading.value = false;
    var planPurchaseHttpService = new PlanPurchaseHttpService();
    subscriptionCategories.value =
        await planPurchaseHttpService.getSubscriptionCategories();
    isCategoriesFetching.value = false;

    update();
    if (subscriptionCategories.isEmpty) {
      currentSubscription.value = mapSubscriptionItem({});
      subscriptionDurations.value = [];
      subscriptions.value = [];
      subTotal.value = 0.0;
      total.value = 0.0;
      discount.value = 0.0;
    } else {
      changeCategory(subscriptionCategories[0]);
    }
  }

  changeCategory(SubscriptionPlanCategory subscriptionPlanCategory) {
    currentCategory.value = subscriptionPlanCategory;
  }

  void changeSubscription(SubscriptionPlan subscription) {

    currentSubscription.value = subscription;
    subTotal.value = currentSubscription.value.price;
    discount.value = 0.0;
    total.value = subTotal.value - discount.value;
  }

  Future<void> getSubscriptionsByCategory() async {
    isPaymentGatewayLoading.value = false;
    isSubscriptionsFetching.value = true;
    subscriptions.value = [];
    var planPurchaseHttpService = PlanPurchaseHttpService();
    subscriptions.value = await planPurchaseHttpService
        .getSubscriptionsByCategory(currentCategory.value);
    update();

    subTotal.value = 0.0;
    total.value = 0.0;
    discount.value = 0.0;

    currentSubscription.value = mapSubscriptionItem({});
    isSubscriptionsFetching.value = false;
  }

  resetCouponCode() {
    isCouponCodeValid.value = false;
    subTotal.value = currentSubscription.value.price;
    discount.value = 0.0;
    total.value = subTotal.value;
  }

  Future<void> checkCouponValidity() async {
    isCouponChecking.value = true;
    isCouponCodeValid.value = false;
    var sharedPreferences = await SharedPreferences.getInstance();
    final String? mobile = sharedPreferences.getString('mobile');


    var planPurchaseHttpService = PlanPurchaseHttpService();
    DiscountData discountData = await planPurchaseHttpService.verifyCoupon(
        currentSubscription.value.id, couponCodeController.value.text,mobile??"");

    if (!discountData.isValid) {
      isCouponCodeValid.value = false;

      showSnackbar(Get.context!, "coupon_code_not_valid".tr, "error");
      subTotal.value = currentSubscription.value.price;
      discount.value = 0.0;
      total.value = subTotal.value;
      couponCodeController.value.text = "";
    } else {
      isCouponCodeValid.value = true;

      subTotal.value = discountData.total;
      discount.value = discountData.discount;
      total.value = discountData.grandTotal;
      // showSnackbar(Get.context!, "coupon_code_valid".tr, "info");
    }
    isCouponChecking.value = false;
  }

  void createOrder() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final String? mobile = sharedPreferences.getString('mobile');

    if (mobile != null && mobile != "") {
      isOrderCreating.value = true;
      var planPurchaseHttpService = PlanPurchaseHttpService();

      PaymentData tPaymentData = await planPurchaseHttpService.createOrder(
          PurchaseData(
              planCategoryId: currentCategory.value.id,
              planId: currentSubscription.value.id,
              startDate: selectedDate.value,
              promoCode: couponCodeController.value.text,
              mobile: mobile));
      paymentData.value = tPaymentData;

      if (paymentData.value.paymentUrl == "" ||
          paymentData.value.redirectUrl == "") {
        if ((total.value == 0 || total.value == 0.0) &&
            (paymentData.value.refId != '' &&
                paymentData.value.orderId != '')) {
          showSnackbar(Get.context!, "payment_capture_success".tr, "info");
          activatePlan(paymentData.value.subscriptionId);
          Get.toNamed(AppRouteNames.otpVerificationSuccessRoute, arguments: [
            ASSETS_SUCCESSMARK_CHECK,
            "subscription_success",
            "subscription_success_info",
            'home',
            false,
            AppRouteNames.homeRoute,
            ""
          ])?.then(
              (value) => Get.toNamed(AppRouteNames.homeRoute, arguments: [0]));
        } else {
          showSnackbar(Get.context!, "customer_support_message".tr, "error");
        }

        isOrderCreating.value = false;
      } else {
        isPaymentGatewayLoading.value = true;
        Get.toNamed(AppRouteNames.paymentPageRoute, arguments: [
          paymentData.value.paymentUrl,
          paymentData.value.redirectUrl,
          paymentData.value.paymentCheckUrl
        ])?.then((value) => checkOrderStatus(mobile));
      }
    } else {
      showSnackbar(Get.context!, "login_message".tr, "error");
      Get.offAllNamed(AppRouteNames.loginRoute);
    }
  }

  void checkDateStatus() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final String? mobile = sharedPreferences.getString('mobile');

    if (mobile != null && mobile != "" && !isDateChecking.value) {
      isDateChecking.value = true;
      var planPurchaseHttpService = PlanPurchaseHttpService();
      String dateString = DateFormat("yyyy-MM-dd").format(selectedDate.value);
      bool isSuccess = await planPurchaseHttpService.checkDateAvailability(
          dateString, mobile, currentSubscription.value.id);
      isDateChecking.value = false;

      if (isSuccess) {
        isDateChecking.value = false;
        Get.toNamed(AppRouteNames.planPurchaseCheckoutRoute);
      }
    }
  }

  void checkOrderStatus(String mobile) async {
    isOrderCreating.value = true;
    isPaymentGatewayLoading.value = true;
    var planPurchaseHttpService = PlanPurchaseHttpService();
    bool isSuccess =
        await planPurchaseHttpService.checkOrderStatus(paymentData.value.refId);
    isOrderCreating.value = false;

    if (!isSuccess) {
      isPaymentGatewayLoading.value = false;
      showSnackbar(Get.context!, "payment_capture_error".tr, "error");
    } else {
      showSnackbar(Get.context!, "payment_capture_success".tr, "info");
      activatePlan(paymentData.value.subscriptionId);
      Get.toNamed(AppRouteNames.otpVerificationSuccessRoute, arguments: [
        ASSETS_SUCCESSMARK_CHECK,
        "subscription_success",
        "subscription_success_info",
        'home',
        false,
        AppRouteNames.homeRoute,
        ""
      ]);
    }
  }

  void activatePlan(int subscriptionId) async {
    if (subscriptionId != -1) {
      var planPurchaseHttpService = PlanPurchaseHttpService();
      bool isSuccess =
          await planPurchaseHttpService.activateSubscription(subscriptionId);

      resetData();
    }
  }

  paymentGatewayGoback(bool status) {
    Get.back(result: status);
  }

  void changePaymentGatewayLoading(bool status) {
    paymentGatewayIsLoading.value = status;
  }

  void resetData() {
    couponCodeController.value.text = "";
    currentSubscription.value = mapSubscriptionItem({});
    isPaymentGatewayLoading.value = false;
    isSubscriptionsFetching.value = false;
    isCategoriesFetching.value = false;
    currentCategory.value = mapSubscriptionCategory({});
    paymentData.value = mapPaymentData({});
    subTotal.value = (0.0);
    discount.value = (0.0);
    total.value = (0.0);
    isCouponChecking.value = false;
    isOrderCreating.value = false;
    paymentGatewayIsLoading.value = false;
    isCouponCodeValid.value = false;
    couponCodeController.value.text = "";
  }

  void setSelectedDate(DateTime date) {
    final kuwaitTimeZone = tz.getLocation('Asia/Kuwait');

    // Convert to Kuwait timezone but preserve the date
    DateTime kuwaitDate = tz.TZDateTime(
        kuwaitTimeZone,
        date.year,
        date.month,
        date.day,
        0, 0, 0, 0
    );

    print("\n📅 Setting selected date:");
    print("Original date: $date");
    print("Kuwait date: $kuwaitDate");

    selectedDate.value = kuwaitDate;
  }

  void previousMonth() {
    var thisMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

    var newDate = DateTime(currentMonth.value.year,
        currentMonth.value.month - 1, currentMonth.value.day);
    if (newDate.isAfter(thisMonth) ||
        (thisMonth.month == newDate.month && thisMonth.year == newDate.year)) {
      currentMonth.value = newDate;
      setCurrentMonthWeekDays();
    }
  }

  void nextMonth() {
    var newDate = DateTime(currentMonth.value.year,
        currentMonth.value.month + 1, currentMonth.value.day);
    currentMonth.value = newDate;
    setCurrentMonthWeekDays();
  }

  setCurrentMonthWeekDays() {
    List<DateTime> weekDays = [];
    DateTime weekStartDate = getDate(currentMonth.value
        .subtract(Duration(days: currentMonth.value.weekday)));
    DateTime weekEndDate = getDate(currentMonth.value.add(Duration(
        days: DateTime.daysPerWeek - (currentMonth.value.weekday + 1))));

    if (weekStartDate.month < currentMonth.value.month &&
        weekEndDate.month < currentMonth.value.month) {
      weekStartDate = currentMonth.value;
      weekEndDate = currentMonth.value.add(Duration(days: 6));
    }

    firstWeekDays.clear();
    secondWeekDays.clear();
    thirdWeekDays.clear();
    fourthWeekDays.clear();
    fifthWeekDays.clear();
    sixthWeekDays.clear();
    for (int index = 1; index <= 6; index++) {
      weekDays = [];
      if (index != 1) {
        weekStartDate = weekStartDate.add(Duration(days: 7));
        weekEndDate = weekEndDate.add(Duration(days: 7));
      }

      for (int i = 0; i <= weekEndDate.difference(weekStartDate).inDays; i++) {
        weekDays.add(weekStartDate.add(Duration(days: i)));
      }

      switch (index) {
        case 1:
          {
            firstWeekDays.addAll(weekDays);
            break;
          }
        case 2:
          {
            secondWeekDays.addAll(weekDays);
            break;
          }
        case 3:
          {
            thirdWeekDays.addAll(weekDays);
            break;
          }
        case 4:
          {
            fourthWeekDays.addAll(weekDays);
            break;
          }
        case 5:
          {
            fifthWeekDays.addAll(weekDays);
            break;
          }
        case 6:
          {
            sixthWeekDays.addAll(weekDays);
            break;
          }
      }
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> planChoiceSelected() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final String? mobile = sharedPreferences.getString('mobile');

    if (mobile != null && mobile != "") {
      Get.toNamed(AppRouteNames.planPurchaseSetInitialDateRoute);
    } else {
      showSnackbar(Get.context!, "login_message".tr, "info");
      Get.toNamed(AppRouteNames.loginRoute);
    }
  }
}
