$(function() {
	// 初始化标题及数据
	init();
	var templateJsonObj = eval('(' + template + ')');
	var bgImg = templateJsonObj.bgImg;
	$('.printbg').css('background', 'rgb(255, 255, 255) url(' + ctx + '/app/images/creditReport/' + bgImg + ') repeat-y scroll 50% 0% / auto padding-box border-box');
});

// 初始化标题及数据
function init() {
	var themeInfoJson = eval('(' + themeInfo + ')');
	var templateJsonObj = eval('(' + template + ')');

	var $content = $('.content');

	$.each(themeInfoJson, function(i, theme) {
		// 一级标题
		$content.append('<div class="tit1">' + fmt(i) + theme.text + '</div>');

		// 二级标题
		$.each(theme.children, function(j, themeTwo) {
			$content.append('<div class="tit2">' + (j + 1) + '、' + themeTwo.text + '</div>');

			// 列表
			var $table = $('<table class="tablePrint"></table>');
			var thead = '<thead><tr>';// 表头
			$.each(themeTwo.columns, function(k, column) {
				thead += '<th>' + column.columnAlias + '</th>';
			});
			thead += '</tr></thead>';
			$table.append(thead);

			var tbody = '<tbody>';// 表数据
			if (!isNull(themeTwo.data)) {
				$.each(themeTwo.data, function(m, columnData) {
					tbody += '<tr>';
					$.each(themeTwo.columns, function(k, column) {
						for ( var item in columnData) {
							// 报告查询页面选中的数据，打印时才显示
							if (columnData['checked'] == true && item == column.columnName) {
								var columnValue = columnData[item];
								if (isNull(columnValue)) {
									columnValue = '暂无数据';
								}
								if (columnData['STATUS'] == '2') {// 已修复的数据，报告中显示为斜体和删除线
									tbody += '<td align="center" valign="top"><i><s>' + columnValue + '</s></i></td>';
								} else {
									tbody += '<td align="center" valign="top">' + columnValue + '</td>';
								}
								break;
							}
						}
					});
					tbody += '</tr>';
				});
				if (tbody == '<tbody><tr></tr>') {
					tbody = '<tbody>';
					tbody += '<tr>';
					$.each(themeTwo.columns, function(k, column) {
						tbody += '<td align="center" valign="top">暂无数据</td>';
					});
					tbody += '</tr>';
				}
			} else {
				tbody += '<tr>';
				$.each(themeTwo.columns, function(k, column) {
					tbody += '<td align="center" valign="top">暂无数据</td>';
				});
				tbody += '</tr>';
			}

			tbody += '</tbody>';
			$table.append(tbody);

			$content.append($table);
		});
	});
	$content.append('<p class="f_16">社会法人信用基础数据库信息来源于省、市有关政府部门。有何问题，请与我们联系。地址：' + templateJsonObj.address + '，电话：' + templateJsonObj.contactPhone + '，联系人：' + templateJsonObj.contact + '。</p>');
}

// 格式标题
function fmt(idx) {
	var sum = idx + 2;
	var txt = '';
	if (2 == sum) {
		txt = "二、";
	} else if (3 == sum) {
		txt = "三、";
	} else if (4 == sum) {
		txt = "四、";
	} else if (5 == sum) {
		txt = "五、";
	} else if (6 == sum) {
		txt = "六、";
	} else if (7 == sum) {
		txt = "七、";
	} else if (8 == sum) {
		txt = "八、";
	} else if (9 == sum) {
		txt = "九、";
	} else if (10 == sum) {
		txt = "十、";
	} else if (11 == sum) {
		txt = "十一、";
	} else if (12 == sum) {
		txt = "十二、";
	} else if (13 == sum) {
		txt = "十三、";
	} else if (14 == sum) {
		txt = "十四、";
	} else if (15 == sum) {
		txt = "十五、";
	} else if (16 == sum) {
		txt = "十六、";
	} else if (17 == sum) {
		txt = "十七、";
	} else if (18 == sum) {
		txt = "十八、";
	} else if (19 == sum) {
		txt = "十九、";
	} else if (20 == sum) {
		txt = "二十、";
	}
	return txt;
}

// 打印
function printDetail() {
	$.post(ctx + "/reportQuery/saveReportPrintLog.action", {
		"appId" : businessId
	}, function(result) {
	}, "json");
	var div = document.getElementById("printDiv");
	div.style.display = "none";
	window.print();
	div.style.display = "block";

	
}
