class ProspectTaskListModel {


  String id = "";

  String status = "";
  String prospect_id = "";
  String item_name = "";
  String task_type = "";
  String first_type = "";

  String second_type = "";
  String material_type = "";
  String material_url = "";
  String description = "";
  String danger_level = "";



  ProspectTaskListModel(
      this.id,
      this.status,
      this.prospect_id,
      this.item_name,
      this.task_type,
      this.first_type, //组件编码
      this.second_type, //组件类型
      this.material_type,
      this.material_url,
      this.description,
      this.danger_level,
      // this.extraInfo,
      );

  ProspectTaskListModel.fromJson(Map<String, dynamic> json)
      : this(
    json['id'],
    json['status'],
    json['prospect_id'] ,
    json['item_name'],
    json['task_type'],
    json['first_type'],
    json['second_type'],
    json['material_type'],
    json['material_url'],
    json['description'],
    json['danger_level'],

  );

  Map<String, dynamic> toJson() => {
//    "id": this.id,
//    "status": this.status,
    "prospect_id": this.prospect_id,
//    "type": this.type,
//    "name": this.name,
//    "province":province, //组件编码
//    "city": city, //组件类型
//    "district":district,
//    "size": size,
//    "remarks":remark,
  };

}