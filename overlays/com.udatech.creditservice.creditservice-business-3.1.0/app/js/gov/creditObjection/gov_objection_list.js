var gol = (function() {
	
	$("#status").select2({
		placeholder : '全部状态',
		minimumResultsForSearch : -1
	});
	$('#status').val(null).trigger("change");
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
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/govObjection/getObjectionList.action",
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
            	var opts = '<a href="javascript:;" onclick="gol.toObjection(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', this)">' + data + '</a>';
				return opts;
			}},
            {"data" : "QYMC"}, 
            {"data" : "TYSHXYDM"},
            {"data" : "ZZJGDM", "visible" : false},
            {"data" : "GSZCH", "visible" : false}, 
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
            	var opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="gol.toObjection(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', this)">查看</a>';
            	if (full.STATUS == "1") {
            		opts += '&nbsp;&nbsp;<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="gol.toObjectionAudit(\'' + data + '\', \'' + full.DETAIL_ID + '\', this)">审核</a>';
            	}
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
	
	function refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, beginDate, endDate, status) {
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
			table.ajax.reload();
		}
	}
	
	function toObjection(id, detailId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/govObjection/toObjection.action?id=" + id + "&detailId=" + detailId;
    	$("div#childBox").html("");
		$("div#childBox").load(url);
		$("div#childBox").show();
		$("div#parentBox").hide();
		$("div#childBox").prependTo("#topBox");
	}
	
	function toObjectionAudit(id, detailId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/govObjection/toObjectionAudit.action?id=" + id + "&detailId=" + detailId;
		$("div#childBox").html("");
		$("div#childBox").load(url);
		$("div#childBox").show();
		$("div#parentBox").hide();
		$("div#childBox").prependTo("#topBox");
	}
	
	function conditionSearch() {
		var bjbh = $.trim($("#bjbh").val());
		var jgqc = $.trim($("#jgqc").val());
		var gszch = $.trim($("#gszch").val());
		var zzjgdm = $.trim($("#zzjgdm").val());
		var tyshxydm = $.trim($("#tyshxydm").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());
		var status = $("#status").val();
		
		refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, beginDate, endDate, status);
	}
	
	function conditionReset() {
		resetSearchConditions('#bjbh,#jgqc,#gszch,#zzjgdm,#tyshxydm,#beginDate,#endDate,#status');
		resetDate(start,end);
	}
	
	return {
		toObjection : toObjection,
		toObjectionAudit : toObjectionAudit,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		table : table
	};
	
})();