var dept = function() {
	var table = $('#departmentGrid').DataTable(// 创建一个Datatable
	{
		ajax : {
			url : CONTEXT_PATH + "/system/department/list.action",
			type : 'post',
			data : {
				deptCode : $.trim($('#deptCode').val()),
				deptName : $.trim($('#deptName').val())
			}
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		ordering : false,
		autoWidth : false,
		columns : [ {
			"data" : "code"
		}, {
			"data" : "departmentName"
		}, {
			"data" : "description"
		}, {
			"data" : "createBy"
		}, {
			"data" : "createDate"
		}, {
			"data" : "updateBy"
		}, {
			"data" : "updateDate"
		} ]
	});

	$('#departmentGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 按条件查询
	function conditionSearch(type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["deptCode"] = $.trim($('#deptCode').val());
			data["deptName"] = $.trim($('#deptName').val());
			table.ajax.reload(null, type == 1 ? true : false);
		}
	}
	// 重置查询条件
	function conditionReset() {
		resetSearchConditions('#deptCode,#deptName');
	}

	function addRootDepartment() {
		$('#addDepartmentForm')[0].reset();
		$('#parentId').val('ROOT');
		$.openWin({
			title : '添加部门',
			content : $("#winAdd"),
			yes : function(index, layero) {
				addDepartment(index);
			}
		});
		addValidator.form();
	}
	// 保存新加的部门
	function addDepartment(index) {
		if (!addValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
		var addDepartmentForm = $("#addDepartmentForm").serialize();
		$.post(ctx + "/system/department/add.action", addDepartmentForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert('增加部门失败!', 2);
			} else if (data.result == 'exsit') {
				$.alert('部门名称不能重复!', 2);
			} else if (data.result == 'exsitCode') {
				$.alert('部门编码不能重复!', 2);
			} else {
				layer.close(index);
				$.alert('增加部门成功!', 1);
				conditionSearch();
			}
		}, "json");
	}

	function editDepartment() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length == 1) {
			var node = gridNodes[0];
			$('#code_edit').attr("readonly", true);
			$('#code_edit').val(node.code);
			$('#departmentName_edit').val(node.departmentName);
			$('#description_edit').val(node.description);
			$('#departmentId_edit').val(node.id);
			$.openWin({
				title : '修改部门',
				content : $("#winEdit"),
				yes : function(index, layero) {
					editSubmit(index);
				}
			});
			editValidator.form();
		} else {
			$.alert('请先选择要修改的部门!');
		}
	}
	// 保存编辑的部门信息
	function editSubmit(index) {
		if (!editValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
		var editDepartmentForm = $("#editDepartmentForm").serialize();
		$.post(ctx + "/system/department/edit.action", editDepartmentForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert('修改部门失败!', 2);
			} else if (data.result == 'exsit') {
				$.alert('部门名称不能重复!', 2);
			} else if (data.result == 'exsitCode') {
				$.alert('部门编码不能重复!', 2);
			} else {
				layer.close(index);
				$.alert('修改部门成功!', 1);
				conditionSearch();
			}
		}, "json");
	}
	// 删除部门
	function deleteConfirm() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			layer.confirm('确认要删除吗？', {
				icon : 3
			}, function(index) {
				loading();
				$.post(ctx + "/system/department/delete.action?id=" + node.id, {}, function(data) {
					loadClose();
					if (!data.result) {
						if (data.message == "1") {
							$.alert('该部门内存在用户,不能删除!', 2);
						} else {
							$.alert('删除部门失败!', 2);
						}
					} else {
						layer.close(index);
						$.alert('删除部门成功!', 1);
						conditionSearch();
					}
				}, "json");
			});
		} else {
			$.alert('请先选择要删除的部门!');
		}
	}

	var rules = {
		code : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 15
		},
		departmentName : {
			required : true,
			illegalChar : [],
			maxlength : 25
		},
		description : {
			maxlength : 250
		}
	};
	var addValidator = $('#addDepartmentForm').validateForm(rules);
	var editValidator = $('#editDepartmentForm').validateForm(rules);

	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		editDepartment : editDepartment,
		addRootDepartment : addRootDepartment,
		deleteConfirm : deleteConfirm
	}
}();