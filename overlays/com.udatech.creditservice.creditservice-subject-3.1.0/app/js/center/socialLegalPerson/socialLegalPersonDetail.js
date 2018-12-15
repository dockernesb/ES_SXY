var sociaLegalPerson = (function () {
    var qymc = $("#qymc").val();
    var gszch = $("#gszch").val();
    var zzjgdm = $("#zzjgdm").val();
    var tyshxydm = $("#tyshxydm").val();
    var qyid = $("#qyid").val();
    var tables = [];

    $.post(ctx + "/theme/getThemeInfo.action", {
        zyyt: "4"
    }, function (json) {
		var bgObj = {
			id : 'BGID',
			parentId : 'ROOT_4',
			text : '变更信息',
			type : 1,
			order : 7,
			zyyt : "4",
			children : [ {
				dataSource : "jdbcTemplate",
				dataTable : "YW_L_JGBGINFO",
				parentId : "BGID",
				text : "变更信息",
				type : "2",
				zyyt : "4",
				column : [ {
					COLUMN_COMMENTS : "变更日期",
					COLUMN_NAME : "BG_TIME"
				}, {
					COLUMN_COMMENTS : "变更项目",
					COLUMN_NAME : "BG_ITEM"
				}, {
					COLUMN_COMMENTS : "变更前内容",
					COLUMN_NAME : "BG_BEFORE"
				}, {
					COLUMN_COMMENTS : "变更后内容",
					COLUMN_NAME : "BG_AFTER"
				} ]

			} ]
		};
    	json.push(bgObj);
        initCategray(json);
    }, "json");

    function initCategray(json) {
        if (json.length > 0) {
            var $tabLabels = $("#winAdd").find("ul.nav-tabs");
            var $tabContents = $("#winAdd").find("div.tab-content");
            $tabLabels.empty();
            $tabContents.empty();
            for (var i = 0; i < json.length; i++) {
                var categray = json[i] || {};
                if (categray.children) {
                    var label = categray.text || "";
                    var tabId = "lay_tab_" + i;
                    var badgeId = "badge_" + (i + 1); // tab右上角标签数字

                    var dataTable = "";
                    if (categray.children.length == 1) {
                        dataTable = categray.children[0].dataTable;
                    }
                    if (i == 0) {
                        $tabLabels.append('<li class="active"><a href="#' + tabId + '" data-toggle="tab"  dataTable=' + dataTable + '>' + label
                            + '<span class="badge badge-default" style="background: red" id="' + badgeId + '"></span></a></li>');
                        $tabContents.append('<div class="tab-pane active" id="' + tabId + '"></div>');
                    } else {
                        $tabLabels.append('<li><a href="#' + tabId + '" data-toggle="tab" dataTable=' + dataTable + '>' + label
                            + '<span class="badge badge-default" style="background: red" id="' + badgeId + '"></span></a></li>');
                        $tabContents.append('<div class="tab-pane" id="' + tabId + '"></div>');
                    }

                    initTableList(categray.children, tabId, label, categray.id, i, badgeId);
                }
            }
        }

        $(".tab-content .tab-pane").hide();
        $("#lay_tab_0").show();

        $(".nav-tabs li").click(function () {
            $(".nav-tabs li").removeClass("active");
            $(this).addClass("active");
            var contentId = $(this).find("a").attr("href");
            $(".tab-content .tab-pane").removeClass("active").hide();
            $(contentId).addClass("active").show();
            var index = Number(contentId.split("#lay_tab_")[1]);
            //conditionSearch(index);
        });
    }

    function initTableList(tableList, tabId, categrayText, id, index, badgeId) {
        var len = tableList.length;
        if (len > 0) {
            for (var i = 0; i < len; i++) {
            	if (tableList[i].column && tableList[i].column.length > 0) {
	                var $div = $('<h3 class="form-section"></h3>');
	                var tableInfo = tableList[i];
	                var label = tableInfo.text || "";
	                $div.append(label);
	                $("#" + tabId).append($div);
	                initTable(tableInfo, tabId, categrayText, label, id, len, index, badgeId);
            	}
            }
        }
    }

    function initTable(tableInfo, tabId, categrayText, tableText, id, len, index, badgeId) {
        if (tableInfo.column.length > 0) {
            var dataTable = tableInfo.dataTable || "";
            var category = categrayText + " ( " + tableText + " ) ";
            var columns = [];
            var $outDiv = $("<div class='row'></div>");
            var $div = $('<div class="col-md-12"></div>');

            var $table = $('<table class="table table-striped table-hover table-bordered" style="width: 100%;"></table>');

            if (tableInfo.text == '变更信息') {
                $table.addClass("bgInfo");
            }

            var $tr = $('<tr role="row" class="heading"></tr>');
            var orderColName = "";// 排序字段
            var orderType = ""; // 排序类型
            var autoWidth = true;
            for (var i = 0; i < tableInfo.column.length; i++) {
                var col = tableInfo.column[i];
                if (tableInfo.text == '变更信息') {
                    autoWidth = false;
                    if (col.COLUMN_NAME == "BG_TIME") {
                        columns.push({"data": (col.COLUMN_NAME || ""), "width":"10%"});
                    } else if (col.COLUMN_NAME == "BG_ITEM") {
                        columns.push({"data": (col.COLUMN_NAME || ""), "width":"10%"});
                    } else if (col.COLUMN_NAME == "BG_BEFORE"){
                        columns.push({"data": (col.COLUMN_NAME || ""), "width":"40%"});
                    } else {
                        columns.push({"data": (col.COLUMN_NAME || ""), "width":"40%"});
                    }
                } else {
                    columns.push({"data": (col.COLUMN_NAME || "")});
                }

                $tr.append('<th>' + (col.COLUMN_COMMENTS || "") + '</th>');
                var data_order = col.DATA_ORDER;
                if (data_order != null && data_order != "") {
                    orderType = data_order;
                    orderColName = col.COLUMN_NAME;
                }
            }
            $table.append('<thead></thead><tbody></tbody>');
            $table.children('thead').append($tr);
            $div.append($table);
            $outDiv.append($div);
            $("#" + tabId).append($outDiv);
            var endTime = $("#startDate" + index).val();
            var table = $table.DataTable({
                ajax: {
                    url: ctx + "/center/socialLegalPerson/getCreditInfo.action",
                    type: "post",
                    data: {
                        tableKey: tableInfo.dataTable,
                        gszch: gszch,
                        zzjgdm: zzjgdm,
                        tyshxydm: tyshxydm,
                        jgqc: qymc,
                        oderColName : orderColName,
                        orderType : orderType
                    }
                },
                autoWidth : autoWidth,
                ordering: false,
                searching: false,
                pageLength: 10,
                serverSide: true,//如果是服务器方式，必须要设置为true
                processing: true,//设置为true,就会有表格加载时的提示
                paging: true,
                columns: columns,
                createdRow: function (row, data, dataIndex) {
                    if (data.STATUS == '2') { // 已修复的数据，特殊显示，红色
                        $(row).css({
                            'background-color': '#e35b5a',
                            'color': '#fff'
                        });
                    }
                    if (data.isObjection == "true" || data.isObjection) { // 有争议的数据，特殊显示：黄色
                        $(row).css({
                            'background-color': '#daae2b',
                            'color': '#fff'
                        });
                    }

                    if (data.isRepair == "true" || data.isRepair) { // 修复中的数据，特殊显示，紫色
                        $(row).css({
                            'background-color' : '#884898',
                            'color' : '#fff'
                        });
                    }
                },
                initComplete : function(settings, data) {
                    var info = table.page.info();
                    var dataRows = info.recordsTotal;
                    var badgeCnt = isNull($("#" + badgeId).html()) ? 0 : eval($("#" + badgeId).html());
                    var tabNum = badgeCnt + dataRows;
                    if (tabNum != 0) {
                        $("#" + badgeId).html(tabNum);
                    }
                }
            });

            tables.push(table);
        }
    }

    function goBack() {
    	$("div#parentBox").show();
		$("div#childBox").hide();
		var selectArr = recordSelectNullEle();
		$("div#parentBox").prependTo("#topBox");
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
    }

    return {
        'goBack': goBack
    }
})();