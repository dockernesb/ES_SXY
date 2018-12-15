// ===============================公用JS=======================================// 

//-------------------------IE10以下支持placeholder属性--------------------------------//
jQuery.fn.placeholder = function() {
	var i = document.createElement('input'), placeholdersupport = 'placeholder' in i;
	if (!placeholdersupport) {
		var inputs = jQuery(this);
		inputs.each(function() {
			var input = jQuery(this), text = input.attr('placeholder'), pdl = 0, height = input.outerHeight(), width = input.outerWidth(), placeholder = jQuery('<span class="phTips">' + text
					+ '</span>');
			try {
				pdl = input.css('padding-left').match(/\d*/i)[0] * 1;
			} catch (e) {
				pdl = 5;
			}
			placeholder.css({
				'margin-left' : -(width - pdl),
				'height' : height,
				'line-height' : height + "px",
				'position' : 'absolute',
				'color' : "#999",
				'font-size' : "14px"
			});
			placeholder.click(function() {
				input.focus();
				input.click();
			});
			if (!isNull(input.val())) {
				placeholder.css({
					display : 'none'
				});
			} else {
				placeholder.css({
					display : 'inline'
				});
			}
			placeholder.insertAfter(input);
			input.on('keyup change', function(e) {
				if (!isNull(jQuery(this).val())) {
					placeholder.css({
						display : 'none'
					});
				} else {
					placeholder.css({
						display : 'inline'
					});
				}
			});
		});
	}
	return this;
};

// 设置jquery的ajax全局请求参数 ,处理ajax请求session过期的问题
$.ajaxSetup({
	cache : false,
	complete : function(XMLHttpRequest, textStatus) {
		var sessionstatus = XMLHttpRequest.getResponseHeader('ajaxSessionStatus');
		if (sessionstatus == 'ajaxTimeOut') {
			// alert(getRootPath());
			layer.alert('登录超时，请重新登录！', {
				icon : 0
			}, function() {
				window.top.location.href = getRootPath();
			});
		}
	}
});

// js获取项目根路径
function getRootPath() {
	// 获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp
	var curPath = window.document.location.href;
	// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
	var pathName = window.document.location.pathname;
	var pos = curPath.indexOf(pathName);
	// 获取主机地址，如： http://localhost:8083
	var localhostPath = curPath.substring(0, pos);
	// 获取带"/"的项目名，如：/uimcardprj
	var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
	return (localhostPath + projectName);
}

// 判断数据是否为空
function isNull(o) {
	return o == null || o == "" || o == 'undefined' || o == 'null';
}
/** 空值转换为''空字符串 */
function nullToEmpty(o) {
	return isNull(o) ? '' : $.trim(o);
}

/**
 * 设置Cookie
 * 
 * @key Cookie名称
 * @value Cookie值
 * @expiredays Cookie有效时间(单位：分钟)
 */
function setCookie(key, value, expireMinute) {
	var date = new Date();
	date.setTime(date.getTime() + expireMinute * 60 * 1000);
	document.cookie = key + "=" + escape(value) + (isNull(expireMinute) ? "" : ";expires=" + date.toUTCString()) + ";path=/";
}

/**
 * 根据key值获取Cookie
 * 
 * @key Cookie名称
 */
function getCookie(key) {
	if (document.cookie.length > 0) {
		c_start = document.cookie.indexOf(key + "=");
		if (c_start != -1) {
			c_start = c_start + key.length + 1;
			c_end = document.cookie.indexOf(";", c_start);
			if (c_end == -1) {
				c_end = document.cookie.length;
			}
			return unescape(document.cookie.substring(c_start, c_end));
		}
	}
	return "";
}

/**
 * 打印控制台日志
 */
function log(message) {
	if (window.console && typeof (console.log) == "function") {
		console.log(message);
	} else if (window.opera && typeof (opera.postError) == "function") {
		opera.postError(message);
	}
}

