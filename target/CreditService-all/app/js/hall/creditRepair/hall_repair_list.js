var hol = (function() {

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
	  istoday: false,// 是否显示今天
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
	  istoday: false,// 是否显示今天
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
            url: ctx + "/hallRepair/getRepairList.action",
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
            	var opts = '<a href="javascript:;" onclick="hol.toRepair(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', this)">' + data + '</a>';
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
            	var opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="hol.toRepair(\'' + full.ID + '\', \'' + full.DETAIL_ID + '\', this)">查看</a>';
            	if (full.STATUS == "0" && (bmlx == '1' || (bmlx == '0' && full.CODE == 'A0000'))) {
            		opts += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="hol.printRepair(\'' + data + '\', \'' + full.DETAIL_ID + '\', this)">打印受理单</a>';
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
	
	function refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, beginDate, endDate,status, deptId) {
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
			table.ajax.reload();
		}
	}
	
	function printRepair(id, detailId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/hallRepair/printRepair.action?id=" + id + "&detailId=" + detailId;
        window.open(url, "信用修复反馈单");
	}
	
	function toRepair(id, detailId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/hallRepair/toRepair.action?id=" + id + "&detailId=" + detailId;
        $("div#mainListDiv").hide();
		$("div#applyDetailDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
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
        var deptId = $.trim($("#deptId").val());
		
		refreshTable(bjbh, jgqc, gszch, zzjgdm, tyshxydm, beginDate, endDate, status, deptId);
	}
	
	function conditionReset() {
		resetSearchConditions('#bjbh,#jgqc,#gszch,#zzjgdm,#tyshxydm,#beginDate,#endDate,#status,#deptId');
		resetDate(start,end);
	}
	
	return {
		printRepair : printRepair,
		toRepair : toRepair,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset
	};
	
})();