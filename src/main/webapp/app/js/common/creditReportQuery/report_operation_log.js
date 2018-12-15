	// 信用报告操作日志Js
var reportOperationLog = (function() {
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
        columns : [{
			 render : function(data, type, row, meta) {
					// 显示行号
					var startIndex = meta.settings._iDisplayStart;
					return startIndex + meta.row + 1;
			 }
		},{
			"data" : "businessName"
		},{
			"data" : "operationUser.username"
		}, {
			"data" : "operationDate"
		}]
    });
	
   $(function(){
		initTable();
	})
	
	

  // 初始化表格数据
	function initTable(){
		$.post(ctx + "/reportQuery/queryReportOperationLog.action", {
			"applyId" : applyId
		}, function(result) {
			table.rows.add(result).draw();
		}, "json");
	}
	
	function goBack() {
		$("div#mainListDiv").show();
		$("div#applyDetailDiv").hide();
		$("div#operationLogDiv").hide();
		var selectArr = recordSelectNullEle();
		$("div#mainListDiv").prependTo('#topDiv');
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	}
	
	return {
		"goBack" : goBack
	};

	
})();