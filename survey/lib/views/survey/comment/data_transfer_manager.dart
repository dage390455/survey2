
import 'dart:convert';

import 'package:sensoro_survey/model/electrical_fire_model.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/comment/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class DataTransferManager {

  static var shared = DataTransferManager();

  var project = projectInfoModel("","",1,"",[]);
  ElectricalFireModel fireCreatModel;

  bool isEditModel = false;

  creatModel(){
     fireCreatModel =  ElectricalFireModel(prefix0.currentTimeMillis(),
        "",
        "",
        "",
        "",

        "",
        "",
        "",
        "",
        "",

        "",
        "",
        "",
        "",
        "",

        "",
        "",
        "",
        "",
        "",

        "",
        "",
        "",
        "",
        "",

        1,
        1,
        1,
        "",
        "",

        1,
        1,
        1,
        "",
        1,

        1,
        0,
        "",
        "",
        "",

        1,
        "",
        ""
    );
  }





  saveProject(){
    String historyKey = 'projectList';
    Map<String, dynamic> map = project.toJson();
    String jsonStr = json.encode(map);
    SaveDataManger.replaceHistory(jsonStr, historyKey, project.projectId);
  }


}