var crl = (function() {

    var bmlx = $("#bmlx").val();
	
	$("#status").select2({
		placeholder : '全部状态',
		minimumResultsForSearch : -1
	});
	
	resizeSelect2($("#status"));
	
	var start = {
	  elem: '#beginDate',
	  format: 'YYYY-MM-DD',
	  max: '2099-12-30', //最大日期
	  istime: false,
	  istoday: false,
	  isclear : false, // 是否显示清空
	  issure : false, // 是否显示确认
	  choose: function(datas){
		 laydatePH('#beginDate', datas);
	     end.min = datas; //开始日选好后，重置结束日的最小日期
	     end.start = datas //将结束日的初始值设定为开始日
	  }
	};
	var end = {
	  elem: '#endDate',
	  format: 'YYYY-MM-DD',
	  max: '2099-12-30',
	  istime: false,
	  istoday: false,
	  isclear : false, // 是否显示清空
	  issure : false, // 是否显示确认
	  choose: function(datas){
		laydatePH('#endDate', datas);
	    start.max = datas; //结束日选好后，重置开始日的最大日期
	  }
	};
	laydate(start);
	laydate(end);

    $.getJSON(ctx + "/system/department/getDeptList.action?userType=2", function(result) {
        // 初始下拉框
        $("#deptId").select2({
            placeholder : '办件部门',
            language : 'zh-CN',
            data : result
        });

        resizeSelect2($("#deptId"));
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/centerRepair/getRepairList.action?statusType=0",
            type: "post"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "BJBH", "render": function(data, type, full) {
            	var opts = '<a href="javascript:;" onclick="crl.toRepair(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', \'' + full.THIRD_ID + '\', \'' + full.DATA_TABLE + '\', this)">' + data + '</a>';
				return opts;
			}},
            {"data" : "BJBM"},
            {"data" : "QYMC"}, 
            {"data" : "GSZCH", "visible" : false}, 
            {"data" : "ZZJGDM", "visible" : false},
            {"data" : "TYSHXYDM"},
            {"data" : "XFZT"},
            {"data" : "CREATE_DATE"}, 
            {"data" : "JBRXM", "visible" : false}, 
            {"data" : "JBRLXDH", "visible" : false}, 
            {"data" : "STATUS", "render": function(data, type, full) {
            	var status = "待审核";
            	if (data == 1) {
            		status = "待核实";
            	} else if (data == 2) {
            		status = "已通过";
            	} else if (data == 3) {
            		status = "未通过";
            	} else if (data == 4) {
            		status = "已完成";
            	}
				return status;
			}}, 
            {"data" : "ID", "render": function(data, type, full) {
            	var opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="crl.toRepair(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', \'' + full.THIRD_ID + '\', \'' + full.DATA_TABLE + '\', this)">查看</a>';
            	if (full.STATUS == "0") {
            		opts += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="crl.toRepairAudit(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', this)">审核</a>';
            	} /*else if (full.STATUS == "2") {
            		opts += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="crl.openAmendWin(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', \'' + full.THIRD_ID + '\', \'' + full.DATA_TABLE + '\', \'' + full.CATEGORY + '\', this)">修复</a>';
            	}*/
				return opts;
			}}
        ],
		initComplete : function(settings, data) {
			var columnTogglerContent = $('#columnTogglerContent').clone();
			$(columnTogglerContent).removeClass('hide');
			var columnTogglerDiv = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
			$(columnTogglerDiv).html(columnTogglerContent);

			$(columnTogglerContent).find('input[type="checkbox"]').iCheck({
				labelHover : false,
				checkboxClass : 'icheckbox_square-blue',
				radioClass : 'iradio_square-blue',
				increaseArea : '20%'
			});

			// 显示隐藏列
			$(columnTogglerContent).find('input[type="checkbox"]').on('ifChanged', function(e) {
				e.preventDefault();
				// Get the column API object
				var column = table.column($(this).attr('data-column'));
				// Toggle the visibility
				column.visible(!column.visible());
			});
		}
    });
	
	$('#dataTable tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});
	
	function refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, beginDate, endDate, status, deptId) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["bjbh"] = bjbh;
			data["jgqc"] = jgqc;
			data["gszch"] = gszch;
			data["zzjgdm"] = zzjgdm;
			data["tyshxydm"] = tyshxydm;
			data["beginDate"] = beginDate;
			data["endDate"] = endDate;
			data["status"] = status;
            data["bjbm"] = deptId;
			table.ajax.reload(null, false);
		}
	}
	
	function toRepair(id, detailId, thirdId, dataTable, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/centerRepair/toRepair.action?id=" + id
				+ "&detailId=" + detailId + "&thirdId=" + thirdId + "&dataTable=" + dataTable;
        $("div#mainListDiv").hide();
		$("div#applyDetailDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
	}
	
	function toRepairAudit(id, detailId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/centerRepair/toRepairAudit.action?id=" + id + "&detailId=" + detailId;
		$("div#mainListDiv").hide();
		$("div#applyDetailDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
	}
	
	function initFormData(json) {
		if (json.length > 0) {
			var $div = $('<div></div>');
			for (var i=0; i<json.length; i++) {
				var row = json[i];
				var label = row.COLUMN_COMMENTS || "";
				var text = row.DATA || "";
				
				var $group = $('<div class="form-group"></div>');
				$group.append('<label class="control-label col-md-4">' + label + '：</label>');
				$group.append('<div class="col-md-6"><input class="form-control" readonly="readonly" value="' + text + '" title="' + text + '" /></div>');
				$div.append($group);
			}
			$("#amendForm").append($div);
		}
	}
	
	/*function openAmendWin(id, detailId, thirdId, dataTable, title, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		$("#amendForm div.form-group:not(:first)").remove();
		validator = {};
		$.post(ctx + "/centerRepair/getCreditDetail.action", {
			"thirdId" : thirdId,
			"dataTable" : dataTable
		}, function(json) {
			initFormData(json);
			$.openWin({
				title : "信用数据修复 - " + (title || ""),
				area : [ '800px', '90%' ],
				content : $("#amendDiv"),
				btn : ['修复', '取消'],
				yes : function(index) {
					amendRepair(detailId, thirdId, dataTable, index);
				}
			});
		}, "json");
	}*/
	
	/*function amendRepair(detailId, thirdId, dataTable, _index) {
		layer.confirm("确定修复吗？", {
			icon : 3,
		}, function(index) {
			layer.close(index);
			loading();
			$.post(ctx + "/centerRepair/amendRepair.action", {
				id : detailId,
				thirdId : thirdId,
				dataTable : dataTable
			}, function(json) {
				loadClose();
				if (json.result) {
					layer.close(_index);
					$.alert(json.message, 1);
					refreshTable();
				} else {
					$.alert(json.message, 2);
				}
			}, "json");
		});
	}*/
	
	function conditionSearch() {
		var bjbh = $.trim($("#bjbh").val());
		var jgqc = $.trim($("#jgqc").val());
		var gszch = $.trim($("#gszch").val());
		var zzjgdm = $.trim($("#zzjgdm").val());
		var tyshxydm = $.trim($("#tyshxydm").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());
		var status = $("#status").val();
        var deptId = $.trim($("#deptId").val());
		
		refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, beginDate, endDate, status, deptId);
	}
	
	function conditionReset() {
		resetSearchConditions('#bjbh,#jgqc,#gszch,#zzjgdm,#tyshxydm,#beginDate,#endDate,#status,#deptId');
		resetDate(start,end);
	}
	
	return {
		toRepair : toRepair,
		toRepairAudit : toRepairAudit,
		/*openAmendWin : openAmendWin,*/
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		table : table
	};
	
})();