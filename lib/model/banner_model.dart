class BannerResponse {
  final List<BannerItem> banners;

  BannerResponse({this.banners = const []});

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      banners: json["_dt"] != null
          ? List<BannerItem>.from(
              json["_dt"].map((x) => BannerItem.fromJson(x)),
            )
          : [],
    );
  }
}

class BannerItem {
  final int id;
  final String refNo;
  final String bannerTitle;
  final String bannerTitle2;
  final String bannerTitle3;
  final String bannerImage;
  final String entryDate;

  BannerItem({
    this.id = 0,
    this.refNo = "",
    this.bannerTitle = "",
    this.bannerTitle2 = "",
    this.bannerTitle3 = "",
    this.bannerImage = "",
    this.entryDate = "",
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json["Id"] ?? 0,
      refNo: json["RefNo"] ?? "",
      bannerTitle: json["BannerTitle"] ?? "",
      bannerTitle2: json["BannerTitle2"] ?? "",
      bannerTitle3: json["BannerTitle3"] ?? "",
      bannerImage: json["BannerImage"] ?? "",
      entryDate: json["EntryDate"] ?? "",
    );
  }
}



class BannerPayload {
  Map<String, dynamic> toJson() {
    return {
      "Id": "",
      "RefNo": "",
      "Region": "",
      "RowRefNo": "",
      "Cmp_Code": "",
      "Dates": "",
      "EventRefNo": "",
      "EventRegNo": "",
      "EntryType": "Event",
      "IsActive": "True",
      "FinalSubmit": true,
      "UserId": "",
      "Action": "getDetails",
      "UserId2": "",
      "RoleId": 0,
      "Page": 0,
      "TotalPage": 0,
      "PageSize": 0,
      "_dt": null,
      "ds": null,
      "_DataRow": null
    };
  }
}
