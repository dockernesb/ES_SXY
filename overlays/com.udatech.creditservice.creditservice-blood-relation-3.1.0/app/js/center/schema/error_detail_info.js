var errorDetailInfo = (function() {
	var deptId = $('#deptId').val();
	var versionId = $('#versionId').val();
	var start = {
			elem : '#error_startDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30', // 最大日期
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#error_startDate', datas);
				end.min = datas; // 开始日选好后，重置结束日的最小日期
				end.start = datas // 将结束日的初始值设定为开始日
			}
		};
		var end = {
			elem : '#error_endDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30',
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#error_endDate', datas);
				start.max = datas; // 结束日选好后，重置开始日的最大日期
			}
		};
	laydate(start);
	laydate(end);
		
	$("#errorDataStatus").select2({
		/*width:100,*/
		placeholder : '数据状态',

		language : 'zh-CN'
	});
	resizeSelect2('#errorDataStatus');
	$('#errorDataStatus').val(null).trigger("change");
	
	$("#error_tableCoulmnName").select2({
		placeholder : '查询字段',
		language : 'zh-CN'
	}).on("change",function(){
		changeCoumlnName();
	});
	
	resizeSelect2('#error_tableCoulmnName');
	$('#error_tableCoulmnName').val(null).trigger("change");
	
	$.getJSON(ctx + "/system/dictionary/listValues.action", {
		groupKey : 'reportWay'
	}, function(result) {
		var data = result.items;
		var op = "<option value=' '>全部方式</option></option>";
		for (var i = 0;i < data.length;i++) {
			op += "<option value='"+data[i].id+"'>"+data[i].text+"</option>";
		}
		
		$("#error_reportWay").html(op);
		// 初始下拉框
		$("#error_reportWay").select2({
			placeholder : '上报方式',
			language : 'zh-CN'
		});
		
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2('#error_reportWay');
		$('#error_reportWay').val(null).trigger("change");
	}, "json");

	$.getJSON(ctx + "/system/department/getDeptList.action?isIncludedAll=true", function(result) {
		// 初始下拉框
		$("#error_departmentDetail").select2({
			placeholder : '部门名称',
			language : 'zh-CN',
			data : result
		});

		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2($("#error_departmentDetail"));
		$('#error_departmentDetail').val(deptId).trigger("change");
	});
	
    $.getJSON(ctx + "/creditCommon/getErrorCode.action", function(result) {

        // 初始下拉框
        $("#errorReason").select2({
			data : result,
            placeholder : '错误原因',
            language : 'zh-CN'
        });

        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
        resizeSelect2('#errorReason');
        $('#errorReason').val(null).trigger("change");
    }, "json");

	var category = $('#choseTitle').val(); //	0:负责专题,1:参与专题,2:设置专题
	var choseTitle = $('#choseTitle').val(); // 选择的标签页

	var taskCode = $('#taskCode').val();//任务编号

	var nameList = $("input#nameList").val();
	var codeList = $("input#codeList").val();
	var typeList = $("input#typeList").val();
	var tableId = $("input#tableId").val();
	var reportName = $("input#reportName").val();
	var errorTaskCode = $("input#errorTaskCode").val();
	var rulesList = $("input#rulesList").val();
	var requiredGroupList = $("input#requiredGroupList").val();
	if (nameList) {
		nameList = eval(nameList);
	}
	if (codeList) {
		codeList = eval(codeList);
	}
	if (typeList) {
		typeList = eval(typeList);
	}
	if (rulesList) {
		rulesList = eval(rulesList);
	}

	if (requiredGroupList) {
		requiredGroupList = eval(requiredGroupList);
	}
	if (requiredGroupList == null || requiredGroupList.length == 0) {
		$("#warningMsgDiv").hide();
	}
	

	var columns = new Array();
	columns.push({
		"data" : "TASK_CODE" // 上报批次编号
	});
	columns.push({
		"data" : "DEPT_NAME" // 上报部门
	});
	
	columns.push({
		"data" : "ERROR_REASON" // 错误原因
	});

    columns.push({
        "data" : "REPORT_WAY", // 上报方式
        "render" : function(data, type, row) {
            var str = '';
            if (data == "0") {
                str = "手动录入";
            } else if (data == "1") {
                str = "文件上传";
            } else if (data == "2") {
                str = "数据库上报";
            } else if (data == "3") {
                str = "FTP上报";
            } else if(data == "4"){
                str = "接口上报";
            } else {
                str = "未知";
            }

            return str;
        }
    });

	columns.push({
		"data" : "OPERATE_STATUS", // 状态
		"render" : function(data, type, row) {
			if (data == 0) {
				return '未处理';
			} else if (data == 1) {
				return '已处理';
			} else if (data == 2) {
				return '已忽略';
			} else if (data == 3) {
				return '已删除';
			} else if (data == 4) {
                return '已修改';
			} else {
				return '';
			}
		}
	});
	columns.push({
		"data" : "OPERATE_TIME" // 更新时间
	});

    for (var i = 0; i < codeList.length; i++) {
        columns.push({
            "data" : codeList[i]
        });
    };

	// 创建一个Datatable
	var errorDataTable = $('#errorDataTable').DataTable({
		ajax : {
			url: CONTEXT_PATH + '/dp/historyDataReport/showUploadError.action',
			type : "post",
			data : {
				taskCode : taskCode,//任务编号
				tableId : tableId,
				queryType : "1",
                deptId: deptId,
                versionId: versionId
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		columns : columns,
		initComplete : function(settings, data) {
			var columnTogglerContent = $('#columnTogglerContent').clone();
			$(columnTogglerContent).removeClass('hide');
			var columnTogglerDiv = $('#errorDataTable').parent().parent().find('.columnToggler');
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
				var column = errorDataTable.column($(this).attr('data-column'));
				// Toggle the visibility
				column.visible(!column.visible());
			});
		},
		drawCallback : function(settings) {
			$('#errorDataTable .checkall').iCheck('uncheck');
			$('#errorDataTable .checkall, #errorDataTable tbody .icheck').iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});

			// 列表复选框选中取消事件
			var checkAll = $('#errorDataTable .checkall');
			var checkboxes = $('#errorDataTable tbody .icheck');
			checkAll.on('ifChecked ifUnchecked', function(event) {
				if (event.type == 'ifChecked') {
					checkboxes.iCheck('check');
					$('#errorDataTable tbody tr').addClass('active');
				} else {
					checkboxes.iCheck('uncheck');
					$('#errorDataTable tbody tr').removeClass('active');
				}
			});
			checkboxes.on('ifChanged', function(event) {
				if (checkboxes.filter(':checked').length == checkboxes.length) {
					checkAll.prop('checked', 'checked');
				} else {
					checkAll.removeProp('checked');
				}
				checkAll.iCheck('update');

				if ($(this).is(':checked')) {
					$(this).closest('tr').addClass('active');
				} else {
					$(this).closest('tr').removeClass('active');
				}
			});

			// 添加行选中点击事件
			$('#errorDataTable tbody tr').on('click', function() {
				$(this).toggleClass('active');
				if ($(this).hasClass('active')) {
					$(this).find('.icheck').iCheck('check');
				} else {
					$(this).find('.icheck').iCheck('uncheck');
				}
			});
		}
	});

	// 返回
	function goBack(){
		var selectArr = recordSelectNullEle();
		$("div#childBox").hide();
		$("div#parentBox").show();
		$("div#parentBox").prependTo("#topBox");
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	}

	function clearData() {
		$('#error_tableCoulmnNameValue').val("");//查询字段内容
		$('#error_tableCoulmnNameValue').prop("disabled", "disabled");
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resetIEPlaceholder();

        $('#errorDataStatus').val(null).trigger("change");

		resetSearchConditions('#error_startDate,#error_departmentDetail,#error_endDate,#error_reportWay, #error_reportBatch, #error_tableCoulmnName, #errorReason');
		resetDate(start,end);
	}

	function queryData() {

		var tableCoulmnName = $.trim($('#error_tableCoulmnName').val());//查询字段名
		if (tableCoulmnName != null && tableCoulmnName != "") {

			var tableCoulmnValue = $('#error_tableCoulmnNameValue').val();//查询字段内容
			if (tableCoulmnValue == null || tableCoulmnValue == "") {
				$.alert('请添加查询字段内容!', 1);
				return;
			}
		}

		var data = errorDataTable.settings()[0].ajax.data;

		if (!data) {
			data = {};
			errorDataTable.settings()[0].ajax["data"] = data;
		}
		data["taskCode"] = $('#error_reportBatch').val();//上报批次编号查询
		data["tableCoulmnName"] = $('#error_tableCoulmnName').val();//查询字段
		data["tableCoulmnNameValue"] = $('#error_tableCoulmnNameValue').val();//查询内容
		data["startDate"] = $('#error_startDate').val();//更新开始时间始
		data["endDate"] = $('#error_endDate').val();//更新开始时间止


		data["deptId"] = $('#error_departmentDetail').val();//上报部门
		data["reportWay"] = $('#error_reportWay').val();//上报方式
		data["errorDataStatus"] = $.trim($("#errorDataStatus").val());//数据状态
        data["errorReason"] = $.trim($('#errorReason').val());//错误原因

		data["queryType"] = 1;//目录查询
		
		
		errorDataTable.ajax.reload();
	}

	//查询字段
	function changeCoumlnName() {

		var tableCoulmnName = $.trim($('#error_tableCoulmnName').val());
		if (tableCoulmnName == null || tableCoulmnName == "") {
			$('#error_tableCoulmnNameValue').val("");
			$('#error_tableCoulmnNameValue').prop("disabled", "disabled");
			resetIEPlaceholder();
		} else {
			$('#error_tableCoulmnNameValue').removeAttr("disabled");
		}
	}

	return {
		"goBack" : goBack,
		"clearData" : clearData,
		"queryData" : queryData
	}
})();