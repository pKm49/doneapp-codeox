import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:doneapp/shared_module/constants/style_params.constants.shared.dart';
import 'package:doneapp/shared_module/services/utility-services/calendar_utilities.service.shared.dart';
import 'package:flutter/material.dart';

String getCalendarDayText(int index) {
  if (index < 7) {
    return getDayNameByIndex(index);
  }
  if (index == 7) {
    return "31";
  }
  if (index < 39) {
    if ((index - 7) < 10) {
      return '0${(index - 7).toString()}';
    }
    return (index - 7).toString();
  }
  if ((index - 38) < 10) {
    return '0${(index - 38).toString()}';
  }
  return (index - 38).toString();
}

getCalendarDayTextColor(int index) {
  if (index < 7) {
    return APPSTYLE_Black;
  }
  if (index == 7) {
    return APPSTYLE_Grey40;
  }
  if (index > 38) {
    return APPSTYLE_Grey40;
  }
  return APPSTYLE_PrimaryColorBg;
}

getProductImage(image) {
  return (image == ASSETS_SAMPLEFOOD)
      ? AssetImage(ASSETS_SAMPLEFOOD)
      : NetworkImage(image);
}

double getOriginalPercentage(
    double recommendedCalories, double currentSelectedCalories2) {
  if (recommendedCalories == 0.0) {
    return 0;
  }
  double percentage = (currentSelectedCalories2 * 100) / recommendedCalories;
  if (percentage > 100) {
    return percentage;

  }
  if (percentage < 0) {
    return percentage.round() * -1;
  }
  return percentage ;
}
int getPercentage(
    double recommendedCalories, double currentSelectedCalories2) {
  if (recommendedCalories == 0.0) {
    return 0;
  }
  double percentage = (currentSelectedCalories2 * 100) / recommendedCalories;
  if (percentage > 100) {
    return 100;
  }
  if (percentage < 0) {
    return percentage.round() * -1;
  }
  return percentage.round();
}

bool isTodayTomorrow(DateTime dateTime){
  DateTime nowDateTime = DateTime.now();
  DateTime checkDateTime = DateTime(dateTime.year,dateTime.month,dateTime.day,4,30,00);
  DateTime todayDateStartTimeDate = DateTime(nowDateTime.year,nowDateTime.month,nowDateTime.day,4,30,00);
  DateTime twoDaysAfterTodayDate = todayDateStartTimeDate.add(Duration(hours: 48));
  DateTime threeDaysAfterTodayDate = todayDateStartTimeDate.add(Duration(hours: 72));

  if(nowDateTime.isBefore(todayDateStartTimeDate)){
    return checkDateTime.isBefore(twoDaysAfterTodayDate);
  }else{
    return checkDateTime.isBefore(threeDaysAfterTodayDate);
  }
}