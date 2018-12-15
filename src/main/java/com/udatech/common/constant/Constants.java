package com.udatech.common.constant;

/**
 * 描述：系统常量类
 * 创建人：guoyt
 * 创建时间：2016年12月12日下午3:12:52
 * 修改人：guoyt
 * 修改时间：2016年12月12日下午3:12:52
 */
public class Constants {

    // 公信力版本号
    public static final String VERSION_NO = "3.0.1";

    public static final String YYYYMMDD_7 = "yyyy-MM";
    public static final String START_SUFFIX = " 00:00:00";
    public static final String END_SUFFIX = " 23:59:59";
    
    public static final String ORDER_DESC = "desc";
    public static final String ORDER_ASC = "asc";
    
    /*-----------------------用户类型BEGIN--------------------------*/
    /*** 管理员 */
    public static String ADMIN = "0";
    
    /*** 中心用户 */
    public static String CENTER = "1";
    
    /*** 业务端用户 */
    public static String YEWU = "2";
    
    /*** 政务端用户 */
    public static String ZHENGWU = "3";
    /*-----------------------用户类型END--------------------------*/

    /*-----------------------数据库字段BEGIN--------------------------*/
    // YW_L_JGSLBGDJ-组织机构代码
    public static final String ENTERPRISE_ZZJGDM = "ZZJGDM";

    // YW_L_JGSLBGDJ-机构全称中文
    public static final String ENTERPRISE_JGQC = "JGQC";

    // YW_L_JGSLBGDJ-工商注册号（单位注册号）
    public static final String ENTERPRISE_GSZCH = "GSZCH";

    // YW_L_JGSLBGDJ-统一社会信用代码
    public static final String ENTERPRISE_TYSHXYDM = "TYSHXYDM";

    // YW_L_JGSLBGDJ-机构地址（住所）
    public static final String ENTERPRISE_JGDZ = "JGDZ";
    /*-----------------------数据库字段END--------------------------- */

    /*-----------------------高德地图设置BEGIN-------------------------*/
    // 地级市名称
    public static final String MAP_CITY = "map.center.city"; 
    // 地级市代码
    public static final String MAP_CITY_CODE = "map.center.city.code";
    // 县级市名称
    public static final String MAP_COUNTY_CITY = "map.county.city";
    
    // 接口返回状态码json字段
    public static final String INFOCODE_FIELD = "infocode";

    // 接口返回状态说明，1000代表正确
    public static final String INFOCODE_OK = "10000";

    // 高德地图web服务API配置项
    public static final String AMAP_WEB_API_KEY = "amap.web.api.key";

    // 高德地图地理编码url
    public static final String AMAP_WEB_API_GEOCODE_URL = "http://restapi.amap.com/v3/geocode/geo";

    // 热力图色差力度控制count
    public static final String CREDIT_THERMODYNAMIC_COUNT = "credit.thermodynamic.count";

    // 信用地图打点企业按比例显示
    public static final String CREDIT_MAP_SCALE = "credit.map.enterprise.scale";

    // 高德地图行政区域查询url
    public static final String AMAP_WEB_API_DISTRICT_URL = "http://restapi.amap.com/v3/config/district";

    // 子级行政区,可选值：0、1、2、3等数字，并以此类推 0：不返回下级行政区；1：返回下一级行政区；2：返回下两级行政区；3：返回下三级行政区；
    public static final String SUBSTRICT_0 = "0";

    // 返回结果控制,可选值：base、all;base:不返回行政区边界坐标点；all:只返回当前查询district的边界值，不返回子节点的边界值；
    public static final String EXTENSIONS_ALL = "all";

    // 是否显示商圈
    public static final boolean SHOWBIZ_FALSE = false;

    // 行政区域查询接口-返回json字段之行政区列表
    public static final String DISTRICTS_LIST = "districts";

    // 行政区域查询接口-返回json字段之行政区边界坐标点，如：121.343498,31.512056;121.335833,31.508295;
    public static final String DISTRICTS_POLYLINE = "polyline";

    // 地理编码接口-返回json字段之地理编码信息列表
    public static final String GEOCODES = "geocodes";

    // 地理编码接口-返回json字段之坐标点，如经度，纬度
    public static final String GEOCODE_LOCATION = "location";
    
    // 地理编码接口-返回json字段之省份，如江苏省
    public static final String GEOCODE_PROVINCE = "province";

