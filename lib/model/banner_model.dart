class BannerResponse {
  final List<BannerItem> banners;

  BannerResponse({required this.banners});

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
    required this.id,
    required this.refNo,
    required this.bannerTitle,
    required this.bannerTitle2,
    required this.bannerTitle3,
    required this.bannerImage,
    required this.entryDate,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json["Id"],
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
