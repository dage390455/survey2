class NetConfig {
  static const DEBUG = true;
  static const baseUrl = "https://city-microdev1-api.sensoro.com/riskcompapi/";
  //查询风险点的变量列表
  static const riskUrl = "comp_variable/list?risk_id=1";
  //查询风险点的变量列表和值
  static const riskValueUrl = "variable_value/list?risk_id=1";
  //查询场所列表分页
  static const siteListPageUrl = "/site_info/page?parent_id=0&limit=5&offset=5";

  //创建风险点 POST
  static const updateRiskUrl = "comp_variable/saveOrUpate";
  //提交一组数据 POST
  static const updateRiskValueUrl = "variable_value/saveOrUpate";

  //新增项目信息 POST
  static const addProjectUrl = "/project_info/create";
  //新增勘察点信息 POST
  static const addPointUrl = "/prospect_info/create";
  //区域列表接口
  static const siteListUrl = "/site_info/list?parent_id=";
  static const createUrl = "site_info/create";
  static const editeUrl = "site_info/update/";
  static const getSiteUrl = "/site_info/detail/";
  static const deleteSiteUrl = "/site_info/delete/";

  static const pointListUrl = "/prospect_info/list?project_id=";
}
