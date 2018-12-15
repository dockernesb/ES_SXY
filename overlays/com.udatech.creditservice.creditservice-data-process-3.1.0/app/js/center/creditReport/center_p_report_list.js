var centerPReport = (function() {
	// 信用报告申请是否审核开关：0不需要审核，1需要审核
	var audit = $('#audit').val();
	var initStatus = '';
	var initVisible = false;
	if (audit == '1') {
		$("#status").select2({
			placeholder : '全部状态',
			minimumResultsForSearch : -1
		});
		$('#status').val('0').trigger("change");
		resizeSelect2('#status');
		initStatus = '0';
		initVisible = true;
	}

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
			url : ctx + "/creditPReport/getReportList.action",
			type : "post",
			data : {
				status : initStatus,
				skipType : '1'
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
				var opts = '<a href="javascript:;" onclick="centerPReport.toReportApplyView(\'' + full.id + '\', this)">' + data + '</a>';
				return opts;
			}
		}, {
			"data" : "xybgbh",
			"render" : function(data, type, full) {
				var opts = '<a href="javascript:;" onclick="centerPReport.toReportViewPrint(\'' + data + '\', \'' + full.id + '\', this)">' + data + '</a>';
				return opts;
			}
		}, {
			"data" : "cxrxm"
		}, {
			"data" : "cxrsfzh"
		}, {
			"data" : "createDate"
		}, {
			"data" : "sqr"
		}, {
			"data" : "status",
			"visible" : initVisible,
			"render" : function(data, type, full) {
				var status = "待审核";
				if (data == 1) {
					status = "已通过";
				} else if (data == 2) {
					status = "未通过";
				}
				return status;
			}
		}, {
			"data" : "id",
			"render" : function(data, type, full) {
				var opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="centerPReport.toReportApplyView(\'' + data + '\', this)">查看</a>';
				if (full.status == "0") {
					opts += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="centerPReport.toReportAudit(\'' + data + '\', this)">审核</a>';
				}
				// else if (full.status == "1" && isNull(full.xybgbh)) {//
				// 已通过且未生成信用报告时，显示生成报告按钮
				// opts += '<a href="javascript:;" class="opbtn btn btn-xs
				// green-meadow" onclick="centerPReport.toReportView(\'' +
				// full.id + '\')">生成报告</a>';
				// }
				return opts;
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

	// 审核页面
	function toReportAudit(id, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/creditPReport/toReportApplyAudit.action?id=" + id;
		$("#mainListDiv,#applyDetailDiv,#auditTwoDiv").hide();
		$("div#auditOneDiv,#applyDetailDiv,#auditTwoDiv").html("");
		$("div#auditOneDiv").show();
		$("div#auditOneDiv").load(url);
		$("div#auditOneDiv").prependTo('#topDiv');
	}
	// 查看报告申请单页面
	function toReportApplyView(id, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/creditPReport/toReportApplyView.action?id=" + id;
		$("#mainListDiv,#auditOneDiv,#auditTwoDiv").hide();
		$("div#applyDetailDiv,#auditOneDiv,#auditTwoDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
	}
	// 生成报告页面
	function toReportView(id) {
		var url = ctx + "/reportQuery/toPReportView.action?id=" + id;
		AccordionMenu.openUrl(null, url);
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

	function conditionSearch() {
		var bjbh = $.trim($("#bjbh").val());
		var cxrxm = $.trim($("#cxrxm").val());
		var cxrsfzh = $.trim($("#cxrsfzh").val());
		var xybgbh = $.trim($("#xybgbh").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());
		var status = '';
		if (audit == '1') {// 需要审核时，传递页面上的选择值
			status = $("#status").val();
		}

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
			data["status"] = status;
			table.ajax.reload();
		}
	}

	function conditionReset() {
		resetSearchConditions('#bjbh,#cxrxm,#cxrsfzh,#beginDate,#endDate,#xybgbh,#status');
		resetDate(start, end);
	}

	return {
		toReportAudit : toReportAudit,
		toReportApplyView : toReportApplyView,
		toReportView : toReportView,
		toReportViewPrint : toReportViewPrint,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		table : table
	};

})();