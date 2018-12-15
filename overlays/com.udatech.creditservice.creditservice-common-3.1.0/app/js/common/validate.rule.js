//-----------------自定义扩展校验规则 ---------------------//
// 表注释校验
$.validator.addMethod("tableComment", function(value, element, params) {
	var regex = /^[a-zA-Z0-9\u4e00-\u9fa5（）()_\-《》]+$/;
	return regex.test(value);
}, "该输入项只能由字母、数字、汉字、小括号、下划线、书名号组成！");

//表名校验
$.validator.addMethod("tableName", function(value, element, params) {
	var regex = /^[a-zA-Z][a-zA-Z_0-9]*$/;
	return regex.test(value);
}, "该输入项只能由字母、数字或下划线组成,且只能以字母开头！");

//正则表达式校验
$.validator.addMethod("pattern", function(value, element, params) {
	try{
		var reg = new RegExp(value);
		return true;
	} catch(e){
		return false;
	}
}, "该正则表达式不正确！");

// 大于0 的正整数
$.validator.addMethod("greaterThanZero", function(value, element, params) {
	var regex = /^[1-9]\d*$/;
	return regex.test(value);
}, "该输入项只能输入大于0的整数！");

//关键字校验
$.validator.addMethod("keyword", function(value, element, params) {
	value = value.toUpperCase();
	var str = "ID、FK_LOG_ID、INSERT_TYPE、STATUS、CREATE_TIME、INFO_TYPE、TASK_CODE、CREATE_USER、DEPT_CODE、DEPT_NAME";
	return str.indexOf(value) < 0;
}, "该输入项不能是以下关键字（ID、FK_LOG_ID、INSERT_TYPE、STATUS、CREATE_TIME、INFO_TYPE、TASK_CODE、CREATE_USER、DEPT_CODE、DEPT_NAME）");

// 空格
$.validator.addMethod("unblank", function(value, element, params) {
	var regex = /^\S+$/gi;
	return regex.test(value);
}, "输入值不能包含空格！");

