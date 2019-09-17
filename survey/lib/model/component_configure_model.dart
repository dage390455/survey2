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
  int page_no;
  int order_no;
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
          json['variable_value'],
          json['is_required'],
          json['risk_id'],
          json['comp_code'],
          json['comp_type'],
          json['options'],
          json['placeholder'],
          json['validate_rule'],
          json['type'],
          json['page_no'],
          json['order_no'],
          json['page_name'],
          json['data_url'],
          // json['extraInfo'],
        );
}
