class BuildModelEntity {
  String address = "";
  String province = "";
  String city = "";
  String parentId = "";
  String district = "";
  double belowFloor;
  String name = "";
  String location = ",";
  String id = "";
  String type = "";
  double height = 0;
  double upperFloor;
  String status = "";
  String remarks = "";

  BuildModelEntity(
      {this.address,
      this.province,
      this.city,
      this.parentId,
      this.district,
      this.belowFloor,
      this.name,
      this.location,
      this.id,
      this.type,
      this.height,
      this.upperFloor,
      this.remarks,
      this.status});

  BuildModelEntity.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
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
}