// 非法特殊字符验证
$.validator.addMethod("illegalChar", function(value, element, params) {
	var regex = new RegExp("[`~!@@#$^&*()=|{}':;'\",.////\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
	return !regex.test(value);
}, "含有非法特殊字符");

$.validator.addMethod("illegalCharTwo", function(value, element, params) {
	var regex = new RegExp("[`~!@@#$^&*()=|{}':;'\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
	return !regex.test(value);
}, "含有非法特殊字符,只允许/.,");

$.validator.addMethod("illegalCharThree", function(value, element, params) {
	var regex = new RegExp("[`~!@@#$^&*()=|{}':;',////\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
	return !regex.test(value);
}, "含有非法特殊字符,只允许.");

$.validator.addMethod("illegalCharFour", function(value, element, params) {
	var regex = new RegExp("[<>&\"'·……——‘’“”×]");
	return !regex.test(value);
}, "含有非法特殊字符");

$.validator.addMethod("illegalCharacter", function(value, element, params) {
	var regex = "[`~!@#$%^&*)(=}|{':;\",\.\\\-\\\+\\\[\\\]\\\\/<>?！￥…（）—【】‘’：“”，、。？＼％]";
	var excepts = params[0] || "";
	for (var i = 0, len = excepts.length; i < len; i++) {
		var except = excepts[i];
		regex = regex.replace(except, "");
	}
	regex = new RegExp(regex);
	return !regex.test(value);
}, "含有非法特殊字符,只允许{0}");

$.validator.addMethod("notchineseG", function(value, element, params) {
	var regex = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
	return !regex.test(value);
}, "禁止含有中文！");

//电话号码验证 （包括手机）
$.validator.addMethod("phone", function(value, element, params) {
	if (value == "") {
		return true;
	}
	var reg = /^((0\d{2,3}-\d{7,8})|(1[3|4|5|7|8|9]\d{9}))$/;
	return reg.test(value);
}, "格式须为固定电话或手机号码，例：0512-12345678或13012345678");

// 手机号码验证 （不包括座机）
$.validator.addMethod("mobile", function(value, element, params) {
	var reg = /^1[3|4|5|7|8|9]\d{9}$/;
	return reg.test(value);
}, "输入手机号码格式不正确");

// 身份证验证
$.validator.addMethod("idCard", function(value, element, params) {
	if (value == "") {
		return true;
	}
	var flag = checkIdCard(value);
	return flag == true ? true : false;
}, "不是有效的身份证号码");

//正整数
$.validator.addMethod("cipint", function(value, element, params) {
	var reg = /^[1-9][0-9]*$/;
    return reg.test(value);
}, "只允许正整数");

// 限制输入长度
$.validator.addMethod("length", function(value, element, params) {
	var len=$.trim(value).length;
	return len>=params[0]&&len<=params[1];
}, "输入内容长度必须介于{0}和{1}之间");

// 数字
$.validator.addMethod("cipnumber", function(value, element, params) {
	var flag= isnumber(value);
    return flag == true ? true : false;
}, "只允许数字");

// 整数或小数
$.validator.addMethod("intOrFloat", function(value, element, params) {
	var reg = /^[+-]?([0-9]*\.?[0-9]+|[0-9]+\.?[0-9]*)([eE][+-]?[0-9]+)?$/;
    return reg.test(value);
}, "请输入整数或小数");

// 正整数或负整数
$.validator.addMethod("positiveOrNegative", function(value, element, params) {
	var reg = /^(-|\+)?\d+$/;
    return reg.test(value);
}, "请输入正整数或负整数");

// 日期格式yyy-mm-dd
$.validator.addMethod("cipdat", function(value, element, params) {
	var reg =/^(\d{4})-(\d{2})-(\d{2})$/;
    return reg.test(value);
}, "请输yyyy-mm-dd格式日期");

// 日期格式yyy-mm-dd hh:mm
$.validator.addMethod("cipdatime", function(value, element, params) {
	var reg =/^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2})$/;
    return reg.test(value);
}, "请输yyyy-mm-dd hh:mm格式日期");

// 时间格式hh:mm
$.validator.addMethod("ciptime", function(value, element, params) {
	var reg = /^(\d{2}):(\d{2})$/;
    return reg.test(value);
}, "请输hh:mm格式时间");

// 年
$.validator.addMethod("cipyear", function(value, element, params) {
	var reg = /^\d{4}$/;
    return reg.test(value);
}, "请输正确的年份");

// qq号
$.validator.addMethod("qq", function(value, element, params) {
	var reg = /^[1-9]\d{4,9}$/i;
    return reg.test(value);
}, "QQ号码格式不正确");

// 邮编
$.validator.addMethod("zip", function(value, element, params) {
	var reg = /^[1-9]\d{5}$/;
    return reg.test(value);
}, "邮编必须是非0开始的6位数字");

// 网址格式
$.validator.addMethod("cipurl", function(value, element, params) {
    var RegUrl = new RegExp(); 
	var strRegex = "^((https|http|ftp|rtsp|mms)?://)"  
		  + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@  
		        + "(([0-9]{1,3}\.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184  
		        + "|" // 允许IP和DOMAIN（域名） 
		        + "([0-9a-z_!~*'()-]+\.)*" // 域名- www.  
		        + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\." // 二级域名  
		        + "[a-z]{2,6})" // first level domain- .com or .museum  
		        + "(:[0-9]{1,4})?" // 端口- :80  
		        + "((/?)|" // a slash isn't required if there is no file name  
		        + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";  
   RegUrl.compile(strRegex);  
   if (!RegUrl.test(value)) {  
       return false;  
   }  
   return true;  
}, "请输正确的网址格式");

// 银行卡号
$.validator.addMethod("cipyh", function(value, element, params) {
	var reg =/^(\d{16}|\d{19})$/;
    return reg.test(value);
}, "请输入正确的账号");

// 中文
$.validator.addMethod("chinese", function(value, element, params) {
	var reg =/^[\Α-\￥]+$/i;
    return reg.test(value);
}, "请输入中文");

// IP地址
$.validator.addMethod("ip", function(value, element, params) {
	var reg =/d+.d+.d+.d+/i;
    return reg.test(value);
}, "IP地址格式不正确");

// 车牌号码
$.validator.addMethod("carNo", function(value, element, params) {
	var reg =/^[u4E00-u9FA5][da-zA-Z]{6}$/;
    return reg.test(value);
}, "车牌号码无效（例：粤J12350）");

// 整数或2位小数
$.validator.addMethod("float", function(value, element, params) {
	var reg =/^[+-]?([0-9]*\.?[0-9]{2}|[0-9]+\.?[0-9]{2})([eE][+-]?[0-9]+)?$/;
    return reg.test(value);
}, "请输入整数或2位小数");

// 命名在数据库是否重复
$.validator.addMethod("cipcheckadd", function(value, element, params) {
	var oldvalue = params[1];
	// 当主子表时子表验证是否重复的情况，此种情况直接从params[1]拿值都是下面一条记录的值，所以换成下面的写法可解决
	if (params.length == 4) {
		for (var i = 0;i < oldValueArr.length;i++) {
			var ovs = oldValueArr[i].split("###");
			var id = ovs[0];
			if ($(element).attr("id") == id) {
				oldvalue = ovs[1];
				break;
			}
		}
	}
	var obj = {};//{'oldvalue' : params[1],params[2] : value};
	obj['oldvalue'] = oldvalue;
	obj['fieldId'] = params[2];
	obj['value'] = value;
    var result=$.ajax({
        url:params[0],
        dataType:"json",
        data:obj,
        async:false,
        cache:false,
        type:"post"
    }).responseText;
    return result=="true";
}, "命名在数据库重复");

//证件（身份证、护照、港澳台通行证等）验证
function checkIdCard(idCard){
	var rex = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)|(^[a-zA-Z]{5,17}$)|(^[a-zA-Z0-9]{5,17}$)|(^[HMhm]{1}([0-9]{10}|[0-9]{8})$)|(^[0-9]{8}$)|(^[0-9]{10}$)/;    
	return isIdCard(idCard) || rex.test(idCard);
}

