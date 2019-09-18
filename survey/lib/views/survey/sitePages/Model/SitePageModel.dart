import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

enum SiteType { area, building,unkonw }

class SitePageModel {
  int sitePageModelId = prefix0.currentTimeMillis();
  String siteName = "";
  String creatDate = "";
  SiteType siteType = SiteType.unkonw;
  String editPosition = ""; //定位地址

//  SitePageModel(this.siteName, this.editPosition, this.editLongitudeLatitude,
//      this.remark);

  String editLongitudeLatitude = ""; //定位坐标
  String remark = "";

  List<SitePageModel> listplace = [];
}
