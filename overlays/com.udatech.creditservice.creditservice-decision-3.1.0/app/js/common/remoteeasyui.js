    $.extend($.fn.validatebox.defaults.rules, {
        myvalidate: {
            validator: function(value, param){
                var result=$.ajax({
                    url:param[0],
                    dataType:"json",
                    data:param[1],
                    async:false,
                    cache:false,
                    type:"post"
                }).responseText;
                return result=="true";
            },
            message: 'Please enter date like 2011-03-21 '
        }  
    });
    
    $.extend($.fn.validatebox.defaults.rules, {
        cipcheckadd: {
            validator: function(value, param){
            	//将字符串转化成json格式
            	param[1] = JSON.parse(param[1]);
            	param[1]["value"] = value;
                var result=$.ajax({
                    url:param[0],
                    dataType:"json",
                    data:param[1],
                    async:false,
                    cache:false,
                    type:"post"
                }).responseText;
                return result=="true";
            },
            message: '命名在数据库重复！'
        }  
    });
    
    $.extend($.fn.validatebox.defaults.rules, {
        cippassword: {
            validator: function(value, param){
            return /^[a-zA-Z0-9_]{6,16}$/i.test(value);
            },
            message: '格式错误，密码6-16字符，允许字母数字下划线'
        }  
    }); 
    
    $.extend($.fn.validatebox.defaults.rules, {
        cipnumber: {
            validator: function(value, param){
            	   var flag= isnumber(value);
                   return flag == true ? true : false;
            },
            message: '只允许数字'
        },
        cipint: {//value值为文本框中的值
            validator: function (value) {
                var reg = /^[1-9][0-9]*$/;
                return reg.test(value);
            },
            message: '只允许正整数.'
        },
        // 身份证验证
        idcared: {
            validator: function(value, param) {
                var flag= isCardID(value);
                return flag == true ? true : false;
            },
            message: '不是有效的身份证号码'
        },
        name: {// 验证姓名，可以是中文或英文
            validator: function (value) {
                return /^[\Α-\￥]+$/i.test(value) | /^\w+[\w\s]+\w+$/i.test(value);
            },
            message: '请输入姓名'
        },
        cipdat: {// 验证姓名，可以是中文或英文
            validator: function (value) {
            	var reg =/^(\d{4})-(\d{2})-(\d{2})$/;           	
                return reg.test(value);
            },
            message: '请输yyyy-mm-dd格式日期'

        },cipyh: {// 验证银行卡号
            validator: function (value) {
                var reg =/^(\d{16}|\d{19})$/;
                return reg.test(value);
            },
            message: '请输入正确的账号'

        },
        cipyear: {//验证年
            validator: function (value) {
            	var reg = /^\d{4}$/;
                return reg.test(value);
            },
            message: '请输正确的年份'
        }, 
        ciptime: {//验证时间格式
            validator: function (value) {
            	var reg = /^(\d{2}):(\d{2})$/;
                return reg.test(value);
            },
            message: '请输yhh:mm格式时间'
            	
        },
        cipdatime: {// 验证姓名，可以是中文或英文 /^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/
            validator: function (value) {
            	var reg =/^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2})$/;
                return reg.test(value);
            },
            message: '请输yyyy-mm-dd hh:mm格式日期'

        }, cipurl: {// 验证姓名，可以是中文或英文 "^[A-Za-z]+://[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&\?\/.=]+$"
            validator: function (value) {
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
            },
            message: '请输正确的网址格式'

        }
    });
    
    var aCity = {11:"北京",12:"天津",13:"河北",14:"山西",
            15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",
            32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",
            41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",
            50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",
            62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",
            82:"澳门",91:"国外"}

    function isCardID(sId) { 
        var iSum=0 ;
        var info="" ;
        if (!/^\d{17}(\d|x)$/i.test(sId)) {
            return "你输入的身份证长度或格式错误";
        }
        sId = sId.replace(/x$/i,"a"); 
        if (aCity[parseInt(sId.substr(0,2))]==null) {
            return "你的身份证地区非法";
        }
        sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));
        var d = new Date(sBirthday.replace(/-/g,"/"));
        if (sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate())) {
            return "身份证上的出生日期非法";
        }
        for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11);
        if (iSum%11!=1) {
            return "你输入的身份证号非法";
        }
        return true;
    }

    function isnumber(value) {
    	return /^\d+(\.\d+)?$/i.test(value);
    }