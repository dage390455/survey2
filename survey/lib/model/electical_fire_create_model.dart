import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class ElectricalFireCreateModel {

  int electricalFireCreateId = prefix0.currentTimeMillis();
  //第一步
  String editAddress = "";   //电箱位置
  String editPurpose = "";   //电箱用途用途
  String step1Remak = "";   //电箱备注


  //第二步
  String editpic1 ="" ;  //第一张图片
  String editpic2  ="";  //第二张图片
  String editpic3  ="";  //第三张图片
  String editpic4  ="" ;  //第四张图片
  String editpic5  ="";  //第五张图片

  String editenvironmentpic1  ="" ;  //环境第一张图片
  String editenvironmentpic2  ="" ;  //第二张图片
  String editenvironmentpic3  ="" ;  //第三张图片
  String editenvironmentpic4  ="" ;  //第四张图片
  String editenvironmentpic5  ="" ;  //第五张图片

  //第三步
  int isNeedCarton = 1; //是否需要外箱
  int isOutSide = 1;  //电箱位置
  int isNeedLadder = 1;  //是否需要梯子
  String editOutsinPic  = "";     //外箱安装位置图片
  String step3Remak = "";      //第三步备注




  //第四步
  int isEffectiveTransmission = 1;  //报警音可否有效传播
  int isNuisance = 1; //是否扰民
  int isNoiseReduction = 1; //是否消音
  String step4Remak = "";      //第四步备注


  //第五步
  int allOpenValue = 1;  //总开
  int isSingle  = 1; //单项三箱
  int isMolded = 0;  //是否微断


  String current = ""; //额定电流
  String dangerous = ""; //危险线路数
  String probeNumber = ""; //探头个数
  int isZhiHui = 1;  //是否智慧空开
  String currentSelect = "";  //额定电流
  String recommendedTransformer = ""; //推荐互感器

}
