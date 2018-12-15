var centerReport = (function() {

    var bmlx = $("#bmlx").val();

	/*$("#isIssue").select2({
		placeholder : '报告下发',
		minimumResultsForSearch : -1
	});
	$('#isIssue').val('0').trigger("change");
	resizeSelect2('#isIssue');*/

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

    $.getJSON(ctx + "/system/department/getDeptList.action?userType=2", function(result) {
        // 初始下拉框
        $("#deptId").select2({
            placeholder : '办件部门',
            language : 'zh-CN',
            data : result
        });

        resizeSelect2($("#deptId"));
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });

	// 创建一个Datatable
	var table = $('#dataTable').DataTable({
		ajax : {
			url : ctx + "/creditReport/getReportList.action",
			type : "post",
			data : {				
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
				var opts = '<a href="javascript:;" onclick="centerReport.toReportApplyView(\'' + full.id + '\', this)">' + data + '</a>';
				return opts;
			}
        }, {
            "data" : "createUser",
            "render" : function(data, type, full) {
                if (data && data.sysDepartment) {
                    return data.sysDepartment.departmentName || "";
                }
                return "";
            }
        }, {
			"data" : "xybgbh",
			"render" : function(data, type, full) {
				var opts = '<a href="javascript:;" onclick="centerReport.toReportViewPrint(\'' + data + '\', \'' + full.id + '\', this, \'' + full.qymc + '\')">' + data + '</a>';
				return opts;
			}
		}, {
			"data" : "qymc"
		}, {
			"data" : "gszch",
			"visible" : false
		}, {
			"data" : "zzjgdm",
			"visible" : false
		}, {
			"data" : "tyshxydm",
			"visible" : false
		}, {
			"data" : "createDate"
		}, {
			"data" : "sqr",
			"visible" : false
		},/* {
			"data" : "status",
			"visible" : false,
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
			"data" : "isHasReport",
			"render" : function(data, type, full) {
				var str = "无";
				if (data == 1) {
					str = "有";
				}
				return str;
			}
		},*/ {
			"data" : "isIssue",
			"render" : function(data, type, full) {
				var status = "";
				if (data == 0) {
					status = "待下发";
				} else if (data == 1) {
					status = "已下发";
				}
				return status;
			}
		},/* {
			"data" : "issueDate"
		}, */{
			"data" : "id",
			"render" : function(data, type, full) {
				var opts = '';
				if (full.isIssue == "0") {
					opts += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="centerReport.toReportIssue(\'' + data + '\', this)">下发</a>';
				} else if (full.isIssue == "1") {
					opts += '已下发';
				}
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

	function refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, xybgbh, beginDate, endDate, isIssue, deptId) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["bjbh"] = bjbh;
			data["jgqc"] = jgqc;
			data["gszch"] = gszch;
			data["zzjgdm"] = zzjgdm;
			data["tyshxydm"] = tyshxydm;
			data["xybgbh"] = xybgbh;
			data["beginDate"] = beginDate;
			data["endDate"] = endDate;
			data["isIssue"] = isIssue;
            data["bjbm"] = deptId;
			table.ajax.reload();
		}
	}

	// 下发页面
	function toReportIssue(id, _this) {
        log("issue = " + id);
        // 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
        addDtSelectedStatus(_this);

        var url = ctx + "/creditReport/toReportIssue.action?id=" + id;
        $("#mainListDiv,#issueDiv").hide();
        $("div#applyDetailDiv,#issueDiv").html("");
        $("div#issueDiv").show();
        $("div#issueDiv").load(url);
        $("div#issueDiv").prependTo('#topDiv');
	}
	// 查看报告申请单页面
	function toReportApplyView(id, _this) {
	    log("view = " + id);
        // 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
        addDtSelectedStatus(_this);

        var url = ctx + "/creditReport/toReportApplyView.action?id=" + id + "&skipType=1";
        $("#mainListDiv,#issueDiv").hide();
        $("div#applyDetailDiv,#issueDiv").html("");
        $("div#applyDetailDiv").show();
        $("div#applyDetailDiv").load(url);
        $("div#applyDetailDiv").prependTo('#topDiv');
	}
	// 生产报告页面
	function toReportView(id) {
		var url = ctx + "/reportQuery/toReportView.action?id=" + id;
		AccordionMenu.openUrl(null, url);
	}
	// 生成的报告打印页面
	function toReportViewPrint(bgbh, id, _this, jgqc) {
		var temp = bgbh.substr(0, 5);
		if (temp == 'XYBGP') {// 表示新版的pdf格式信用报告
			// 报告生成成功，新窗口直接打开生成过的报告页面
			if (isAcrobatPluginInstall()) {
				var url = ctx + '/reportQuery/viewReport.action?xybgbh=' + bgbh + "&jgqc=" + jgqc;
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
		var jgqc = $.trim($("#jgqc").val());
		var gszch = $.trim($("#gszch").val());
		var zzjgdm = $.trim($("#zzjgdm").val());
		var tyshxydm = $.trim($("#tyshxydm").val());
		var xybgbh = $.trim($("#xybgbh").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());
		var isIssue = $("#isIssue").val();
        var deptId = $.trim($("#deptId").val());

		refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, xybgbh, beginDate, endDate, isIssue, deptId);
	}

	function conditionReset() {
		resetSearchConditions('#bjbh,#jgqc,#gszch,#zzjgdm,#tyshxydm,#beginDate,#endDate,#xybgbh,#isIssue,#deptId');
		resetDate(start, end);
	}

	return {
		toReportIssue : toReportIssue,
		toReportApplyView : toReportApplyView,
		toReportView : toReportView,
		toReportViewPrint : toReportViewPrint,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
        table : table
	};

})();