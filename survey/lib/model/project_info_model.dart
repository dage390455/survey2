import 'electrical_fire_model.dart';
//
//class projectInfoSubModel {
//  String subId;
//  String subName;
//
//  projectInfoSubModel(this.subId, this.subName);
//
//  projectInfoSubModel.fromJson(Map<String, dynamic> json)
//      : this(
//          json['subId'],
//          json['subName'],
//        );
//
//  @override
//  // toString() {
//  // return 'projectName:$projectName;createTime:$createTime;remark:$remark;id:${projectId.toString()}';
//  // }
//
//  Map<String, dynamic> toJson() => {
//        'subId': subId,
//        'subName': subName,
//      };
//}

class projectInfoModel {
  String projectId; //项目id ，暂用时间戳
  String projectName; //项目名称
  String createTime; //创建时间 yyyy-mm-dd hh:mm的格式
  String remark; //备注
  String status;
  String site_id;
  String site_type;
  // List<projectInfoSubModel> subList;
  List<dynamic> subList; //勘察点信息列表

  projectInfoModel(this.projectId, this.projectName, this.createTime,
      this.remark, this.status, this.site_id, this.site_type, this.subList);

  projectInfoModel.fromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['projectName'],
          json['createTime'],
          json['remark'],
          json['status'],
          json['site_id'],
          json['site_type'],
          json['subList'],
        );

  @override
  toString() {
    return 'projectName:$projectName,createTime:$createTime,remark:$remark,id:${projectId.toString()}';
  }

  List<Map<String, dynamic>> subList1() {
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < subList.length; i++) {
//      ElectricalFireModel model = subList[i];
//      Map<String, dynamic> map = model.toJson();
      Map<String, dynamic> map = subList[i];
      list.add(map);
    }
    return list;
  }

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'createTime': createTime,
        'remark': remark,
        'id': projectId,
        'status': status,
        'site_id': site_id,
        'site_type': site_type,
        'subList': this.subList1(),
      };
}
