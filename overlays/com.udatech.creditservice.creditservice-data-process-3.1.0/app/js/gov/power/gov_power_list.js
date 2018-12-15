var power = (function() {
	var rowIds = []; /*定义一个全局数组，记录列表选中的数据勾线导出*/
	var rules = {
		powerCode : {
			required : true,
			maxlength : 25
		},
		powerName : {
			required : true,
			maxlength : 50
		},
		according : {
			required : true,
			maxlength : 2000
		}
	};
	
	var addValidator = $('#addEnterForm').validateForm(rules);
	var editValidator = $('#editEnterForm').validateForm(rules);
	 

	var ownerDeptId = $("#ownerDeptId").val();

	$(".upload-file").uploadFile({
		showList : false,
		supportTypes : [ "xls", "xlsx" ],
		beforeUpload : function() {
			loading();
		},
		callback : function(data) {
			var filePathStr = "";
			var fileNameStr = "";
			var fileArr = data.success;
			for (var i = 0; i < fileArr.length; i++) {
				filePathStr += fileArr[i].path + ",";
				fileNameStr += fileArr[i].name + ",";
			}
			
			if(data.success.length > 0){
				batchAdd(filePathStr, fileNameStr);
			}
		}
	});
	
	$.getJSON(ctx + "/system/dictionary/listValues.action", {
		"groupKey" : "powerType"
	}, function(result) {
		var data = result.items;
		var html = "<option value=''></option>";
		var html2 = "";
		for (var i = 0; i < data.length; i++) {
			html += "<option value='" + data[i].id + "'>" + data[i].text + "</option>";
			html2 += "<option value='" + data[i].id + "'>" + data[i].text + "</option>";
		}

		$("#powerTypeCon").html(html);
		
		$("#powerType").html(html2);
		
		$("#powerTypeEdit").html(html2);
		
		// 初始下拉框
		$("#powerTypeCon").select2({
			placeholder : '权力类别',
			language : 'zh-CN'
		});
		$("#powerType").select2({
			minimumResultsForSearch : -1
		});
		$("#powerTypeEdit").select2({
			minimumResultsForSearch : -1
		});
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2('#powerTypeCon');
		resizeSelect2('#powerType');
		resizeSelect2('#powerTypeEdit');
	});

	$.getJSON(ctx + "/system/dictionary/listValues.action", {
		"groupKey" : "xzxdrType"
	}, function(result) {
		var html = '';
		if (result.items) {
			for (var i = 0, len = result.items.length; i < len; i++) {
				var item = result.items[i];
				html += '<option value="' + item.id + '">' + item.text
						+ '</option>';
			}
			$("#xzxdrType").append(html);
			$("#xzxdrTypeEdit").append(html);
		}
		$("#xzxdrType").select2({
			placeholder : '行政相对人类别',
			language : 'zh-CN',
			minimumResultsForSearch : -1
		});
		$("#xzxdrTypeEdit").select2({
			placeholder : '行政相对人类别',
			language : 'zh-CN',
			minimumResultsForSearch : -1
		});
		resizeSelect2($("#xzxdrType"));
		resizeSelect2($("#xzxdrTypeEdit"));
	});
	
	// 创建一个Datatable
	var table = $('#dataTable')
			.DataTable(
					{
						ajax : {
							url : ctx + "/executivePower/getPowerList.action",
							type : "post"
						},
						ordering : false,
						searching : false,
						autoWidth : false,
						lengthChange : true,
						pageLength : 10,
						serverSide : true,// 如果是服务器方式，必须要设置为true
						processing : true,// 设置为true,就会有表格加载时的提示
						columns : [
								{
							        "data" : "", // checkBox
							        render : function(data, type, full) {
							            return '<input type="checkbox" name="checkThis" class="icheck">';
							        }
								},
								{
									"data" : "QL_CODE"
								},
								{
									"data" : "QL_NAME"
								},
								{
									"data" : "QL_TYPE_NAME"
								},
								{
									"data" : "DEPARTMENT_NAME"
								},
								{
									"data" : "ACCORDING",
									"render": fmtAccording
								},
								{
									"data" : "XZXDR_TYPE_NAME"
								},
								{
									"data" : "STATUS",
									"render" : function(data, type, full) {
										if (data == 1) {
											return '<input id="' + full.ID + '" value="'+data+'"  type="checkbox" checked class="make-switch" name="changeStatus" data-size="mini" />';
										} else {
											return '<input id="' + full.ID + '" value="'+data+'"  type="checkbox" class="make-switch" name="changeStatus" data-size="mini" />';
										}
									}
								} ],
								drawCallback : function(settings) {
									$('.make-switch').bootstrapSwitch({
										onSwitchChange : function(event, state) {
											if ($(this).attr("name") == 'changeStatus') {
												if ($(this).val() == 1) {
													enablePower($(this).attr("id"), 0);
												} else {
													enablePower($(this).attr("id"), 1);
												}
											}
										}
									});
									
									$('#dataTable .checkall').iCheck('uncheck');
									$('#dataTable .checkall, #dataTable tbody .icheck').iCheck({
										labelHover : false,
										cursor : true,
										checkboxClass : 'icheckbox_square-blue',
										radioClass : 'iradio_square-blue',
										increaseArea : '20%'
									});

									// 列表复选框选中取消事件
									var checkAll = $('#dataTable .checkall');
									var checkboxes = $('#dataTable tbody .icheck');
									checkAll.on('ifChecked ifUnchecked', function(event) {
										if (event.type == 'ifChecked') {
											checkboxes.iCheck('check');
											$('#dataTable tbody tr').addClass('active');
										} else {
											checkboxes.iCheck('uncheck');
											$('#dataTable tbody tr').removeClass('active');
										}
									});
									checkboxes.on('ifChanged', function(event) {
										if (checkboxes.filter(':checked').length == checkboxes.length) {
											checkAll.prop('checked', 'checked');
										} else {
											checkAll.removeProp('checked');
										}
										checkAll.iCheck('update');
                                        var selectedData = table.rows($(this).closest('tr')).data();
										if ($(this).is(':checked')) {
											$(this).closest('tr').addClass('active');
                                            if (!rowIds.contains(selectedData[0].ID)) {
                                                rowIds.push(selectedData[0].ID)
                                            }
										} else {
                                            rowIds.remove(selectedData[0].ID);
											$(this).closest('tr').removeClass('active');
										}
									});

									// 添加行选中点击事件
									$('#dataTable tbody tr').on('click', function() {
										$(this).toggleClass('active');
										if ($(this).hasClass('active')) {
											$(this).find('.icheck').iCheck('check');
										} else {
											$(this).find('.icheck').iCheck('uncheck');
										}
									});
								}
					});

	

	function refreshTable(type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["powerName"] = $.trim($("#powerNameCon").val());
			data["powerCode"] = $.trim($("#powerCodeCon").val());
			data["powerType"] = $.trim($("#powerTypeCon").val());
			
			table.ajax.reload(null, type==1?true:false);// 刷新列表还保留分页信息
		}
	}

	
	// 保存文件信息
	function saveFileInfo(fileInfo, $self) {
		loading();
		$.post(ctx + "/promise/saveFileInfo.action", {
			"businessId" : $self.attr("id"),
			"fileName" : fileInfo.success[0].name,
			"filePath" : fileInfo.success[0].path,
			"icon" : fileInfo.success[0].icon
		}, function(result) {
			loadClose();
			refreshTable();
			if (result.result) {
				$.alert("操作成功！", 1);
			} else {
				$.alert(result.message, 2);
			}
		}, "json");
	}

	// 删除文件信息
	function deleteFileInfo(uploadFileId, businessId) {
		layer.confirm("确定删除承诺细则吗？", {
			icon : 3,
		}, function(index) {
			loading();
			$.post(ctx + "/promise/deleteFileInfo.action", {
				"uploadFileId" : uploadFileId,
				"businessId" : businessId
			}, function(result) {
				loadClose();
				refreshTable();
				if (result.result) {
					$.alert("操作成功！", 1);
				} else {
					$.alert(result.message, 2);
				}
			}, "json");
		});
	}

	// 搜索
	function conditionSearch(type) {
        rowIds = [];//清空选中的数据
		refreshTable(type);
	}

	// 重置
	function conditionReset() {
        rowIds = [];//清空选中的数据
        $('.icheck').iCheck('uncheck'); //去除选中的状态
        $('tr').removeClass('active'); //去除选中的状态
		resetSearchConditions('#powerNameCon,#powerCodeCon,#powerTypeCon');
	}

	// 手工录入
	function manualAdd() {
		$('#addEnterForm')[0].reset();
		$("#powerType").select2({
			minimumResultsForSearch : -1
		});
		$("#xzxdrType").select2({
			minimumResultsForSearch : -1
		});
		$.openWin({
			title : '手动录入',
			content : $("#winAdd"),
			btnAlign : 'c',
			area : [ '600px', '488px' ],
			yes : function(index, layero) {
				manualAddSub(index);
			}
		});
	}

	// 手工录入 提交
	function manualAddSub(index) {
		if(!addValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}

		var powerType = $.trim($('#powerType').val());
		var xzxdrType = $.trim($('#xzxdrType').val());
		if (isNull(powerType)) {
			$.alert("请选择权力类别!");
			return;
		}
		
		if (isNull(xzxdrType)) {
			$.alert("请选择行政相对人类别!");
			return;
		}
		
		loading();
		var formVal = $("#addEnterForm").serialize();
		$.post(CONTEXT_PATH + '/executivePower/manualAdd.action', formVal, function(data) {
			loadClose();
			conditionSearch();
			if (data.result) {
				layer.close(index);
				layer.confirm(data.message + '是否继续添加？', {
					icon : 3
				}, function(index) {
					layer.close(index);
					manualAdd();
				});
			} else {
				$.alert(data.message, 2);
			}
		}, "json");
	}

	// 打开修改页面
	function onEditPower() {
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
		
		var id = row.ID;
		
		$('#editEnterForm')[0].reset();
		
		
		resizeSelect2("#powerTypeEdit");
		resizeSelect2("#xzxdrTypeEidt");
		loading();
		$.getJSON(ctx + "/executivePower/onEditPower.action", {
			id : id
		}, function(data) {
			loadClose();
			$("#editId").val(data.powerId);
			$("#powerCodeEidt").val(data.powerCode);
			$('#powerTypeEdit').val(data.powerType).trigger("change");
			$('#powerNameEdit').val(data.powerName);
			$('#deptIdEdit').val(data.deptId);
			$("#accordingEdit").val(data.according);
			$('#xzxdrTypeEdit').val(data.xzxdrType).trigger("change");
			
			$.openWin({
				title : '修改权力目录',
				content : $("#winEdit"),
				btnAlign : 'c',
				area : [ '600px', '488px' ],
				yes : function(index, layero) {
					editPower(index);
				}
			});
		})
	}
	
	// 修改权力目录
	function editPower(index) {
		if (!editValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}
		
		var powerType = $.trim($('#powerTypeEdit').val());
		var xzxdrType = $.trim($('#xzxdrTypeEdit').val());
		if (isNull(powerType)) {
			$.alert("请选择权力类别!");
			return;
		}
		
		if (isNull(xzxdrType)) {
			$.alert("请选择行政相对人类别!");
			return;
		}
		
		loading();
		var formVal = $("#editEnterForm").serialize();
		$.post(CONTEXT_PATH + '/executivePower/editPower.action', formVal, function(data) {
			loadClose();
			if (data.result) {
				layer.close(index);
				$.alert(data.message);
				conditionSearch();
			} else {
				$.alert(data.message, 2);
			}
		}, "json");
	}
	
	// 批量上传
	function batchAdd(filePathStr, fileNameStr) {
		loading();
		$.post(CONTEXT_PATH + '/executivePower/batchAdd.action', {
			deptId : ownerDeptId,
			filePathStr : filePathStr,
			fileNameStr : fileNameStr
		}, function(data) {
			conditionSearch();
			layer.open({
				type : 1, // Page层类型
				area : [ '550px', '400px' ],
				title : '批量导入解析结果',
				shade : 0.6, // 遮罩透明度
				anim : 1, // 0-6的动画形式，-1不开启
				content : '<div style="padding:10px 20px;">' + data.message
						+ '</div>'
			});
			loadClose();
		}, "json");
	}

	// 开启关闭权力目录
	function enablePower(id, type) {
		var msg = "";
		if (type == 1) {
			msg = "启用";
		} else {
			msg = "禁用";
		}
		loading();
		$.post(ctx + "/executivePower/enablePower.action", {powerId : id}, function(data) {
			loadClose();
			layer.msg(msg + "成功", {
				icon : 1,
				anim : 1
			});
			refreshTable();
		});
		loadClose();
	}
	
	// 格式化依据
	function fmtAccording(data, type, full) {
		var icon = data ? "fa-file-text-o" : "fa-file-o";
		return "<div style='text-align:center;'><i class='fa " + icon + "' style='cursor:pointer;' title='" + (data||'') + "' "
				+ "onclick='power.openAccordingWin(this, \"" + full.ID + "\")'></i></div>";
	}
	
	// 权力依据
	function openAccordingWin(obj, id) {
		var row = getRowById(id);
		$("#accordingText").val(row.ACCORDING || "");
		$.openWin({
			title: "实施依据",
			btn :["关闭"],
			content: $("#accordingDiv")
		});
	}
	
	//	根据ID获取一行数据
	function getRowById(id) {
		var rows = table.data();
		if (rows.length < 50) {
			for (var i=0; i<rows.length; i++) {
				var row = rows[i];
				if (row.ID == id) {
					return row;
				}
			}
		}
	}
	
	// 下载模板
	function templateDownload() {
		loading();
		window.location.href = CONTEXT_PATH
				+ "/executivePower/templateDownload.action";
		loadClose();
	}

    //导出
    $('#export').on('click', function () {
        var rows = [];
        var selectedRows = table.rows().data();
        $.each(selectedRows, function (i, selectedRowData) {
            rows.push(selectedRowData);
        });

        if (isNull(rows) || rows.length === 0) {
            $.alert('无数据，不可导出！');
            return;
        }

        var powerName = $.trim($("#powerNameCon").val());
        var powerCode = $.trim($("#powerCodeCon").val());
        var powerType = $.trim($("#powerTypeCon").val());
        var str = '';
        if (rowIds.length > 0) {
            layer.confirm('是否按照当前勾选的数据导出?', function (data) {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                str += 'ids=' + rowIds;
                document.location = ctx + '/executivePower/exportPowerList.action?' + str;
            });
        } else if (powerName || powerCode || powerType) {
            layer.confirm('是否按照当前查询条件导出数据?', function (data) {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                str += 'powerName=' + powerName + '&powerCode=' + powerCode + '&powerType=' + powerType;
                document.location = ctx + '/executivePower/exportPowerList.action?' + str;
            });
        } else {
            layer.confirm('是否导出所有数据?', function (data) {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                document.location = ctx + '/executivePower/exportPowerList.action';
            });
        }

    });

	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		batchAdd : batchAdd,
		manualAdd : manualAdd,
		templateDownload : templateDownload,
		enablePower : enablePower,
		openAccordingWin : openAccordingWin,
		onEditPower : onEditPower
	};

})();