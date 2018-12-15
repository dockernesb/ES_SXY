var user = (function() {

	$("#conditionStatus").select2({
		placeholder : '全部状态',
		minimumResultsForSearch : -1,
		language : 'zh-CN'
	});
	resizeSelect2('#conditionStatus');

    $("#conditionType").select2({
        placeholder : '用户类型',
        minimumResultsForSearch : -1,
        language : 'zh-CN'
    });
    resizeSelect2('#conditionType');
	
	var rules = {
		username : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 20,
			minlength : 5
		},
		password : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 50,
			minlength : 6
		},
		realName : {
			illegalChar : [],
			maxlength : 20
		},
		idCard : {
			idCard : []
		},
		address : {
			illegalChar : [],
			maxlength : 100
		},
		email : {
			email : [],
			maxlength : 30
		},
		phoneNumber : {
			phone : [],
			maxlength : 30
		}
	};
	var addValidator = $('#addUserForm').validateForm(rules);
	var editValidator = $('#editUserForm').validateForm(rules);

	var table = $('#userGrid').DataTable({
		ajax : {
			url : CONTEXT_PATH + '/system/user/list.action',
			type : 'post'
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		pageLength : 10,
		ordering : false,
		autoWidth : false,
		stateSave: true,
		columns : [ {
			"className" : 'details-control',
			"orderable" : false,
			"data" : null,
			"defaultContent" : '<div class="icon">&nbsp;</div>'
		}, {
			"data" : "username"
		}, {
			"data" : "sysDepartment.departmentName"
		}, {
			"data" : "type"
		}, {
			"data" : "enabled"
		}, {
			"data" : null
		} ],
		columnDefs : [ {
			targets : 3, // 类别
			render : function(data, type, row) {
				if (data == 0) {
					return "管理员";
				} else if (data == 1) {
					return "中心端";
				} else if (data == 2) {
					return "业务端";
				} else {
					return "政务端";
				}
			}
		}, {
			targets : 4, // 状态
			render : function(data, type, row) {
				if (data) {
					return '<input id="' + row.id + '" type="checkbox" checked class="make-switch" name="changeStatus" data-size="mini" />';
				} else {
					return '<input id="' + row.id + '" type="checkbox" class="make-switch" name="changeStatus" data-size="mini" />';
				}
			}
		}, {
			targets : 5, // 操作
			render : function(data, type, row) {
				var str = '';
				str += '<button type="button" class="btn green btn-xs" onclick="user.onGrant(\'' + row.id + '\',\'' + row.username + '\');"><i class="fa fa-cogs"></i> 授权</button>';
				str += '<button type="button" class="btn blue btn-xs" onclick="user.onEditUser(\'' + row.id + '\');"><i class="fa fa-edit"></i> 修改</button>';
				str += '<button type="button" class="btn blue-hoki btn-xs" onclick="user.resetPassword(\'' + row.id + '\');"><i class="fa fa-refresh"></i> 重置</button>';
				str += '<button type="button" class="btn red btn-xs" onclick="user.deleteUser(\'' + row.id + '\');"><i class="fa fa-trash-o"></i> 删除</button>';
				return str;
			}
		} ],
		"drawCallback" : function(settings) {
			$('.make-switch').bootstrapSwitch({
				onSwitchChange : function(event, state) {
					if ($(this).attr("name") == 'changeStatus') {
						userEnable($(this).attr("id"), $(this).bootstrapSwitch('state'));
					}
				}
			});
		}
	});
	// 行明细点击事件
	$('#userGrid tbody').on('click', 'td.details-control', function() {
		var tr = $(this).closest('tr');
		var row = table.row(tr);
		if (row.child.isShown()) { // This row is already open - close it
			row.child.hide();
			tr.removeClass('shown');
		} else { // Open this row
			row.child(showDetail(row.data())).show();
			tr.addClass('shown');
		}
	});
	// 显示行明细
	function showDetail(rowData) {
		var gender = '';
		if (rowData.gender) {
			gender = '男';
		} else {
			gender = '女';
		}
		var str = '';
		str += '<table class="table-detail" style="width:50%;min-width:600px;"> ';
		str += '<tr><td class="col-md-3"><b>真实姓名</b></td><td class="col-md-8">' + rowData.realName + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>性别</b></td><td class="col-md-8">' + gender + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>Email</b></td><td class="col-md-8">' + rowData.email + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>联系电话</b></td><td class="col-md-8">' + rowData.phoneNumber + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>地址</b></td><td class="col-md-8">' + rowData.address + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>创建者</b></td><td class="col-md-8">' + rowData.createBy + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>创建时间</b></td><td class="col-md-8">' + rowData.createDate + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>更新者</b></td><td class="col-md-8">' + rowData.updateBy + '</td></tr>';
		str += '<tr><td class="col-md-3"><b>更新时间</b></td><td class="col-md-8">' + (rowData.updateDate || '') + '</td></tr>';
		str += '</table>';
		return str;
	}

	$('#userGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	function choseUser() {
		table.$('tr.active').removeClass('active');
		$(this).parents("tr").addClass('active');
	}

	$("#gender").select2({
		minimumResultsForSearch : -1
	});
	$("#editGender").select2({
		minimumResultsForSearch : -1
	});

	$("#departmentId").select2();
	$("#editDepartmentId").select2();
	
	$("#editType").select2({
		minimumResultsForSearch : -1
	});
	
	$("#type").select2({
		minimumResultsForSearch : -1
	});

	var data1 ;
	var data2 ;
	$.getJSON(ctx + "/system/department/getDeptList.action?userType=1", function(result) {
		data1 = result;
	});
	$.getJSON(ctx + "/system/department/getDeptList.action?userType=3", function(result) {
		data2 = result;
	});
	
	$("#type").change(function() {
		$("#departmentId").empty();// 清空下拉框
		var adduserType = $("#type").val();
		var data = data1;
		if (adduserType == "3") {
			data = data2;
		}
		// 初始下拉框
		$("#departmentId").select2({
			placeholder : '请选择部门',
			language : 'zh-CN',
			data : data
		});
		resizeSelect2("#departmentId");
	});
	$("#editType").change(function() {
		$("#editDepartmentId").empty();// 清空下拉框
		var edituserType = $("#editType").val();
		var data = data1;
		if (edituserType == "3") {
			data = data2;
		}
		// 初始下拉框
		$("#editDepartmentId").select2({
			placeholder : '请选择部门',
			language : 'zh-CN',
			data : data
		});
		resizeSelect2("#editDepartmentId");
	});

	// 启用、禁用用户
	function userEnable(id, enabled) {
		var msg = "";
		if (enabled) {
			msg = "启用";
		} else {
			msg = "禁用";
		}
		loading();
		$.post(ctx + "/system/user/enable.action?id=" + id, {}, function(data) {
			loadClose();
			layer.msg(msg + "成功", {
				icon : 1,
				anim : 1
			});
		});
		loadClose();
	}

	// 查询按钮
	function conditionSearch(type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["username"] = $.trim($('#conditionName').val());
			data["realName"]=$.trim($('#conditionRealName').val());
			data["depart"] = $.trim($('#conditionDepart').val());
			data["status"] = $.trim($('#conditionStatus').val());
			data["type"]=$.trim($('#conditionType').val());
			table.ajax.reload(null, type == 1 ? true : false);
		}
	}
	// 重置
	function conditionReset() {
		resetSearchConditions('#conditionName,#conditionRealName,#conditionDepart,#conditionStatus,#conditionType');
	}

	// 删除用户
	function deleteUser(id) {
		layer.confirm('确认要删除此用户吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(ctx + "/system/user/delete.action?id=" + id, {}, function(data) {
				loadClose();
				if (!data.result) {
					$.alert('删除用户失败!', 2);
				} else {
					layer.close(index);
					$.alert('删除用户成功!', 1);
					conditionSearch();
				}
			}, "json");
		});
	}
	var userType = $('#userType').val(); // 用户类型

	function resetAddFrom() {
		$('#addUserForm')[0].reset();
		$("#type").val(userType).trigger("change");
		if (userType != 0 && userType != 1) {
			$("#type").prop("disabled", true);
		}
		resizeSelect2("#gender");
		resizeSelect2("#type");
		addValidator.form();
	}

	// 打开新建用户界面
	function onAddUser() {
		resetAddFrom();
		$.openWin({
			title : '新增用户',
			content : $("#winAdd"),
			btnAlign : 'c',
			area : [ '600px', '620px' ],
			yes : function(index, layero) {
				addUser(index);
			}
		});
		addValidator.form();
	}

	// 提交 新建用户
	function addUser(index) {
		if (!addValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}

		loading();
		$("#type").prop("disabled", false);
		var addUserForm = $("#addUserForm").serialize();
		$.post(ctx + "/system/user/add.action", addUserForm, function(data) {
			loadClose();
			if (!data.result) {
				if (data.message == "1") {
					$.alert("部门不存在!");
				} else if (data.message == "2") {
					$.alert("用户名在系统中已经存在!");
				} else {
				}
			} else {
				$.alert("用户添加成功!");
				layer.close(index);
				conditionSearch();
			}
		}, "json");
	}

	// 打开修改页面
	function onEditUser(id) {
		$('#editUserForm')[0].reset();
		if (userType != 0 && userType != 1) {
			$("#editType").prop("disabled", true);
		}
		resizeSelect2("#editGender");
		resizeSelect2("#editType");
		loading();
		$.getJSON(ctx + "/system/user/onEdit.action", {
			userId : id
		}, function(data) {
			loadClose();
			$("#editType").val(data.TYPE).trigger("change");
			$('#userId').val(data.SYS_USER_ID);
			$('#username').val(data.USERNAME);
			$('#editRealName').val(data.REAL_NAME);
			$("#editGender").val(data.GENDER).trigger("change");
			$('#editIdCard').val(data.ID_CARD);
			$('#editAddress').val(data.ADDRESS);
			$('#editEmail').val(data.EMAIL);
			$('#editPhoneNumber').val(data.PHONE_NUMBER);
			$("#editDepartmentId").val(data.SYS_DEPARTMENT_ID).trigger("change");
			
			$.openWin({
				title : '修改用户',
				content : $("#winEdit"),
				btnAlign : 'c',
				area : [ '600px', '520px' ],
				yes : function(index, layero) {
					editUser(index);
				}
			});
		})
	}
	// 修改用户
	function editUser(index) {
		if (!editValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}

		loading();
		$("#editType").prop("disabled", false);
		var editUserForm = $("#editUserForm").serialize();
		$.post(ctx + "/system/user/edit.action", editUserForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert("修改用户信息失败！");
			} else {
				$.alert("修改用户信息成功！");
			}
			layer.close(index);
			conditionSearch();
		}, "json");

	}

	//重置密码
	function resetPassword(userId) {
		layer.confirm('确认重置此用户密码为654321吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(ctx + "/system/user/resetPassword.action?id=" + userId, {}, function(data) {
				loadClose();
				if (!data.result) {
					$.alert("重置密码失败！");
				} else {
					$.alert("密码重置成功！");
				}
			}, "json");
		});
	}

	// 创建一个Datatable
	var editRoleTable = $('#editRoleGrid').DataTable({
		ajax : {
			url : ctx + "/system/role/list.action",
			async:false
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : false,
		pageLength : 10,
		serverSide : true,//如果是服务器方式，必须要设置为true
		//        processing: true,//设置为true,就会有表格加载时的提示
		columns : [ {
			"data" : "id"
		}, //各列对应的数据列
		{
			"data" : "roleName"
		}, {
			"data" : "description"
		} ],
		columnDefs : [ {
			targets : 0, // checkBox
			render : function(data, type, row) {
				return '<input type="checkbox" name="checkThis" class="icheck" id="' + data + '">';
			}
		} ],
		"drawCallback" : function(settings) {
			$('.icheck').iCheck({
				labelHover : false,
				cursor : true,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});

			// 全选 TODO
			$('#chkall').on('ifChecked', function(event) {
				$('input.icheck').iCheck('check');
			});

			$('#chkall').on('ifUnchecked', function(event) {
				$('input.icheck').iCheck('uncheck');
			});
		}
	});

	$('#editRoleGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 打开授权页面
	function onGrant(userId, username) {
		editRoleTable.ajax.reload();
		if (username.length > 20) {
			username = username.substring(0, 20) + '...';
		}

		$('#grantUserId').val(userId);
		var setting = {
			treeId : "id",
			async : {
				enable : true,
				url : ctx + "/system/access/userPrivilege.action?id=" + userId,
				type : "post"
			},
			check : {
				enable : true,
				chkDisabledInherit : true,
				nocheckInherit : true
			},
			data : {
				key : {
					name : "text",
				}
			},
			callback : {
				onAsyncSuccess : function() { // 展开一级二级节点
					var treeObj = $.fn.zTree.getZTreeObj("editPrivilegeTree");
					//					treeObj.expandAll(true);
					var root = treeObj.getNodeByParam("id", "ROOT");
					var root1 = treeObj.getNodeByParam("id", "ROOT_1");
					var root2 = treeObj.getNodeByParam("id", "ROOT_2");
					treeObj.expandNode(root, true);
					treeObj.expandNode(root1, true);
					treeObj.expandNode(root2, true);
				},
				onClick : function(event, treeId, treeNode) { // 单击节点刷新列表
				//					refreshTable(treeNode.id);
				}
			}
		};
		var zTreeObj = $.fn.zTree.init($("#editPrivilegeTree"), setting);

		// 添加选中事件
		$.post(ctx + "/system/user/roleIdsAndPrivilegeIds.action?id=" + userId, {}, function(data) {
			if (data != null && data.length > 0) {
				var data = eval('(' + data + ')');
				for (var x = 0; x < data.roleIds.length; x++) {
					var checkId = "#" + data.roleIds[x];
					$(checkId).iCheck('check');
				}
			}
		});

		$.openWin({
			title : '用户 ' + username + ' 授权',
			content : $("#winGrant"),
			btnAlign : 'c',
			area : [ '1000px', '600px' ],
			yes : function(index, layero) {
				grantUser(index);
			}
		});
	}

	// 授权
	function grantUser(index) {
		var treeObj = $.fn.zTree.getZTreeObj("editPrivilegeTree");
		var selectedPrivileges = treeObj.getCheckedNodes(true);
		var param = "";
		if (selectedPrivileges != null) {
			for (var i = 0; i < selectedPrivileges.length; i++) {
				if (!selectedPrivileges[i].attributes) {

				} else {
					param = param + selectedPrivileges[i].id;
					if (i < selectedPrivileges.length - 1) {
						param = param + ";";
					}
				}
			}
		}
		$('#privilegeIds').val(param);
		// 获取选中角色 
		var allRoleId = "";
		$("input[name='checkThis']:checkbox").each(function() {
			if (true == $(this).is(':checked')) {
				allRoleId += $(this).attr("id") + ";";
			}
		});
		var noRole = false;
		if (allRoleId.length > 0) {
			allRoleId = allRoleId.substring(0, allRoleId.length - 1);
		} else {
			noRole = true;
		}
		$('#roleIds').val(allRoleId);
		var grantUserForm = $("#grantUserForm").serialize();
		$.post(ctx + "/system/user/grant.action", grantUserForm, function(data) {
			if (!data.result) {
				$.alert('用户授权失败!');
			} else {
				var message = "授权成功!";
				if (noRole) {
					message = '授权成功，但是没有给用户授权任何角色！'
				}
				$.alert(message);
				layer.close(index);
			}
		}, "json");
	}

	return {
		"conditionReset" : conditionReset,
		"conditionSearch" : conditionSearch,
		"userEnable" : userEnable,
		"deleteUser" : deleteUser,
		"onAddUser" : onAddUser,
		"addUser" : addUser,
		"onEditUser" : onEditUser,
		"editUser" : editUser,
		"resetPassword" : resetPassword,
		"onGrant" : onGrant,
		"grantUser" : grantUser
	};

})();
