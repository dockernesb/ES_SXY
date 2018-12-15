(function() {
	
	var businessId = $("#businessId").val() || "";
	var status = $("#status").val();
	var dataTable = $("#dataTable").val();
	var thirdId = $("#thirdId").val();

	var steps = [ {
		title : "前台已受理",
		content : "前台已受理"
	}, {
		title : "待审核",
		content : "待中心审核"
	}, {
		title : "待核实",
		content : "待部门核实"
	} ];

	if (status == 3) { //	3:未通过
		steps.push({
			title : "审核不通过",
			content : "审核不通过"
		});
	} else {
		steps.push({
			title : "审核通过",
			content : "审核通过"
		});
		steps.push({
			title : "已修正",
			content : "已修正"
		});
	}

	steps.push({
		title : "流程结束",
		content : "流程结束"
	});

	$("#stepDiv").loadStep({
		//ystep的外观大小
		//可选值：small,large
		size : "large",
		//ystep配色方案
		//可选值：green,blue
		color : "blue",
		//ystep中包含的步骤
		steps : steps
	});
	
	if (status == 0) { //	0:待审核
		$("#stepDiv").setStep(2);
	} else if (status == 1) {//	1:待核实
		$("#stepDiv").setStep(3);
	} else if (status == 2) {//	2:已通过
		$("#stepDiv").setStep(4);
	} else if (status == 3) {//	3:未通过
		$("#stepDiv").setStep(5);
	} else if (status == 4) {//	4:已完成
		$("#stepDiv").setStep(6);
	}

	$("#backBtn,#backBtn2").click(function() {
		$("div#applyDetailDiv").hide();
		$("div#mainListDiv").show();
		var selectArr = recordSelectNullEle();
		$("div#mainListDiv").prependTo('#topDiv');
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	});
	
	$.post(ctx + "/hallRepair/getCreditDetail.action", {
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