//验证身份证号方法
function isIdCard(idcard) {
	// var Errors=new
	// Array("验证通过!","身份证号码位数不对!","身份证号码出生日期超出范围或含有非法字符!","身份证号码校验错误!","身份证地区非法!");
	var area = {
		11 : "北京",
		12 : "天津",
		13 : "河北",
		14 : "山西",
		15 : "内蒙古",
		21 : "辽宁",
		22 : "吉林",
		23 : "黑龙江",
		31 : "上海",
		32 : "江苏",
		33 : "浙江",
		34 : "安徽",
		35 : "福建",
		36 : "江西",
		37 : "山东",
		41 : "河南",
		42 : "湖北",
		43 : "湖南",
		44 : "广东",
		45 : "广西",
		46 : "海南",
		50 : "重庆",
		51 : "四川",
		52 : "贵州",
		53 : "云南",
		54 : "西藏",
		61 : "陕西",
		62 : "甘肃",
		63 : "青海",
		64 : "宁夏",
		65 : "xinjiang",
		71 : "台湾",
		81 : "香港",
		82 : "澳门",
		91 : "国外"
	};
	var Y, JYM;
	var S, M;
	var idcard_array = new Array();
	idcard_array = idcard.split("");
	if (area[parseInt(idcard.substr(0, 2))] == null)
		return false;
	switch (idcard.length) {
	case 15:
		if ((parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0
				|| ((parseInt(idcard.substr(6, 2)) + 1900) % 100 == 0 && (parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0)) {
			ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;// 测试出生日期的合法性
		} else {
			ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;// 测试出生日期的合法性
		}
		if (ereg.test(idcard))
			return true;
		else
			return false;
		break;
	case 18:
		if (parseInt(idcard.substr(6, 4)) % 4 == 0
				|| (parseInt(idcard.substr(6, 4)) % 100 == 0 && parseInt(idcard.substr(6, 4)) % 4 == 0)) {
			ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;// 闰年出生日期的合法性正则表达式
		} else {
			ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;// 平年出生日期的合法性正则表达式
		}
		if (ereg.test(idcard)) {
			S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7
					+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9
					+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10
					+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5
					+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8
					+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4
					+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 + parseInt(idcard_array[7]) * 1
					+ parseInt(idcard_array[8]) * 6 + parseInt(idcard_array[9]) * 3;
			Y = S % 11;
			M = "F";
			JYM = "10X98765432";
			M = JYM.substr(Y, 1);
			if (M == idcard_array[17])
				return true;
			else
				return false;
		} else
			return false;
		break;
	default:
		return false;
		break;
	}
}

function isnumber(value) {
	return /^\d+(\.\d+)?$/i.test(value);
}