var holPPrint = (function() {

	var start = {
		elem : '#beginDate',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		istime : false,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#beginDate', datas);
			end.min = datas; // 开始日选好后，重置结束日的最小日期
			end.start = datas // 将结束日的初始值设定为开始日
		}
	};
	var end = {
		elem : '#endDate',
		format : 'YYYY-MM-DD',
		max : '2099-12-30',
		istime : false,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#endDate', datas);
			start.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(start);
	laydate(end);

	// 创建一个Datatable
	var table = $('#dataTable').DataTable({
		ajax : {
			url : ctx + "/hallPReport/getReportList.action",
			type : "post",
			data : {
				status : '',
				skipType : '2'
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		columns : [ {
			"data" : "bjbh",
			"render" : function(data, type, full) {
				var opts = '<a href="javascript:;" onclick="holPPrint.toReport(\'' + full.id + '\', this)">' + data + '</a>';
				return opts;
			}
		}, {
			"data" : "xybgbh",
			"render" : function(data, type, full) {
				var opts = '<a href="javascript:;" onclick="holPPrint.toReportViewPrint(\'' + data + '\', \'' + full.id + '\', this)">' + data + '</a>';
				return opts;
			}
		}, {
			"data" : "cxrxm"
		}, {
			"data" : "cxrsfzh"
		}, {
			"data" : "createDate"
		}, {
			"data" : "sqr",
			"visible" : false
		}, {
			"data" : "status",
			"visible" : false,
			"render" : function(data, type, full) {
				var status = "";
				if (data == 1) {
					status = "已通过";
				}
				return status;
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

	$('#dataTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	function refreshTable(bjbh, cxrxm, cxrsfzh, xybgbh, beginDate, endDate) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["bjbh"] = bjbh;
			data["cxrxm"] = cxrxm;
			data["cxrsfzh"] = cxrsfzh;
			data["xybgbh"] = xybgbh;
			data["beginDate"] = beginDate;
			data["endDate"] = endDate;
			table.ajax.reload();
		}
	}

	// 信用报告申请单查看页面
	function toReport(id, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/hallPReport/toReport.action?type=1&id=" + id;
		$("div#mainListDiv").hide();
		$("div#applyDetailDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
	}
	// 生成的报告打印页面
	function toReportViewPrint(bgbh, id, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var temp = bgbh.substr(0, 5);
		if (temp == 'XYBGP') {// 表示新版的pdf格式信用报告
			// 报告生成成功，新窗口直接打开生成过的报告页面
			if (isAcrobatPluginInstall()) {
				var url = ctx + '/reportQuery/viewReport.action?xybgbh=' + bgbh;
				var newwin = window.open(url);
				newwin.focus();
				// 添加信用报告预览日志
				addPreViewLog(id);
			} else {
				$.alert("未安装Adobe Reader，无法预览！");
			}
		} else {// 表示旧版的html格式信用报告
			var url = ctx + '/static_html/' + bgbh + ".html";
			var newwin = window.open(url);
			newwin.focus();
			// 添加信用报告预览日志
			addPreViewLog(id);
		}
	}

	// 打印市信用报告
	$('.printCityBtn').on('click', function() {
		var selectedRows = table.rows('.active').data();
		if (selectedRows.length > 0) {
			var row = selectedRows[0];
			toReportViewPrint(row.xybgbh);
		} else {
			$.alert('请选择要操作的记录！');
		}
	});
	// 打印反馈单
	$('.printFeedbackBtn').on('click', function() {
		var selectedRows = table.rows('.active').data();
		if (selectedRows.length > 0) {
			var row = selectedRows[0];
			var url = ctx + "/hallPReport/printReportApply.action?id=" + row.id;
			var newwin = window.open(url, "信用报告申请反馈单");
			newwin.focus();
		} else {
			$.alert('请选择要操作的记录！');
		}
	});

	function conditionSearch() {
		var bjbh = $.trim($("#bjbh").val());
		var cxrxm = $.trim($("#cxrxm").val());
		var cxrsfzh = $.trim($("#cxrsfzh").val());
		var xybgbh = $.trim($("#xybgbh").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());

		refreshTable(bjbh, cxrxm, cxrsfzh, xybgbh, beginDate, endDate);
	}

	function conditionReset() {
		resetSearchConditions('#bjbh,#cxrxm,#cxrsfzh,#beginDate,#endDate,#xybgbh');
		resetDate(start, end);
	}

	return {
		toReport : toReport,
		toReportViewPrint : toReportViewPrint,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset
	};

})();