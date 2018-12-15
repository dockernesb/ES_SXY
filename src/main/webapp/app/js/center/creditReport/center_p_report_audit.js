(function() {
	var businessId = $("#businessId").val() || "";

	var validator = $('#submit_form').validateForm({
		zxshyj : {
			required : true,
			maxlength : 500
		}
	});

	validator.form();

	$(".backBtn").click(function() {
		$("#applyDetailDiv,#auditOneDiv,#auditTwoDiv").hide();
		$("div#mainListDiv").show();
		var selectArr = recordSelectNullEle();
		$("div#mainListDiv").prependTo('#topDiv');
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	});

	// 下一步
	$("#nextStepBtn").click(function() {
		if (!validator.form()) {
			$.alert("中心审核意见不能为空！");
			return;
		}

		var url = ctx + "/reportQuery/toPReportView.action";
		loading();
		$("#mainListDiv,#auditOneDiv,#applyDetailDiv").hide();
		$("div#auditTwoDiv,#applyDetailDiv").html("");
		$("div#auditTwoDiv").show();
		$("div#auditTwoDiv").prependTo('#topDiv');
		$("div#auditTwoDiv").load(url, {
			id : businessId,
			zxshyj : $.trim($("#zxshyj").val())
		}, function() {
			loadClose();
		});
	});

})();