function AccordionMenu(options) {
	this.config = {
		containerCls : '.page-sidebar-menu', // 外层容器
		menuArrs : '', // Json传进来的数据
		type : 'click', // 默认为click 也可以mouseover
		renderCallBack : null, // 渲染html结构后回调
		clickItemCallBack : null
	// 每点击某一项时候回调
	};
	this.cache = {

	};
	this.init(options);
}
// 不显示的左侧菜单名称集合
AccordionMenu.exceptMenuName = [ ];

AccordionMenu.openUrl = function(name, url) {
	if(url.indexOf('outer:') != -1){
		url =  url.substring(url.indexOf('outer:') + 6, url.length);
		window.open(url).focus();
		return;		
	}

	if (url != 'javascript:;' && url != '#') {
		$('.page-content').removeClass('wellcome');
		if (!isNull(name)) {
			$("h3.page-title").html(name);
		}
		$("div#mainContent").load(url);
		$('html, body').animate({
			scrollTop : 0
		}, 500);
	}
}

// menuId:对应菜单的a标签的id值，如传递：#1500
AccordionMenu.skipToMenu = function(menuId) {
    $(menuId).trigger('click');
}

AccordionMenu.prototype = {

	constructor : AccordionMenu,

	init : function(options) {
		this.config = $.extend(this.config, options || {});
		var self = this, _config = self.config, _cache = self.cache;

		// 渲染html结构
		$(_config.containerCls).each(function(index, item, path) {
			self._renderHTML(item);
		});
	},
	_renderHTML : function(container) {
		var self = this, _config = self.config, _cache = self.cache;
		var arr = eval('(' + _config.menuArrs + ')');
		$.each(arr, function(index, item) {
			if (AccordionMenu.exceptMenuName.contains(item.name)) {// 过滤不显示菜单
				return true;
			}
			var url = item.url || 'javascript:;';
			var lihtml = $('<li></li>');
			var lia = $('<a href="javascript:;" id="' + item.order + '"  onclick="AccordionMenu.openUrl(\'' + item.name + '\',\'' + url + '\')"><i class="' + item.icon + '"></i><span class="title">&nbsp;' + item.name
					+ '</span></a>');
			if (item.submenu && item.submenu.length > 0) {
				var lispan = $('<span class="arrow"></span>');
				lia.append(lispan);
				lihtml.append(lia);
				self._createSubMenu(item.submenu, lihtml);
			} else {
				lihtml.append(lia);
			}
			$(container).append(lihtml);
		});

		_config.renderCallBack && $.isFunction(_config.renderCallBack) && _config.renderCallBack();
	},
	/**
	 * 创建子菜单
	 * 
	 * @param {array}
	 *            子菜单
	 * @param {lihtml}
	 *            li项
	 */
	_createSubMenu : function(submenu, lihtml) {
		var self = this, _config = self.config, _cache = self.cache;
		var subUl = $('<ul class="sub-menu"></ul>'), callee = arguments.callee, subLi;

		$(submenu).each(function(index, item) {
			if (AccordionMenu.exceptMenuName.contains(item.name)) {// 过滤不显示菜单
				return true;
			}
			var url = item.url || 'javascript:;';
			var subLi = $('<li></li>');
			var suba = $('<a href="javascript:;" id="' + item.order + '"  onclick="AccordionMenu.openUrl(\'' + item.name + '\',\'' + url + '\')"><i class="' + item.icon + '"></i>&nbsp;' + item.name + '</a>');
			if (item.submenu && item.submenu.length > 0) {
				var subspan = $('<span class="arrow"></span>');
				suba.append(subspan);
				subLi.append(suba);
				callee(item.submenu, subLi);
			} else {
				subLi.append(suba);
			}
			subUl.append(subLi);
		});
		lihtml.append(subUl);
	}
};