    // 地图缩放等级
    public static final int MAP_LEVEL_18 = 18;
    /*-----------------------高德地图设置END-------------------------*/

    /*-----------------------信用地图搜索条件BEGIN-------------------------*/
    // 企业类型
    public static final String ENTERPRISE_TYPE_NEIZI = "QIYEA";
    public static final String ENTERPRISE_TYPE_SIYING = "QIYEB";
    public static final String ENTERPRISE_TYPE_WAIZI = "QIYEC";
    public static final String ENTERPRISE_TYPE_OTHER = "QIYED";

    // 注册规模
    public static final String REGISTRATION_SCALE = "ZHUCE";
    public static final String REGISTRATION_SCALE_10 = "ZHUCEA";
    public static final String REGISTRATION_SCALE_100 = "ZHUCEB";
    public static final String REGISTRATION_SCALE_500 = "ZHUCEC";
    public static final String REGISTRATION_SCALE_1000 = "ZHUCED";
    public static final String REGISTRATION_SCALE_5000 = "ZHUCEE";
    public static final String REGISTRATION_SCALE_MAX = "ZHUCEF";
    public static final int REGISTRATION_SCALE_10_VALUE = 10;
    public static final int REGISTRATION_SCALE_100_VALUE = 100;
    public static final int REGISTRATION_SCALE_500_VALUE = 500;
    public static final int REGISTRATION_SCALE_1000_VALUE = 1000;
    public static final int REGISTRATION_SCALE_5000_VALUE = 5000;

    // 企业年龄（信用地图）
    public static final String TOPIC_YEAR = "NF";
    public static final String TOPIC_YEAR_1 = "NFA";
    public static final String TOPIC_YEAR_5 = "NFB";
    public static final String TOPIC_YEAR_10 = "NFC";
    public static final String TOPIC_YEAR_MAX = "NFD";
    public static final int TOPIC_YEAR_1_VALUE = 1;
    public static final int TOPIC_YEAR_5_VALUE = 5;
    public static final int TOPIC_YEAR_10_VALUE = 10;

    public static final String FIRST_INDUSTRY = "QB1";
    public static final String SECONDE_INDUSTRY = "QB2";
    /*-----------------------信用地图搜索条件BEGIN------------------------*/
    
    /*-----------------------高管来源分析BEGIN-------------------------*/
    //高管来源分析信用城市名称以及市县
    public static final String EXECUTIVE_CITY = "executives.center.city"; 
    public static final String EXECUTIVE_CITY_LEVEL = "executives.center.city.level"; 
    public static final String EXECUTIVE_LEVEL = "executives.level"; 
    
    // 高管类型
    public static final String EXECUTIVE_TYPE_GGFR = "0"; //法定代表人
    public static final String EXECUTIVE_TYPE_GGDS = "1"; //董事监事高管
    
    //职务
    public static final String POST_DONGSHI = "0";  //董事
    public static final String POst_JIANSHI = "1";  //监事
    
    //性别
    public static final String SEX_MAN = "0";
    public static final String SEX_WOMEN = "1";
    
    //年龄分布
    public static final String AGE_DISTRIBUTION_50 = "5";
    public static final String AGE_DISTRIBUTION_60 = "6";
    public static final String AGE_DISTRIBUTION_70 = "7";
    public static final String AGE_DISTRIBUTION_80 = "8";
    public static final String AGE_DISTRIBUTION_90 = "9";
    public static final String AGE_DISTRIBUTION_OTHER = "99";
    /*-----------------------高管来源分析END-------------------------*/

    /*-----------------------信用立方搜索条件BEGIN------------------------*/
    // 图谱层级
    public static final String CUBIC_LEVEL = "cubic.level";
    /*-----------------------信用立方搜索条件END------------------------*/

    /*-----------------------license设置BEGIN------------------------*/
    // license是否过期
    public static final String IS_VALID_LICENSE = "isValidLicense";

    // license配置文件保存地址
    public static final String LICENSE_CONFIG_PATH = "properties/license.properties";
    /*-----------------------license设置END--------------------------*/

    /*-----------------------资源库顶级类别 BEGIN------------------------*/
    public static final String ROOT = "ROOT";// 根
    
    /*-----------------------资源库顶级类别 END------------------------*/

