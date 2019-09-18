
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

enum SiteType {
  area,
  building
}


class SitePageModel {
  int sitePageModelId = prefix0.currentTimeMillis();
  String siteName = "";
  String creatDate = "";
  SiteType siteType = SiteType.area;
  String editPosition = ""; //定位地址
  String editLongitudeLatitude = ""; //定位坐标
  String remark = "";


}