// 数据去除重复的值
Array.prototype.del = function() {
	var a = {}, c = [], l = this.length;
	for (var i = 0; i < l; i++) {
		var b = this[i];
		var d = (typeof b) + b;
		if (a[d] === undefined) {
			c.push(b);
			a[d] = 1;
		}
	}
	return c;
};

// 数据获取指定元素下标
Array.prototype.indexOf = function(val) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == val)
			return i;
	}
	return -1;
};

// 数据去除指定的值
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};

// 数据是否包含指定的值
Array.prototype.contains = function(element) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == element) {
			return true;
		}
	}
};

function Map() {
	this.elements = new Array();
	// 获取MAP元素个数
	this.size = function() {
		return this.elements.length;
	};

	// 判断MAP是否为空
	this.isEmpty = function() {
		return (this.elements.length < 1);
	};

	// 删除MAP所有元素
	this.clear = function() {
		this.elements = new Array();
	};

	// 向MAP中增加元素（key, value)
	this.put = function(_key, _value) {
		if (this.containsKey(_key)) {
			this.remove(_key);
		}
		this.elements.push({
			key : _key,
			value : _value
		});
	};
	// 删除指定KEY的元素，成功返回True，失败返回False
	this.remove = function(_key) {
		var bln = false;
		try {
			for (var i = 0; i < this.elements.length; i++) {
				if (this.elements[i].key == _key) {
					this.elements.splice(i, 1);
					return true;
				}
			}
		} catch (e) {
			bln = false;
		}
		return bln;
	};

	// 获取指定KEY的元素值VALUE，失败返回NULL
	this.get = function(_key) {
		try {
			for (var i = 0; i < this.elements.length; i++) {
				if (this.elements[i].key == _key) {
					return this.elements[i].value;
				}
			}
		} catch (e) {
			return null;
		}
	};

	// 获取指定索引的元素（使用element.key，element.value获取KEY和VALUE），失败返回NULL
	this.element = function(_index) {
		if (_index < 0 || _index >= this.elements.length) {
			return null;
		}
		return this.elements[_index];
	};

	// 判断MAP中是否含有指定KEY的元素
	this.containsKey = function(_key) {
		var bln = false;
		try {
			for (var i = 0; i < this.elements.length; i++) {
				if (this.elements[i].key == _key) {
					bln = true;
				}
			}
		} catch (e) {
			bln = false;
		}
		return bln;
	};

	// 判断MAP中是否含有指定VALUE的元素
	this.containsValue = function(_value) {
		var bln = false;
		try {
			for (var i = 0; i < this.elements.length; i++) {
				if (this.elements[i].value == _value) {
					bln = true;
				}
			}
		} catch (e) {
			bln = false;
		}
		return bln;
	};

	// 获取MAP中所有VALUE的数组（ARRAY）
	this.values = function() {
		var arr = new Array();
		for (var i = 0; i < this.elements.length; i++) {
			arr.push(this.elements[i].value);
		}
		return arr;
	};

	// 获取MAP中所有KEY的数组（ARRAY）
	this.keys = function() {
		var arr = new Array();
		for (var i = 0; i < this.elements.length; i++) {
			arr.push(this.elements[i].key);
		}
		return arr;
	};
}

/**
 * *获取URL的参数值 *@param strName 参数名称
 */
function getRequestURLParam(strName) {
	var strHref = document.location.href;
	var intPos = strHref.indexOf("?");
	var strRight = strHref.substr(intPos + 1);
	var arrTmp = strRight.split("&");
	for (var i = 0; i < arrTmp.length; i++) {
		var arrTemp = arrTmp[i].split("=");
		if (arrTemp[0].toUpperCase() == strName.toUpperCase()) {
			return arrTemp[1];
		}
	}
	return "";
}

/*
 * 键盘回车事件 $('#xxx').bind('keypress',enterEvent(e, fn));
 */
