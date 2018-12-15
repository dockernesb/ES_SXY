var role = (function() {
	var rules = {
		roleName : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 50
		},
		description : {
			illegalChar : [],
			maxlength : 200
		},
	};
	var addValidator = $('#roleAddForm').validateForm(rules);
	var editValidator = $('#roleEditForm').validateForm(rules);
	
	var table = $('#roleGrid').DataTable({
		// "scrollX": true,
		"deferRender" : true,
		"ordering" : false,
		"searching" : false,
		"lengthChange" : true,
		"autoWidth" : false,
		"stateSave" : false,
		"columnDefs" : [ {
			"orderable" : false,
			"targets" : 0
		} ],
		"pageLength" : 10, // 显示5项结果
		ajax : { // 通过ajax访问后台获取数据
			"url" : CONTEXT_PATH + '/system/role/list.action', // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : "roleName"
		}, {
			"data" : "description", "render": function(data, type, full) {
            	var desc = "";
            	if (full.description) {
            		desc = full.description.replace(/\s+/g,"&nbsp;");   
            	}
            	var str = "<span title="+(desc||'')+">" + data + "</span>";
        		return str;
			}
		}, {
			"data" : "createBy"
		}, {
			"data" : "createDate"
		}, {
			"data" : "updateBy"
		}, {
			"data" : "updateDate"
		}, {
			"data" : "id"
		}],
		columnDefs : [ {
			targets : 6, // 操作
			render : function(data, type, row) {
				var str = '';
				str += '<button type="button" class="btn blue btn-xs" onclick="role.onEditRole(\'' + row.id + '\', this);"><i class="fa fa-edit"></i> 修改</button>';
				if (hasDeletePerm == 1) {
					str += '<button type="button" class="btn red btn-xs" onclick="role.deleteRole(\'' + row.id + '\', this);"><i class="fa fa-trash-o"></i> 删除</button>';
				}
				return str;
			}

		} ],
		"drawCallback" : function(settings) {
		}
	});
	
	$('#roleGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 删除角色
	function deleteRole(id, _this) {
		addDtSelectedStatus(_this);
		layer.confirm('删除后, 此角色下的用户不再拥有此角色对应的权限, 确认要删除吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(ctx + "/system/role/deleteRole.action?id=" + id, {}, function(data){
				loadClose();
        		var data = eval('(' + data + ')');
    	        if (!data.result){
    	        	$.alert('删除角色失败!', 2);
    	        } else {
    	        	$.alert('删除角色成功!', 1);
    	        	table.ajax.reload(null,false);// 刷新列表还保留分页信息
    	        }
        	});
		});
	}

	// 打开新建界面
	function onAddRole() {
		$('#roleAddForm')[0].reset();
		var setting = {
			treeId : "id",
			async : {
				enable : true,
				url : ctx + "/system/access/privilegeList.action",
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
					var treeObj = $.fn.zTree.getZTreeObj("addPrivilegeTree");
					var root = treeObj.getNodeByParam("id", "ROOT");
					var root1 = treeObj.getNodeByParam("id", "ROOT_1");
					var root2 = treeObj.getNodeByParam("id", "ROOT_2");
					treeObj.expandNode(root, true);
					treeObj.expandNode(root1, true);
					treeObj.expandNode(root2, true);
				},
				onClick : function(event, treeId, treeNode) { // 单击节点刷新列表
				}
			}
		};
		var zTreeObj = $.fn.zTree.init($("#addPrivilegeTree"), setting);

		$.openWin({
			title : '新增角色',
			content : $("#winAdd"),
			btnAlign : 'c',
			area : [ '600px', '610px' ],
			yes : function(index, layero) {
				addRole(index);
			}
		});
		addValidator.form();
	}

	// 提交 新建
	function addRole(index) {
		if (!addValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}

		loading();
    	var treeObj = $.fn.zTree.getZTreeObj("addPrivilegeTree");
		var selectedPrivileges = treeObj.getCheckedNodes(true);
		var param = "";
		if (selectedPrivileges != null) {
			for (var i = 0; i < selectedPrivileges.length; i++) {
				if (selectedPrivileges[i].attributes && selectedPrivileges[i].attributes.indexOf("cid") >= 0) {
					param = param + selectedPrivileges[i].id;
					if (i < selectedPrivileges.length - 1) {
						param = param + ";";
					}
				}
			}
		}
		$('#addPrivilegeIds').val(param);
		var roleAddForm = $("#roleAddForm").serialize();
		$.post(ctx + "/system/role/addRole.action", roleAddForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert("角色名称已经存在！");
			} else {
				$.alert("新增角色成功！");
				layer.close(index);
				table.ajax.reload(null,false);// 刷新列表还保留分页信息
			}
		}, "json");
	}

	// 打开修改页面
	function onEditRole(id, _this) {
		addDtSelectedStatus(_this);
		$('#roleEditForm')[0].reset();
		var setting = {
			treeId : "id",
			async : {
				enable : true,
				url : ctx + "/system/access/rolePrivilege.action?id=" + id,
				type : "post"
			},
			check : {
				enable : true,
				chkDisabledInherit : true,
				nocheckInherit : true
			},
			data : {
				key : {
					name : "text"
				}
			},
			callback : {
				onAsyncSuccess : function() { // 展开一级二级节点
					var treeObj = $.fn.zTree.getZTreeObj("editPrivilegeTree");
					var root = treeObj.getNodeByParam("id", "ROOT");
					var root1 = treeObj.getNodeByParam("id", "ROOT_1");
					var root2 = treeObj.getNodeByParam("id", "ROOT_2");
					treeObj.expandNode(root, true);
					treeObj.expandNode(root1, true);
					treeObj.expandNode(root2, true);
//					treeObj.updateNode(node);
					
				},
				onClick : function(event, treeId, treeNode) { // 单击节点刷新列表
				}
			}
		};
		var zTreeObj = $.fn.zTree.init($("#editPrivilegeTree"), setting);
		
		$.getJSON(ctx + "/system/role/onEdit.action", {
			id : id
		}, function(data) {
			loadClose();
			$('#roleId').val(id);
			$('#roleName').val(data.roleName);
			$('#description').val(data.description);
			$.openWin({
				title : '修改角色',
				content : $("#winEdit"),
				btnAlign : 'c',
				area : [ '600px', '520px' ],
				yes : function(index, layero) {
					editRole(index);
				}
			});
			editValidator.form();
		});
	}
	// 修改角色
	function editRole(index) {
		if (!editValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
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
		$('#editPrivilegeIds').val(param);
		var roleEditForm = $("#roleEditForm").serialize();
		$.post(ctx + "/system/role/editRole.action", roleEditForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert("角色名称已经存在！");
			} else {
				$.alert("修改角色成功！");
				layer.close(index);
				table.ajax.reload(null,false);// 刷新列表还保留分页信息
			}
		}, "json");
	}

	return {
		"deleteRole" : deleteRole,
		"onAddRole" : onAddRole,
		"addRole" : addRole,
		"onEditRole" : onEditRole,
		"editRole" : editRole
	};
})();