    /*---------------------联动监管企业相关Start---------------------------*/
    // 解析上传企业文件标题验证用
    public final static String TITLE_ZZJGDM = "组织机构代码";
    public final static String TITLE_QYMC = "企业名称";
    public final static String TITLE_GSZCH = "工商注册号";
    public final static String TITLE_SHXYDM = "统一社会信用代码";
    /*---------------------End---------------------------*/
    
    /*-----------------------多维分析搜索条件BEGIN-------------------------*/
    // 信用主题：1-诚信记录；2-失信记录
    public static final String CREDIT_THEME_CHENGXIN = "1";
    public static final String CREDIT_THEME_SHIXIN = "2";
    
    // 趋势类别：1-累计；2-新增
    public static final String TREND_TYPE_LEIJI = "1";
    public static final String TREND_TYPE_XINZENG = "2";

    // 统计内容：1-企业数量；2-记录数量
    public static final String STATISTC_QIYE_COUNT = "1";
    public static final String STATISTC_JILU_COUNT = "2";
    
    // 统计类别：1-行业门类；2-行政区划；3-企业年龄
    public static final String CATEGORY_INDUSTRY = "1";
    public static final String CATEGORY_REGIONAL = "2";
    public static final String CATEGORY_AGE = "3";
    
    // 统计sql返回字段
    public static final String CATEGORY = "CATEGORY";                      //栏目
    public static final String TOTAL = "TOTAL";                            //数量   
    public static final String YEAR = "YEAR";                              //年份
    public static final String MAX = "MAX";                                //所有记录最大值
    public static final String PARENT_CODE = "PARENT_CODE";                //行业细类父编码
    public static final String NEXT_PARENT_CODE = "NEXT_PARENT_CODE";      //行业细类父编码
    public static final int INDUSTRY_LEVEL_TOTAL = 4;                      //行业细类统计最高层级
    public static final int INDUSTRY_LEVEL_TWO = 2;                        //行业细类统计行业大类层级
    public static final int INDUSTRY_LEVEL_THREE = 3;                      //行业细类统计行业中类层级
    public static final int INDUSTRY_LEVEL_FOUR = 4;                       //行业细类统计行业小类层级
    
    // 图表主题：1-行业分布情况； 2-行业趋势分析； 3-行业分级情况
    public static final String CHART_THEME_DISTRIBUTION = "1";
    public static final String CHART_THEME_TRENDS = "2";
    public static final String CHART_THEME_CLASSIFICATION = "3";
    
    // 区域字典表键
    public static final String REGIONAL_DICTIONARY = "administrativeArea";
    
    // 企业年龄字典表键
    public static final String ENTERPRISE_AGE_DIC = "enterpriseAge";
    
    // 企业年龄(统计分析)
    public static final String ENTERPRISE_AGE = "NL";
    public static final String ENTERPRISE_AGE_3 = "NLA";
    public static final String ENTERPRISE_AGE_5 = "NLB";
    public static final String ENTERPRISE_AGE_10 = "NLC";
    public static final String ENTERPRISE_AGE_20 = "NLD";
    public static final String ENTERPRISE_AGE_30 = "NLE";
    public static final String ENTERPRISE_AGE_MAX = "NLF";
    /*-----------------------多维分析搜索条件END-------------------------*/
    
    /*-----------------------业务分析搜索条件BEGIN-------------------------*/
    // 统计主题：1-信用报告统计；2-异议处理统计；3-信用修复统计；4-信用核查统计；
    public static final String CATEGORY_CREDIT_REPORT = "1";
    public static final String CATEGORY_OBJECTION_HANDLING = "2";
    public static final String CATEGORY_CREDIT_REPAIR = "3";
    public static final String CATEGORY_CREDIT_CHECK = "4";
    public static final String CATEGORY_DOUBLE_PUBLICITY = "5";
    public static final String LEGAL_PERSON = "0";
    public static final String MONTH_HANDLE ="10";
    public static final String NATURAL_PERSON ="1";
    // 维度分析：1-申诉内容分析； 2-数据提供部门分析； 3-修复内容分析；4-审查类别分析；5-申请部门分析
    public static final String DIMENSION_APPEAL_CONTENT = "1";
    public static final String DIMENSION_DATA_PROVIDER = "2";
    public static final String DIMENSION_REPAIR_CONTENT = "3";
    public static final String DIMENSION_REVIEW_CATEGORY = "4";
    public static final String DIMENSION_APPLICATION_DEPARTMENT = "5";
    public static final String DIMENSION_DECISION_DATE = "6";
    public static final String DIMENSION_REPORT_DATE = "7";
    
