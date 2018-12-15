var promiseAddEnter = (function() {
	var cnlb = $('#cnlb').val(); // 措施类别
	var deptId = $('#deptId').val(); // 部门ID
	
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
	
	$("#searchStatus").select2({
		//allowClear : true,
		placeholder : "黑名单状态",
		language : 'zh-CN'
	});
	
	$("#searchStatus").val(null).trigger("change");

	var startDate = {
		elem : '#startDate',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		min : '1900-01-01', // 最小日期
		istime : false,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#startDate', datas);
			endDate.min = datas; // 开始日选好后，重置结束日的最小日期
			endDate.start = datas // 将结束日的初始值设定为开始日
		}
	};
	var endDate = {
		elem : '#endDate',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		min : '1900-01-01', // 最小日期
		istime : false,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose : function(datas) {
			laydatePH('#endDate', datas);
			startDate.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(startDate);
	laydate(endDate);

	var table = $('#enterGrid').DataTable({
		"deferRender" : true,
		"ordering" : false,
		"searching" : false,
		"lengthChange" : true,
		"autoWidth" : false,
		"columnDefs" : [ {
			"orderable" : false,
			"targets" : 0
		} ],
		"pageLength" : 10,
		ajax : {
			url : CONTEXT_PATH + '/promise/queryList.action?cnlb=' + cnlb + '&deptId=' + deptId, // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : "QYMC"
		}, {
			"data" : "GSZCH"
		}, {
			"data" : "ZZJGDM"
		}, {
			"data" : "TYSHXYDM"
		}, {
			"data" : "CREATE_TIME"
		}, {
			"data" : "CN_FILE", // 承诺附件
			"render" : function(data, type, row) {
				var str = '';
				if (data) {
					str = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="viewPdf(\'' + data.uploadFileId + '\')">预览</a>';
					str += '<a href="javascript:;" class="opbtn btn btn-xs red" onclick="promiseAddEnter.deleteFileInfo(\'' + data.uploadFileId + '\', \'' + data.businessId + '\')">删除</a>';
            	} else {
            		str = '<a href="javascript:;" class="opbtn btn btn-xs blue uploadPdf" id="' + row.ID + '">上传</a>&nbsp;&nbsp;';
            	}
				return str;
			}
		}, {
			"data" : "STATUS", // 黑名单状态
			"render" : function(data, type, row) {
				var str = '';
				if (data == '0') {
					str = '未列入'; 
				} else if (data == '1') {
					str = '已列入'; 
				} else if (data == '2') {
					str = '已过期'; 
				}
				return str;
			}
		}, {
			"data" : "ID",
			"render" : function(data, type, row) {
				var str = '';
				if (row.STATUS == '0') {
					str = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="promiseAddEnter.toPromiseQyHandle(\'' + data + '\', this);">处理</a>';
				} else {
					str = '<a href="javascript:;" class="opbtn btn btn-xs blue" onclick="promiseAddEnter.toPromiseQyView(\'' + data + '\', this)">查看</a>';
				}
				str +='<a href="javascript:;" class="opbtn btn btn-xs red" onclick="promiseAddEnter.removeEnt(\'' + data + '\', this)">删除</a>';
				return str;
			}
		} ],
        initComplete : function(settings, json) {
        	addUploadBtnListener();
        },
        drawCallback : function(settings, json) {
        	addUploadBtnListener();
        }
	});

	$('#enterGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});
	
	// 查询按钮
	function conditionSearch(type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["searchQymc"] = $.trim($('#searchQymc').val());
			data["searchGszch"] = $.trim($('#searchGszch').val());
			data["searchZzjgdm"] = $.trim($('#searchZzjgdm').val());
			data["searchTyshxydm"] = $.trim($('#searchTyshxydm').val());
			data["searchStatus"] = $.trim($('#searchStatus').val());
			data["startDate"] = $.trim($('#startDate').val());
			data["endDate"] = $.trim($('#endDate').val());
			table.ajax.reload(function() {
				addUploadBtnListener();
			}, type==1?true:false);
		}
	}
	
	function addUploadBtnListener() {
		$("a.uploadPdf").uploadFile({
    		supportTypes : ["pdf"],
    		showList : false,
    		multiple : false,
    		callback : function(fileInfo, $self) {
    			if (fileInfo.success.length > 0) {
    				saveFileInfo(fileInfo, $self);
    			}
    		}
    	});
	}
	
	//	保存文件信息
	function saveFileInfo(fileInfo, $self) {
		loading();
		$.post(ctx + "/promise/saveFileInfo.action", {
			"businessId" : $self.attr("id"),
			"fileName" : fileInfo.success[0].name,
			"filePath" : fileInfo.success[0].path,
			"icon" : fileInfo.success[0].icon
		}, function(result) {
			loadClose();
			conditionSearch();
			if (result.result) {
				$.alert("操作成功！", 1);
			} else {
				$.alert(result.message, 2);
			}
		}, "json");
	}
	
	//	删除文件信息
	function deleteFileInfo(uploadFileId, businessId) {
		layer.confirm("确定删除承诺附件吗？", {
			icon : 3,
		}, function(index) {
			loading();
			$.post(ctx + "/promise/deleteFileInfo.action", {
				"uploadFileId" : uploadFileId,
				"businessId" : businessId
			}, function(result) {
				loadClose();
				conditionSearch();
				if (result.result) {
					$.alert("操作成功！", 1);
				} else {
					$.alert(result.message, 2);
				}
			}, "json");
		});
	}
	
	// 重置
	function conditionReset() {
		resetSearchConditions('#searchQymc,#searchGszch,#searchZzjgdm,#searchTyshxydm,#searchStatus,#startDate,#endDate');
	    resetDate(startDate,endDate);
	}
	
	// 跳转到查看详细
	function toViewEnterDetail(enterId) {
		var url = CONTEXT_PATH + '/promise/toViewEnterDetail.action?enterId=' + enterId + '&supvId=' + supvId;
		$("div#mainContent").load(url);
	}

	// 手工录入
	function manualAdd() {
		$('#addEnterForm')[0].reset();
		$.openWin({
			title : '手动录入企业',
			content : $("#winAdd"),
			btnAlign : 'c',
			area : [ '600px', '388px' ],
			yes : function(index, layero) {
				manualAddSub(index);
			}
		});
	}

	// 手工录入 提交
	function manualAddSub(index) {
		var zzjgdm = $.trim($('#zzjgdm').val());
		var qymc = $.trim($('#qymc').val());
		var gszch = $.trim($('#gszch').val());
		var shxydm = $.trim($('#shxydm').val());
		if (isNull(qymc)) {
			$.alert("请填写企业名称!");
			return;
		}
		if (isNull(shxydm) && (isNull(gszch) || isNull(zzjgdm))) {
			$.alert("请填写统一社会信用代码, 若没有请填写组织机构代码和工商注册号!");
			return;
		}
		loading();
		var formVal = $("addEnterForm").serialize();
		$.post(CONTEXT_PATH + '/promise/manualAdd.action', {
			qymc : qymc,
			tyshxydm : shxydm,
			zzjgdm : zzjgdm,
			gszch : gszch,
			cnlb : cnlb,
			deptId : deptId
		}, function(data) {
			loadClose();
			layer.close(index);
			conditionSearch();
			if (data.result) {
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

	// 批量上传
	function batchAdd(filePathStr, fileNameStr) {
		loading();
		$.post(CONTEXT_PATH + '/promise/batchAdd.action', {
			cnlb : cnlb,
			deptId : deptId,
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
				content : '<div style="padding:10px 20px;">' + data.message + '</div>'
			});
			loadClose();
		}, "json");
	}

	// 下载模板
	function templateDownload() {
		loading();
		window.location.href = CONTEXT_PATH + "/promise/templateDownload.action";
		loadClose();
	}

	// 删除企业
	function removeEnt(id, _this) {
		addDtSelectedStatus(_this);
		layer.confirm('确认要删除此企业吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(CONTEXT_PATH + "/promise/reomveEnter.action", {
				id : id
			}, function(data) {
				loadClose();
				if (data.result) {
					$.alert('删除成功!', 1);
					conditionSearch();
				} else {
					$.alert('删除失败!', 2);
				}
			}, "json");
		});
	}

	// 返回
	function goback() {
        $("div#childDiv").hide();
        $("div#fatherDiv").prependTo("#topBox");
        $("div#fatherDiv").show();
        cpl.listTable.ajax.reload();
        resetIEPlaceholder();
	}
	
	//	承诺处理
	function toPromiseQyHandle(id, _this) {
		addDtSelectedStatus(_this);
		var url = ctx + "/promise/toPromiseQyHandle.action?id=" + id;
        $("div#child_childDiv").html("");
        $("div#child_childDiv").load(url);
        $("div#child_childDiv").prependTo("#childTopBox");
        $("div#child_fatherDiv").hide();
        $("div#child_childDiv").show();
        resetIEPlaceholder();
	}
	
	//	查看承诺处理
	function toPromiseQyView(id, _this) {
		addDtSelectedStatus(_this);
		var url = ctx + "/promise/toPromiseQyView.action?id=" + id + "&from=2";
        $("div#child_childDiv").html("");
        $("div#child_childDiv").load(url);
        $("div#child_childDiv").prependTo("#childTopBox");
        $("div#child_fatherDiv").hide();
        $("div#child_childDiv").show();
        resetIEPlaceholder();
	}

	return {
		"goback" : goback,
		"manualAdd" : manualAdd,
		"removeEnt" : removeEnt,
		"toViewEnterDetail" : toViewEnterDetail,
		"conditionSearch" : conditionSearch,
		"conditionReset" : conditionReset,
		"templateDownload" : templateDownload,
		"deleteFileInfo" : deleteFileInfo,
		"toPromiseQyHandle" : toPromiseQyHandle,
		"toPromiseQyView" : toPromiseQyView,
		"table" : table
	};

})();