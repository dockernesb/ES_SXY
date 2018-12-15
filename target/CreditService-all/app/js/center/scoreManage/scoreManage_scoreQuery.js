var smsq = (function() {
	
	$.post(ctx + "/center/scoreManage/scoreModelQuery.action", function(json) {
		if (json && json.length > 0) {
			var html = '<option value=""></option>';
			for (var i=0; i<json.length; i++) {
				var item = json[i];
				var mxbh = item.mxbh || "";
				var mxmc = item.mxmc || "";
				html += '<option value="' + mxbh + '">' + mxmc + '</option>';
			}
			$("#pfmx").children().remove();
			$("#pfmx").append(html);
		}
		$("#pfmx").select2({
			placeholder : '评分模型',
			language : 'zh-CN',
			minimumResultsForSearch : -1
		});
		resizeSelect2($("#pfmx"));
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
	}, "json");
	
	// 查询按钮
	function conditionSearch() {
		var qymc = $.trim($('#qymc').val());
		var gszch = $.trim($('#gszch').val());
		var zzjgdm = $.trim($('#zzjgdm').val());
		var shxydm = $.trim($('#shxydm').val());
		var mxbh = $('#pfmx').val();
		
		if (qymc == "" && gszch == "" && zzjgdm == "" && shxydm == "") {
			$.alert('企业名称、工商注册号、组织机构代码、统一社会信用代码不能同时为空！');
			return;
		}
		
		if (mxbh == null || mxbh == "") {
			$.alert('请选择评分模型！');
			return;
		}
		
		$("#searchBtn").attr("disabled", "disabled");
		$("#tips").show();
		$("#scoreList").children().remove();
		
		getScoreList(qymc, gszch, zzjgdm, shxydm, mxbh);
	}

	//		获取评分
	function getScoreList(qymc, gszch, zzjgdm, shxydm, mxbh) {
		$.post(ctx + "/center/scoreManage/getScoreList.action", {
			"mxbh" : mxbh,
			"zzjgdm" : zzjgdm,
			"gszch" : gszch,
			"jgqc" : qymc,
			"tyshxydm" : shxydm
		}, function(data) {
			$("#scoreList").children().remove();
			$("#searchBtn").removeAttr("disabled");
			$("#tips").hide();
			if (data.result) {
				showScoreList(data.score);
			} else {
				$.alert(data.message || '', 2);
			}
		}, "json");
	}

	//		展示评分
	function showScoreList(score) {
		$("#total").html(600 + score.score);
		$("#config").html(score.score);
		var children = score.children || [];
		for (var i=0; i<children.length; i++) {
			var child = children[i];
			var html = '<tr>';
			html += '<th width="200px">' + (child.zbmc || '') + '</th>';
			html += '<td width="*"><a href="#">' + (child.score || 0) + '</a></td>';
			html += '<td width="50px">分</td>';
			html += '</tr>';
			$("#scoreList").append(html);
		}
	}

	// 重置按钮
	function conditionReset() {
		resetSearchConditions("#qymc,#gszch,#zzjgdm,#shxydm,#pfmx");
	}
	
	return {
		"conditionSearch" : conditionSearch,
		"conditionReset" : conditionReset
	};

	
})();
