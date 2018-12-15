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
		for (var i = 0; i < data.length; i++) {
			html += "<option value='" + data[i].id + "'>" + data[i].text + "</option>";
		}

		$("#powerTypeCon").html(html);

		// 初始下拉框
		$("#powerTypeCon").select2({
			placeholder : '权力类别',
			language : 'zh-CN'
		});

		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2('#powerTypeCon');

	});

	$.getJSON(ctx + "/system/department/getDeptList.action?isIncludedAll=true", function(result) {
		// 初始下拉框
		$("#deptCon").select2({
			placeholder : '实施主体',
			language : 'zh-CN',
            allowClear : false,
            data : result
		});

		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2('#deptCon');

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
                        columns: [
                            {
                                "data": "", // checkBox
                                render: function (data, type, full) {
                                    return '<input type="checkbox" name="checkThis" class="icheck">';
                                }
                            },
                            {
                                "data": "QL_CODE"
                            },
                            {
                                "data": "QL_NAME"
                            },
                            {
                                "data": "QL_TYPE_NAME"
                            },
                            {
                                "data": "DEPARTMENT_NAME"
                            },
                            {
                                "data": "ACCORDING",
                                "render": fmtAccording
                            },
                            {
                                "data": "XZXDR_TYPE_NAME"
                            }],
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
                        },
						initComplete : function(settings, data) {
							var columnTogglerContent = $('#columnTogglerContent').clone();
							$(columnTogglerContent).removeClass('hide');
							var columnTogglerDiv = $('.columnToggler');
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
						}
					});



	function refreshTable() {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["powerName"] = $.trim($("#powerNameCon").val());
			data["powerCode"] = $.trim($("#powerCodeCon").val());
			data["powerType"] = $.trim($("#powerTypeCon").val());
			data["deptId"] = $.trim($("#deptCon").val());
			table.ajax.reload(function() {
				addUploadBtnListener();
			});
		}
	}

	function addUploadBtnListener() {
		$("a.uploadPdf").uploadFile({
			supportTypes : [ "pdf" ],
			showList : false,
			multiple : false,
			callback : function(fileInfo, $self) {
				if (fileInfo.success.length > 0) {
					saveFileInfo(fileInfo, $self);
				}
			}
		});
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
	function conditionSearch() {
        rowIds = [];//清空选中的数据
		var cnlbKey = $('#cnlbKey').val();
		var deptId = $('#deptId').val();
		refreshTable(cnlbKey, deptId);
	}

	// 重置
	function conditionReset() {
        rowIds = [];//清空选中的数据
        $('.icheck').iCheck('uncheck'); //去除选中的状态
        $('tr').removeClass('active'); //去除选中的状态
		resetSearchConditions('#powerNameCon,#powerCodeCon,#powerTypeCon,#deptCon');
	}


	// 格式化依据
	function fmtAccording(data, type, full) {
		var icon = data ? "fa-file-text-o" : "fa-file-o";
		return "<div style='text-align:center;'><i class='fa " + icon + "' style='cursor:pointer;' title='" + (data||'') + "' "
		+ "onclick='power.openAccordingWin(this, \"" + full.ID + "\")'></i></div>";
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
        var deptId = $.trim($("#deptCon").val());
        var str = '';
        if (rowIds.length > 0) {
            layer.confirm('是否按照当前勾选的数据导出?', function (data) {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                str += 'ids=' + rowIds;
                document.location = ctx + '/executivePower/exportPowerList.action?' + str;
            });
        } else if (powerName || powerCode || powerType || deptId) {
            layer.confirm('是否按照当前查询条件导出数据?', function (data) {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                str += 'powerName=' + powerName + '&powerCode=' + powerCode + '&powerType=' + powerType + '&deptId=' + deptId;
                document.location = ctx + '/executivePower/exportPowerList.action?' + str;
            });
        }else{
            layer.confirm('是否导出所有数据?', function (data) {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                document.location = ctx + '/executivePower/exportPowerList.action';
            });
        }

    });

	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		openAccordingWin : openAccordingWin
	};

})();