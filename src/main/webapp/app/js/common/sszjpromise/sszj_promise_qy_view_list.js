var promiseAddEnter = (function() {
	var CENTER_DEPT_CODE = "A0000"; // 信用中心部门代码
	
	$("#searchStatus").select2({
		placeholder : "黑名单状态"
	});
	
	$("#searchStatus").val(null).trigger("change");

	$.getJSON(ctx + "/system/dictionary/listValues.action", {
		"groupKey" : "cnlb"
	}, function(result) {
		var html = "<option value=' '>全部</option>";
		if (result.items) {
			for (var i=0, len=result.items.length; i<len; i++) {
				var item = result.items[i];
				html += '<option value="' + item.id + '">' + item.text + '</option>';
			}
			$("#cnlbKey").append(html);
		}
		$("#cnlbKey").select2({
			placeholder : "承诺类别"
		});
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		$("#cnlbKey").val(null).trigger("change");
	});
	
	$.getJSON(ctx + "/system/department/getDeptList.action?isIncludedAll=true", function(result) {
		// 初始下拉框
		$("#jgbmId").select2({
			placeholder : '监管部门',
			language : 'zh-CN',
			data : result
		});
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
		resizeSelect2($("#jgbmId"));
		$("#jgbmId").val(null).trigger("change");
	});
	
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
			url : CONTEXT_PATH + '/sszj_promise/queryList.action', // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : "QYMC"
		}, {
			"data" : "TYSHXYDM"
		}, {
			"data" : "ZZJGDM"
		}, {
			"data" : "GSZCH"
		}, {
			"data" : "CREATE_TIME"
		}, {
			"data" : "CNLB"
		}, {
			"data" : "DEPT_NAME"
		}, 
		   {
			"data" : "CN_FILE", // 承诺附件
			"render" : function(data, type, row) {
				var str = '';
				// 信用中心
				if (row.DEPT_CODE == CENTER_DEPT_CODE) {
					if (data) {
						str += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="viewPdf(\'' + data.uploadFileId + '\')">预览</a>';
						str += '<a href="javascript:;" class="opbtn btn btn-xs red" onclick="promiseAddEnter.deleteFileInfo(\'' + data.uploadFileId + '\', \'' + data.businessId + '\')">删除</a>';
	            	} else {
	            		str += '<a href="javascript:;" class="opbtn btn btn-xs blue uploadPdf" id="' + row.ID + '">上传</a>';
	            	}
				} else {
					if (data) {
						str += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="viewPdf(\'' + data.uploadFileId + '\')">预览</a>';
					} else {
						str += '未上传';
					}
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
				
				// 信用中心
				if (row.DEPT_CODE == CENTER_DEPT_CODE) {
					if (row.STATUS != '0') {
						str += '<a href="javascript:;" class="opbtn btn btn-xs blue" onclick="promiseAddEnter.toPromiseQyView(\'' + data + '\', this)">查看</a>';
						str += '<a href="javascript:;" class="opbtn btn btn-xs red" onclick="promiseAddEnter.removeEnt(\'' + data + '\', this)">删除</a>';
					} else {
						str = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="promiseAddEnter.toPromiseQyHandle(\'' + data + '\', this);">处理</a>';
						str += '<a href="javascript:;" class="opbtn btn btn-xs red" onclick="promiseAddEnter.removeEnt(\'' + data + '\', this)">删除</a>';
					}
				} else {
					if (row.STATUS != '0') {
						str += '<a href="javascript:;" class="opbtn btn btn-xs blue" onclick="promiseAddEnter.toPromiseQyView(\'' + data + '\', this)">查看</a>';
					}
				}
				
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
	function conditionSearch() {
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
			data["cnlb"] = $.trim($('#cnlbKey').val());
			data["deptId"] = $.trim($('#jgbmId').val());
			
			table.ajax.reload(function() {
				addUploadBtnListener();
			});
		}
	}

	//	删除文件信息
	function deleteFileInfo(uploadFileId, businessId) {
		layer.confirm("确定删除承诺附件吗？", {
			icon : 3,
		}, function(index) {
			loading();
			$.post(ctx + "/sszj_promise/deleteFileInfo.action", {
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
		resetSearchConditions('#searchQymc,#searchGszch,#searchZzjgdm,#searchTyshxydm,#searchStatus,#startDate,#endDate,#cnlbKey,#jgbmId');
		startDate.min = '1970-01-01';
	    startDate.max = '2099-12-30';
		endDate.min = '1970-01-01';
	    endDate.max = '2099-12-30';
	}

	//	查看承诺处理
	function toPromiseQyView(id, _this) {
		addDtSelectedStatus(_this);
		var url = ctx + "/sszj_promise/toPromiseQyView.action?id=" + id + "&from=1";
        $("div#child_childDiv").html("");
        $("div#child_childDiv").load(url);
        $("div#child_childDiv").prependTo("#childTopBox");
        $("div#child_fatherDiv").hide();
        $("div#child_childDiv").show();
        resetIEPlaceholder();
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
		$.post(ctx + "/sszj_promise/saveFileInfo.action", {
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
	
	//	承诺处理
	function toPromiseQyHandle(id, _this) {
		addDtSelectedStatus(_this);
		var url = ctx + "/sszj_promise/toPromiseQyHandle.action?id=" + id+"&type=1";
        $("div#child_childDiv").html("");
        $("div#child_childDiv").load(url);
        $("div#child_childDiv").prependTo("#childTopBox");
        $("div#child_fatherDiv").hide();
        $("div#child_childDiv").show();
        resetIEPlaceholder();
	}
	
	// 删除企业
	function removeEnt(id, _this) {
		addDtSelectedStatus(_this);
		layer.confirm('确认要删除此企业吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(CONTEXT_PATH + "/sszj_promise/reomveEnter.action", {
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
	
	return {
		"toPromiseQyView" : toPromiseQyView,
		"conditionSearch" : conditionSearch,
		"conditionReset" : conditionReset,
		"toPromiseQyHandle" : toPromiseQyHandle,
		"removeEnt" : removeEnt,
		"deleteFileInfo" : deleteFileInfo,
		"table" : table
	};

})();