class EventDetailsModel {
  final int? id;
  final bool? status;
  final String? message;
  final EventResponse? response;

  EventDetailsModel({
    this.id,
    this.status,
    this.message,
    this.response,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['Id'],
      status: json['status'],
      message: json['message'],
      response: json['response'] != null
          ? EventResponse.fromJson(json['response'])
          : null,
    );
  }
}

class EventResponse {
  final String? refNo;
  final String? cmpCode;
  final String? userId;
  final List<EventData>? dataList;

  EventResponse({
    this.refNo,
    this.cmpCode,
    this.userId,
    this.dataList,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    final dtList = json['_dt'] as List?;
    return EventResponse(
      refNo: json['RefNo'],
      cmpCode: json['Cmp_Code'],
      userId: json['UserId'],
      dataList:
          dtList != null ? dtList.map((e) => EventData.fromJson(e)).toList() : [],
    );
  }
}

class EventData {
  final String? eventType;
  final String? eventName;
  final String? startDate;
  final String? endDate;
  final String? regStartDate;
  final String? regEndDate;
  final String? isRegistrationActive;
  final String? eventActive;
  final String? venue;
  final String? priceMoney;
  final String? content;
  final String? year;
  final String? image;
  final String? entryDate;

  EventData({
    this.eventType,
    this.eventName,
    this.startDate,
    this.endDate,
    this.regStartDate,
    this.regEndDate,
    this.isRegistrationActive,
    this.eventActive,
    this.venue,
    this.priceMoney,
    this.content,
    this.year,
    this.image,
    this.entryDate,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      eventType: json['EventType'],
      eventName: json['EventName'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      regStartDate: json['RegStartDate'],
      regEndDate: json['RegEndDate'],
      isRegistrationActive: json['IsRegistrationActive'],
      eventActive: json['EventActive'],
      venue: json['Venue'],
      priceMoney: json['PriceMoney'],
      content: json['Content'],
      year: json['Year'],
      image: json['Image'],
      entryDate: json['EntryDate'],
    );
  }
}
