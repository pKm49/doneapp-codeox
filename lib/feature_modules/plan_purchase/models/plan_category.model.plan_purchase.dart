import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:intl/intl.dart';

class SubscriptionPlanCategory {
  final int id;
  final String imageUrl;
  final String name;
  final String description;
  final String arabicName;
  final String startDate;
  final String arabicDescription;
  final List<String> mealsConfig;
  final List<String> mealsConfigArabic;

  SubscriptionPlanCategory({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.arabicDescription,
    required this.mealsConfig,
    required this.startDate,
    required this.mealsConfigArabic,
  });

  Map toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'name': name,
        'arabic_name': arabicName,
    'start_date':startDate
      };
}

SubscriptionPlanCategory mapSubscriptionCategory(dynamic payload) {
  List<String> mealConfig = [];
  List<String> mealsConfigArabic = [];

  if (payload["meal_configuration"] != null &&
      payload["meal_configuration"] is! String) {
    payload["meal_configuration"].forEach((element) {
      if (element != null) {
        mealConfig.add(element);
      }
    });
  }

  if (payload["meal_configuration_arabic"] != null &&
      payload["meal_configuration_arabic"] is! String) {
    payload["meal_configuration_arabic"].forEach((element) {
      if (element != null) {
        mealsConfigArabic.add(element);
      }
    });
  }
  return SubscriptionPlanCategory(
      id: payload["id"] ?? -1,
      imageUrl: payload["image"] != null
          ? payload["image"].toString()
          : ASSETS_WELCOME_LOGIN_BG,
      name: payload["name"] != null && payload["name"] != false
          ? payload["name"]
          : "",
      arabicName:
          payload["arabic_name"] != null && payload["arabic_name"] != false
              ? payload["arabic_name"]
              : "",
      startDate: payload['start_date'] ??
          DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 2))),      description:
          payload["description"] != null && payload["description"] != false
              ? payload["description"]
              : "",
      arabicDescription: payload["arabic_description"] != null &&
              payload["arabic_description"] != false
          ? payload["arabic_description"]
          : "",
      mealsConfig: mealConfig,
      mealsConfigArabic: mealsConfigArabic);
}
