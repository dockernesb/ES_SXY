var dataPermission = (function() {
	
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
					permissionClickRow();
				},
				beforeClick: function(treeId, treeNode, clickFlag) {
					return !treeNode.isParent;	//当是父节点 返回false 不让选取
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
		
		function saveOrUpdate(){
            var parms = {};
            parms.id = $("#id").val();
            parms.dataFilter=$("#dataFilter").val(),
            parms.description=$("#description").val(),
            parms.menuId=$("#menuId").val(),
            parms.menuName=$("#menuName").val();
            if(!parms.menuId){
            	$.alert('请先在左边的树中选择菜单节点！');
            	return;
            }
            $.ajax({
                type:"post",
                dataType:"json",
                contentType:"application/json",
                data:JSON.stringify(parms),
                url:ctx + "/system/datapermission/saveOrUpdate.action",
                success:function(data){
                		if(data.result){
                        	$("#id").val(""+data.id);
                        	$.alert('保存成功!');
                		}
                }
            });
        }


		function permissionClickRow() {
			document.getElementById("formEdit").reset();
	    	$("#id").val("");
			var nodes = zTreeObj.getSelectedNodes();
			
			if (nodes != null && nodes.length > 0) {
				var node = nodes[0];
				
				$('#menuId').val(node.id);
				$("#menuName").val(node.text);
				$.post(ctx + '/system/datapermission/getFilter/'+node.id+'.action',function(data){
	                if(data){
	                	$("#id").val(data.id);
	                    $("#dataFilter").val(data.dataFilter);
	                    $("#description").val(data.description);
	                }
	            });
			} else {
				$.alert('请先在左边的树中选择菜单节点！');
			}
	    }
		
	return {
		saveOrUpdate : saveOrUpdate
	};

})();
