class FireTroubleModel {
  String prospect_id = "";
  String id = "";
  String task_type = "fire_danger";
  String first_type = "";
  String material_type = "image";
  String material_url = "";

  String description = "";
  String danger_level = "";
  String item_name = "";

  FireTroubleModel(
      this.id,
      this.prospect_id,
      this.task_type,
      this.first_type,
      this.material_type,
      this.material_url,
      this.description,
      this.danger_level,
      this.item_name);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prospect_id'] = this.prospect_id;
    data['task_type'] = this.task_type;
    data['first_type'] = this.first_type;
    data['material_type'] = this.material_type;
    data['material_url'] = this.material_url;
    data['description'] = this.description;
    data['danger_level'] = this.danger_level;
    data['item_name'] = this.item_name;
    return data;
  }

  FireTroubleModel.fromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['prospect_id'],
          json['task_type'],
          json['first_type'],
          json['material_type'],
          json['material_url'],
          json['description'],
          json['danger_level'],
          json['item_name'],
        );
}
