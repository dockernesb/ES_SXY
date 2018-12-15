(function() {
	var businessId = $("#businessId").val() || "";

	var validator = $('#submit_form').validateForm({
		zxshyj : {
			required : true,
			maxlength : 500
		}
	});

	validator.form();


	// 返回列表页
	$(".backBtn").click(function() {
		$("#applyDetailDiv,#auditOneDiv,#auditTwoDiv").hide();
		$("div#mainListDiv").show();
		var selectArr = recordSelectNullEle();
		$("div#mainListDiv").prependTo('#topDiv');
		callbackSelectNull(selectArr);
		var activeIndex = recordDtActiveIndex(centerReport.table);
		centerReport.table.ajax.reload(function(){
        	callbackDtRowActive(centerReport.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
		resetIEPlaceholder();
	});
	// 下一步
	$("#nextStepBtn").click(function() {
		if (!validator.form()) {
			$.alert("中心审核意见不能为空！");
			return;
		}

		var url = ctx + "/reportQuery/toReportView.action";
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

	// 保存审核不通过信息
	function saveReportAuditOther(status) {
		$.post(ctx + "/creditReport/reportApplyAudit.action", {
			"id" : businessId,
			"status" : status,
			"zxshyj" : $.trim($("#zxshyj").val())
		}, function(result) {
			if (result.result) {
				if (status == 1) {
					// 审核通过，生成报告
					generateReport();
				}else {	
					$.alert('审核驳回成功！', 1, function() {
						$(".backBtn").trigger("click");// 审核不通过，返回审核列表页
					});
				}
			} else {
				$.alert(result.message, 2);
			}
		}, "json");
	}
    
	  $("#shbtgBtn").click(function() {
			if (!validator.form()) {
				$.alert("中心审核意见不能为空！");
				return;
			}	
			layer.confirm("确认驳回吗？", {
				icon : 3,
			}, function(index) {
				saveReportAuditOther(2);
			});
		});
	
})();