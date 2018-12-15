(function() {
	
	var cnlb = $("#cnlb").val();
	var deptId = $("#deptId").val();
	var type = $("#type").val();
	
	$("#backBtn,#backBtn2").click(function() {
		var url = ctx + "/sszj_promise/toPromiseQyList.action?cnlb=" + cnlb + "&deptId=" + deptId;
		if (type == 1) {
			url = ctx + "/sszj_promise/toPromiseQyViewList.action";
		}
        $("div#child_fatherDiv").prependTo("#childTopBox");
        $("div#child_fatherDiv").show();
        $("div#child_childDiv").hide();
    	var activeIndex = recordDtActiveIndex(promiseAddEnter.table);
    	promiseAddEnter.table.ajax.reload(function(){
        	callbackDtRowActive(promiseAddEnter.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
        resetIEPlaceholder();
	});
	
	$("#yxq").select2({
		minimumResultsForSearch : -1,
		language : 'zh-CN'
	});
	
	//	校验规则
	var validator = $("#submit_form").validateForm({
		"clyj" : {
			required: true,
			maxlength: 1000
		},
		"yxq" : {
			required: true
		}
	});
	
	validator.form();
	
	//	提交事件
	$("#saveBtn").click(function() {
		var clyj = $.trim($("#clyj").val());
		if (!clyj) {
			$.alert("请输入处理意见！");
			return;
		}
		if (clyj.length > 1000) {
			$.alert("处理意见最多1000个字！");
			return;
		}
		saveSupervisionTheme();
	});
	
	//	保存监管专题
	function saveSupervisionTheme() {
		loading();
		$("#submit_form").ajaxSubmit({
			url : ctx + "/sszj_promise/savePromiseQyHandle.action",
			success : function(result) {
				loadClose();
				if (result.result) {
					$.alert(result.message, 1, function() {
						$("#backBtn").trigger("click");
					});
				} else {
					$.alert(result.message, 2);
				}
			},
			dataType : "json"
		});
	}
	
})();














