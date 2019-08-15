class taskDetailModel {
  final String name;
  final String image;
  final int id;
  final String time;

  taskDetailModel(this.id, this.name, this.image, this.time);

  taskDetailModel.fromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['name'],
          json['image'] != null
              ? json['image']
              : (json['images'] != null ? json['images'][0] : null),
          json['time'] != null
              ? json['time']
              : (json['time'] != null ? json['time'][0] : null),
        );

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': name, 'image': image, 'time': time};
  }
}

// ","sensorTypes":"curr","thresholds":15,"_id":
// "5d2f2a8c4c77100a0f8922c3"},
// {"conditionType":"gt","sensorTypes":"t4_val","thresholds":46,
// "_id":"5d2f2a8c4c7710bc0e8922c2"},{"conditionType":"gt",
// "sensorTypes":"t1_val","thresholds":46,
// "_id":"5d2f2a8c4c7710cc0c8922c1"},
// {"conditionType":"gt","sensorTypes":"t2_val","thresholds":46,
// "_id":"5d2f2a8c4c7710f4168922c0"},
// {"conditionType":"gt","sensorTypes":"t3_val","thresholds":46,
// "_id":"5d2f2a8c4c771042028922bf"}],"sns":["02851117C6CF39A2"],
// "contact":{"name":"测","number":"13811789131"},
// "id":"5d2f2a8c4c7710455c8922be","successTotal":1,
// "failTotal":0,"execTotal":0,"userName":"工厂测试"},
// {"refrence":"061d1a62afaf106193776ff1be84fab8",
// "deviceType":"acrel_alpha","scheduleNo":"ED-20190717-215518.409",
// "type":"threshold","appId":"L3ma0Uut3QnJ","owners":"5b86438092bb4
