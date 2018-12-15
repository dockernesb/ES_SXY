var co = (function() {
	
	var businessId = $("#businessId").val() || "";
	var detailId = $("#detailId").val();
	var status = $("#status").val();
	var dataTable = $("#dataTable").val();
	var thirdId = $("#thirdId").val();

	$("#backBtn,#backBtn2").click(function() {
		$("div#applyDetailDiv").hide();
		$("div#mainListDiv").show();
		var selectArr = recordSelectNullEle();
		$("div#mainListDiv").prependTo('#topDiv');
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	});
	
	$.post(ctx + "/centerObjection/getCreditDetail.action", {
		"thirdId" : thirdId,
		"dataTable" : dataTable
	}, function(json) {
		if (json.length > 0) {
			for (var i=0; i<json.length; i++) {
				var row = json[i];
				var label = row.COLUMN_COMMENTS || "";
				var text = row.DATA || "";
				$("#nrzs").append('<tr><th>' + label + '</th><td>' + text + '</td></tr>');
			}
		}
	}, "json");
	
	function viewHistory() {
		$.post(ctx + "/centerObjection/viewHistory.action", {
			businessId : detailId,
			thirdId : thirdId
		}, function(list) {
			$("#historyDiv .form-group:not(:first)").remove();
			if (list.length > 0) {
				var html = '';
				for (var i=0, len=list.length; i<len; i++) {
					var field = list[i];
					html += '<div class="form-group">'
						 + '<label class="control-label col-md-3">' + (field.label || '') + '</label>'
						 + '<div class="col-md-4"><input class="form-control" readonly="readonly" value="' 
						 + (field.oldValue || '') + '" /></div>'
						 + '<div class="col-md-4"><input class="form-control" readonly="readonly" value="' 
						 + (field.newValue || '') + '" /></div>'
						 + '</div>';
				}
				$("#historyDiv #historyForm").append(html);
			}
			$.openWin({
				title : "信用数据查看",
				area : [ '900px', '550px' ],
				content : $("#historyDiv"),
				btn : ["关闭"],
				yes : function(index) {
					layer.close(index);
				}
			});
		}, "json");
	}
	
	return {
		viewHistory : viewHistory
	}

})();