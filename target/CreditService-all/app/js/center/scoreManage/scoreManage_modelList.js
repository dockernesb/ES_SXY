var smml = (function() {
	
	//	初始化日期组件
	var start = {
	  elem: '#cjsjs',
	  format: 'YYYY-MM-DD',
	  max: '2099-12-30', //最大日期
	  istime: false,
	  istoday: false,// 是否显示今天
	  isclear : false, // 是否显示清空
	  issure : false, // 是否显示确认
	  choose: function(datas){
		  laydatePH('#cjsjs', datas);
		  end.min = datas; //开始日选好后，重置结束日的最小日期
		  end.start = datas //将结束日的初始值设定为开始日
	  }
	};
	var end = {
	  elem: '#cjsjz',
	  format: 'YYYY-MM-DD',
	  max: '2099-12-30',
	  istime: false,
	  istoday: false,// 是否显示今天
	  isclear : false, // 是否显示清空
	  issure : false, // 是否显示确认
	  choose: function(datas){
		  laydatePH('#cjsjz', datas);
		  start.max = datas; //结束日选好后，重置开始日的最大日期
	  }
	};
	laydate(start);
	laydate(end);
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/center/scoreManage/queryModelList.action",
            type: "post"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "mxbh"},
            {"data" : "mxmc"}, 
            {"data" : "createUser"}, 
            {"data" : "createTime"},
            {"data" : "status", "render": function(data, type, full) {
            	if ("0" == data) {
        			return "已启用";
        		} else if ("1" == data) {
        			return "未启用";
        		}
			}}, 
            {"data" : "mxbh", "render": function(data, type, full) {
            	var opts = '<a href="javascript:;" onclick="smml.viewModel(\'' + data + '\', this);">查看</a>&nbsp;&nbsp;';
            	if (full.status == 1) {
            		opts += '<a href="javascript:;" onclick="smml.handleModel(0, \'' + data + '\', this);">启用</a>'
        		} else {
        			opts += '<a href="javascript:;" onclick="smml.handleModel(1, \'' + data + '\', this);">禁用</a>'
        		}
				return opts;
			}}
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
	
	function refreshTable(mxbh, mxmc, cjr, cjsjs, cjsjz,type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["mxbh"] = mxbh || "";
			data["mxmc"] = mxmc || "";
			data["cjr"] = cjr || "";
			data["cjsjs"] = cjsjs || "";
			data["cjsjz"] = cjsjz || "";
			table.ajax.reload(null, type==1?true:false);
		}
	}
	
	// 查询按钮
	function conditionSearch() {
		var mxbh = $.trim($('#mxbh').val());
		var mxmc = $.trim($('#mxmc').val());
		var cjr = $.trim($('#cjr').val());
		var cjsjs = $("#cjsjs").val();
		var cjsjz = $("#cjsjz").val();
	
		refreshTable(mxbh, mxmc, cjr, cjsjs, cjsjz,1);
	}
	
	// 重置
	function conditionReset() {
		resetSearchConditions("#mxbh,#mxmc,#cjr,#cjsjs,#cjsjz");
		resetDate(start,end);
	}

	// 启用/禁用模板
	function handleModel(status, mxbh, _this) {
		addDtSelectedStatus(_this);
		if (status == 1) {
			layer.confirm('确认要禁用此模板吗?', function(r) {
				if (r) {
					loading();
					$.post(CONTEXT_PATH + "/center/scoreManage/handleModel.action", {
						"status" : "1",
						"mxbh" : mxbh
					}, function(result) {
						loadClose();
						if (result) {
							refreshTable();
							$.alert('禁用模板成功!', 1);
						} else {
							$.alert('禁用模板失败!', 2);
						}
					}, "json");
				}
			});
		} else {
			layer.confirm('确认要启用此模板吗?', function(r) {
				if (r) {
					loading();
					$.post(CONTEXT_PATH + "/center/scoreManage/handleModel.action", {
						"status" : "0",
						"mxbh" : mxbh
					}, function(result) {
						loadClose();
						if (result) {
							refreshTable();
							$.alert('启用模板成功!', 1);
						} else {
							$.alert('启用模板失败!', 2);
						}
					}, "json");
				}
			});
		}
	}

	// 新建模型
	function toAddModel() {
		var url = CONTEXT_PATH + "/center/scoreManage/toAddModel.action";
        $("div#childDiv").html("");
        $("div#childDiv").load(url);
        $("div#childDiv").prependTo("#topBox");
        $("div#fatherDiv").hide();
        $("div#childDiv").show();
        resetIEPlaceholder();
	}
	
	$("#addBtn").click(function() {
		toAddModel();
	});
	
	//	编辑模型
	function toEditModel(mxbh) {
		var url = CONTEXT_PATH + "/center/scoreManage/toEditModel.action?mxbh=" + mxbh;
        $("div#childDiv").html("");
        $("div#childDiv").load(url);
        $("div#childDiv").prependTo("#topBox");
        $("div#fatherDiv").hide();
        $("div#childDiv").show();
        resetIEPlaceholder();
	}
	
	$("#editBtn").click(function() {
		var nodes = table.rows('.active').data();
		if (nodes.length == 1) {
			var node = nodes[0] || {};
			toEditModel(node.mxbh);
		} else {
			$.alert('请在列表中选择要修改的模型!');
		}
	});
	
	//	删除
	function deleteModel(mxbh) {
		layer.confirm('确认要删除此模板吗?', function(r) {
			if (r) {
				loading();
				$.post(CONTEXT_PATH + "/center/scoreManage/deleteModel.action", {
					"mxbh" : mxbh
				}, function(result) {
					loadClose();
					if (result) {
						refreshTable();
						$.alert('删除模板成功!', 1);
					} else {
						$.alert('删除模板失败!', 2);
					}
				}, "json");
			}
		});
	}

	$("#delBtn").click(function() {
		var nodes = table.rows('.active').data();
		if (nodes.length == 1) {
			var node = nodes[0] || {};
			deleteModel(node.mxbh);
		} else {
			$.alert('请在列表中选择要删除的模型!');
		}
	});
	
	//	查看
	function viewModel(mxbh, _this) {
		addDtSelectedStatus(_this);
		var url = CONTEXT_PATH + "/center/scoreManage/toViewModel.action?mxbh=" + mxbh;
        $("div#childDiv").html("");
        $("div#childDiv").load(url);
        $("div#childDiv").prependTo("#topBox");
        $("div#fatherDiv").hide();
        $("div#childDiv").show();
        resetIEPlaceholder();
	}
	
	return {
		"conditionSearch" : conditionSearch,
		"conditionReset" : conditionReset,
		"handleModel" : handleModel,
		"viewModel" : viewModel,
		"table" : table
	};
	
})();

