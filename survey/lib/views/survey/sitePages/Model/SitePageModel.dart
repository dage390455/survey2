import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

enum SiteType { area, building, unkonw }

class SitePageModel {
  int sitePageModelId = prefix0.currentTimeMillis();
  String siteName = "";
  String creatDate = "";
  SiteType siteType = SiteType.unkonw;
  String editPosition = ""; //定位地址
  String area = "";

//  SitePageModel(this.siteName, this.editPosition, this.editLongitudeLatitude,
//      this.remark);

  String editLongitudeLatitude = ""; //定位坐标
  String remark = "";

  List<SitePageModel> listplace = [];
  List<SitePageModel> buildingList = [];

  String id = "";

  String status = "";
  String parent_id = "";
  String type = "";
  String name = "";

  String province = "";

  String city = "";

  String district = "";
  double size = 0.0;

  String address = "";
  String parentId = "";
  String belowFloor;
  String location = ",";
  String height;
  String upperFloor;
  String remarks = "";

  String cityText;
  String districtText;
  String provinceText;

  SitePageModel(
    this.id,
    this.status,
    this.parent_id,
    this.type,
    this.name,
    this.province, //组件编码
    this.city, //组件类型
    this.district,
    this.size,
    this.remark,
    this.editPosition,
    // this.extraInfo,
  );

  SitePageModel.fromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['status'],
          json['parent_id'],
          json['type'],
          json['name'],
          json['province'],
          json['city'],
          json['district'],
          json['size'] == null ? 0.0 : json['size'],
          json['remarks'] == null ? "" : json['remarks'],
          "",
        );

  SitePageModel.modelfromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['status'],
          json['parent_id'],
          json['type'],
          json['name'],
          json['province'],
          json['city'],
          json['district'],
          json['size'] == null ? 0.0 : json['size'],
          json['remarks'] == null ? "" : json['remarks'],
          json['province_text'] + json['city_text'] + json['district_text'],
        );

  Map<String, dynamic> toJson() => {
//    "id": this.id,
//    "status": this.status,
        "parent_id": this.parent_id,
        "type": this.type,
        "name": this.name,
        "province": province, //组件编码
        "city": city, //组件类型
        "district": district,
        "size": size,
        "remarks": remark,
      };

  SitePageModel.fromBuildJson(Map<String, dynamic> json) {
    address = json['address'];
    province = json['province'];
    city = json['city'];
    parentId = json['parent_id'];
    district = json['district'];
    belowFloor = json['below_floor'];
    name = json['name'];
    location = json['location'];
    id = json['id'];
    type = json['type'];
    height = json['height'];
    remarks = json['remarks'];
    upperFloor = json['upper_floor'];
    status = json['status'];
  }

  Map<String, dynamic> toBuildJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['province'] = this.province;
    data['city'] = this.city;
    data['parent_id'] = this.parentId;
    data['district'] = this.district;
    data['below_floor'] = this.belowFloor;
    data['name'] = this.name;
    data['height'] = this.height;
    data['location'] = this.location;
    data['id'] = this.id;
    data['type'] = this.type;
    data['remarks'] = this.remarks;
    data['upper_floor'] = this.upperFloor;
    data['status'] = this.status;
    return data;
  }

  SitePageModel.fromDetailJson(Map<String, dynamic> json) {
    cityText = json['city_text'];
    districtText = json['district_text'];
    address = json['address'];
    province = json['province'];
    provinceText = json['province_text'];
    city = json['city'];
    parentId = json['parent_id'];
    district = json['district'];
    name = json['name'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toDetailJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_text'] = this.cityText;
    data['district_text'] = this.districtText;
    data['address'] = this.address;
    data['province'] = this.province;
    data['province_text'] = this.provinceText;
    data['city'] = this.city;
    data['parent_id'] = this.parentId;
    data['district'] = this.district;
    data['name'] = this.name;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}
