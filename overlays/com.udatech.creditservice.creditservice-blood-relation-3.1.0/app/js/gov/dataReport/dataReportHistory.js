var dataReport = (function(){
	$("#tableCoulmnName").select2({
		width:100,
		placeholder : '查询字段',
		language : 'zh-CN'
	}).on("change",function(){
		changeCoumlnName();
	});
	
	resizeSelect2('#tableCoulmnName');
	$('#tableCoulmnName').val(null).trigger("change");
	
	$("#reprotDataStatus").select2({
		/*width:100,*/
		placeholder : '数据状态',
		language : 'zh-CN'
	});
	
	resizeSelect2('#reprotDataStatus');
	$('#reprotDataStatus').val(null).trigger("change");
	
	var category = $('#choseTitle').val();	//	0:负责专题,1:参与专题,2:设置专题
	var choseTitle = $('#choseTitle').val(); // 选择的标签页
	
	var taskCode =$('#taskCode').val();//任务编号
	var parentMenu = $('#parentMenu').val();//上级菜单
	var toMore = $("#toMore").val();// 是否是更多记录打开
	var nameList = $("input#nameList").val();
	var codeList = $("input#codeList").val();
	var typeList = $("input#typeList").val();
	var tableId = $("input#tableId").val();
	var reportName = $("#reportName").val();
	var errorTaskCode = $("input#errorTaskCode").val();
	var rulesList = $("input#rulesList").val();
    var checkTime = $("input#checkTime").val();
	var deptId = $("#deptId").val();
	var logicTableId = $("#logicTableId").val();
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
    if (checkTime) {
        checkTime = eval(checkTime);
    }
	if (requiredGroupList) {
		requiredGroupList = eval(requiredGroupList);
	}
	if (requiredGroupList == null || requiredGroupList.length == 0) {
		$("#warningMsgDiv").hide();
	}
	
	if (errorTaskCode == 'true') {
		$.alert("上报批次编号信息错误！", 2, function () {
			goBack();
		});
	} else {
		var columns = new Array();
		columns.push({
			"data" : null // 复选框
		});
		columns.push({
			"data" : "INSERT_TYPE", // 上报方式
			"render" : function(data, type, row) {
				var str = '';
				if (data == 0) {
					str = "手动录入";
				} else if (data == 1) {
					str = "文件上传";
				} else if (data == 2) {
					str = "数据库上报";
				} else if (data == 3) {
					str = "FTP上报";
				} else if(data=="4"){
					str = "接口上报";
				} else {
					str = "未知";
				}
				return str;
			}
		});

		columns.push({
			"data" : "STATUS", // 数据状态
			"render" : function(data, type, row) {
				var str = '';
                if (data == 0 || data == 9) {
                    str = "新增";
                } else if (data == -3) {
                    str = "已修改";
                }else if (data == -2 || data == 99) {
                    str = "删除";
                } else if (data == 1 ) {
                    str = "已处理";
                } else {
                    str = "未知";
                }

				return str;
			}
		});

        columns.push({
			"data" : "CREATE_TIME", // 更新时间
		});
        for (var i = 0; i < codeList.length; i++) {
            columns.push({
                "data" : codeList[i]
            });
        };
        var table = $('#dataReportGrid').DataTable({
			ajax :{
				url: CONTEXT_PATH + '/dp/historyDataReport/list.action',
				type : 'post',
				data : {
					tableId : tableId,
					taskCode : taskCode,
					tableCoulmn : $('#tableCoulmnName').val(),
					coulmnValue : $('#tableCoulmnNameValue').val(),
					reprotDataStatus : $('#reprotDataStatus').val()
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
				var columnTogglerDiv = $('#dataReportGrid').parent().parent().find('.columnToggler');
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
			},
			columnDefs : [ {
				targets : 0, // checkBox
				render : function(data, type, full) {
					return '<input type="checkbox" name="checkThis" class="icheck">';
				}
			} ],
			drawCallback : function(settings) {
				$('#dataReportGrid .checkall').iCheck('uncheck');
				$('#dataReportGrid .checkall, #dataReportGrid tbody .icheck').iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});

				// 列表复选框选中取消事件
				var checkAll = $('#dataReportGrid .checkall');
				var checkboxes = $('#dataReportGrid tbody .icheck');
				checkAll.on('ifChecked ifUnchecked', function(event) {
					if (event.type == 'ifChecked') {
						checkboxes.iCheck('check');
						$('#dataReportGrid tbody tr').addClass('active');
					} else {
						checkboxes.iCheck('uncheck');
						$('#dataReportGrid tbody tr').removeClass('active');
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
				$('#dataReportGrid tbody tr').on('click', function() {
					$(this).toggleClass('active');
					if ($(this).hasClass('active')) {
						$(this).find('.icheck').iCheck('check');
					} else {
						$(this).find('.icheck').iCheck('uncheck');
					}
				});
			}
		});
	}
	
	var editValidator = $('#editDataForm').validateForm();
	
	// 返回
	function goBack(){
		var selectArr = recordSelectNullEle();
		if (toMore != null  && toMore == "tomore") {
			$("div#childBoxMore").hide();
			$("div#parentBoxMore").show();
			$("div#parentBoxMore").prependTo("#topBoxMore");
		} else {
			$("div#childBox").hide();
			$("div#parentBox").show();
			$("div#parentBox").prependTo("#topBox");
		}
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	}
	
	
	function queryData(){
		
		var tableCoulmnName =  $.trim($('#tableCoulmnName').val());//查询字段名
		if(tableCoulmnName != null && tableCoulmnName != ""){
			
			var tableCoulmnValue= $('#tableCoulmnNameValue').val();//查询字段内容
			if(tableCoulmnValue == null || tableCoulmnValue == ""){
				$.alert('请添加查询字段内容!', 1);
				return;
			}
		}
		var data = table.settings()[0].ajax.data;
	
		if (!data) {
			data = {};
			table.settings()[0].ajax["data"] = data;
		}
		data["tableCoulmn"] = $.trim($("#tableCoulmnName").val());
		data["coulmnValue"] = $.trim($("#tableCoulmnNameValue").val());
		data["reprotDataStatus"] = $.trim($("#reprotDataStatus").val());
		table.ajax.reload();
	}


	function clearData(){
		$('#tableCoulmnNameValue').val("");//查询字段内容
		$('#tableCoulmnNameValue').prop("disabled", "disabled");
		$('#tableCoulmnName.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resetIEPlaceholder();
		resetSearchConditions('#reprotDataStatus,#tableCoulmnName');
	}
	
	
	//查询字段
	function changeCoumlnName(){
		
		var tableCoulmnName = $.trim($('#tableCoulmnName').val());
		if(tableCoulmnName == null || tableCoulmnName == ""){
			$('#tableCoulmnNameValue').prop("disabled", "disabled");
			$('#tableCoulmnNameValue').val("");
			resetIEPlaceholder();
		}else{
			$('#tableCoulmnNameValue').removeAttr("disabled");
		}
	}
	
	// 打开修改窗口
	function openEdit() {
		var rows = new Array();
		var selectedRows = table.rows('.active').data();
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
		
		var row = selectedRows[0];
		var status = row.STATUS;
		if (status == 1) {
			$.alert('已处理记录无法修改');
			return;
		}
		
		var editId = "";// 修改的记录id
		$.each(rows, function(i, row) {
			editId = row.ID;
		});

		var taskCode = "";// 批次编号
		$.each(rows, function(i, row) {
			taskCode = row.TASK_CODE;
		});
		
		$('#editDataForm')[0].reset();
		loading();
		$.post(CONTEXT_PATH + "/dp/dataReport/getEditData.action", {
			editId : editId,
			tableId : tableId
		}, function(data) {
			var data = eval(data);
			loadClose();
			for (var i = 0; i < codeList.length; i++) {
				var colName = codeList[i];
				$('#' + codeList[i]).val(data[colName]);
			}
			$('#editId').val(editId);
			$.openWin({
				title : '修改',
				content : $("#winEdit"),
				btnAlign : 'c',
				area : [ '600px', '650px' ],
				yes : function(index, layero) {
					editData(index);
				}
			});
			editValidator.form();
		}, "json");
	}
	
	// 修改数据
	function editData(index) {
		if (!editValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}
        if (checkTime) {
            var isCheck = checkTime[0];
            if (isCheck.IS_CHECK_DATE == 1) {
                var beginTime = new Date($('#' + isCheck.BEGIN_DATE_CODE).val());
                var endTime = new Date($('#' + isCheck.END_DATE_CODE).val());
                if (beginTime.getTime() > endTime.getTime()) {
                    $.alert("开始时间不能大于结束时间！");
                    return;
                }
            }
        }
		var editDataForm = $("#editDataForm").serialize();
		editDataForm += "&taskCode=" + taskCode;
		loading();
		$.post(CONTEXT_PATH + "/dp/historyDataReport/edit.action", editDataForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert(data.message, 2);
			} else {
				$.alert(data.message, 1);
				layer.close(index);
				table.ajax.reload(null, false);
			}
		}, "json");
	}

	// 删除
	function deleteData() {

		var rows = new Array();
		var selectedRows = table.rows('.active').data();
		$.each(selectedRows, function(i, selectedRowData) {
			rows.push(selectedRowData);
		});

		// check
		if (isNull(rows) || rows.length == 0) {
			$.alert('请勾选要操作的记录');
			return;
		}

		var dataArray = new Array();
		$.each(rows, function(i, row) {
			dataArray.push(row.ID);
		});

		layer.confirm('确认要删除这些数据吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(CONTEXT_PATH + "/dp/dataReport/delete.action", {
				ids : JSON.stringify(dataArray),
				tableId : tableId
			}, function(data) {
				loadClose();
				if (!data.result) {
					$.alert('删除数据失败!', 2);
				} else {
					layer.close(index);
					$.alert('删除数据成功!', 1);
					table.ajax.reload(null, false);
				}
			}, "json");
		});
	}

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
	
	return {
		"goBack" : goBack,
		"queryData" : queryData,
		"deleteData" : deleteData,
		"openEdit" : openEdit,
		"clearData" : clearData
	}
})();