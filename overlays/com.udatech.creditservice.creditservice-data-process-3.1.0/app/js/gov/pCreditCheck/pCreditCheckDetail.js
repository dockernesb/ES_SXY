// 核查详细Js
var creditCheckDetail = (function() {
	var applyId = $('#applyId').val();
	var table = $('#enterGrid').DataTable({
		// "scrollY": 385,
		"deferRender" : true,
		"ordering" : false,
		"searching" : false,
		"autoWidth" : false,
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		pageLength : 10,
		"columnDefs" : [ {
			"orderable" : false,
			"targets" : 0
		} ],
		"pageLength" : 10, // 显示5项结果
		ajax : { // 通过ajax访问后台获取数据
			url : CONTEXT_PATH + '/gov/pCreditCheck/getEnterList.action?id=' + applyId, // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : null
		}, {
			"data" : "xm"
		}, {
			"data" : "sfzh"
		} ],
		columnDefs : [ {
			"targets" : 0,
			render : function(data, type, row, meta) {
				// 显示行号
				var startIndex = meta.settings._iDisplayStart;
				return startIndex + meta.row + 1;
			}
		} ]
	});

	var status = $('#status').val();
	var path_hcfj = $('#path_hcfj').val();
	if ("1" == status) {
		$("#shyj").css("display", "");
	} else if ("2" == status) {
		$("#shyj").css("display", "");
		if (path_hcfj == "" || path_hcfj == null || path_hcfj == undefined) {
		} else {
			$("#shfj").css("display", "");
		}
	}

	function downLoadReport(filePath, fileName) {
        document.location = CONTEXT_PATH + "/creditCommon/ajaxDownload.action?filePath=" + filePath + "&fileName=" + fileName;
	}
	
	function goBack() {
        $("div#creditCheckList").prependTo("#topBox");
        $("div#creditCheckList").show();
        $("div#creditCheckDetail").hide();
        resetIEPlaceholder();
	}

	return {
		'downLoadReport': downLoadReport,
		"goBack" : goBack
	};

})();