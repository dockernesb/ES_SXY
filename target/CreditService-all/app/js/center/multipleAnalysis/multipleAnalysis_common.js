var multiCommon = (function() {	
    // 查询行业列表
	function getIndustryList(){
		$.post(ctx + '/creditCommon/getIndustryTree.action',
			function(data) {
			   if (data != null && data.length > 0 && data[0].children) {
				   var industries = data[0].children;
					    var options = "<option value='0' selected>全部</option>";
					    for (var i = 0;i < industries.length;i++) {
	        				options += "<option value='"+industries[i].id+"'>"+industries[i].text+"</option>";
	        			}
	        			$("#hyhf").html(options);
	        			$("#hyhf").select2();
			   }
		}, "json");
	}
	
	// 行政区划字典表数据
	function getRegionalDic(){
		$.getJSON(ctx + "/system/dictionary/listValues.action", {
			groupKey : 'administrativeArea'
		}, function(result) {
			var data = result.items;
			data.unshift({id : "0", text : '全部'});
			// 初始下拉框
			$("#xzq").select2({
				//placeholder : '行政区划',
				allowClear : false,
				language : 'zh-CN',
				data : data
			});
			resizeSelect2($("#xzq"));
			$("#xzq").val(['0']).trigger('change');
		}, "json");
	}
	
	// 查询条件展开和收缩
	function toggleTopBox() {
		if ($("#topBox").css("display") == "none") {
	    	$("#toBig").attr({"src":ctx + "/app/images/multipleAnalysis/toTop.png","alt":"收缩","title":"收缩"});
		} else if ($("#topBox").css("display") == "block") { 
			$("#toBig").attr({"src":ctx + "/app/images/multipleAnalysis/toBottom.png","alt":"展开","title":"展开"});
		}
		$("#topBox").slideToggle();
	    
	}
	
	var isLeiji = false;
	// 切换累计和新增改变日期名称
	function changeRQ(){
		var zhibiao1 = $("input[name='zhibiao1']:checked").val();
		if (zhibiao1 == 1) {
			isLeiji = true;
			$("#tjsjSpan").html("截止时间");
		} else {
			isLeiji = false;
			$("#tjsjSpan").html("统计期间");
		}
	}
	
	function changeSelect(obj){
		/*var svals = $.trim($(obj).select2('val'));
		var arr = svals.split(",");
		if (arr.length > 0 && arr[0] == 0) {
			arr.shift();
		}
		log(arr);*/
		
		//$(obj).val(arr).trigger('change');
	}
	
	createEventListener('qynl');
	createEventListener('qylx');
	createEventListener('zcgm');
	createEventListener('hyhf');
	createEventListener('xzq');
	function createEventListener(id) {
		$("#" + id).on("select2:select",function(e){
			var curid = e.params.data.id;
			if (curid == 0) {
				$("#" + id).val(["0"]).trigger('change');
			} else {
				var vals = $.trim($("#" + id).select2('val'));
				var arr = vals.split(",");
				if (arr.length > 0 && arr[0] == 0) {
					arr.shift();
				}
				$("#" + id).val(arr).trigger('change');
			}
		});
	}
	
	return {
		isLeiji : isLeiji,
		getRegionalDic : getRegionalDic,
		getIndustryList : getIndustryList,
		toggleTopBox : toggleTopBox,
		changeRQ : changeRQ,
		changeSelect : changeSelect
	} 
})();
