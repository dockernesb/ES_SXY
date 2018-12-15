(function() {
	
	var tabIndex = 0;	//	tab下标
	var tables = [];	//	表集合
	
	var handleTitle = function(tab, navigation, index) {
        var total = navigation.find('li').length;
        var current = index + 1;
        
        if (current == 2) {
        	var qymc = $.trim($("#qymc").val());
    		var gszch = $.trim($("#gszch").val());
    		var zzjgdm = $.trim($("#zzjgdm").val());
        	if (!qymc && !gszch && !zzjgdm) {
        		$.alert("请先查询企业信息！");
                return false;
        	}
        	var yyzzLen = $("input[name='yyzzPath']").length;
        	var zzjgdmzLen = $("input[name='zzjgdmzPath']").length;
        	if (yyzzLen <= 0 && zzjgdmzLen <= 0) {
        		$.alert("营业执照和组织机构代码证至少上传一个！");
                return false;
        	}
        }
        
        if (current == 3) {
        	var jbrxm = validator.element("#jbrxm");
        	var jbrsfzhm = validator.element("#jbrsfzhm");
        	var jbrlxdh = validator.element("#jbrlxdh");
        	if (!jbrxm || !jbrsfzhm || !jbrlxdh) {
        		$.alert("表单验证不通过！");
        		return false;
        	}
        	
        	var sfzLen = $("input[name='sfzPath']").length;
        	if (sfzLen <= 0) {
        		$.alert("请上传身份证！");
                return false;
        	}
        }
        
        if (current == 4) {
        	var xfnrLen = $("input.repairInfo").length;
        	if (xfnrLen <= 0) {
        		$.alert("请选择修复内容！");
                return false;
        	}
        
        	var xfzt = validator.element("#xfzt");
        	var xfbz = validator.element("#xfbz");
        	if (!xfzt || !xfbz) {
        		$.alert("表单验证不通过！");
        		return false;
        	}
        	
        	var xfxxsqbLen = $("input[name='xfxxsqbPath']").length;
        	if (xfxxsqbLen <= 0) {
        		$.alert("请上传修复信息申请表！");
                return false;
        	}
        }
        
        $('li').removeClass("done");
        var li_list = navigation.find('li');
        for (var i = 0; i < index; i++) {
            $(li_list[i]).addClass("done");
        }

        if (current == 1) {
            $('.button-previous').hide();
        } else {
            $('.button-previous').show();
        }

        if (current >= total) {
            $('.button-next').hide();
            $('.button-submit').show();
        } else {
            $('.button-next').show();
            $('.button-submit').hide();
        }
        
        if (current == 4) {
        	$(".button_reset").hide();
        } else {
        	$(".button_reset").show();
        }
        
        return true;
    }

	$('#submit_form').bootstrapWizard({
        'nextSelector': '.button-next',
        'previousSelector': '.button-previous',
        onTabClick: function (tab, navigation, index, clickedIndex) {
            return false;
        },
        onNext: function (tab, navigation, index) {
            return handleTitle(tab, navigation, index);
        },
        onPrevious: function (tab, navigation, index) {
            handleTitle(tab, navigation, index);
        },
        onTabShow: function (tab, navigation, index) {
            var total = navigation.find('li').length;
            var current = index + 1;
            tabIndex = current;
            var $percent = (current / total) * 100;
            $('div.progress-bar').css({
                width: $percent + '%'
            });
            if (current == 4) {
            	initView();
            }
        }
    });
	
	//	初始化预览
	function initView() {
		$("#qymcView").val($("#qymc").val());
		$("#gszchView").val($("#gszch").val());
		$("#zzjgdmView").val($("#zzjgdm").val());
		$("#tyshxydmView").val($("#tyshxydm").val());
		$("#jbrxmView").val($("#jbrxm").val());
    	$("#jbrsfzhmView").val($("#jbrsfzhm").val());
    	$("#jbrlxdhView").val($("#jbrlxdh").val());
    	$("#xfztView").val($("#xfzt").val());
    	$("#xfbzView").val($("#xfbz").val());
    	setTimeout(function() {
    		copyImg();
    	}, 0);
	}
	
	//	复制图片
	function copyImg() {
		$.each($(".upload-img:not(label)"), function(i, obj) {
			var id = $(obj).attr("id");
			var $target = $(obj).data("target");
			if ($target && $target.length == 1) {
				var viewId = id + "View";
				var $clone = $target.clone();
				$clone.find("input").remove();
				$clone.find("div.delete").remove();
				$("#" + viewId).children().remove();
				$("#" + viewId).append($clone);
				
				$clone.find("img").click(function() {
					openPhoto($(this).attr("src"));
				});
			}
		});
	}
	
	$('.button-previous').hide();
	$('.button-submit').hide();
	
	$(".upload-img:not(#sfz)").cclUpload({
		"type" : "img",
		"showList" : true
	});
	$("#sfz").cclUpload({
		"type" : "img",
		"showList" : true,
		"multiple" : true,
		"max" : 2
	});
	
	$(".button_reset").click(function() {
		if (tabIndex == 1) {
			$("#searchInput").val("").change();
			$("#qymc").val("");
			$("#gszch").val("");
			$("#zzjgdm").val("");
			$("#tyshxydm").val("");
			$("#yyzz,#zzjgdmz").cclResetUpload();
		} else if (tabIndex == 2) {
			$("#jbrxm").val("");
        	$("#jbrsfzhm").val("");
        	$("#jbrlxdh").val("");
        	$("#sfz,#qysqs").cclResetUpload();
		} else if (tabIndex == 3) {
			$("#xfzt").val("");
			$("#xfbz").val("");
        	$("#xfxxsqb,#zmcl").cclResetUpload();
        	$("input.repairInfo").remove();
        	$("input.checkbox").removeAttr("checked");
        	$("#nrSelectDiv tr").removeClass("active");
        	$("span.count").hide();
		}
		validator.form();
	});
	
	$('#searchInput').combobox({
		url : ctx + "/creditCommon/getEnterpriseList.action",
		key : "ID",
		value : "NAME",
		searchBtn : "#searchBtn",
		callback : function(i, row) {
			$("#qymc").val(row.JGQC);
			$("#gszch").val(row.GSZCH);
			$("#zzjgdm").val(row.ZZJGDM);
			$("#tyshxydm").val(row.TYSHXYDM);
			$("#qyxx").show();
			refreshTable();
		}
	});
	
	var validator = $('#submit_form').validateForm({
		jbrxm : {
			required: true,
			maxlength: 50
		},
		jbrsfzhm : {
			required: true,
			idCard: [],
			maxlength: 18
		},
		jbrlxdh : {
			required: true,
			phone: [],
			maxlength: 15
		},
		xfzt : {
			required: true,
			maxlength: 50
		},
		xfbz : {
			required: true,
			maxlength: 500
		}
	});
	
	validator.form();
	
	$.post(ctx + "/theme/getThemeInfo.action", {
		zyyt : "3"
	}, function(json) {
		setTimeout(function() {
			initCategray(json);
		}, 1000);
	}, "json");
	
	function initCategray(json) {
		var $tabLabels = $("#nrSelectDiv").find("ul.nav-tabs");
		var $tabContents = $("#nrSelectDiv").find("div.tab-content");
		var $nrDiv = $("div.nr-div");
		$tabLabels.children().remove();
		$tabContents.children().remove();
		$nrDiv.children().remove();
		if (json.length > 0) {
			for (var i=0; i<json.length; i++) {
				var categray = json[i] || {};
				if (categray.children) {
					var label = categray.text || "";
					var tabId = "tab_" + i;
					$tabLabels.append('<li><a href="#' + tabId + '" data-toggle="tab">' + label + '<span class="count ' + tabId + '">(0)</span></a></li>');
					$tabContents.append('<div class="tab-pane" id="' + tabId + '"></div>');
					$nrDiv.append('<button type="button" class="btn btn-success ' + tabId + '" i="' + i + '">' + label + '<span class="count ' + tabId + '">(0)</span></button>');
					
					initTableList(categray.children, tabId, label);
				}
			}
			$nrDiv.children("button").click(function() {
				var i = $(this).attr("i");
				if (!isNaN(i)) {
					i = parseInt(i, 10) || 0;
					$tabLabels.find("li.active").removeClass("active");
					$tabLabels.find("li:eq(" + i + ")").addClass("active");
					$tabContents.children("div.active").removeClass("active");
					$tabContents.children("div:eq(" + i + ")").addClass("active");
					if (tabIndex == 3) {
						openEditWin("tab_" + i);
					} else if (tabIndex == 4) {
						openViewWin();
					}
				}
			});
		}
	}
	
	function openEditWin(tabId) {
		$("input.checkbox:not(:checked)").parent("td").parent("tr").show();
		$("input.checkbox").removeAttr("disabled");
		$.openWin({
			title : "修复内容选择",
			area : [ '90%', '90%' ],
			content : $("#nrSelectDiv"),
			yes : function(index) {
				var $list = $("input.checkbox:checked");
				if ($list.length > 0) {
					layer.close(index);
					$("#submit_form").find(".repairInfo").remove();
					var tabCounts = {};
					$.each($list, function(i, obj) {
						var dataTable = $(obj).attr("dataTable");
						var thirdId = $(obj).attr("thirdId");
						var tabId = $(obj).attr("tabId");
						var category = $(obj).attr("category");
						var bmbm = $(obj).attr("bmbm");
						var bmmc = $(obj).attr("bmmc");
						var html = '<input type="hidden" class="repairInfo" name="dataTable" value="' + dataTable + '" />';
						html += '<input type="hidden" class="repairInfo" name="thirdId" value="' + thirdId + '" />';
						html += '<input type="hidden" class="repairInfo" name="category" value="' + category + '" />';
						html += '<input type="hidden" class="repairInfo" name="deptCode" value="' + bmbm + '" />';
						html += '<input type="hidden" class="repairInfo" name="deptName" value="' + bmmc + '" />';
						$("#submit_form").append(html);
						if (tabId) {
							var tc = tabCounts[tabId];
							if (!tc) {
								tc = 1;
							} else {
								tc++;
							}
							tabCounts[tabId] = tc;
						}
					});
					
					$("span.count").hide();
					for (var tab in tabCounts) {
						$("span.count." + tab).html("(" + tabCounts[tab] + ")").show();
					}
				} else {
					$.alert("请选择修复内容！");
				}
			}
		});
	}
	
	function openViewWin() {
		$("input.checkbox:not(:checked)").parent("td").parent("tr").hide();
		$("input.checkbox").prop("disabled", "disabled");
		$.openWin({
			title : "修复内容展示",
			area : [ '90%', '90%' ],
			content : $("#nrSelectDiv"),
			btn : ["关闭"],
			yes : function(index) {
				layer.close(index);
			}
		});
	};
	
	function initTableList(tableList, tabId, categrayText) {
		var len = tableList.length;
		if (len > 0) {
			var $div = $('<div style="height:50px;line-height:50px;background-color:#fff;font-size:16px;"></div>');
			
			for (var i=0; i<len; i++) {
				var tableInfo = tableList[i];
				var label = tableInfo.text || "";
				if (len > 1) {
					$div.append('<a href="javascript:;" class="myBtn" style="margin:0px;color:#666;text-decoration:none;">' + label + '</a>');
					if (i < len - 1) {
						$div.append('&nbsp;&nbsp;|&nbsp;&nbsp;');
					}
				}
				initTable(tableInfo, tabId, categrayText, label);
			}
			
			if (len >= 2) {
				$div.children("a.myBtn:first").css("color", "#E35A5A");
				$("#" + tabId).prepend($div);
				$.each($div.children("a.myBtn"), function(i, obj) {
					$(obj).click(function() {
						$div.children("a.myBtn").css("color", "#666");
						$(this).css("color", "#E35A5A");
						$("#" + tabId).children("div.gridDiv").hide();
						$("#" + tabId).children("div.gridDiv:eq(" + i + ")").show();
					});
				});
			}
			
			$("#" + tabId).children("div.gridDiv:first").show();
		}
	}
	
	function initTable(tableInfo, tabId, categrayText, tableText) {
		if (tableInfo.column.length > 0) {
			var dataTable = tableInfo.dataTable || "";
			var category = categrayText + " ( " + tableText + " ) ";
			var columns = [
				{"data" : "ID", "sClass" : "center", "render" : function(data, type, full) {
					var bmbm = full.BMBM || "";
					var bmmc = full.BMMC || "";
					return '<input type="checkbox" class="checkbox" tabId="' + tabId 
						   + '" dataTable="' + dataTable + '" thirdId="' + data 
						   + '" category="' + category + '" bmbm="' + bmbm + '" bmmc="' + bmmc + '" />';
				}}
			];
			var fieldColumns = "ID,BMBM,BMMC";
			var $div = $('<div class="gridDiv" style="display:none;"></div>');
			var $table = $('<table class="table table-striped table-bordered table-hover" style="min-width: 100%;"></table>');
			var $tr = $('<tr role="row" class="heading"><th style="width: 35px; text-align: center;"></th></tr>');
            var orderColName = "";// 排序字段
            var orderType = ""; // 排序类型
			for (var i=0; i<tableInfo.column.length; i++) {
				var col = tableInfo.column[i];
				$tr.append('<th style="white-space:nowrap;">' + (col.COLUMN_COMMENTS || "") + '</th>');
				columns.push({"data" : (col.COLUMN_NAME || "")});
				fieldColumns += "," + (col.COLUMN_NAME || "");
                var data_order = col.DATA_ORDER;
                if (data_order != null && data_order != "") {
                    orderType = data_order;
                    orderColName = col.COLUMN_NAME;
                }
			}
			$table.append('<thead></thead><tbody></tbody>');
			$table.children('thead').append($tr);
			$div.append($table);
			$("#" + tabId).append($div);
			
			var table = $table.DataTable({
		        ajax: {
		            url: ctx + "/creditCommon/getCreditInfo.action",
		            type: "post",
		            data: {
		            	dataTable: dataTable,
		            	fieldColumns: fieldColumns,
		            	type: 1,
                        oderColName : orderColName,
                        orderType : orderType
		            }
		        },
		        ordering: false,
		        searching: false,
		        autoWidth: false,
		        lengthChange: true,
		        pageLength: 10,
		        serverSide: true,//如果是服务器方式，必须要设置为true
		        processing: true,//设置为true,就会有表格加载时的提示
		        paging: false,
		        columns: columns,
		        initComplete: function(settings, json) {
		        	$table.children("tbody").on('click', 'tr', function() {
		        		if (tabIndex == 3) {
			        		if ($(this).hasClass('active')) {
			        			$(this).removeClass('active');
			        			$(this).find("input.checkbox").removeAttr("checked");
			        		} else {
			        			$(this).addClass('active');
		        				$(this).find("input.checkbox").prop("checked", "checked");
			        		}
			        		$(this).find("input.checkbox").change();
		        		}
		        	});
		        },
		        drawCallback : function(settings, json) {
		        	addCheckedListener($div);
		        }
		    });
			
			tables.push(table);
		}
	}
	
	//	表格中复选框事件
	function addCheckedListener($div) {
		var $input = $div.find("input.checkbox");
		var $info = $div.find("div.checkedInfo");
		if ($info.length == 0) {
			$info = $('<div class="checkedInfo" style="padding-top:8px;float:left;margin-left:10px;">（已选中0条）</div>');
			$div.find("div.dataTables_info").after($info);
		}
		$input.change(function() {
			var len = $div.find("input.checkbox:checked").length || 0;
			$info.html("（已选中"  + len + "条）");
		});
	}
	
	//	刷新表格
	function refreshTable() {
		$("span.count").html("");
		$("div.checkedInfo").html("（已选中0条）");
		if (tables.length > 0) {
			for (var i=0; i<tables.length; i++) {
				var table = tables[i];
				if (table) {
					var data = table.settings()[0].ajax.data;
					if (!data) {
						data = {};
						table.settings()[0].ajax["data"] = data;
					}
					data["jgqc"] = $("#qymc").val();
					data["gszch"] = $("#gszch").val();
					data["zzjgdm"] = $("#zzjgdm").val();
					data["tyshxydm"] = $("#tyshxydm").val();
					data["op"] = "query";
					table.ajax.reload();
				}
			}
		}
	}
	
	$(".button-submit").click(function() {
		loading();
		$("#submit_form").ajaxSubmit({
			url : ctx + "/hallRepair/addRepair.action",
			success : function(result) {
				loadClose();
				if (result.result) {
					layer.confirm(result.message, {
						icon : 1,
						btn: ['立即打印受理单', '暂不打印'],
						cancel: function(index){ 
							var url = ctx + "/hallRepair/toRepairApply.action";
			                $("div#mainContent").load(url);
						},
						btn2 : function() {
							var url = ctx + "/hallRepair/toRepairApply.action";
			                $("div#mainContent").load(url);
						}
					}, function(index) {
		            	layer.close(index);
		            	var url = ctx + "/hallRepair/printRepair.action?id=" + result.id;
		                window.open(url, "异议申诉反馈单");
		                url = ctx + "/hallRepair/toRepairApply.action";
		                $("div#mainContent").load(url);
		            });
				} else {
					$.alert(result.message, 2);
				}
			},
			dataType : "json"
		});
	});
	
})();