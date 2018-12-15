(function() {
	
	var cnlb = $("#cnlb").val();
	var deptId = $("#deptId").val();
	var from = $("#from").val();
	
	$("#backBtn,#backBtn2").click(function() {
		var url = "";
		if (from == 1) {
			url = ctx + "/promise/toPromiseQyViewList.action?cnlb=" + cnlb + "&deptId=" + deptId;
		} else if (from == 2) {
			url = ctx + "/promise/toPromiseQyList.action?cnlb=" + cnlb + "&deptId=" + deptId;
		}
        $("div#child_fatherDiv").prependTo("#childTopBox");
        $("div#child_fatherDiv").show();
        $("div#child_childDiv").hide();
        resetIEPlaceholder();
	});
	
})();














