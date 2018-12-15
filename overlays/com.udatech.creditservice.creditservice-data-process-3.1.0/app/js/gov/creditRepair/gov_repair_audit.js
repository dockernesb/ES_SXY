(function() {
	
	var businessId = $("#businessId").val() || "";
	var status = $("#status").val();
	var dataTable = $("#dataTable").val();
	var thirdId = $("#thirdId").val();
	var detailId = $("#detailId").val();

	var validator = $('#submit_form').validateForm({
		bmshyj : {
			required : true,
			maxlength : 500
		}
	});

	validator.form();

	$("#backBtn,#backBtn2").click(function() {
		$("div#parentBox").show();
		$("div#childBox").hide();
		var selectArr = recordSelectNullEle();
		$("div#parentBox").prependTo("#topBox");
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	});

	function saveRepairAudit(status) {
		$.post(ctx + "/govRepair/saveRepairAudit.action", {
			"id" : detailId,
			"status" : status,
			"bmshyj" : $.trim($("#bmshyj").val())
		}, function(result) {
			if (result.result) {
				$.alert(result.message, 1, function() {
					$("#backBtn").trigger("click");
					var activeIndex = recordDtActiveIndex(grl.table);
					grl.table.ajax.reload(function(){
			        	callbackDtRowActive(grl.table, activeIndex);
			        }, false);// 刷新列表还保留分页信息
				});
			} else {
				$.alert(result.message, 2);
			}
		}, "json");
	}

	$("#shtgBtn").click(function() {
		if (!validator.form()) {
			$.alert("部门审核意见验证不通过！");
			return;
		}
		layer.confirm("确定审核通过吗？", {
			icon : 3,
		}, function(index) {
			saveRepairAudit(2);
		});
	});

	$("#shbtgBtn").click(function() {
		if (!validator.form()) {
			$.alert("部门审核意见验证不通过！");
			return;
		}
		layer.confirm("确定审核不通过吗？", {
			icon : 3,
		}, function(index) {
			saveRepairAudit(3);
		});
	});
	
	$.post(ctx + "/govRepair/getCreditDetail.action", {
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