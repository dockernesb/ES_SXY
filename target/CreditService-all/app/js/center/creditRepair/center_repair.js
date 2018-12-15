(function() {
	
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
	
	$.post(ctx + "/centerRepair/getCreditDetail.action", {
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

})();