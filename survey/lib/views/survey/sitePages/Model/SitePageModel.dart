import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

enum SiteType { area, building,unkonw }

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


  String id = "";

  String status = "";
  String parent_id = "";
  String type = "";
  String name = "";

  String province = "";

  String city = "";

  String district = "";
  double size = 0.0;




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
      // this.extraInfo,
   );

  SitePageModel.fromJson(Map<String, dynamic> json)
      : this(
    json['id'],
    json['status'],
    json['parent_id'] ,
    json['type'],
    json['name'],
    json['province'],
    json['city'],
    json['district'],
    json['size'] ==null?0.0:json['size'],
    json['remarks'] == null?"":json['remarks']
  );

  Map<String, dynamic> toJson() => {
//    "id": this.id,
//    "status": this.status,
    "parent_id": this.parent_id,
    "type": this.type,
    "name": this.name,
    "province":province, //组件编码
    "city": city, //组件类型
    "district":district,
    "size": size,
    "remarks":remark,
  };

}
