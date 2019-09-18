class componentModel {
  String variable_name;
  String variable_code;
  String variable_value;
  String is_required;
  String risk_id;
  String comp_code; //组件编码
  String comp_type; //组件类型
  String options;
  String placeholder;
  String validate_rule; //正则表达式
  String type; //所属业务类型
  double page_no;
  double order_no;
  String page_name;
  String data_url; //数据URL
  // Map<String, dynamic> extraInfo;

  componentModel(
    this.variable_name,
    this.variable_code,
    this.variable_value,
    this.is_required,
    this.risk_id,
    this.comp_code, //组件编码
    this.comp_type, //组件类型
    this.options,
    this.placeholder,
    this.validate_rule, //正则表达式
    this.type, //所属业务类型
    this.page_no,
    this.order_no,
    this.page_name,
    this.data_url, //数据URL
    // this.extraInfo,
  );

  componentModel.fromJson(Map<String, dynamic> json)
      : this(
          json['variable_name'],
          json['variable_code'],
          json['variable_value'] == null ? "" : json['variable_value'],
          json['is_required'],
          json['risk_id'],
          json['comp_code'],
          json['comp_type'],
          json['options'] == null ? "" : json['options'],
          json['placeholder'] == null ? "" : json['placeholder'],
          json['validate_rule'] == null ? "" : json['validate_rule'],
          json['type'],
          json['page_no'],
          json['order_no'],
          json['page_name'],
          json['data_url'] == null ? "" : json['data_url'],
          // json['extraInfo'],
        );

  Map<String, dynamic> toJson() => {
        "variable_name": this.variable_name,
        "variable_code": this.variable_code,
        "variable_value": this.variable_value,
        "is_required": this.is_required,
        "risk_id": this.risk_id,
        "comp_code": this.comp_code, //组件编码
        "comp_type": this.comp_type, //组件类型
        "options": this.options,
        "placeholder": this.placeholder,
        "validate_rule": this.validate_rule, //正则表达式
        "type": this.type, //所属业务类型
        "page_no": this.page_no,
        "order_no": this.order_no,
        "page_name": this.page_name,
        "data_url": this.data_url,
      };
}
