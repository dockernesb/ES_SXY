(function() {
	
	var setting = {
		treeId : "id",
		async : {
			enable : true,
			url : ctx + "/system/access/tree.action",
			type : "post"
		},
		data : {
			key : {
				name : "text",
			}
		},
		callback : {
			onAsyncSuccess : function() {	//	展开一级二级节点
				var treeObj = $.fn.zTree.getZTreeObj("menuTree");
				allNodes = treeObj.transformToArray(zTreeObj.getNodes());
				expandTreeNode();
			},
			onClick : function(event, treeId, treeNode) {	//	单击节点刷新列表
				refreshTable(treeNode.id);
			}
		}
	};
	
	function expandTreeNode() {
		var treeObj = $.fn.zTree.getZTreeObj("menuTree");
		var root = treeObj.getNodes()[0];
		treeObj.expandNode(root, true);
		var children = root.children;
		if (children) {
			for (var i=0, len = children.length; i<len; i++) {
				var child = children[i];
				treeObj.expandNode(child, true);
			}
		}
	}
	
	var zTreeObj = $.fn.zTree.init($("#menuTree"), setting);
	var allNodes = [];
	var oldText = "";
	
	$("#searchTree").keyup(function() {
		$("#searchTreeMsg").hide();
        var val = $.trim($(this).val());
        zTreeObj.showNodes(allNodes);
        if (val != "") {
            var nodes = zTreeObj.getNodesByParamFuzzy("text", val);
            
            if (nodes.length == 0) {
            	$("#searchTreeMsg").show();
            }
            
            for (var i=0, len=nodes.length; i<len; i++) {
                var node = nodes[i];
                node["searchType"] = true;
                getParents(node);
            }
            
            for (var i=0, len=allNodes.length; i<len; i++) {
                var node = allNodes[i];
                if (!node["searchType"]) {
                    zTreeObj.hideNode(node);
                } else {
                    node["searchType"] = false;
                }
            }
            zTreeObj.expandAll(true);
        } else if (oldText != "") {
        	zTreeObj.expandAll(false);
        	expandTreeNode();
        }
        oldText = val;
    });
	
    function getParents(node) {
        var parent = node.getParentNode();
        if (parent && !parent["searchType"]) {
            parent["searchType"] = true;
            getParents(parent);
        }
    }
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/system/access/list.action"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "privilegeName"}, //各列对应的数据列
            {"data" : "privilegeCode"}, 
            {"data" : "description"}
        ]
    });
	
	$('#dataTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});
	
	function format ( d ) {
		var str = '<table class="table-detail">';
		str += '<tr><th>功能权限URL</th></tr>';
		var url = d.url;
		if (url) {
			var arr = url.split(",");
			for (var i = 0, len = arr.length; i < len; i++) {
				var t = arr[i];
				str += '<tr><td>' + t + '</td></tr>';
			}
		}
		str += '</table>';
	    return str;
	}
	
	$('#dataTable tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        var row = table.row( tr );
        if ( row.child.isShown() ) {	// This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        } else {	// Open this row
            row.child( format(row.data()) ).show();
            tr.addClass('shown');
        }
    });
	
	function refreshTable(id) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["parentId"] = id;
			table.ajax.reload(null,false);// 刷新列表还保留分页信息
		}
	}
	
	$("#addAccessBtn").click(function() {
		var nodes = zTreeObj.getSelectedNodes();
		if (nodes.length > 0) {
			var node = nodes[0];
			if (node.attributes != null && node.attributes == 'available') {
				$("#menuIdAdd").val(node.id);
				$("#privilegeCodeAdd").val("");
				$("#privilegeNameAdd").val("");
				$("#descriptionAdd").val("");
				$.openWin({
					title: '新增功能权限',
					area : [ '600px', '380px' ],
					content: $("#accessAddDiv"),
					yes: function(index, layero) {
						addAccess(index, node.id);
					}
				});
				addValidator.form();
			} else {
				$.alert('请选择功能权限树的叶子节点进行功能权限添加！');
			}
		} else {
			$.alert('请先在左边的树中选择功能权限叶子节点!');
		}
	});
	
	function addAccess(index, menuId) {
		if (!addValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
        var accessAddForm = $("#accessAddForm").serialize();
        $.post(ctx + "/system/access/addAccess.action", accessAddForm, function (data) {
        	loadClose();
            if (!data.result) {
            	$.alert(data.message, 2);
            } else {
				layer.close(index);
                $.alert(data.message, 1);
                zTreeObj.reAsyncChildNodes(null, "refresh");
                resetSearchConditions('#searchTree');
                refreshTable(menuId);
            }
        }, "json");
	}
	
	$("#editAccessBtn").click(function() {
		var nodes = table.rows('.active').data();
		if (nodes.length == 1) {
			var node = nodes[0];
			$("#privilegeIdEdit").val(node.privilegeId);
			$("#menuIdEdit").val(node.menuId);
			$("#privilegeCodeEdit").val(node.privilegeCode);
			$("#privilegeNameEdit").val(node.privilegeName);
			$('#privilegeOldName').val(node.privilegeName);
			$("#descriptionEdit").val(node.description);
			$.openWin({
				title: '修改功能权限',
				area : [ '600px', '380px' ],
				content: $("#accessEditDiv"),
				yes: function(index, layero) {
					editAccess(index, node.menuId);
				}
			});
			editValidator.form();
		} else {
			$.alert('请在列表中选择要修改的功能权限项!');
		}
	});
	
	function editAccess(index, menuId) {
		if (!editValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
        var accessEditForm = $("#accessEditForm").serialize();
        $.post(ctx + "/system/access/editAccess.action", accessEditForm, function (data) {
        	loadClose();
        	if (!data.result) {
        		$.alert(data.message, 2);
        	} else {
        		layer.close(index);
        		$.alert(data.message, 1);
        		zTreeObj.reAsyncChildNodes(null, "refresh");
        		resetSearchConditions('#searchTree');
                refreshTable(menuId);
        	}
        }, "json");
    }
	
	$("#delAccessBtn").click(function() {
		var nodes = zTreeObj.getSelectedNodes();
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
        	var node = gridNodes[0];
        	layer.confirm('删除此功能权限会解除相关的授权项目, 确认要删除此功能权限吗?', {icon : 3}, function(index) {
        		layer.close(index);
        		loading();
                $.post(ctx + "/system/access/deleteAccess.action", {id: node.privilegeId}, function(data) {
                	loadClose();
                	if (!data.result) {
                		$.alert(data.message, 2);
                    } else {
                    	$.alert(data.message, 1);
                    }
                	zTreeObj.reAsyncChildNodes(null, "refresh");
                	resetSearchConditions('#searchTree');
                	var menuId = nodes[0].id || "ROOT";
                    refreshTable(menuId);
                }, "json");
            });
        } else {
            $.alert('请在列表中选择要删除的功能权限项!');
        }
	});
	
	var rules = {
		privilegeCode: {
			required: true,
			notchineseG: [],
			illegalCharacter: ["."],
			unblank: [],
            maxlength: 100
        },
        privilegeName: {
        	required: true,
        	unblank: [],
        	maxlength: 15
        },
        url: {
        	required: true,
        	notchineseG: [],
        	illegalCharacter: ["/.,"],
        	unblank: [],
        	maxlength: 300
        },
        description: {
            maxlength: 250
        }
	};
	
	var addValidator = $('#accessAddForm').validateForm(rules);
	var editValidator = $('#accessEditForm').validateForm(rules);
	
})();