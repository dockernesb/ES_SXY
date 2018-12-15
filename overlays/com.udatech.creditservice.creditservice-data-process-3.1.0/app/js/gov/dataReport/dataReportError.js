var dataReport = (function() {
	var start = {
			elem : '#startDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30', // 最大日期
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#startDate', datas);
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
		
	$("#errorDataStatus").select2({
		//width:100,
		placeholder : '数据状态',

		language : 'zh-CN'
	});
	resizeSelect2('#errorDataStatus');
	$('#errorDataStatus').val('0').trigger("change");
	
	$("#tableCoulmnName").select2({
		placeholder : '查询字段',
		language : 'zh-CN'
	}).on("change",function(){
		changeCoumlnName();
	});
	
	resizeSelect2('#tableCoulmnName');
	$('#tableCoulmnName').val(null).trigger("change");
	
	$.getJSON(ctx + "/system/dictionary/listValues.action", {
		groupKey : 'reportWay'
	}, function(result) {
		var data = result.items;
		var op = "<option value=' '>全部方式</option></option>";
		for (var i = 0;i < data.length;i++) {
			op += "<option value='"+data[i].id+"'>"+data[i].text+"</option>";
		}
		
		$("#reportWay").html(op);
		// 初始下拉框
		$("#reportWay").select2({
			placeholder : '上报方式',
			language : 'zh-CN'
		});
		
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2('#reportWay');
		$('#reportWay').val(null).trigger("change");
	}, "json");

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

	var taskCode = $('#taskCode').val();//任务编号

	// var nameList = $("input#nameList").val();
	var codeList = $("input#codeList").val();
	// var typeList = $("input#typeList").val();
	var tableId = $("input#tableId").val();
	// var reportName = $("input#reportName").val();
	var errorTaskCode = $("input#errorTaskCode").val();
	var rulesList = $("input#rulesList").val();
	var requiredGroupList = $("input#requiredGroupList").val();
	// if (nameList) {
	// 	nameList = eval(nameList);
	// }
	if (codeList) {
		codeList = eval(codeList);
	}
	// if (typeList) {
	// 	typeList = eval(typeList);
	// }
	if (rulesList) {
		rulesList = eval(rulesList);
	}

	if (requiredGroupList) {
		requiredGroupList = eval(requiredGroupList);
	}
	if (requiredGroupList == null || requiredGroupList.length == 0) {
		$("#warningMsgDiv").hide();
	}
	
	if (errorTaskCode == 'true') {
		$.alert("上报批次编号信息错误！", 2, function() {
			goBack();
		});
	} else {

		var columns = new Array();
		columns.push({
			"data" : null // 复选框
		});
		
		columns.push({
			"data" : "TASK_CODE" // 上报批次编号
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
			"data" : "OPERATE_STATUS", // 数据状态
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
				url : ctx + "/dp/dataReport/showUploadError.action",
				type : "post",
				data : {
					tableId : tableId,
					queryType : $("#queryType").val(),
                    taskCode : $("#reportBatch").val(), // 上报批次编号
					errorDataStatus : $('#errorDataStatus').val(),//数据状态
					tableCoulmnName : $('#tableCoulmnName').val(),
					tableCoulmnNameValue : $('#tableCoulmnNameValue').val()
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
			columnDefs : [ {
				targets : 0, // checkBox
				render : function(data, type, full) {
					return '<input type="checkbox" name="checkThis" class="icheck">';
				}
			} ],
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

		showUploadErrorNum(taskCode);
	}

	var editValidator = $('#editDataForm').validateForm();

	// 初始化校验规则
	if (rulesList instanceof Array) {
		for (var i = 0; i < rulesList.length; i++) {
			var rulesMap = rulesList[i];
			for ( var code in rulesMap) {
				// 生成验证规则
				var rulesArr = rulesMap[code];
				if (rulesArr) {
					rulesArr = eval(rulesArr);
				}
				var validType = [];
				if (rulesArr instanceof Array) {
					for (var k = 0; k < rulesArr.length; k++) {
						var tips = rulesArr[k].MSG;
						var patten = rulesArr[k].PATTERN;
						var ruleName = code;
						extendRule(ruleName, patten, tips);
						editValidator.form();
						addRules(ruleName);
					}
				}
			}
		}
	}

	//	扩展校验规则
	function extendRule(name, pattern, tips) {
		jQuery.validator.addMethod(name, function(value, element) {
			return this.optional(element) || (new RegExp(pattern).test(value));
		}, tips);
	}

	function addRules(name) {
		var rules = {};
		rules[name] = true;
		$("#" + name).rules("add", rules);
	}

	// 返回
	function goBack() {
		$("div#childBox").hide();
		$("div#parentBox").show();
		var selectArr = recordSelectNullEle();
		$("div#parentBox").prependTo("#topBox");
		callbackSelectNull(selectArr);
		var activeIndex = recordDtActiveIndex(govTask.table);
		govTask.table.ajax.reload(function(){
        	callbackDtRowActive(govTask.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
		resetIEPlaceholder();
	}

	function showUploadErrorNum(taskCodeStr) {

		$.post(ctx + "/dp/dataReport/getUploadErrorDataNum.action", {
			taskCode : taskCodeStr
		}, function(data) {
			var totalNum = 0;
			var notOpNum = 0;
			if (data["rt"]) {
				var totalNum = data["totalNum"];
				var notOpNum = data["noOpNum"];
			}
			$('#totalUploadNum').text(totalNum);
			$('#totalUploadErrorNum').text(notOpNum);
		}, "json");

	}

	// 修改上传错误信息
	function onEditUploadError() {

		var rows = new Array();
		var selectedRows = errorDataTable.rows('.active').data();
		$.each(selectedRows, function(i, selectedRowData) {
			rows.push(selectedRowData);
		});

		// check
		if (isNull(rows) || rows.length == 0) {
			$.alert('请勾选要操作的记录');
			return;
		}

		if (rows.length > 1) {
			$.alert('一次只能修改一条记录');
			return;
		}

        var editId = "";// 修改的记录id
		var dataStatus;//状态
		var rowData;
		$.each(rows, function(i, row) {
            editId = row.DATA_ID + "|" + row.DATA_SOURSE;
			dataStatus = row.OPERATE_STATUS;
            rowData = row;
		});

        if (dataStatus == 1) {
            $.alert('已处理记录无法修改');
            return;
        }

		var taskCode = "";// 批次编号
		$.each(rows, function(i, row) {
			taskCode = row.TASK_CODE;
		});
		
		var reportWay = "";// 报送方式
		$.each(rows, function(i, row) {
			reportWay = row.REPORT_WAY;
		});

		var targetUrl = "/dp/dataReport/getEditData.action";
		loading();
		$.post(CONTEXT_PATH + targetUrl, {
			editId : editId,
			tableId : tableId
        }, function(data) {
			var data = eval(data);
			loadClose();
			if (data == null) {
				$.alert('操作记录存在异常');
				return;
			}
			for (var i = 0; i < codeList.length; i++) {
				var colName = codeList[i];
				$('#' + codeList[i]).val(data[colName]);
			}
			$.openWin({
				title : '修改',
				content : $("#winEdit"),
				btnAlign : 'c',
				area : [ '600px', '650px' ],
				yes : function(index, layero) {
					editDataError(index, rowData.ID, rowData.DATA_ID, taskCode, rowData.DATA_SOURSE);
				}
			});

			editValidator.form();
		}, "json");
	}

	// 上传错误信息，修改状态（true :删除  false: 忽略）
	function onChgStatusUploadError(delOrIgnore) {

		var rows = new Array();
		var selectedRows = errorDataTable.rows('.active').data();
		$.each(selectedRows, function(i, selectedRowData) {
			rows.push(selectedRowData);
		});

		// check
		if (isNull(rows) || rows.length == 0) {
			$.alert('请勾选要操作的记录');
			return;
		}

		var dataArray = new Array();
		var allRowFinish = true;//选择的所有记录都是已处理
		$.each(rows, function(i, row) {
			if (row.OPERATE_STATUS == 0) {
				//只能处理状态是“未处理”的记录
				dataArray.push(row.ID);

				allRowFinish = false;
			}

		});

		var taskCode = "";// 批次编号
		$.each(rows, function(i, row) {
			taskCode = row.TASK_CODE;
		});
		
		if (allRowFinish) {//已处理不能修改
			$.alert('只能操作未处理的记录');
			return;
		}
		loading();
		layer.confirm('您确认忽略选中的错误记录吗？', {
			icon : 3
		}, function(idx) {
			loading();
			var dataArray = new Array();
			$.each(rows, function(i, row) {
				dataArray.push(row.ID + '|' + row.DATA_SOURSE + '|' + row.DATA_ID);
			});

			$.post(CONTEXT_PATH + "/dp/dataReport/chgErrorDataStatus.action", {
				taskCode : taskCode,
				dataIds : JSON.stringify(dataArray),
				delOrIgnore : delOrIgnore
				}, function(data) {
				var data = eval(data);
				loadClose();
				if (!data.result) {
					if (!isNull(data.message)) {
						$.alert(data.message, 2);
					} else {
						$.alert('操作失败！', 2);
					}
				} else {
					$.alert('操作成功！', 1);

					layer.close(idx);
					setTimeout(function(){errorDataTable.ajax.reload(null, false);},1000)
				}
			}, "json");
		}, function() {
			loadClose();
		});

	}

	// 修改数据
	function editDataError(index, editId, dataId, taskCode, editDataFrom) {
		if (!editValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}

		var url = CONTEXT_PATH + "/dp/dataReport/editError.action";

		$('#editId').val(editId);// _E错误表的主键id
		$('#dataId').val(dataId);// 正常表的数据主键id
		var editDataForm = $("#editDataForm").serialize();
        editDataForm += '&taskCode=' + taskCode + '&editDataFrom=' + editDataFrom;
		loading();
		$.post(url, editDataForm, function(data) {
			loadClose();
			if (!data.result) {
				if (!isNull(data.message)) {
					$.alert(data.message, 2);
				} else {
					$.alert('修改数据失败!', 2);
				}
			} else {
				$.alert('修改数据成功!', 1);
				layer.close(index);
				setTimeout(function(){errorDataTable.ajax.reload(null, false);},1000)
			}
		}, "json");
	}

	function clearData() {
		$('#tableCoulmnNameValue').val("");//查询字段内容
		$('#tableCoulmnNameValue').prop("disabled", "disabled");
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resetIEPlaceholder();

        $('#errorDataStatus').val('0').trigger("change");

		if ($("#queryType").val() != 1) {
			resetSearchConditions('#startDate,#endDate,#reportWay, #tableCoulmnName, #errorReason');
		} else {
			resetSearchConditions('#startDate,#endDate,#reportWay, #reportBatch, #tableCoulmnName, #errorReason');
		}
		
		resetDate(start,end);
	}

	function queryErrorData() {
		showUploadErrorNum(taskCode);
	}

	function queryData() {

		var tableCoulmnName = $.trim($('#tableCoulmnName').val());//查询字段名
		if (tableCoulmnName != null && tableCoulmnName != "") {

			var tableCoulmnValue = $('#tableCoulmnNameValue').val();//查询字段内容
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
		data["errorDataStatus"] = $.trim($("#errorDataStatus").val());

		data["tableCoulmnName"] = $('#tableCoulmnName').val();
		data["tableCoulmnNameValue"] = $('#tableCoulmnNameValue').val();

		data["startDate"] = $('#startDate').val();
		data["endDate"] = $('#endDate').val();
		
		data["reportWay"] = $('#reportWay').val();

        data["errorReason"] = $.trim($('#errorReason').val());

		data["queryType"] = $('#queryType').val();
		
		data["taskCode"] = $('#reportBatch').val();
		
		errorDataTable.ajax.reload();
	}

	//查询字段
	function changeCoumlnName() {

		var tableCoulmnName = $.trim($('#tableCoulmnName').val());
		if (tableCoulmnName == null || tableCoulmnName == "") {
			$('#tableCoulmnNameValue').val("");
			$('#tableCoulmnNameValue').prop("disabled", "disabled");
			resetIEPlaceholder();
		} else {
			$('#tableCoulmnNameValue').removeAttr("disabled");
		}
	}

	// 导出疑问数据
	function downloadData(){
		
		var tableCoulmnName = $.trim($('#tableCoulmnName').val());//查询字段名
		if (tableCoulmnName != null && tableCoulmnName != "") {

			var tableCoulmnValue = $('#tableCoulmnNameValue').val();//查询字段内容
			if (tableCoulmnValue == null || tableCoulmnValue == "") {
				$.alert('请添加查询字段内容!', 1);
				return;
			}
		}
		var errorDataStatus = $.trim($("#errorDataStatus").val());
		var tableCoulmnName = $('#tableCoulmnName').val() || '';
		var tableCoulmnNameValue = $('#tableCoulmnNameValue').val() || '';
		var taskCode = $('#reportBatch').val() || '';
		var tableId = $("#tableId").val() || '';
		var reportWay = $('#reportWay').val() || '';
		var startDate = $('#startDate').val() || '';
		var endDate  = $('#endDate').val() || '';
        var errorReason  = $.trim($('#errorReason').val());

		layer.confirm("确认要导出数据吗？", {
			icon : 3
		}, function(index) {
			 var rows = new Array();
	         var selectedRows = errorDataTable.rows().data();
	         $.each(selectedRows, function(i, selectedRowData) {
	             rows.push(selectedRowData);
	         });

	         // check
	         if (isNull(rows) || rows.length == 0) {
	             $.alert('无数据，不可导出！');
	             return;
	         }
	         
	         layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});

            var queryParams = "errorDataStatus=" + errorDataStatus;
            queryParams += "&tableCoulmnName=" + tableCoulmnName;
            queryParams += "&tableCoulmnNameValue=" + tableCoulmnNameValue;
            queryParams += "&taskCode=" + taskCode;
            queryParams += "&tableId=" + tableId;
            queryParams += "&queryType=1";
            queryParams += "&startDate=" + startDate;
            queryParams += "&endDate=" + endDate;
            queryParams += "&reportWay=" + reportWay;
            queryParams += "&errorReason=" + errorReason;
            document.location = ctx + "/dp/dataReport/exportData.action?"+queryParams;
		});
		
	}

    // 初始化文件上传
    $(".upload-file").uploadFile({
        showList : false,
        supportTypes : ["xlsx"],
        beforeUpload : function() {
            loading();
        },
        callback : function(data) {
            var filePathStr = "";
            var fileNameStr = "";
            var fileArr = data.success;
            if (fileArr.length > 0) {
                for (var i = 0; i < fileArr.length; i++) {
                    filePathStr += fileArr[i].path + ",";
                    fileNameStr += fileArr[i].name + ",";
                }
                uploadFile(filePathStr, fileNameStr);
            }
        }
    });

    // 上传文件
    function uploadFile(filePathStr, fileNameStr) {
        loading();
        $.post(CONTEXT_PATH + '/dp/dataReport/uploadErrFile.action', {
            fileNameStr : fileNameStr,
            filePathStr : filePathStr
        }, function(data) {
            loadClose();
            var data = eval('(' + data + ')');
            if (!data.result) {
                $.alert(data.message);
            } else {
                $.alert(data.message);
            }
        });
    }

	return {
		"goBack" : goBack,
		"onEditUploadError" : onEditUploadError,
		"onChgStatusUploadError" : onChgStatusUploadError,
		"queryErrorData" : queryErrorData,
		"clearData" : clearData,
		"queryData" : queryData,
		"downloadData" : downloadData
	}
})();