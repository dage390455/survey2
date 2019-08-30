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
  int projectId;
  String projectName;
  String createTime;
  String remark; //备注
  // List<projectInfoSubModel> subList;
  List<dynamic> subList;

  projectInfoModel(this.projectName, this.createTime, this.projectId,
      this.remark, this.subList);

  projectInfoModel.fromJson(Map<String, dynamic> json)
      : this(
          json['projectName'],
          json['createTime'],
          json['id'],
          json['remark'],
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
        'subList': this.subList1(),
      };
}
