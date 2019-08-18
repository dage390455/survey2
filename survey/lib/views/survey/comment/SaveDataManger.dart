import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveDataManger {

  static saveHistory(List<String> tags,String historyKey) async {
//     SharedPreferences.setMockInitialValues({});
     const MethodChannel('plugins.flutter.io/shared_preferences')
         .setMockMethodCallHandler((MethodCall methodCall) async {
       if (methodCall.method == 'getAll') {
         return <String, dynamic>{}; // set initial values here if desired
       }
        return null;
     });
     SharedPreferences prefs = await SharedPreferences.getInstance();

     var tagsString  = "";

     for (int i=0;i<tags.length;i++){
       if (tagsString.length ==0){
         tagsString = tags[i];
       }else{
         tagsString = tagsString + "," + tags[i];
       }
     }

     var f =  await prefs.setString(historyKey, tagsString);

     print("---------------"+f.toString());

  }

  static  Future<List<String>> getHistory(String historyKey) async{
//      SharedPreferences.setMockInitialValues({});

      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{}; // set initial values here if desired
        }
        return null;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var history = prefs.getString(historyKey);
      if (history!=null && history.length>0){
         return  history.split(",");

      }
      return List<String>();
  }

  static addHistory(String tag,String historyKey) async {

     var history = await SaveDataManger.getHistory(historyKey);

     if (!history.contains(tag)){
        history.add(tag);

        SaveDataManger.saveHistory(history, historyKey);
     }






//    var tagsString  = "";
//
//    for (int i=0;i<tags.length;i++){
//      if (tagsString.length ==0){
//        tagsString = tags[i];
//      }else{
//        tagsString = tagsString + "," + tags[i];
//      }
//    }
//
//    prefs.setString(historyKey, tagsString);

  }


}