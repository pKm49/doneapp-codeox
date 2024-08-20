 
import 'package:doneapp/env.dart' as env;
import 'package:doneapp/feature_modules/plan_purchase/models/payment_data.model.plan_purchase.dart';
import 'package:doneapp/shared_module/constants/http_request_endpoints.constants.shared.dart';
import 'package:doneapp/shared_module/models/http_response.model.shared.dart';
import 'package:doneapp/shared_module/models/my_subscription.model.shared.dart';
import 'package:doneapp/shared_module/models/notification.model.shared.dart';
import 'package:doneapp/shared_module/models/sendotp_credential.model.auth.dart';
import 'package:doneapp/shared_module/models/user_data.model.shared.dart';
import 'package:doneapp/shared_module/services/http-services/http_request_handler.service.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/toaster_snackbar_shower.service.shared.dart';
import 'package:get/get.dart';

class SharedHttpService {
  
  getAccessToken() async {
    Map<String, dynamic> params = {};
    params["client_id"] = env.clientId;
    params["client_secret"] = env.clientSecret;
    AppHttpResponse response = await getRequest(
        SharedHttpRequestEndpoint_GetAccessToken, params);
    print("response is");
    print(response.statusCode);
    print(response.message);
    return;
  }

  Future<UserData> getProfileData(String mobile) async {
    try {
      Map<String, dynamic> params = {};
      params["mobile"] = mobile;
      AppHttpResponse response =
          await getRequest(SharedHttpRequestEndpoint_GetProfileData, params);
      print("getProfileData");
      print(response.data);
      if (response.statusCode == 200 && response.data != null) {
        return mapUserData(response.data[0]);
      }
      return mapUserData({});
    } catch  (e,st){
      print(e);
      print(st);
      return mapUserData({});
    }
  }

  Future<List<MySubscription>> getMySubscriptions(String mobile) async {


    try{

      AppHttpResponse response =
      await getRequest(SharedHttpRequestEndpoint_GetCustomerSubscriptions+mobile,null);

      List<MySubscription> tempMealCategories = [];
      if (response.statusCode == 200 && response.data != null) {
        for (var i = 0; i < response.data.length; i++) {
          tempMealCategories.add(mapMySubscription(response.data[i]));
        }
      }

      return tempMealCategories;

    }catch  (e,st){
      print(e);
      print(st);
      return [];
    }
  }


  Future<List<AppNotification>> getNotifications(String mobile) async {
    try {
      List<AppNotification> notifications = [];
      AppHttpResponse response =
          await getRequest(SharedHttpRequestEndpoint_GetNotifications+"$mobile", null);
      if (response.statusCode == 200 && response.data != null) {
        for (var i = 0; i < response.data.length; i++) {
          notifications.add(mapAppNotification(response.data[i]));
        }
      }
      return notifications;
    } catch  (e,st){
      print(e);
      print(st);
      return [];
    }
  }

  Future<bool> saveDeviceToken(String mobile, String deviceToken) async {
    try {
      Map<String, dynamic> body = {};
      body["mobile"] = mobile;
      body["device_token"] = deviceToken;
      AppHttpResponse response =
          await postRequest(SharedHttpRequestEndpoint_SaveDeviceToken, body);

      return response.statusCode == 200;
    } catch  (e,st){
      print(e);
      print(st);
      return false;
    }
  }

  Future<bool> sendOtp(SendOTPCredential sendOTPCredential) async {

    try{
      AppHttpResponse response = await postRequest(SharedHttpRequestEndpoint_SendOTP, sendOTPCredential.toJson());

      if(response.statusCode != 200){
        showSnackbar(Get.context!, response.message, "error");
      }
      return response.statusCode == 200;
    }catch  (e,st){
      print(e);
      print(st);
      showSnackbar(Get.context!, "something_wrong".tr, "error");
      return false;
    }
  }

  Future<bool> verifyOtp(String mobile, String otp) async {

    try{
      Map<String, dynamic> params = {};
      params["mobile"]=mobile;
      params["otp"]=otp;

      AppHttpResponse response =
      await getRequest(SharedHttpRequestEndpoint_VerifyOTP,params);

      if(response.statusCode != 200){
        showSnackbar(Get.context!, response.message, "error");
      }
      return response.statusCode == 200;
    }catch  (e,st){
      print(e);
      print(st);
      showSnackbar(Get.context!, "something_wrong".tr, "error");
      return false;
    }
  }

 Future<String> getSupportNumber() async {

    try{
      AppHttpResponse response =
          await getRequest(SharedHttpRequestEndpoint_GetSupportNumber,null);
        print("getSupportNumber");
        print(response.statusCode);
        print(response.data);
      if(response.statusCode == 200){
        return response.data;
      }
      return "";
    }catch  (e,st){
      print(e);
      print(st);
      return "";
    }
  }

  Future<bool> bookDietitionAppointment(String mobile) async {
    try {
      Map<String, dynamic> body = {};
      body["mobile"] = mobile;
      AppHttpResponse response =
      await postRequest(SharedHttpRequestEndpoint_BookDietitianAppointment, body);

      return response.statusCode == 200;
    } catch (e,st){
      print(e);
      print(st);
      showSnackbar(Get.context!, "something_wrong".tr, "error");
      return false;
    }
  }

  Future<bool> activateSubscription(int subscriptionId) async {

    try{
      Map<String, dynamic> params = {};
      params["subscription_id"]=subscriptionId;
      AppHttpResponse response =
      await postRequest(SharedHttpRequestEndpoint_ActivateSubscription, params);

      print("activateSubscription");
      print(response.statusCode.toString());
      print(response.data.toString());
      print(response.message.toString());
      return response.statusCode == 200;

    }catch  (e,st){
      print(e);
      print(st);
      return false;
    }
  }

  Future<PaymentData> getPaymentLink(int subscriptionId) async {

    try{
      Map<String, dynamic> params = {};
      params["subscription_id"]=subscriptionId;
      AppHttpResponse response =
      await postRequest(SharedHttpRequestEndpoint_GetPaymentLink, params);
      if (response.statusCode == 200 && response.data != null) {
        print("createOrder inside iff");
        print(response.data[0].toString());
        return mapPaymentData(response.data[0]);

      }else{
        print("createOrder inside else");
        showSnackbar(Get.context!, response.message , "error");
      }
      print("createOrder outside else");

      return mapPaymentData({});

    }catch  (e,st){
      print(e);
      print(st);
      return mapPaymentData({});
    }
  }
}
