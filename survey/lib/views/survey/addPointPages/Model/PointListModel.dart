import 'package:sensoro_survey/views/survey/const.dart' as prefix0;


class PointListModel {


  String id = "";

  String status = "";
  String project_id = "";
  String site_type = "";
  String site_id = "";
  String name = "";

  double resident_count = 0.0;


  double total_assets = 0.0;




  PointListModel(
      this.id,
      this.status,
      this.project_id,
      this.site_type,
      this.name,
      this.site_id, //组件编码
      this.resident_count, //组件类型
      this.total_assets,

      // this.extraInfo,
   );

  PointListModel.fromJson(Map<String, dynamic> json)
      : this(
    json['id'],
    json['status'],
    json['project_id'] ,
    json['site_type'],
    json['name'],
    json['site_id'],
    json['resident_count'],
    json['total_assets'],

  );

  Map<String, dynamic> toJson() => {
//    "id": this.id,
//    "status": this.status,
    "parent_id": this.project_id,
//    "type": this.type,
//    "name": this.name,
//    "province":province, //组件编码
//    "city": city, //组件类型
//    "district":district,
//    "size": size,
//    "remarks":remark,
  };

}
