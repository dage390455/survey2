class projectInfoModel {
  int projectId;
  String projectName;
  String createTime;
  String remark; //备注

  projectInfoModel(
      this.projectName, this.createTime, this.projectId, this.remark);

  projectInfoModel.fromJson(Map<String, dynamic> json)
      : this(
          json['projectName'],
          json['createTime'],
          json['projectId'],
          json['remark'],
        );

  @override
  toJson() {
    return 'projectName:$projectName,createTime:$createTime,remark:$remark,projectId:${projectId.toString()}';
  }
}
