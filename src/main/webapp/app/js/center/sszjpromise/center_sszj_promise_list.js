var cpl = (function() {
	
	var ownerDeptId = $("#ownerDeptId").val();
	
	$.getJSON(ctx + "/system/dictionary/listValues.action", {
		"groupKey" : "cnlb"
	}, function(result) {
		var html = '';
		if (result.items) {
			for (var i=0, len=result.items.length; i<len; i++) {
				var item = result.items[i];
				html += '<option value="' + item.id + '">' + item.text + '</option>';
			}
			$("#cnlbKey").append(html);
		}
		$("#cnlbKey").select2({
			placeholder : '承诺类别',
			language : 'zh-CN',
			minimumResultsForSearch : -1
		});
		resizeSelect2($("#cnlbKey"));
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
	});
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/sszj_promise/getPromiseList.action",
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
            {"data" : "DICT_VALUE"},
            {"data" : "QY_COUNT"}, 
            {"data" : "UPDATE_TIME"},
            {"data" : "CN_FILE", "render": function(data, type, full) {
            	var opts = '';
            	if (ownerDeptId == full.DEPT_ID && !data) {
                	opts = '<a href="javascript:;" class="opbtn btn btn-xs blue uploadPdf" id="' + full.ID + '">上传</a>';
            	}
            	if (data) {
            		opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="viewPdf(\'' + data.uploadFileId + '\')">预览</a>';
            		opts += '<a href="javascript:;" class="opbtn btn btn-xs red" onclick="cpl.deleteFileInfo(\'' + data.uploadFileId + '\', \'' + data.businessId + '\', this)">删除</a>';
            	}
				return opts;
			}}, 
            {"data" : "ID", "render": function(data, type, full) {
            	var opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="cpl.toPromiseQyList(\'' + full.DICT_KEY + '\', \'' + full.DEPT_ID + '\', this)">管理承诺企业</a>';
				return opts;
			}}
        ],
        initComplete : function(settings, json) {
        	addUploadBtnListener();
        }
    });
	
	$('#dataTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});
	
	function refreshTable(cnlbKey) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["cnlbKey"] = cnlbKey || "";
			table.ajax.reload(function() {
				addUploadBtnListener();
			});
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
		$.post(ctx + "/sszj_promise/saveFileInfo.action", {
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
	
	//	删除文件信息
	function deleteFileInfo(uploadFileId, businessId, _this) {
		addDtSelectedStatus(_this);
		layer.confirm("确定删除承诺细则吗？", {
			icon : 3,
		}, function(index) {
			loading();
			$.post(ctx + "/sszj_promise/deleteFileInfo.action", {
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
	
	//	搜索
	function conditionSearch() {
		var cnlbKey = $('#cnlbKey').val();
		refreshTable(cnlbKey);
	}

	//		重置
	function conditionReset() {
		resetSearchConditions('#cnlbKey');
	}
	
	//	管理承诺企业
	function toPromiseQyList(cnlb, deptId, _this) {
		addDtSelectedStatus(_this);
		url = ctx + "/sszj_promise/toPromiseQyList.action?cnlb=" + cnlb + "&deptId=" + deptId;
        $("div#childDiv").html("");
        $("div#childDiv").load(url);
        $("div#childDiv").prependTo("#topBox");
        $("div#fatherDiv").hide();
        $("div#childDiv").show();
        resetIEPlaceholder();
	}
	
	return {
		listTable : table,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		toPromiseQyList : toPromiseQyList,
		deleteFileInfo : deleteFileInfo
	};
	
})();