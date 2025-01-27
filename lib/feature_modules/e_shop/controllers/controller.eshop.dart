

import 'package:dietdone/feature_modules/address/models/shipping_address.model.address.dart';
import 'package:dietdone/feature_modules/e_shop/models/cart.model.eshop.dart';
import 'package:dietdone/feature_modules/e_shop/models/meal_item.model.eshop.dart';
import 'package:dietdone/feature_modules/e_shop/services/http.services.eshop.dart';
import 'package:dietdone/feature_modules/plan_purchase/models/discount_data.model.plan_purchase.dart';
import 'package:dietdone/feature_modules/plan_purchase/models/payment_data.model.plan_purchase.dart';
import 'package:dietdone/shared_module/constants/app_route_names.constants.shared.dart';
import 'package:dietdone/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:dietdone/shared_module/controllers/controller.shared.dart';
import 'package:dietdone/shared_module/models/general_item.model.shared.dart';
import 'package:dietdone/shared_module/services/utility-services/toaster_snackbar_shower.service.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EshopController extends GetxController {

  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  var isCouponChecking = false.obs;
  var isCouponCodeValid = false.obs;
  var paymentData = mapPaymentData({}).obs;
  var isCategoriesFetching = false.obs;
  var isAddingToOrRemoveFromCart = false.obs;
  var isEmptyingCart = false.obs;
  var subTotal = (0.0).obs;
  var discount = (0.0).obs;
  var total = (0.0).obs;
  var isPurchaseHistoryFetching = false.obs;
  var isOrderCreating = false.obs;
  var isCartDetailsFetching = false.obs;
  var cart = mapCart({}).obs;
  var orders = <Cart>[].obs;
  var isOrdersFetching = false.obs;
  var shiftList = <GeneralItem>[].obs;
  var customerAddressList = <Address>[].obs;
  var isCustomerAddressListFetching = false.obs;
  var isShiftFetching = false.obs;
  var isMealsLoading = false.obs;
  var mealCategories = <GeneralItem>[].obs;
  var meals = <MealItem>[].obs;
  var currentMealCategoryId = (-1).obs;
  var currentMeal = mapMealItem({}).obs;
  var isPaymentGatewayLoading = false.obs;
  var paymentGatewayIsLoading = false.obs;
  var addressId = (-1).obs;
  var shiftId = (-1).obs;


  Future<void> getOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tMobile = prefs.getString('mobile');
    if (tMobile != null && tMobile != '') {
      if(!isOrdersFetching.value ){
        isOrdersFetching.value = true;
        var eshopHttpService = new EshopHttpService();
        orders.value =
        await eshopHttpService.getOrderHistory(tMobile);

        isOrdersFetching.value = false;
      }
    }


  }

  Future<void> getCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tMobile = prefs.getString('mobile');
    if (tMobile != null && tMobile != '') {
      if(!isCartDetailsFetching.value ){
        isCartDetailsFetching.value = true;
        var eshopHttpService = new EshopHttpService();
        cart.value =
        await eshopHttpService.getCartDetails(tMobile);
        subTotal.value = cart.value.total;
        discount.value = 0.0;
        total.value = subTotal.value;
        isCartDetailsFetching.value = false;
        isAddingToOrRemoveFromCart.value = false;
      }
    }


  }

  Future<void> updateCartItem(int mealId, int quantity, bool isAdd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tMobile = prefs.getString('mobile');
    if (tMobile != null && tMobile != '') {
      if(!isAddingToOrRemoveFromCart.value ){
        isAddingToOrRemoveFromCart.value = true;

        var eshopHttpService = new EshopHttpService();
        bool isSuccess = false;
        if(isAdd){
          isSuccess =
          await eshopHttpService.addToCart(tMobile,mealId,quantity);
        }else{
          isSuccess =
          await eshopHttpService.removeFromCart(tMobile,mealId,quantity*-1);
        }
        getCart();

      }
    }


  }

  Future<void> getMealCategories() async {
    if(!isCategoriesFetching.value && !isMealsLoading.value){
      isCategoriesFetching.value = true;
      isMealsLoading.value = true;
      mealCategories.value = [];
      var eshopHttpService = new EshopHttpService();
      mealCategories.value =
      await eshopHttpService.getMealCategories();
      isCategoriesFetching.value = false;
      isMealsLoading.value = false;
      currentMealCategoryId.value = -1;
      update();
      if (mealCategories.isEmpty) {
        currentMeal.value = mapMealItem({});
        meals.value = [];
      }else{
        getMealsByCategory(mealCategories[0].id);
      }
    }

  }

  Future<void> getMealsByCategory(int categoryId) async {
    if(!isCategoriesFetching.value && !isMealsLoading.value && categoryId !=-1){
      isMealsLoading.value = true;
      currentMealCategoryId.value = categoryId;
      currentMeal.value = mapMealItem({});
      meals.value = [];
      var eshopHttpService = EshopHttpService();
      meals.value =
      await eshopHttpService.getMealsByCategory(categoryId);
      isMealsLoading.value = false;

    }
  }

  void viewMeal(MealItem mealItem) {
    if(mealItem.id != -1){
      currentMeal.value = mealItem;
      Get.toNamed(AppRouteNames.eshopMenuItemDetailsRoute);
    }
  }
  Future<void> checkCouponValidity() async {
    isCouponChecking.value = true;
    isCouponCodeValid.value = false;

    var planPurchaseHttpService = EshopHttpService();
    DiscountData discountData = await planPurchaseHttpService.verifyCoupon(
        cart.value.total,
        couponCodeController.value.text);

    if (!discountData.isValid ) {
      isCouponCodeValid.value = false;

      showSnackbar(Get.context!, "coupon_code_not_valid".tr, "error");
      subTotal.value = cart.value.total;
      discount.value = 0.0;
      total.value = subTotal.value;
      couponCodeController.value.text = "";
    } else {
      isCouponCodeValid.value = true;

      subTotal.value = discountData.total;
      discount.value = discountData.discount;
      total.value = discountData.grandTotal;
      showSnackbar(Get.context!, "coupon_code_valid".tr, "info");
    }
    isCouponChecking.value = false;
  }

  void createOrder() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final String? mobile = sharedPreferences.getString('mobile');

    if (mobile != null && mobile != "") {
      isOrderCreating.value = true;
      var planPurchaseHttpService = EshopHttpService();

      PaymentData tPaymentData = await planPurchaseHttpService.checkout(  mobile, addressId.value,shiftId.value,couponCodeController.value.text );
      paymentData.value = tPaymentData;

      if (paymentData.value.paymentUrl == "" ||
          paymentData.value.redirectUrl == "") {
        if ((total.value == 0 || subTotal.value == 0.0) && (paymentData.value.refId!='' && paymentData.value.orderId!='')) {
          showSnackbar(Get.context!, "payment_capture_success".tr, "info");

          Get.toNamed(AppRouteNames.otpVerificationSuccessRoute,arguments: [
            ASSETS_SUCCESSMARK_CHECK,"purchase_success","purchase_success_info",
            'home',false,AppRouteNames.homeRoute,""
          ])?.then((value) => Get.toNamed(AppRouteNames.homeRoute,arguments: [0]));
        }else{
          showSnackbar(Get.context!, "customer_support_message".tr, "error");
        }

        isOrderCreating.value = false;
      } else {
        isPaymentGatewayLoading.value = true;
        Get.toNamed(AppRouteNames.eshopPaymentPageRoute, arguments: [
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

  void changePaymentGatewayLoading(bool status) {
    paymentGatewayIsLoading.value = status;
  }

  paymentGatewayGoback(bool status) {
    Get.back(result: status);
  }
  void checkOrderStatus(String mobile) async {
    isOrderCreating.value = true;
    isPaymentGatewayLoading.value = true;
    var planPurchaseHttpService = EshopHttpService();
    bool isSuccess = await planPurchaseHttpService
        .checkOrderStatus(paymentData.value.refId);
    isOrderCreating.value = false;

    if (!isSuccess) {
      isPaymentGatewayLoading.value = false;
      showSnackbar(Get.context!, "payment_capture_error".tr, "error");
    } else {
      showSnackbar(Get.context!, "purchase_success".tr, "info");
      Get.toNamed(AppRouteNames.otpVerificationSuccessRoute,arguments: [
        ASSETS_SUCCESSMARK_CHECK,"purchase_success","purchase_success_info",
        'home',false,AppRouteNames.homeRoute,""
      ]) ;
    }
  }

  Future<void> emptyCart() async {


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tMobile = prefs.getString('mobile');
    if (tMobile != null && tMobile != '') {
      if(!isEmptyingCart.value ){
        isEmptyingCart.value = true;
        var eshopHttpService = new EshopHttpService();
       bool isSuccess =
            await eshopHttpService.emptyFromCart(tMobile);

        isEmptyingCart.value = false;
        getCart();
      }
    }


  }




  Future<void> getShiftList() async {

    isShiftFetching.value = true;
    shiftList.value = [];
    var addressHttpService = new EshopHttpService();
    shiftList.value =
    await addressHttpService.getShiftList();
    isShiftFetching.value = false;

  }

  Future<void> getCustomerAddressList() async {

    var sharedPreferences = await SharedPreferences.getInstance();
    final String? mobile = sharedPreferences.getString('mobile');

    if(mobile != null && mobile !=""){
      isCustomerAddressListFetching.value = true;
      customerAddressList.value = [];
      var addressHttpService = new EshopHttpService();
      customerAddressList.value =
      await addressHttpService.getUserAddressess(mobile);
      isCustomerAddressListFetching.value = false;
    }

  }

  changeAddressId(int id){
    print("id");
    print(id);
    addressId.value = id;
    update();
  }

  changeShiftId(int id){
    shiftId.value = id;
    update();
  }

}