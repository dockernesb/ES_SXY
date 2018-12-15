(function() {
	$('input[name="isHasReport"]').iCheck({
		labelHover : false,
		checkboxClass : 'icheckbox_square-blue',
		radioClass : 'iradio_square-blue',
		increaseArea : '20%'
	});

	$('input[name="isHasReport"]').on('ifChanged', function(event) {
		if ($(this).is(':checked')) {
			$('#issuePdf').hide();
		} else {
			$('#issuePdf').show();
		}
	});

	// 初始化附件选择工具
	$("#sbg").cclUpload({
		"supportTypes" : [ "pdf" ],
		"showList" : true,
		"multiple" : false,
		"max" : 10
	});

	var businessId = $("#businessId").val() || "";
	var xybgbh = $("#xybgbh").val() || "";

	var validator = $('#submit_form').validateForm({
		issueOpition : {
			required : true,
			maxlength : 500
		}
	});

	validator.form();

	$(".backBtn").click(function() {
        $("#applyDetailDiv,#issueDiv").hide();
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

	// 下发按钮事件
	$("#issueBtn").click(function() {
		var sbgName = $('input[name=sbgName]').val();
		var sbgPath = $('input[name=sbgPath]').val();
		if (!$('input[name="isHasReport"]').is(':checked') && (isNull(sbgName) || isNull(sbgPath))) {
			$.alert('请上传省报告，否则请勾选无省报告！');
			return;
		}
		if (!validator.form()) {
			$.alert("下发意见不能为空！");
			return;
		}
		layer.confirm("确认下发吗？", {
			icon : 3,
		}, function(index) {
			var isHasReport = '1';// 默认有省报告
			if ($('input[name="isHasReport"]').is(':checked')) {
				isHasReport = '0';// 无省报告
			}
			$.post(ctx + "/creditReport/reportIssue.action", {
				"id" : businessId,
				"isHasReport" : isHasReport,
				"issueOpition" : $.trim($("#issueOpition").val()),
				"sbgName" : sbgName,
				"sbgPath" : sbgPath
			}, function(result) {
				if (result.result) {
					$.alert(result.message, 1, function() {
                        $(".backBtn").click();
					});
				} else {
					$.alert(result.message, 2);
				}
			}, "json");

		});
	});

	// 查看报告
	$("#reportViewBtn").click(function() {
        var temp = xybgbh.substr(0, 5);
        if (temp == 'XYBGP') {// 表示新版的pdf格式信用报告
            // 报告生成成功，新窗口直接打开生成过的报告页面
            if (isAcrobatPluginInstall()) {
                var url = ctx + '/reportQuery/viewReport.action?xybgbh=' + xybgbh + "&jgqc=" + $("#qymc").val();
                var newwin = window.open(url);
                newwin.focus();
                // 添加信用报告预览日志
                addPreViewLog(id);
            } else {
                $.alert("未安装Adobe Reader，无法预览！");
            }
        } else {// 表示旧版的html格式信用报告
            var url = ctx + '/static_html/' + xybgbh + ".html";
            var newwin = window.open(url);
            newwin.focus();
            // 添加信用报告预览日志
            addPreViewLog(id);
        }
	});

	// 重新审核按钮事件
	$("#reAuditBtn").click(function() {
		layer.confirm("确认重新审核吗？", {
			icon : 3,
		}, function(index) {
			$.post(ctx + "/creditReport/reAudit.action", {
				"id" : businessId
			}, function(result) {
				if (result.result) {
					$.alert(result.message, 1, function() {
                        $(".backBtn").click();
					});
				} else {
					$.alert(result.message, 2);
				}
			}, "json");
		});
	});

})();