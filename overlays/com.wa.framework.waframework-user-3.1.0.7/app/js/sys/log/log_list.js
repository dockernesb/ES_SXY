var logger = function() {
	
	var start = {
		elem : '#startDate',
		format : 'YYYY-MM-DD hh:mm:ss',
		max : '2099-12-30', // 最大日期
		istime : true,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : true, // 是否显示确认
		choose : function(datas) {
			laydatePH('#startDate', datas);
			end.min = datas; // 开始日选好后，重置结束日的最小日期
			end.start = datas // 将结束日的初始值设定为开始日
		}
	};
	var end = {
		elem : '#endDate',
		format : 'YYYY-MM-DD hh:mm:ss',
		max : '2099-12-30',
		istime : true,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : true, // 是否显示确认
		choose : function(datas) {
			laydatePH('#endDate', datas);
			start.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(start);
	laydate(end);
	
	
	var table = $('#logGrid').DataTable(// 创建一个Datatable
	{
		ajax : {
			url : CONTEXT_PATH + "/system/log/list.action",
			type : 'post',
			data : {
				logType : logType
			}
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		ordering : false,
		autoWidth : false,
		columns : [ {
			"data" : "username"
		}, {
			"data" : "ip"
		}, {
			"data" : "accessUrl"
		}, {
			"data" : "accessName"
		}, {
			"data" : "logDate"
		}]
	});

	$('#logGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 按条件查询
	function conditionSearch() {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["username"] = $.trim($('#conditionUsername').val());
			data["ip"] = $.trim($('#conditionIp').val());
			data["accessUrl"] = $.trim($('#conditionAccessUrl').val());
			data["accessName"] = $.trim($('#conditionAccessName').val());
			data["logType"] = logType;
			data["startDate"] = $.trim($('#startDate').val());
			data["endDate"] = $.trim($('#endDate').val());
			
			table.ajax.reload();
		}
	}
	// 重置查询条件
	function conditionReset() {
		resetSearchConditions('#conditionUsername,#conditionIp,#conditionAccessUrl,#conditionAccessName,#startDate,#endDate');
		resetDate(start,end);
	}

	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset
	}
}();