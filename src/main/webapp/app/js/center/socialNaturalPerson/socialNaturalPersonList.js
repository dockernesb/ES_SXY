var naturalPerson = (function() {
	var zymc = '';
	// 表格加载数据
	var table = $('#naturalPersonGrid').DataTable({
		ajax : {
			url : CONTEXT_PATH + '/center/socialNaturalPerson/queryList.action',
			type : 'post'
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		pageLength : 10,
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		ordering : false,
		autoWidth : false,
		columns : [ {
			"data" : "XM"
		}, {
			"data" : "SFZH"
		}, {
			"data" : "XB"
		}, {
			"data" : "SSHY"
		}, {
			"data" : "CSRQ"
		}, {
			"data" : "MZ", 
			"visible" : false
		}, {
			"data" : "HJDZ", 
			"visible" : false
		}, {
			"data" : null,
			"render" : function(data, type, row) {
				var str = '';
				str += '<button type="button" class="btn green btn-xs" onclick="naturalPerson.toView(\'' + row.SFZH + '\',\'' + row.ZYMC + '\', this);">查看</button>';
				return str;
			}
		} ],
		initComplete : function(settings, data) {
			var columnTogglerContent = $('#columnTogglerContent').clone();
			$(columnTogglerContent).removeClass('hide');
			var columnTogglerDiv = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
			$(columnTogglerDiv).html(columnTogglerContent);

			$(columnTogglerContent).find('input[type="checkbox"]').iCheck({
				labelHover : false,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});

			// 显示隐藏列
			$(columnTogglerContent).find('input[type="checkbox"]').on('ifChanged', function(e) {
				e.preventDefault();
				// Get the column API object
				var column = table.column($(this).attr('data-column'));
				// Toggle the visibility
				column.visible(!column.visible());
			});
		}
	});
	
	$('#naturalPersonGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});
	
	// 查看详细
	function toView(sfzh, zymc, _this) {
		addDtSelectedStatus(_this);
		zymc = isNull(zymc) ? '' : zymc;
		var url = CONTEXT_PATH + '/center/socialNaturalPerson/toView.action';
		$("div#childBox").html("");
		$("div#childBox").load(url, {
			sfzh : sfzh,
			zymc : zymc
		});
		$("div#parentBox").hide();
		$("div#childBox").show();
		$("div#childBox").prependTo("#topBox");
		resetIEPlaceholder();
	}
	
	function findByZymc(obj){
		if (!isNull(obj)) {
			if ($(obj).hasClass("yellow")) {
				$(obj).removeClass("yellow");
				zymc = '';
			} else {
				$('a.yellow').removeClass("yellow");
				$(obj).addClass("yellow");
				zymc = $.trim($(obj).html());
			}
		} else {
			zymc = '';
		}
		conditionSearch();
	}
	

	// 查询按钮
	function conditionSearch() {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["zymc"] = zymc;
			data["xm"] = $.trim($('#xm').val());
			data["sfzh"] = $.trim($('#sfzh').val());
			
			table.ajax.reload();
		}
	}
	// 重置
	function conditionReset() {
		zymc = '';
		$('a.yellow').removeClass("yellow");
		resetSearchConditions('#xm,#sfzh');
	}

	return {
		"toView" : toView,
		"findByZymc" : findByZymc,
		"conditionSearch" : conditionSearch,
		"conditionReset" : conditionReset
	}

})();