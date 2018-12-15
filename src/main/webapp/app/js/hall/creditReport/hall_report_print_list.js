var holPrint = (function() {

    var bmlx = $("#bmlx").val();

    $("#isHasReport").select2({
        placeholder : '是否有省报告',
        minimumResultsForSearch : -1
    });
    $('#isHasReport').val(null).trigger("change");
    resizeSelect2('#isHasReport');

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
			url : ctx + "/hallReport/getReportList.action",
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
				var opts = '<a href="javascript:;" onclick="holPrint.toReport(\'' + full.id + '\', this)">' + data + '</a>';
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
				var opts = '<a href="javascript:;" onclick="holPrint.toReportViewPrint(\'' + data + '\', \'' + full.id + '\', this, \'' + full.qymc + '\')">' + data + '</a>';
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
        }, {
            "data" : "isHasReport",
            "render" : function(data, type, full) {
                var str = "无";
                if (data == 1) {
                    str = "有";
                }
                return str;
            }
        }, {
            "data" : "isIssue", 
            "render" : function(data, type, full) {
				var status = "";
				if (data == 0) {
					status = "待下发";
				} else if (data == 1) {
					status = "待打印";//待打印其实就是已下发
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

	function refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, xybgbh, beginDate, endDate, isHasReport, deptId) {
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
            data["isHasReport"] = isHasReport;
            data["bjbm"] = deptId;
			table.ajax.reload();
		}
	}

	// 信用报告申请单查看页面
	function toReport(id, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/hallReport/toReport.action?type=1&id=" + id;
		$("div#mainListDiv").hide();
		$("div#applyDetailDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
	}
	// 生成的报告打印页面
	function toReportViewPrint(bgbh, id, _this, jgqc) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
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

    // 打印市信用报告
    $('.printCityBtn').on('click', function() {
        var selectedRows = table.rows('.active').data();
        if (selectedRows.length > 0) {
            var row = selectedRows[0];
            toReportViewPrint(row.xybgbh, row.id, null, row.qymc);
        } else {
            $.alert('请选择要操作的记录！');
        }
    });
    // 打印省信用报告
    $('.printProvinceBtn').on('click', function() {
        var selectedRows = table.rows('.active').data();
        if (selectedRows.length > 0) {
            var row = selectedRows[0];
            $.post(ctx + "/hallReport/printProvinceReport.action", {
                "id" : row.id
            }, function(data) {
                if (data.result) {
                    viewPdf(data.message);
                } else {
                    $.alert(data.message, 2);
                }
            }, "json");
        } else {
            $.alert('请选择要操作的记录！');
        }
    });
	// 打印反馈单
	$('.printFeedbackBtn').on('click', function() {
		var selectedRows = table.rows('.active').data();
		if (selectedRows.length > 0) {
			var row = selectedRows[0];
			var url = ctx + "/hallReport/printReportApply.action?id=" + row.id;
			var newwin = window.open(url, "信用报告申请反馈单");
			newwin.focus();
		} else {
			$.alert('请选择要操作的记录！');
		}
	});
	
	// 已办结
	$('.finishTask').on('click',function(){
		var selectedRows = table.rows('.active').data();
		if(selectedRows.length >0){
			var row = selectedRows[0];
			var url = ctx + "/hallReport/finishPrintTask.action?id=" + row.id;
			layer.confirm('确定要完结此操作列吗？',{
				icon : 3
			},function(index){
				loading();
				$.post( url,function(data){
					loadClose();
					if (!data.result) {
						$.alert('操作失败!', 2);
					} else {
						layer.close(index);
						$.alert('操作成功!', 1);
						conditionSearch();
					}
				},"json");
			});
		}else {
			$.alert('请选择要完结的操作列！');
		}
	});

	function conditionSearch() {
		var bjbh = $.trim($("#bjbh").val());
		var jgqc = $.trim($("#jgqc").val());
		var gszch = $.trim($("#gszch").val());
		var zzjgdm = $.trim($("#zzjgdm").val());
		var tyshxydm = $.trim($("#tyshxydm").val());
		var xybgbh = $.trim($("#xybgbh").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());
        var isHasReport = $("#isHasReport").val();
        var deptId = $.trim($("#deptId").val());

		refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, xybgbh, beginDate, endDate, isHasReport, deptId);
	}

	function conditionReset() {
		resetSearchConditions('#bjbh,#jgqc,#gszch,#zzjgdm,#tyshxydm,#beginDate,#endDate,#xybgbh,#isHasReport,#deptId');
		resetDate(start, end);
	}

	return {
		toReport : toReport,
		toReportViewPrint : toReportViewPrint,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset
	};

})();