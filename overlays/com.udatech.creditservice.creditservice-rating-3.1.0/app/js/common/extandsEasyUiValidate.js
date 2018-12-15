$.extend($.fn.validatebox.defaults.rules, {
    minLength : { // 判断最小长度
        validator : function(value, param) {
            return value.length >= param[0];
        },
        message : "最少输入 {0} 个字符"
    },
    
    
     maxLength : { // 判断最小长度
        validator : function(value, param) {
            return value.length <= param[0];
        },
        message : "最多输入 {0} 个字符"
    },
  //邮政编码验证
    postCodecheck:{
   validator:function(value) {
	   return /^[1-9]\d{5}$/.test(value);

   },message:"邮编应为6位邮政编码"
   },

   
   //特殊字符过滤验证允许/.
   notillegalChar:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;',.////\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符"
   },
   
   
   //特殊字符过滤验证允许/.
   illegalChar:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;',\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许/."
   },
   
   
   //特殊字符过滤验证允许/.,
   illegalCharTwo:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;'\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许/.,"
   },
    
   
   
   //特殊字符过滤验证允许.
   illegalCharThree:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;',////\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许."
   },
   
   //特殊字符过滤验证允许/.?=&
   illegalCharFour:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^*()|{}':;',\[\\]<>~！@#￥……*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许/.?=&"
   },
   
   //特殊字符过滤验证允许/.()（）-
   illegalCharFive:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*=|{}':;',.////\[\\]<>?~！@#￥……&*——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许()（）"
   },
   
   // 特殊字符过滤验证允许.。()（）-!！@@=[]【】?？$￥“”''‘’%％％%:：,，、、-——……
   illegalCharSix:{
    validator:function(value) {
     var pattern = new RegExp("[`~#^&*|{}////\\\<>~#&*|{}\\\\＼＼]");
     return !pattern.test(value);
     
    },message:"含有非法特殊字符"
   },
   
   //验证数字且去空格
   num:{
	   validator:function(value) {
		    return /^[1-9]\d*$/.test($.trim(value));
	   },message:"必须为非0开始的整数"
   },
   
    
    length:{validator:function(value,param){
        var len=$.trim(value).length;
            return len>=param[0]&&len<=param[1];
        },
            message:"输入内容长度必须介于{0}和{1}之间."
        },
        
      //电话号码验证//        
        phone : {// 验证电话号码  
            validator : function(value) { 
            	var reg = /^((0\d{2,3}-\d{7,8})|(1[3|4|5|7|8|9]\d{9}))$/;
                return reg.test(value);
            },  
            message : '格式须为固定电话或手机号码如0512-12345678或13012345678'  
        }, 
        
      //移动手机号码验证 "^\\d+$"
        mobile: {//value值为文本框中的值
            validator: function (value) {
                var reg = /^1[3|4|5|7|8|9]\d{9}$/;
                return reg.test(value);
            },
            message: '输入手机号码格式不准确.'
        },
    
    idcard : {// 验证身份证
        validator : function(value) {
            return /^\d{17}([0-9]|X$)/i.test(value);
//            return /(^\d{15}$)|(^\d{17}([0-9]|X)$)/i.test(value);
        },
        message : "身份证号码格式应为18位数字或最后位可为X"
    },
    
    intOrFloat : {// 验证整数或小数
        validator : function(value) {
            return /^[+-]?([0-9]*\.?[0-9]+|[0-9]+\.?[0-9]*)([eE][+-]?[0-9]+)?$/;
        },
        message : "请输入整数或小数，并确保格式正确"
    },
    positiveOrNegative : {// 验证整数，包括负数
        validator : function(value) {
            return /^(-|\+)?\d+$/.test(value);
        },
        message : "请输入正整数或负整数，并确保格式正确"
    },
    float : {// 验证2位小数
        validator : function(value) {
            return /^[+-]?([0-9]*\.?[0-9]{2}|[0-9]+\.?[0-9]{2})([eE][+-]?[0-9]+)?$/.test(value);
        },
        message : "请输入整数或2位小数，并确保格式正确"
    },
    
    currency : {// 验证货币
        validator : function(value) {
            return /^d+(.d+)?$/i.test(value);
        },
        message : "货币格式不正确"
    },
    
    qq: {// 验证QQ,从10000开始
        validator: function (value) {
            return /^[1-9]\d{4,9}$/i.test(value);
        },
        message : "QQ号码格式不正确"
    },
    
    integer : {// 验证整数
        validator : function(value) {
            return /^[+]?[1-9]+d*$/i.test(value);
        },
        message : "请输入整数"
    },
    
    chinese : {// 验证中文
        validator : function(value) {
            return /^[\Α-\￥]+$/i.test(value);
        },
        message : "请输入中文"
    },
    
    notchinese : {// 验证密码格式
    	validator : function(value) {
    		return /^[a-zA-Z0-9_]{6,16}$/i.test(value);
    	},
    	message : '格式错误，密码6-16字符，只允许字母数字下划线'
    },
    notchineseG : {// 验证含中文
    	validator : function(value) {
    		var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
    		/*return !/^[\u0391-\uFFE5]?$/i.test(value);*/
    		   return !reg.test(value);
    		/*return !/^[\u4e00-\u9fa5]+$/i.test(value); */
    	},
    	message : "禁止含有中文"   
    },
    
    english : {// 验证英语
        validator : function(value) {
            return /^[A-Za-z]+$/i.test(value);
        },
        message : "请输入英文"
    },
    
    unnormal : {// 验证是否包含空格和非法字符
        validator : function(value) {
            return /.+/i.test(value);
        },
        message : "输入值不能为空和包含其他非法字符"
    },
    
    unblank : {// 验证是否包含空格
        validator : function(value) {
            return /^\S+$/gi.test(value);
        },
        message : "输入值不能包含空格"
    },
    
    username : {// 验证用户名
        validator : function(value) {
            return /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/i.test(value);
        },
        message : "用户名不合法（字母开头，允许6-16字节，允许字母数字下划线）"
    },
    
    faxno : {// 验证传真
        validator : function(value) {
//            return /^[+]{0,1}(d){1,3}[ ]?([-]?((d)|[ ]){1,12})+$/i.test(value);
            return /^(((d{2,3}))|(d{3}-))?((0d{2,3})|0d{2,3}-)?[1-9]d{6,7}(-d{1,4})?$/i.test(value);
        },
        message : "传真号码不正确"
    },
    
    zip : {// 验证邮政编码
    	validator: function (value) {
            var reg = /^[1-9]\d{5}$/;
            return reg.test(value);
        },
        message: '邮编必须是非0开始的6位数字.'
    },
    
    ip : {// 验证IP地址
        validator : function(value) {
            return /d+.d+.d+.d+/i.test(value);
        },
        message : "IP地址格式不正确"
    },
    
    carNo:{
        validator : function(value){
            return /^[u4E00-u9FA5][da-zA-Z]{6}$/.test(value);
        },
        message : "车牌号码无效（例：粤J12350）"
    },
    
    carenergin:{
        validator : function(value){
            return /^[a-zA-Z0-9]{16}$/.test(value);
        },
        message : "发动机型号无效(例：FG6H012345654584)"
    },
    
    email:{//验证邮箱
        validator : function(value){
        	var reg =/^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/; 
            return reg.test(value);
        },
        message : "请输入有效的电子邮件账号(例：abc@126.com)"   
    },
    
    msn:{
        validator : function(value){
        return /^w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*$/.test(value);
    },
    message : "请输入有效的msn账号(例：abc@hotnail(msn/live).com)"
    },
    
    same:{
        validator : function(value, param){
            if($("#"+param[0]).val() != "" && value != ""){
                return $("#"+param[0]).val() == value;
            }else{
                return true;
            }
        },
        message : "两次输入的密码不一致！"   
    }
});
