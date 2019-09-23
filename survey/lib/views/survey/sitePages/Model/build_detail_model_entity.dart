class BuildDetailModelEntity {
  String cityText;
  String districtText;
  String address;
  String province;
  String provinceText;
  String city;
  String parentId;
  String district;
  String name;
  String id;
  String status;

  BuildDetailModelEntity(
      {this.cityText,
      this.districtText,
      this.address,
      this.province,
      this.provinceText,
      this.city,
      this.parentId,
      this.district,
      this.name,
      this.id,
      this.status});

  BuildDetailModelEntity.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
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
