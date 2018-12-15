var taskNoRelated = (function(){
	$("#tableCoulmnName").select2({
		placeholder : '查询字段',
		language : 'zh-CN'
	}).on("change",function(){
		changeCoumlnName();
	});
	
	resizeSelect2('#tableCoulmnName');
	$('#tableCoulmnName').val(null).trigger("change");
	var start = {
			elem : '#updateStartDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30', // 最大日期
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#updateStartDate', datas);
				end.min = datas; // 开始日选好后，重置结束日的最小日期
				end.start = datas // 将结束日的初始值设定为开始日
			}
		};
		var end = {
			elem : '#updateEndDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30',
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#updateEndDate', datas);
				start.max = datas; // 结束日选好后，重置开始日的最大日期
			}
		};
		laydate(start);
		laydate(end);
		
	
	var nameList = $("input#nameList").val();
	var codeList = $("input#codeList").val();
	var typeList = $("input#typeList").val();
	var reportName = $("#reportName").val();
	var errorTaskCode = $("input#errorTaskCode").val();
	var rulesList = $("input#rulesList").val();
	var deptId = $("#deptId").val();
	var tableCode = $("#tableCode").val();
	var personType = $("#personType").val();
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
		if ($("#pageType").val() == 0) {//
			columns.push({
				"data" : "RWBH" // 上报批次编号
			});
		}
			columns.push({
				"data" : "CREATE_TIME", // 更新时间
			});
		for (var i = 0; i < codeList.length; i++) {
			columns.push({
				"data" : codeList[i]
			});
		};
		log("sdfsdfsd="+$("#personType").val())
    var table = $('#dataReportGrid').DataTable({
			ajax :{
				url: CONTEXT_PATH + '/dp/task/noRelatedList.action',
				type : 'post',
				data : {
					tableCode:tableCode,
					taskCode:$.trim($("#showTaskCode").val()),
					deptId:$.trim($("#departmentDetail").val()),
					personType:personType
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
		data["taskCode"] = $.trim($("#showTaskCode").val());
		data["tableCoulmn"] = $.trim($("#tableCoulmnName").val());
		data["tableCoulmn"] = $.trim($("#tableCoulmnName").val());
		data["coulmnValue"] = $.trim($("#tableCoulmnNameValue").val());
		data["beginTime"]=$.trim($("#updateStartDate").val());
		data["endTime"] = $.trim($("#updateEndDate").val());
		data["deptId"] = $.trim($("#departmentDetail").val())
		data["pageType"] = $.trim($("#pageType").val());
		data["personType"] = $.trim($("#personType").val());
		table.ajax.reload();
	}


	function clearData(){
		
		$('#tableCoulmnNameValue').val("");//查询字段内容
		$('#tableCoulmnNameValue').prop("disabled", "disabled");
		$('#tableCoulmnName.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resetIEPlaceholder();
		resetSearchConditions('#tableCoulmnName,#updateStartDate,#updateEndDate');
		if($("#pageType").val() == "0"){
			resetSearchConditions('#showTaskCode');
		}
		resetDate(start, end);
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
	
	// 返回
	function goBack(){
        var selectArr = recordSelectNullEle();
		if ($("#pageType").val() == 1) {
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
		
		var tableCoulmnName = $('#tableCoulmnName').val() || '';
		var tableCoulmnNameValue = $('#tableCoulmnNameValue').val() || '';
		var taskCode = $('#showTaskCode').val() || '';
		var tableId = $("#tableId").val() || '';
		var startDate = $('#updateStartDate').val() || '';
		var endDate  = $('#updateEndDate').val() || '';
		var deptId  = $('#departmentDetail').val() || '';

		layer.confirm("确认要导出数据吗？", {
			icon : 3
		}, function(index) {
			 var rows = new Array();
	         var selectedRows = table.rows().data();
	         $.each(selectedRows, function(i, selectedRowData) {
	             rows.push(selectedRowData);
	         });

	         // check
	         if (isNull(rows) || rows.length == 0) {
	             $.alert('无数据，不可导出！');
	             return;
	         }

            layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
            var queryParams = "";
            queryParams += "tableCoulmnName=" + tableCoulmnName;//查询字段
            queryParams += "&tableCoulmnNameValue=" + tableCoulmnNameValue;//查询字段值
            queryParams += "&taskCode=" + taskCode;//上报批次编号
            queryParams += "&tableCode=" + tableCode;//
            queryParams += "&startDate=" + startDate;//更新开始时间
            queryParams += "&endDate=" + endDate;//更新结束时间
            queryParams += "&deptId=" + deptId;//上报部门
            queryParams += "&logicTableId=" + $("#tableId").val();//上报部门
            queryParams += "&pageType=" + $("#pageType").val();//上报部门
            document.location = ctx + "/dp/task/exportData.action?" + queryParams;
		});
	}
	
	return {
		goBack:goBack,
		clearData:clearData,
		"queryData" : queryData,
		downloadData:downloadData
	}
})();