// 审查列表JS
var cCreditCheckList = (function() {

	var type = $("#type").val();
    var bmlx = $("#bmlx").val();

	$.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
		// 初始下拉框
		$("#xqbm").select2({
			placeholder : '审查部门',
			allowClear : false,
			language : 'zh-CN',
			data : result
		});
		$("#examineList_status").select2({
			placeholder : '全部状态',
			minimumResultsForSearch: -1,
			language : 'zh-CN'
		});
		$('#xqbm').val(null).trigger("change");
		resizeSelect2($("#xqbm"));
		resizeSelect2($("#examineList_status"));
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		
	});

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

	var start = {
		elem : '#sqsjs',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		min : '1900-01-01', // 最小日期
		istime : false,
		istoday : false,// 是否显示今天
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
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#sqsjz', datas);
			start.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(start);
	laydate(end);

	var table = $('#applyListGrid').DataTable(// 创建一个Datatable
	{
		ajax : {
			url : CONTEXT_PATH + "/center/creditCheck/queryApplyList.action?type=" + type,
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
				var str = '<a href="javascript:;" onclick="cCreditCheckList.toView(\'' + row.id + '\')">'+ row.bjbh +'</a>';
				return str;
			}
        }, {
            "data" : "createUser",
            "render" : function(data, type, full) {
                if (data && data.sysDepartment) {
                    if (data.sysDepartment.code.substring(0, 1) == "B") {
                        return data.sysDepartment.departmentName || "";
                    } else {
                        return "苏州市公共信用信息中心";
                    }
                }
                return "";
            }
        }, {
			"data" : "scmc"
		}, {
			"data" : "scxqbm.departmentName"
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
			"data" : "status", // 操作
			render : function(data, type, row) {
				var str = '';
				if (row.status == "0") {
					str = '<a href="javascript:;" onclick="cCreditCheckList.toExamine(\'' + row.id + '\')">审核</a>';
				} else {
					str = '<a href="javascript:;" onclick="cCreditCheckList.toView(\'' + row.id + '\')">查看</a>';
				}
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
			data["xqbm"] = $.trim($('#xqbm').val());
			data["bjbh"] = $.trim($('#bjbh').val());
			data["sqsjs"] = $.trim($('#sqsjs').val());
			data["sqsjz"] = $.trim($('#sqsjz').val());
			data["status"] = $.trim($('#examineList_status').val());
            data["bjbm"] = $.trim($("#deptId").val());
			table.ajax.reload();
		}
	}
	// 重置
	function conditionReset() {
		resetSearchConditions('#bjbh,#scmc,#xqbm,#examineList_status,#sqsjs,#sqsjz,#deptId');
		resetDate(start,end);
	}

	function toView(id) {
		var url = CONTEXT_PATH + '/center/creditCheck/toView.action?id=' + id;
        $("div#cCreditCheckExamineDetail").html("");
        $("div#cCreditCheckExamineDetail").load(url);
        $("div#cCreditCheckExamineDetail").prependTo("#topBox");
        $("div#cCreditCheckExamineDetail").show();
        $("div#cCreditCheckExamineList").hide();
        resetIEPlaceholder();
	}

	function toExamine(id) {
		var url = CONTEXT_PATH + '/center/creditCheck/toExamine.action?id=' + id;
        $("div#cCreditCheckExamineDetail").html("");
        $("div#cCreditCheckExamineDetail").load(url);
        $("div#cCreditCheckExamineDetail").prependTo("#topBox");
        $("div#cCreditCheckExamineDetail").show();
        $("div#cCreditCheckExamineList").hide();
        resetIEPlaceholder();
	}
	
	return {
		"conditionSearch" : conditionSearch,
		"toView" : toView,
		"toExamine" : toExamine,
		"conditionReset" : conditionReset,
		"table" : table
	};

})();