    // 1-行政许可；2-行政处罚
    public static final String PUBLICITY_TYPE_XUKE = "1";
    public static final String PUBLICITY_TYPE_CHUFA = "2";
    /*-----------------------业务分析搜索条件END-------------------------*/

    /*-----------------------数据上报文本上传，错误记录状态BEGIN-------------------------*/
    public static final int UPLOAD_ERROR_DO_NOTHIING = 0;//未处理
    public static final int UPLOAD_ERROR_FINISH = 1;//已经处理 表示已经经过kettle处理并且入业务库
    public static final int UPLOAD_ERROR_IGNORE = 2;//忽略
    public static final int UPLOAD_ERROR_DEL = 3;//删除
    public static final int UPLOAD_ERROR_MODIFY = 4; // 已修改 只在页面上修改，还没经过kettle处理

    /*-----------------------数据上报文本上传，错误记录状态END-------------------------*/
    
    /*-----------------------原始库上报成功的数据状态BEGIN-------------------------*/
    public static final int UPLOAD_DATA_ADD_BYHAND = 0;//手动录入
    public static final int UPLOAD_DATA_ADD_UPLOAD = 9;//文本上传
    public static final int UPLOAD_DATA_DEAL = 1;//数据从原始库获取到有效库
    public static final int UPLOAD_DATA_DEL = -2;//删除
    public static final int UPLOAD_DATA_EDIT = -3;//已修改
    public static final int UPLOAD_CETL_INVALID_HANDED = 999;// kettle处理后标识为:无效已处理的状态，
    public static final int UPLOAD_CETL_DELETE_HANDED = 99;// kettle处理后标识为:删除已处理的状态，
    
    
    public static final String UPLOAD_DATA_SHOW_ADD = "1";//新增
    public static final String UPLOAD_DATA_SHOW_EDIT = "2";//已修改
    public static final String UPLOAD_DATA_SHOW_DEL = "3";//删除
    public static final String UPLOAD_DATA_SHOW_DEAL = "4";//已处理
    
    /*-----------------------数据上报数据，疑问数据状态BEGIN-------------------------*/
    
    
    /*-----------------------原始库上报成功的数据状态BEGIN-------------------------*/
    public static final String UPLOAD_ERROR_TYPE_PARSE = "0";//数据解析入库
    public static final String UPLOAD_ERROR_TYPE_EFFECT = "1";//有限数据校验
    public static final String UPLOAD_ERROR_TYPE_SERVICE = "2";//数据业务校验
    /*-----------------------数据上报数据，疑问数据来源END-------------------------*/
    
    /*-----------------------数据血缘cetl信息BEGIN-------------------------*/
    public static final int UPLOAD_ERROR_CETL_TYPE_y2x = 1;//原始库到有效库
    public static final int UPLOAD_ERROR_CETL_TYPE_x2w  = 2;//有效库到业务库
    
    public static final String UPLOAD_ERROR_CETL_STEPS = "steps";
    public static final String UPLOAD_ERROR_CETL_STEPHOPLIST = "stepHopList";
    /*-----------------------数据血缘cetl信息END-------------------------*/

    // 信用中心 部门代码
    public static String CENTER_DEPT_CODE = "A0000";
    
    /*------------------------联合奖惩BEGIN----------------------------*/
    public static final String ENTERPRISE_DIRECTORY = "1";//奖惩主体
    public static final String FEEDBACK_RECORD = "2";//反馈记录
    public static final String HAS_CONTITION = "1";//监管信息-有查询条件
    /*------------------------联合奖惩END----------------------------*/

    public static final String ERROR_NAME_GZJX = "规则解析错误";//规则解析错误
    public static final String ERROR_CODE_GZJX = "40001";//规则解析错误


    /*-------------------------字段规则类型BEGIN----------------------------------*/

    public static final String RULE_TYPE_ZHENGZE = "0"; //正则表达式
    public static final String RULE_TYPE_CHAJIAN = "1"; //插件
    public static final String RULE_TYPE_MOREN = "2";   //默认值
    public static final String RULE_TYPE_SHIJIAN = "3"; //时间合理性
    public static final String RULE_TYPE_TESHU = "4";   //特殊规则
    public static final String RULE_TYPE_SHENFEN = "5";//身份证校验
    /*-------------------------字段规则类型END----------------------------------*/
    
}
