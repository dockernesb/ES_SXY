(function() {
	
	var setting = {
		treeId : "id",
		async : {
			enable : true,
			url : ctx + "/common/tree.action",
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
            url: ctx + "/system/menu/list.action"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "menuName"}, //各列对应的数据列
            {"data" : "menuUrl"}, 
            {"data" : "menuIcon"}, 
            {"data" : "displayOrder"} 
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
	
	$("#addMenuBtn").click(function() {
		var nodes = zTreeObj.getSelectedNodes();
		if (nodes.length > 0) {
			var node = nodes[0];
			$("#parentIdAdd").val(node.id);
			$("#currentNameAdd").val(node.text);
			$("#menuNameAdd").val("");
			$("#menuUrlAdd").val("");
			$("#menuIconAdd").val("");
			$("#displayOrderAdd").val("");
			$.openWin({
				title: '新增子菜单',
				content: $("#menuAddDiv"),
				yes: function(index, layero) {
					addMenu(index);
				}
			});
			addValidator.form();
		} else {
			$.alert('请先在左边的树中选择菜单节点!');
		}
	});
	
	function addMenu(index) {
		if (!addValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
        var menuAddForm = $("#menuAddForm").serialize();
        $.post(ctx + "/system/menu/addMenu.action", menuAddForm, function (data) {
        	loadClose();
            if (!data.result) {
            	$.alert(data.message, 2);
            } else if(data.result=="exsit"){
            	$.alert('存在相同的排序！', 2);
            }else {
				layer.close(index);
                $.alert(data.message, 1);
                zTreeObj.reAsyncChildNodes(null, "refresh");
                resetSearchConditions('#searchTree');
                refreshTable("ROOT");
            }
        }, "json");
	}
	
	$("#editMenuBtn").click(function() {
		var nodes = table.rows('.active').data();
		if (nodes.length == 1) {
			var node = nodes[0];
			$("#parentIdEdit").val(node.parentId);
			$("#idEdit").val(node.id);
			$("#menuNameEdit").val(node.menuName);
			$("#menuUrlEdit").val(node.menuUrl);
			$("#menuIconEdit").val(node.menuIcon);
			$("#displayOrderEdit").val(node.displayOrder);
			$.openWin({
				title: '修改菜单',
				content: $("#menuEditDiv"),
				yes: function(index, layero) {
					editMenu(index);
				}
			});
			editValidator.form();
		} else {
			$.alert('请在列表中选择要修改的菜单项!');
		}
	});
	
	function editMenu(index) {
		if (!editValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
        var menuEditForm = $("#menuEditForm").serialize();
        $.post(ctx + "/system/menu/editMenu.action", menuEditForm, function (data) {
        	loadClose();
        	if (!data.result) {
        		$.alert(data.message, 2);
        	} else if(data.result=="exsit"){
        		$.alert("存在相同的排序", 2);
        	}else{
        		layer.close(index);
        		$.alert(data.message, 1);
        		zTreeObj.reAsyncChildNodes(null, "refresh");
        		resetSearchConditions('#searchTree');
                refreshTable("ROOT");
        	}
        }, "json");
    }
	
	$("#delMenuBtn").click(function() {
		var treeNodes = zTreeObj.getSelectedNodes();
		var gridNodes = table.rows('.active').data();
		if (treeNodes.length > 0) {
			var node = treeNodes[0];
            layer.confirm('删除此菜单会删除该菜单下的所有子菜单, 确认要删除此菜单吗?', {icon : 3}, function(index) {
            	layer.close(index);
            	loading();
                $.post(ctx + "/system/menu/deleteMenu.action", {id: node.id}, function(data) {
                	loadClose();
                	if (!data.result) {
                		$.alert(data.message, 2);
                    } else {
                    	$.alert(data.message, 1);
                    }
                	zTreeObj.reAsyncChildNodes(null, "refresh");
                	resetSearchConditions('#searchTree');
                    refreshTable("ROOT");
                }, "json");
            });
        } else {
            $.alert('请先在左边的树中选择菜单节点!');
        }
	});
	
	var rules = {
		menuName: {
			required: true,
			unblank: [],
            maxlength: 15
        },
        menuUrl: {
        	illegalCharacter: [":/.?&=#%-"],
        	maxlength: 100
        },
        menuIcon: {
        	illegalCharacter: ["-"],
        	maxlength: 50
        },
        displayOrder: {
            required: true,
            digits: true,
            maxlength: 9
        }
	};
	
	var addValidator = $('#menuAddForm').validateForm(rules);
	var editValidator = $('#menuEditForm').validateForm(rules);
	
})();