/**
 * 查看评分模型模板用JS
 */
var viewModel = (function() {
	// table添加行
	function addRow(table, id) {
		var rowNum = $("#" + table + " tr").length - 1; // 总行数
		var newRow = $("#trForAdd tr:eq(" + id + ")").clone(); // 获取tr
		$.each($(newRow).find("input"), function(i, item) {
			$(item).val('');
		});
		$("#" + table + " tr:eq(" + rowNum + ")").before(newRow); // 在table的最后一行前面添加一行
	}
	
	// 企业资质列表
	var table = $('#appGrid').DataTable({
		// "scrollY": 385,
		"deferRender" : true,
		"ordering" : false,
		"searching" : false,
		"lengthChange" : true,
		"autoWidth" : false,
		"columnDefs" : [ {
			"orderable" : false,
			"targets" : 0
		} ],
		"pageLength" : 10, // 显示5项结果
		ajax : { // 通过ajax访问后台获取数据
			url : CONTEXT_PATH + '/center/scoreManage/queryQYZZZS.action', // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : "ZZMC"
		}, {
			"data" : "RDJGQC"
		} ]
	});
	
	// --------添加row----------//
	function addRowSForOld() {
		var qyzzMapList = $("#qyzzMapList").val();
		qyzzMapList = eval(qyzzMapList);
		$.each(qyzzMapList, function(i, value) {
			var str = "";
			str += "<tr>";
			str += "	<td align='left' nowrap >" + value.ZLMC;
			str += "	</td>";
			str += "	<td align='center' nowrap >";
			str += '		<input name="qyzz_fs" value="' + value.SCORE + '" type="text" disabled="disabled" maxlength="3" required class="form-control"/>';
			str += "	</td>";
			str += "</tr>";

			var $str = $(str);
			$("#qyzz_qj tbody").append($str); // 在table的最后一行前面添加一行
		});
		var qjfMapList = $("#qjfMapList").val();
		qjfMapList = eval(qjfMapList);
		$.each(qjfMapList, function(i, value) {
			var pfzbName = value.PFZBNAME;
			var pfzbMin = value.MIN;
			var pfzbMax = value.MAX;
			var pfzbScore = value.SCORE;
			var flg = value.FLG;
			var tbodyName = pfzbName.substring(pfzbName.lastIndexOf("_") + 1, pfzbName.length);
			addTrForOld(pfzbName, pfzbMin, pfzbMax, pfzbScore, flg, tbodyName);
		});
	}

	// table添加行
	function addTrForOld(pfzbName, pfzbMin, pfzbMax, pfzbScore, flg, tbodyName) {
		if (pfzbMax != null) {
			var rowNum = $("#" + tbodyName + " tr").length - 1; // 总行数-1
			var newRow = $("#trForAdd tr:eq(" + flg + ")").clone(); // 获取tr
			$.each($(newRow).find("input[name='" + pfzbName + "qjF']"), function(i, item) {
				$(item).val(pfzbMin);
			});
			$.each($(newRow).find("input[name='" + pfzbName + "qjE']"), function(i, item) {
				$(item).val(pfzbMax);
			});
			$.each($(newRow).find("input[name='" + pfzbName + "qjfs']"), function(i, item) {
				$(item).val(pfzbScore);
			});
			$("#" + tbodyName + " tr:eq(" + rowNum + ")").before(newRow); // 在table的最后一行前面添加一行
		} else {
			$("#" + pfzbName + "qjM").val(pfzbMin);
			var rowNum = $("#" + tbodyName + " tr").length - 1;
			var thisRow = $("#" + tbodyName + " tr:eq(" + rowNum + ")"); // 获取tr
			$.each($(thisRow).find("input[name='" + pfzbName + "qjfs']"), function(i, item) {
				$(item).val(pfzbScore);
			});
		}
	}

	// 返回
	function goBackList() {
        $("div#fatherDiv").prependTo("#topBox");
        $("div#fatherDiv").show();
        $("div#childDiv").hide();
        resetIEPlaceholder();
	}
	
	addRowSForOld();

	return {
		goBackList : goBackList
	};

})();