class projectInfoModel {
  String projectName;
  String createTime;
  int projectId;

  projectInfoModel(this.projectName, this.createTime, this.projectId);

  // taskDetailModel.fromJson(Map<String, dynamic> json)
  //     : this(
  //         json['id'],
  //         json['name'],
  //         json['image'] != null
  //             ? json['image']
  //             : (json['images'] != null ? json['images'][0] : null),
  //         json['time'] != null
  //             ? json['time']
  //             : (json['time'] != null ? json['time'][0] : null),
  //       );

  // Map<String, dynamic> toJson() {
  //   return {'id': id, 'title': name, 'image': image, 'time': time};
  // }
}
