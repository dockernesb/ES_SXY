(function() {
	
	var businessId = $("#businessId").val() || "";
	var status = $("#status").val();
	var dataTable = $("#dataTable").val();
	var thirdId = $("#thirdId").val();
	var detailId = $("#detailId").val();
	
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

	var validator = $('#submit_form').validateForm({
		zxshyj : {
			required : true,
			maxlength : 500
		}
	});

	validator.form();

	$("#backBtn,#backBtn2").click(function() {
		$("div#applyDetailDiv").hide();
		$("div#mainListDiv").show();
		var selectArr = recordSelectNullEle();
		$("div#mainListDiv").prependTo('#topDiv');
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	});

	function saveRepairAudit(status) {
		$.post(ctx + "/centerRepair/saveRepairAudit.action", {
			"id" : detailId,
			"status" : status,
			"zxshyj" : $.trim($("#zxshyj").val())
		}, function(result) {
			if (result.result) {
				$.alert(result.message, 1, function() {
					$("#backBtn").trigger("click");
					var activeIndex = recordDtActiveIndex(crl.table);
					crl.table.ajax.reload(function(){
			        	callbackDtRowActive(crl.table, activeIndex);
			        }, false);// 刷新列表还保留分页信息
				});
			} else {
				$.alert(result.message, 2);
			}
		}, "json");
	}

	$("#bmBtn").click(function() {
		if (!validator.form()) {
			$.alert("中心审核意见验证不通过！");
			return;
		}
		layer.confirm("确定部门核实吗？", {
			icon : 3,
		}, function(index) {
			saveRepairAudit(1);
		});
	});

	$("#shtgBtn").click(function() {
		if (!validator.form()) {
			$.alert("中心审核意见验证不通过！");
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
			$.alert("中心审核意见验证不通过！");
			return;
		}
		layer.confirm("确定审核不通过吗？", {
			icon : 3,
		}, function(index) {
			saveRepairAudit(3);
		});
	});
	
	$("#nrzs").click(function() {
		$.openWin({
			title : "修复内容展示",
			area : [ '900px', '550px' ],
			content : $("#xfnrSelectDiv"),
			btn : ["关闭"],
			yes : function(index) {
				layer.close(index);
			}
		});
	});
	
})();