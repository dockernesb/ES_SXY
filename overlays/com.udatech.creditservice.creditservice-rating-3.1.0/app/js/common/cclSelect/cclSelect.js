/**
 * 多选下拉框组件
 * 示例：
 * 	var data = [{"id":"1", "text":"A"}, ...];
 *
 * 	$("#cclSelect").cclSelect({
 * 		url : ctx + "/system/department/getDeptList.action",	//	ajax获取下拉值
 * 		data : [],												//	本地数据给下拉框赋值（url | data选其一即可，同时存在时，url优先）
 * 		key : "id",												//	<option value="key"></option>默认为id
 *		val : "text",											//	<option>val</option>默认为text
 * 		change : function() {									//	下拉框值改变时触发，执行校验
 * 			validator.element($("#cclSelect"));
 * 		},
 * 		beforeDel : function(k, v) {
 *         return false;
 *      }
 * 	});
 */
$.fn.extend({
	cclSelect : function(opts) {
		var url = opts.url || "";
		var params = opts.params || {};
		var data = opts.data || [];
		var key = opts.key || "id";
		var val = opts.val || "text";
		var itemWidth = opts.itemWidth;
		var change = opts.change;
		var beforeDel = opts.beforeDel;
		$.each($(this), function(i, obj) {
			var timer = null;
			var $self = $(obj);
			var width = $self.width();
			var $select = $('<div class="form-control ccl-multi-select"></div>');
			$select.append('<input class="ccl-multi-select-search" />');
			var $panel = $('<div class="ccl-multi-select-panel"></div>');
			$panel.append('<div class="ccl-multi-select-tip">未找到结果</div>');
			$self.after($select);
			$select.after($panel);
			$self.addClass("ccl-hidden");

			if (url) {
				$.post(url, params, function(json) {
					initSelect(json);
				}, "json");
			} else if (data) {
				initSelect(data);
			}

			//	初始化多选框数据
			function initSelect(list) {
				if (list && list.length > 0) {
					var html1 = '';
					var html2 = '';
					for (var i=0; i<list.length; i++) {
						var item = list[i] || {};
						var k = item[key] || "";
						var v = item[val] || "";
						html1 += '<option value="' + k + '">' + v + '</option>';

						html2 += '<span class="ccl-multi-select-item" key="' + k + '">' + v + '</span>';
					}
					$self.children().remove();
					$self.append(html1);
					$panel.children(":not(.ccl-multi-select-tip)").remove();
					$panel.children(".ccl-multi-select-tip").hide();
					$panel.append(html2);
					if (itemWidth) {
						$panel.find(".ccl-multi-select-item").css("width", itemWidth);
					}

					initListener();
				}
			}

			//	监听事件
			function initListener() {

				//	本地搜索功能
				$select.find(".ccl-multi-select-search").keyup(function() {
                    var $items = $panel.find(".ccl-multi-select-item");

					var text = $.trim($(this).val());
					if (text) {
						$items.hide();
						var bool = false;
						$.each($items, function(i, obj) {
							var html = $(obj).html();
							if (html.indexOf(text) >= 0) {
								bool = true;
								$(obj).show();
							}
						});
						if (!bool) {
							$panel.children(".ccl-multi-select-tip").show();
						} else {
							$panel.children(".ccl-multi-select-tip").hide();
						}
					} else {
						$panel.children(".ccl-multi-select-tip").hide();
						$items.show();
					}
				});

				//	单击事件
                var $items = $panel.find(".ccl-multi-select-item");
				$items.click(function() {
					var key = $(this).attr("key");
					var val = $(this).html();
					if ($(this).hasClass("ccl-multi-select-active")) {
						if (beforeDel instanceof Function) {
							var bool = beforeDel(key, val);
							if (!bool) {
								return;
							}
						}

						$(this).removeClass("ccl-multi-select-active");
						$self.find("option[value='" + key + "']").removeAttr("selected");
						delSelectedItem(key, val)
					} else {
						$(this).addClass("ccl-multi-select-active");
						$self.find("option[value='" + key + "']").attr("selected", "selected");
						addSelectedItem(key, val);
					}
					// $select.find(".ccl-multi-select-search").val("");
					if (change instanceof Function) {
						change();
					}
				});

				function addSelectedItem(k, v) {
					if ($select.find(".ccl-multi-select-li[key='" + k + "']").length > 0) {
						return;
					}
					var $item = $('<span class="ccl-multi-select-li" key="' + k + '"></span>');
					$item.append('<span class="ccl-multi-select-del">×</span>');
					$item.append(v);
					$select.find(".ccl-multi-select-search").before($item);

					$item.find(".ccl-multi-select-del").click(function(e) {
						e.stopPropagation();

						clearTimeout(timer);

						if (beforeDel instanceof Function) {
							var bool = beforeDel(k, v);
							if (!bool) {
								return;
							}
						}

						$items.filter("[key='" + k + "']").removeClass("ccl-multi-select-active");
						$self.find("option[value='" + k + "']").removeAttr("selected");

						$select.find(".ccl-multi-select-search").focus();
						delSelectedItem(k, v);
					});

					if (change instanceof Function) {
						change();
					}
				}

				function delSelectedItem(k, v) {

					$select.find(".ccl-multi-select-li[key='" + k + "']").remove();

					if (change instanceof Function) {
						change();
					}
				}

				//	select改变事件监听
				$self.change(function() {
					//	不展示禁用的选项
					$items.removeClass("ccl-multi-select-disabled");
					var $disabledItems = $(this).find("option:disabled");
					if ($disabledItems.length > 0) {
						$.each($disabledItems, function(i, obj) {
							$(obj).removeAttr("selected");	//	禁用的取消选中状态
							var key = $(obj).attr("value");
							var $item = $items.filter("[key='" + key + "']");
							$item.addClass("ccl-multi-select-disabled");
							var text = $item.html();
							delSelectedItem(key, text);
						});
					}

					//	初始化选中项
					var vals = $(this).val();
					$items.removeClass("ccl-multi-select-active");
					if (vals && vals.length > 0) {
						for (var i=0; i<vals.length; i++) {
							var key = vals[i];
							var $item = $items.filter("[key='" + key + "']:not(:disabled)");
							if ($item.length == 1) {
								$item.addClass("ccl-multi-select-active");
								var text = $item.html();
								addSelectedItem(key, text);
							}
						}
					}

					if ($self.find("option:not(:disabled)").length == 0) {
						$panel.children(".ccl-multi-select-tip").show();
					}

					if (change instanceof Function) {
						change();
					}
				});
			}

			$select.click(function() {
				clearTimeout(timer);
				$.each($panel.find("span.ccl-multi-select-item"), function(i, obj) {
					if ($(obj).css("display") == "inline") {
						$(obj).removeAttr("style");
					}
				});
				if (!$panel.is(":visible")) {
					if ($self.find("option:not(:disabled)").length > 0) {
						$panel.children(".ccl-multi-select-tip").hide();
					} else {
						$panel.children(".ccl-multi-select-tip").show();
					}
					$panel.show();
					$select.addClass("ccl-multi-select-focus");
				}
				$select.find(".ccl-multi-select-search").focus();
			});

			$panel.click(function() {
				clearTimeout(timer);
				$select.find(".ccl-multi-select-search").focus();
			});

			$select.find(".ccl-multi-select-search").blur(function(eve) {
				var $self = $(this);
				timer = setTimeout(function() {
					$panel.hide();
					$self.val("");
					$self.keyup();
					$select.removeClass("ccl-multi-select-focus");
				}, 200);
			});

		});
	},
	/**
	 * 重置多选下拉框
	 * */
    cclSelectRemove:function () {
		$.each($(this), function (i, obj) {
            $(obj).find('option').remove();
            $(obj).next('.ccl-multi-select').remove();
            $(obj).next('.ccl-multi-select-panel').remove();
        });
    },
	/**
	 * 动态添加数据
	 *
	 * 举例
     * $("#status").cclSelectAddData({
     *      data: [
     *          {id: "0", text: "待审核"},
     *          {id: "1", text: "已通过"},
     *          {id: "2", text: "未通过"}
     *      ]
     *  });
     *
	 * */
    cclSelectAddData: function (opts) {
        var key = opts.key || "id";
        var val = opts.val || "text";
        var change = opts.change;
        var beforeDel = opts.beforeDel;
        var data = opts.data;
        $.each($(this), function (idx, self) {
            var $self = $(self);
            var $select = $(self).next('.ccl-multi-select');
            var $panel = $select.next('.ccl-multi-select-panel');

            var html1 = '';
            var html2 = '';
            for (var i = 0; i < data.length; i++) {
                var item = data[i] || {};
                var k = item[key] || "";
                var v = item[val] || "";
                html1 += '<option value="' + k + '">' + v + '</option>';
                html2 += '<span class="ccl-multi-select-item" key="' + k + '">' + v + '</span>';
            }
            $self.append(html1);
            $panel.append(html2);

            //	单击事件
            var $items = $panel.find(".ccl-multi-select-item");
            $items.unbind('click');
            $items.click(function() {
                var key = $(this).attr("key");
                var val = $(this).html();
                if ($(this).hasClass("ccl-multi-select-active")) {
                    if (beforeDel instanceof Function) {
                        var bool = beforeDel(key, val);
                        if (!bool) {
                            return;
                        }
                    }

                    $(this).removeClass("ccl-multi-select-active");
                    $self.find("option[value='" + key + "']").removeAttr("selected");
                    delSelectedItem(key, val)
                } else {
                    $(this).addClass("ccl-multi-select-active");
                    $self.find("option[value='" + key + "']").attr("selected", "selected");
                    addSelectedItem(key, val);
                }
                // $select.find(".ccl-multi-select-search").val("");
                if (change instanceof Function) {
                    change();
                }
            });

            function addSelectedItem(k, v) {
                if ($select.find(".ccl-multi-select-li[key='" + k + "']").length > 0) {
                    return;
                }
                var $item = $('<span class="ccl-multi-select-li" key="' + k + '"></span>');
                $item.append('<span class="ccl-multi-select-del">×</span>');
                $item.append(v);
                $select.find(".ccl-multi-select-search").before($item);

                $item.find(".ccl-multi-select-del").click(function(e) {
                    e.stopPropagation();
                    var timer = null;
                    clearTimeout(timer);

                    if (beforeDel instanceof Function) {
                        var bool = beforeDel(k, v);
                        if (!bool) {
                            return;
                        }
                    }

                    $items.filter("[key='" + k + "']").removeClass("ccl-multi-select-active");
                    $self.find("option[value='" + k + "']").removeAttr("selected");

                    $select.find(".ccl-multi-select-search").focus();
                    delSelectedItem(k, v);
                });

                if (change instanceof Function) {
                    change();
                }
            }

            function delSelectedItem(k, v) {

                $select.find(".ccl-multi-select-li[key='" + k + "']").remove();

                if (change instanceof Function) {
                    change();
                }
            }
        });

    },
    /**
	 * 动态删除数据
	 *
     * 举例
     * $("#status").cclSelectRemoveData({
     *      data: [{id: "0", text: "待审核" + index}, {id: "1", text: "已通过" + index}]
     *  });
     *
     * */
    cclSelectRemoveData:function (opts) {
        var key = opts.key || "id";
        var data = opts.data;

        $.each($(this), function (idx, self) {
            var $self = $(self);
            var $select = $(self).next('.ccl-multi-select');
            var $panel = $select.next('.ccl-multi-select-panel');
            var $items = $panel.find(".ccl-multi-select-item");

            for (var i = 0; i < data.length; i++) {
                var item = data[i] || {};
                var k = item[key] || "";

                $items.filter("[key='" + k + "']").remove();
                $self.find("option[value='" + key + "']").remove();
                $select.find(".ccl-multi-select-search").focus();
                $select.find(".ccl-multi-select-li[key='" + k + "']").remove();
            }

        });

    }
});














