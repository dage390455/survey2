
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class ElectricalFireModel {

  // 勘察点信息
  int electricalFireId = prefix0.currentTimeMillis();

  String editName ="";       //勘察点信息
  String editPurpose = "";   //勘察点用途
  String editAddress = "";   //具体地址
  String editPosition = "";  //定位地址
  String editLongitudeLatitude = ""; //定位坐标
  String editPointStructure = "";  //勘察点结构
  String editPointArea = "";  //勘察点面积
  String headPerson = "";     //勘察点负责人
  String headPhone = "";      //勘察点电话
  String bossName = "";       //现场负责人姓名
  String bossPhone = "";      //现场负责人电话


  //第二页面

  //第一步
  String page2editAddress = "";   //电箱位置
  String page2editPurpose = "";   //电箱用途用途
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



  ElectricalFireModel(
      this.electricalFireId,
      this.editName,
      this.editPurpose,
      this.editAddress,
      this.editPosition,

      this.editLongitudeLatitude,
      this.editPointStructure,
      this.editPointArea,
      this.headPerson,
      this.headPhone,

      this.bossName,
      this.bossPhone,
      this.page2editAddress,
      this.page2editPurpose,
      this.step1Remak,

      this.editpic1,
      this.editpic2,
      this.editpic3,
      this.editpic4,
      this.editpic5,

      this.editenvironmentpic1,
      this.editenvironmentpic2,
      this.editenvironmentpic3,
      this.editenvironmentpic4,
      this.editenvironmentpic5,


      this.isNeedCarton,
      this.isOutSide,
      this.isNeedLadder,
      this.editOutsinPic,
      this.step3Remak,

      this.isEffectiveTransmission,
      this.isNuisance,
      this.isNoiseReduction,
      this.step4Remak,
      this.allOpenValue,

      this.isSingle,
      this.isMolded,
      this.current,
      this.dangerous,
      this.probeNumber,

      this.isZhiHui,
      this.currentSelect,
      this.recommendedTransformer,

      );




  ElectricalFireModel.fromJson(Map<String, dynamic> json)
      : this(
    json['electricalFireId'],
    json['editName'],
    json['editPurpose'],
    json['editAddress'],
    json['editPosition'],

    json['editLongitudeLatitude'],
    json['editPointStructure'],
    json['editPointArea'],
    json['headPerson'],
    json['headPhone'],

    json['bossName'],
    json['bossPhone'],
    json['page2editAddress'],
    json['page2editPurpose'],
    json['step1Remak'],

    json['editpic1'],
    json['editpic2'],
    json['editpic3'],
    json['editpic4'],
    json['editpic5'],

    json['editenvironmentpic1'],
    json['editenvironmentpic2'],
    json['editenvironmentpic3'],
    json['editenvironmentpic4'],
    json['editenvironmentpic5'],

    json['isNeedCarton'],
    json['isOutSide'],
    json['isNeedLadder'],
    json['editOutsinPic'],
    json['step3Remak'],

    json['isEffectiveTransmission'],
    json['isNuisance'],
    json['isNoiseReduction'],
    json['step4Remak'],
    json['allOpenValue'],

    json['isSingle'],
    json['isMolded'],
    json['current'],
    json['dangerous'],
    json['probeNumber'],

    json['isZhiHui'],
    json['currentSelect'],
    json['recommendedTransformer'],

  );

//  @override
//  toString() {
//    return 'electricalFireId:$electricalFireId;'
//        'editName:$editName;'
//        'editPurpose:$editPurpose;'
//        'editAddress:$editAddress;'
//        'editPosition:$editPosition;'
//
//
//        'editLongitudeLatitude:$editLongitudeLatitude;'
//        'editPointStructure:$editPointStructure;'
//        'editPointArea:$editPointArea;'
//        'headPerson:$headPerson;'
//        'headPhone:$headPhone;'
//
//        'bossName:$bossName;'
//        'bossPhone:$bossPhone;'
//        'page2editAddress:$page2editAddress;'
//        'page2editPurpose:$page2editPurpose;'
//        'step1Remak:$step1Remak;'
//
//        'editpic1:$editpic1;'
//        'editpic2:$editpic2;'
//        'editpic3:$editpic3;'
//        'editpic4:$editpic4;'
//        'editpic5:$editpic5;'
//
//        'editenvironmentpic1:$editenvironmentpic1;'
//        'editenvironmentpic2:$editenvironmentpic2;'
//        'editenvironmentpic3:$editenvironmentpic3;'
//        'editenvironmentpic4:$editenvironmentpic4;'
//        'editenvironmentpic5:$editenvironmentpic5;'
//
//        'isNeedCarton:$isNeedCarton;'
//        'isOutSide:$isOutSide;'
//        'isNeedLadder:$isNeedLadder;'
//        'editOutsinPic:$editOutsinPic;'
//        'step3Remak:$step3Remak;'
//
//        'isEffectiveTransmission:$isEffectiveTransmission;'
//        'isNuisance:$isNuisance;'
//        'isNoiseReduction:$isNoiseReduction;'
//        'step4Remak:$step4Remak;'
//        'allOpenValue:$allOpenValue;'
//
//        'isSingle:$isSingle;'
//        'isMolded:$isMolded;'
//        'current:$current;'
//        'dangerous:$dangerous;'
//        'probeNumber:$probeNumber;'
//
//        'isZhiHui:$isZhiHui;'
//        'currentSelect:$currentSelect;'
//        'recommendedTransformer:$recommendedTransformer;';
//
//  }


  Map<String, dynamic> toJson() => {

    'electricalFireId': electricalFireId,
    'editName': editName,
    'editPurpose': editPurpose,
    'editAddress': editAddress,
    'editPosition': editPosition,

    'editLongitudeLatitude': editLongitudeLatitude,
    'editPointStructure': editPointStructure,
    'editPointArea': editPointArea,
    'headPerson': headPerson,
    'headPhone': headPhone,

    'bossName': bossName,
    'bossPhone': bossPhone,
    'page2editAddress': page2editAddress,
    'page2editPurpose': page2editPurpose,
    'step1Remak': step1Remak,

    'editpic1': editpic1,
    'editpic2': editpic2,
    'editpic3': editpic3,
    'editpic4': editpic4,
    'editpic5': editpic5,

    'editenvironmentpic1':editenvironmentpic1,
    'editenvironmentpic2': editenvironmentpic2,
    'editenvironmentpic3': editenvironmentpic3,
    'editenvironmentpic4':editenvironmentpic4,
    'editenvironmentpic5': editenvironmentpic5,

    'isNeedCarton': isNeedCarton,
    'isOutSide': isOutSide,
    'isNeedLadder': isNeedLadder,
    'editOutsinPic': editOutsinPic,
    'step3Remak': step3Remak,

    'isEffectiveTransmission': isEffectiveTransmission,
    'isNuisance': isNuisance,
    'isNoiseReduction': isNoiseReduction,
    'step4Remak': step4Remak,
    'allOpenValue': allOpenValue,

    'isSingle': isSingle,
    'isMolded': isMolded,
    'current': current,
    'dangerous': dangerous,
    'probeNumber': probeNumber,

    'isZhiHui': isZhiHui,
    'currentSelect': currentSelect,
    'recommendedTransformer':recommendedTransformer,
  };


}
