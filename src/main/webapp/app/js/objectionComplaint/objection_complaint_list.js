var hol = (function() {
	
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
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/objectionComplaint/getObjectionList.action",
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
            	var opts = '<a href="javascript:;" onclick="hol.toObjection(\'' + full.ID + '\', \'' + full.LINK_ID + '\', this)">' + data + '</a>';
				return opts;
			}},
            {"data" : "NAME"},
            {"data" : "JSZ"},
            {"data" : "PHONE_NUMBER"},
            {"data" : "CREATE_DATE"},
            {"data" : "STATE", "render": function(data, type, full) {
            	var state = "待审核";
            	if (data == 1) {
                    state = "待核实";
            	} else if (data == 2) {
                    state = "已通过";
            	} else if (data == 3) {
                    state = "未通过";
            	} else if (data == 4) {
                    state = "已完成";
            	}
				return state;
			}}, 
            {"data" : "ID", "render": function(data, type, full) {
            	var opts = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="hol.toObjection(\'' + data + '\', \'' + full.LINK_ID + '\', this)">查看</a>';
            	if (full.STATE == "0") {
            		opts += '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="hol.printObjection(\'' + data + '\', \'' + full.LINK_ID + '\', this)">打印受理单</a>';
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
				var column = table.column($(this).attr('data-column'));
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
	
	function refreshTable(bjbh, name, jsz, beginDate, endDate) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["bjbh"] = bjbh;
			data["name"] = name;
			data["jsz"] = jsz;
			data["beginDate"] = beginDate;
			data["endDate"] = endDate;
			table.ajax.reload();
		}
	}
	
	function printObjection(id, detailId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);

		var url = ctx + "/objectionComplaint/printObjection.action?id=" + id ;
        window.open(url, "异议申诉反馈单");
	}
	
	function toObjection(id, linkId, _this) {
		// 添加列表操作列按钮点击，强制行选中，返回时，行选中状态不会丢失
		addDtSelectedStatus(_this);
		
		var url = ctx + "/objectionComplaint/toObjection.action?id=" + id + "&linkId=" + linkId;
        $("div#mainListDiv").hide();
		$("div#applyDetailDiv").html("");
		$("div#applyDetailDiv").show();
		$("div#applyDetailDiv").load(url);
		$("div#applyDetailDiv").prependTo('#topDiv');
	}
	
	function conditionSearch() {
		var bjbh = $.trim($("#bjbh").val());
		var name = $.trim($("#name").val());
		var jsz = $.trim($("#jsz").val());
		var beginDate = $.trim($("#beginDate").val());
		var endDate = $.trim($("#endDate").val());
		
		refreshTable(bjbh, name, jsz, beginDate, endDate);
	}
	
	function conditionReset() {
		resetSearchConditions('#bjbh,#name,#jsz,#beginDate,#endDate');
		resetDate(start,end);
	}
	
	return {
		printObjection : printObjection,
		toObjection : toObjection,
		conditionSearch : conditionSearch,
		conditionReset : conditionReset
	};
	
})();