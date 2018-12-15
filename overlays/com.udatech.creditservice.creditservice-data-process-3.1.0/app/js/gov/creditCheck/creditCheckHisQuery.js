// 审查申请Js
var creditCheckApply = (function() {
	// $.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
	// 	// 初始下拉框
	// 	$("#xqbm").select2({
	// 		placeholder : '审查部门',
	// 		allowClear : false,
	// 		language : 'zh-CN',
	// 		data : result
	// 	});
		$("#status").select2({
			placeholder : '全部状态',
			minimumResultsForSearch: -1,
			language : 'zh-CN'
		});
		
		$("#status").val(null).trigger("change");
		// resizeSelect2($("#xqbm"));
		resizeSelect2($("#status"));
	// 	$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
	// });

	var start = {
		elem : '#sqsjs',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		min : '1900-01-01', // 最小日期
		istime : false,
		istoday : false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#sqsjs', datas);
			end.min = datas; // 开始日选好后，重置结束日的最小日期
			end.start = datas // 将结束日的初始值设定为开始日
		}
	};
	var end = {
		elem : '#sqsjz',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		min : '1900-01-01', // 最小日期
		istime : false,
		istoday : false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#sqsjz', datas);
			start.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(start);
	laydate(end);

	var table = $('#applyListGrid').DataTable({// 创建一个Datatable
		ajax : {
			url : CONTEXT_PATH + "/gov/creditCheck/queryApplyList.action",
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
			"data" : "bjbh", // 编号
			render : function(data, type, row) {
				var str = '<a href="javascript:;" onclick="creditCheckApply.toView(\'' + row.id + '\')">'+ row.bjbh +'</a>';
				return str;
			}
		}, {
			"data" : "scmc"
		// }, {
		// 	"data" : "scxqbm.departmentName"
		}, {
			"data" : "scxxlStr"
		}, {
			"data" : "applyDate"
		}, {
			"data" : "status", // 状态
			render : function(data, type, row) {
				if ("0" == data) {
					return "待审核";
				} else if ("1" == data) {
					return "未通过";
				} else if ("2" == data) {
					return "已通过";
				}
			}
		}, {
			"data" : null, // 操作
			render : function(data, type, row) {
				var str = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="creditCheckApply.toView(\'' + row.id + '\')">查看</a>';
				return str;
			}
		} ]
	});

	$('#applyListGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 查询按钮
	function conditionSearch() {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["scmc"] = $.trim($('#scmc').val());
			/*data["xqbm"] = $.trim($('#xqbm').val());*/
			data["bjbh"] = $.trim($('#bjbh').val());
			data["sqsjs"] = $.trim($('#sqsjs').val());
			data["sqsjz"] = $.trim($('#sqsjz').val());
			data["status"] = $.trim($('#status').val());
			table.ajax.reload();
		}
	}
	// 重置
	function conditionReset() {
		// resetSearchConditions('#bjbh,#scmc,#xqbm,#status,#sqsjs,#sqsjz');
		resetSearchConditions('#bjbh,#scmc,#status,#sqsjs,#sqsjz');
		resetDate(start,end);
	}

	function toView(id) {
		var url = CONTEXT_PATH + '/gov/creditCheck/toView.action?id=' + id;
        $("div#creditCheckDetail").html("");
        $("div#creditCheckDetail").load(url);
        $("div#creditCheckDetail").prependTo("#topBox");
        $("div#creditCheckList").hide();
        $("div#creditCheckDetail").show();
        resetIEPlaceholder();
	}

	return {
		"conditionSearch" : conditionSearch,
		"toView" : toView,
		"conditionReset" : conditionReset
	};

})();