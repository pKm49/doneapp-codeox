import 'dart:convert';

class BufferDetailsResponse {
  bool? statusOk;
  int? statusCode;
  List<dynamic>? message;
  Payload? payload;
  List<dynamic>? error;

  BufferDetailsResponse({
    this.statusOk,
    this.statusCode,
    this.message,
    this.payload,
    this.error,
  });

  factory BufferDetailsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return BufferDetailsResponse(
        statusOk: json["statusOk"] is bool ? json["statusOk"] : null,
        statusCode: json["statusCode"] is int ? json["statusCode"] : null,
        message: json["message"] == null
            ? []
            : (json["message"] is List
            ? List<dynamic>.from(json["message"])
            : null),
        payload: json["payload"] == null
            ? null
            : Payload.fromJson(json["payload"]),
        error: json["error"] == null
            ? []
            : (json["error"] is List
            ? List<dynamic>.from(json["error"])
            : null),
      );
    } catch (e) {
      print("Error parsing BufferDetailsResponse: $e");
      return BufferDetailsResponse(); // Return empty object on parsing error
    }
  }

  Map<String, dynamic> toJson() => {
    "statusOk": statusOk,
    "statusCode": statusCode,
    "message": message ?? [],
    "payload": payload?.toJson(),
    "error": error ?? [],
  };
}

class Payload {
  int? bufferBefore430;
  int? bufferAfter430;
  String? isWednesday;
  int? wednesdayBufferBefore430;
  int? wednesdayBufferAfter430;

  Payload({
    this.bufferBefore430,
    this.bufferAfter430,
    this.isWednesday,
    this.wednesdayBufferBefore430,
    this.wednesdayBufferAfter430,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    try {
      return Payload(
        bufferBefore430: json["buffer_before_4_30"] is int ? json["buffer_before_4_30"] : null,
        bufferAfter430: json["buffer_after_4_30"] is int ? json["buffer_after_4_30"] : null,
        isWednesday: json["is_wednesday"] is String ? json["is_wednesday"] : null,
        wednesdayBufferBefore430: json["wednesday_buffer_before_4_30"] is int ? json["wednesday_buffer_before_4_30"] : null,
        wednesdayBufferAfter430: json["wednesday_buffer_after_4_30"] is int ? json["wednesday_buffer_after_4_30"] : null,
      );
    } catch (e) {
      print("Error parsing Payload: $e");
      return Payload(); // Return empty object on parsing error
    }
  }

  Map<String, dynamic> toJson() => {
    "buffer_before_4_30": bufferBefore430,
    "buffer_after_4_30": bufferAfter430,
    "is_wednesday": isWednesday,
    "wednesday_buffer_before_4_30": wednesdayBufferBefore430,
    "wednesday_buffer_after_4_30": wednesdayBufferAfter430,
  };
}