function enterEvent(e, fn) {
	if ($.browser.msie) {
		if (event.keyCode == 13) {
			eval(fn);
		}
	} else {
		if (e.which == 13) {
			eval(fn);
		}
	}
}
// 弹框位置固定 屏幕中央
function popPosition(dom) {
	var _windowHeight = $(window).height();
	var _windowWidth = $(window).width();
	var _popupHeight = $(dom).height();
	var _popupWidth = $(dom).width();
	$(dom).css('width', _popupWidth);
	var _posiTop = (_windowHeight - _popupHeight) / 2;
	var _posiLeft = (_windowWidth - _popupWidth) / 2;
	$(dom).css({
		"left" : _posiLeft,
		"top" : _posiTop
	}).show();
}

// 打开图片预览窗口
function openViewWindow(id) {
	var iWidth = 800; // 弹出窗口的宽度;
	var iHeight = 550; // 弹出窗口的高度;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; // 获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; // 获得窗口的水平位置;
	var viewPath = $("#" + id + "_viewPath").val();
	var newwin = window.open(CONTEXT_PATH + "/gov/common/openViewWindow.action?viewPath=" + viewPath, null, 'width=' + iWidth + ', height=' + iHeight
			+ ', toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,innerWidth=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',resizable=1, titlebar=no, toolbar=no, location=no, menubar=no');
	newwin.focus();
}

// 打开图片预览窗口
function openPhoto(path) {
	layer.photos({
		photos : {
			"title" : "", // 相册标题
			"id" : "photos", // 相册id
			"start" : 0, // 初始显示的图片序号，默认0
			"data" : [ // 相册包含的图片，数组格式
			{
				"alt" : "",
				"pid" : 123, // 图片id
				"src" : path, // 原图地址
				"thumb" : "" // 缩略图地址
			} ]
		},
		anim : 5
	// 0-6的选择，指定弹出图片动画类型，默认随机（请注意，3.0之前的版本用shift参数）
	});
}

// 格式化日期
Date.prototype.format = function(format) {
	var o = {
		"M+" : this.getMonth() + 1, // month
		"d+" : this.getDate(), // day
		"h+" : this.getHours(), // hour
		"m+" : this.getMinutes(), // minute
		"s+" : this.getSeconds(), // second
		"q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
		"S" : this.getMilliseconds()
	// millisecond
	};

	if (/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	}

	for ( var k in o) {
		if (new RegExp("(" + k + ")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}
	}
	return format;
}

/**
 * 复制到剪切板
 * 
 * @param $btn
 *            按钮
 * @param $text
 *            文本域
 */
function clipboard(btnSelector, textSelector) {
	var val = $(textSelector).val();
	if (window.clipboardData) { // for ie
		$(btnSelector).click(function() {
			window.clipboardData.setData('text', val);
			var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'>☺ 复制成功</div></div>");
			$("body").find(".copy-tips").remove().end().append($copysuc);
			$(".copy-tips").fadeOut(3000);
		});
	} else {
		$(btnSelector).zclip({
			path : getRootPath() + "/js/jquery.zclip/ZeroClipboard.swf",
			copy : function() {
				return val;
			},
			afterCopy : function() {/* 复制成功后的操作 */
				var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'>☺ 复制成功</div></div>");
				$("body").find(".copy-tips").remove().end().append($copysuc);
				$(".copy-tips").fadeOut(3000);
			}
		});
	}
	return false;
}

// json工具
var json = {
	// ------json深拷贝------
	"clone" : function(param) {
		var jsonObject = null;
		if (param instanceof Array) {
			jsonObject = [];
			for (var i = 0; i < param.length; i++) {
				jsonObject[i] = json.clone(param[i]);
			}
		} else if (typeof param == "object") {
			jsonObject = {};
			for ( var k in param) {
				jsonObject[k] = json.clone(param[k]);
			}
		} else {
			jsonObject = param;
		}
		return jsonObject;
	},
	// ------json转字符串------
	"jsonToString" : function(param) {
		var str = '', empty = true;
		if (param instanceof Array) {// 数组
			var len = param.length;
			str = '[';
			for (var i = 0; i < len; i++) {
				str += json.jsonToString(param[i]);
				i < len - 1 ? str += ',' : null;
			}
			str += ']';
		} else if (typeof param == "object") {// 对象
			str = '{';
			for ( var k in param) {
				str += '"' + k + '":' + json.jsonToString(param[k]) + ',';
				empty = false;
			}
			!empty ? str = str.substring(0, str.length - 1) : null;
			str += '}';
		} else if (typeof param == "number") { // 数字
			str = param;
		} else {// 字符串或其它
			str = '"' + param + '"';
		}
		return str;
	}
};

// 获取不重复的英文名子
var random = (function() {
	function Random() {
		var len = 5;
		var currentName = "";

		this.getName = function() {
			if (currentName == "") {
				for (var i = 0; i < len; i++) {
					currentName += "a";
				}
			} else {
				for (var i = len - 1; i > 0; i--) {
					var prefix = currentName.substring(0, i);
					var suffix = currentName.substring(i + 1, len);
					var code = currentName.charCodeAt(i);
					if (code < 122) {
						code = code + 1;
						var newChar = String.fromCharCode(code);
						currentName = prefix + newChar + suffix;
						break;
					} else {
						currentName = prefix + "a" + suffix;
					}
				}
			}
			return currentName;
		}
	}

	return new Random();
})();

$.extend({
	alert : function(msg, cfg, fun) { // 消息框
		cfg = cfg || 0;
		var icon = {
			icon : cfg
		};
		layer.alert(msg || "", icon, function(index) {
			layer.close(index);
			if (fun instanceof Function) {
				fun();
			}
		});
	},
	openWin : function(params) {
		layer.open({
			type : params.type || 1,
			title : params.title,
			shadeClose : false,
			shade : 0.6,
			maxmin : true, // 开启最大化最小化按钮
			area : params.area || [ '600px', '400px' ],
			content : params.content || "",
			btn : params.btn || [ "确定", "取消" ],
			btnAlign : params.btnAlign || 'c',
			yes : params.yes || function(index, layero) {
				layer.close(index);
			},
			btn2 : params.btn2 || function(index, layero) {
				layer.close(index);
			}
		});
	}
});

$.fn.extend({
	validateForm : function(rules, ignore) {
		var validators = [];
		$.each($(this), function() {
			var validator = $(this).validate({
				errorElement : 'span',
				errorClass : 'help-block help-block-error',
				focusInvalid : false,
				ignore : ignore,
				rules : rules,

				errorPlacement : function(error, element) { // render error
					// placement for
					// each input type
					var icon = $(element).parent('.input-icon').children('i');
					icon.removeClass('fa-check').addClass("fa-warning");
					icon.attr("data-original-title", error.text()).tooltip({
						'container' : 'body'
					});
				},

				highlight : function(element) { // hightlight error inputs
					$(element).closest('.input-icon').parent('div,td').removeClass("has-success").addClass('has-error');
				},

				success : function(label, element) {
					var icon = $(element).parent('.input-icon').children('i');
					$(element).closest('.input-icon').parent('div,td').removeClass('has-error').addClass('has-success');
					icon.removeClass("fa-warning").addClass("fa-check");
				}
			});
			validators.push(validator);
		});
		return validators.length == 1 ? validators[0] : validators;
	}
});

// 打开加载提示
var loading = function() {
	layer.load();
};
// 关闭加载提示
var loadClose = function() {
	layer.closeAll('loading');
};

// 重新定位三角形位置
var resizeSelect2 = function(selector) {
	$(selector).next('span').find('.select2-selection__arrow').css('right', '10px');
	$(selector).next('span').find('.select2-selection__clear').css('margin-right', '0');
}
// 重置三角形位置
var resetSelect2 = function(selector) {
	$(selector).next('span').find('.select2-selection__arrow').css('right', '30px');
	$(selector).next('span').find('.select2-selection__clear').css('margin-right', '22px');
}

//获取事件
function getEvent(){
    if(window.event)    {return window.event;}
    func=getEvent.caller;
    while(func!=null){
        var arg0=func.arguments[0];
        if(arg0){
            if((arg0.constructor==Event || arg0.constructor ==MouseEvent
                || arg0.constructor==KeyboardEvent)
                ||(typeof(arg0)=="object" && arg0.preventDefault
                && arg0.stopPropagation)){
                return arg0;
            }
        }
        func=func.caller;
    }
    return null;
}

//阻止冒泡事件
function stopBubble() {
	var e=getEvent();
	if(window.event){
	    // e.returnValue=false;//阻止自身行为
	    e.cancelBubble=true;// 阻止冒泡
	}else if(e.preventDefault){
	    // e.preventDefault();//阻止自身行为
	    e.stopPropagation();// 阻止冒泡
	}
}

//阻止默认浏览器动作(W3C),如：<a onclick=''>如果要阻止默认事件的触发，即默认的href事件
function stopDefault() {
	var e = arguments.callee.caller.arguments[0] || event; // 若省略此句，下面的e改为event，IE运行可以，但是其他浏览器就不兼容
	if (e && e.preventDefault) {
		// IE中阻止函数器默认动作的方式
		e.preventDefault();
	} else {
		window.event.returnValue = false;
	}
	return false;
}


// 加载图片出错时加载默认图片
function loadDefaultImg(obj) {
	if (obj) {
		obj.src = ctx + "/app/images/img.jpg";
	}
}

// 删除附件
function deleteAdjunct(obj) {
	$(obj).parent(".preview-file").remove();
	$(obj).parent(".preview-img").remove();
}

/**
 * 解决ie9的placeholder兼容性问题
 * 
 * @param elem
 *            laydate日期框的JQuery选择器 如：#id .class
 * @param selectedValue
 *            日期框选中的日期值
 */
function laydatePH(elem, selectedValue) {
	// 解决ie9的placeholder兼容性问题--begin--
	var phspan = $(elem).next('.phTips');
	if (!isNull(phspan) && !isNull(selectedValue)) {
		$(phspan).hide();
	}
	// 解决ie9的placeholder兼容性问题--end--
}
/**
 * 重置表格的查询条件
 * 
 * @param elems
 *            需要重置查询条件的元素JQuery选择器 如：#id .class
 * @param fun
 *            回调函数
 */
function resetSearchConditions(elems, fun) {
	$(elems).val('').trigger('change');
	if (fun instanceof Function) {
		fun();
	}
}

function resetDate(){
    if(arguments && arguments.length>=1){
   	 for(var i=0;i<arguments.length;i++){
			 arguments[i].min = '1970-01-01';
			 arguments[i].max = '2099-12-30';
			 arguments[i].start = '';
   	 }
    }
}


//	在线预览PDF
function viewPdf(uploadFileId) {
	var url = ctx + "/common/viewPdf.action?uploadFileId=" + uploadFileId;
	window.open(url, uploadFileId);
}

//	下载文件
function downloadFile(uploadFileId) {
	var url = ctx + "/common/ajaxDownload.action?uploadFileId=" + uploadFileId;
	log("downloadFile = " + url);
	document.location.href = url;
}

//添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
//_this：点击事件方法里的this变量，multiple：列表是否支持行多选，单选时可不传值
function addDtSelectedStatus(_this, multiple) {
	if(!multiple){
		$(_this).closest('tbody').find('tr.active').removeClass('active');
	}
	// 如果有行复选框，则选中
	var icheck = $(_this).closest('tr').find('.icheck');
	if(icheck){
		icheck.iCheck('check');
	}
	
	$(_this).closest('tr').addClass('active');
	stopBubble();
}
