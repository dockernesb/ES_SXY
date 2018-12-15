var dpLog=(function(){
	$("#dataStatus").select2({
	placeholder : '全部状态',
	language : 'zh-CN',
	minimumResultsForSearch : -1
});

resizeSelect2($("#dataStatus"));
 
$("#sblx").select2({
	placeholder : '上报类型',
	language : 'zh-CN',
	minimumResultsForSearch : -1
});

resizeSelect2($("#sblx"));

$("#messageType").select2({
	placeholder : '信息类型',
	language : 'zh-CN',
	minimumResultsForSearch : -1
});
$('#messageType').val('1').trigger("change");
resizeSelect2($("#messageType"));


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

		var arr = new Array();//var arr =[];
		var table;
		//创建一个Datatable
		function addTable(){
			$("#tablePanel").children().remove();
			$("#tablePanel").append('<table class="table table-striped table-hover table-bordered" id="dataReportGrid" style="width: 2000px"><thead><tr id="tableId" class="heading"><th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th></tr></thead></table>');
			$.post(ctx + "/dpThemeLog/getMsgColumns.action", {
				'msgType': $("#messageType").val()
			}, function(data) {	
				if (table) {
					table = null;
					arr = [];
				 }
				$("#tableId").children(":not(:first)").remove();
				$("#dataTable_column_toggler").children().remove();
				for(var i =0;i<data.length;i++){
					 $("#dataTable_column_toggler").append('<label><input type="checkbox" class="icheck" checked data-column="'+(i+1)+'">'+data[i].comments+ '</label>');
				
				 }
				loadClose();
				arr.push({
					"data" : "ID", "render": function(data, type, full) {
		            	var opts = '<input type="checkbox" class="icheck"/>';
						return opts;
					}
				});			
				 for(var i =0;i<data.length;i++){
					 $("#tableId").append('<th>'+data[i].comments+'</th>');
					 arr.push({
				    		"data" : data[i].columnName
				    	});	
				 }
				 $("#tableId").append('<th>提交日期</th>');
					arr.push({
						"data" : "TJRQ"						
						});
					
				 $("#tableId").append('<th>上报状态</th><th>上报类型</th>');
				 arr.push({
					 "data" : "SBZT",
					 "render": function(data, type, full){
						 var str ='';
						 if(data ==1){
							 str = '提交成功';
						 }else if(data ==2){
							 str = '提交失败';
						 }
						 return str;
					 }
				 });				
				 arr.push({
					 "data": "SBLX",
					 "render" : function(data, type, full){
						 var str = '';
						 if(data == 0){							 
							 str += '<label>上报省平台</label>';
						 }else if (data ==1){
							 str +='<label>上报信用中国平台</label>';						 
						 }
						 return  str;
					 }
				 });
				 table = $('#dataReportGrid').DataTable({
			        ajax: {
			            url: ctx + "/dpThemeLog/themePage/tableList.action",
			            type: "post",
			            data: { 
			            	msgType : $("#messageType").val(),
			            	sblx : $("#sblx").val(),
			            	status : $("#dataStatus").val(),
			            	beginDate : $("#beginDate").val(),
			            	endDate : $("#endDate").val()
			                  }
			        },
			        ordering: false,
			        searching: false,
			        autoWidth: false,
			        lengthChange: true,
			        pageLength: 10,
			        serverSide: true,//如果是服务器方式，必须要设置为true
			        processing: true,//设置为true,就会有表格加载时的提示
			        columns: arr,
					initComplete : function(settings, data) {
					var columnTogglerContent = $('#columnTogglerContent').clone();
					$(columnTogglerContent).removeClass('hide');
					var columnTogglerDiv = $('#dataReportGrid').parent().parent().find('.columnToggler');
					$(columnTogglerDiv).html(columnTogglerContent);

					$(columnTogglerContent).find('input[type="checkbox"]').iCheck({
						labelHover : false,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});
					// 显示隐藏列
	                $(columnTogglerContent).find('input[type="checkbox"]').on('ifChanged', function (e) {
	                    e.preventDefault();
	                    // Get the column API object
	                    var column = table.column($(this).attr('data-column'));
	                    console.log(column);
	                    // Toggle the visibility
	                    column.visible(!column.visible());              
	                });
				},
				columnDefs: [{
	                targets: 0, // checkBox
	                render: function (data, type, full) {
	                    return '<input type="checkbox" name="checkThis" class="icheck">';
	                }
	            }],
				drawCallback : function(settings) {
					$('#dataReportGrid .checkall').iCheck('uncheck');
					$('#dataReportGrid .checkall, #dataReportGrid tbody .icheck').iCheck({
						labelHover : false,
						cursor : true,
						checkboxClass : 'icheckbox_square-blue',
						radioClass : 'iradio_square-blue',
						increaseArea : '20%'
					});

					// 列表复选框选中取消事件
					var checkAll = $('#dataReportGrid .checkall');
					var checkboxes = $('#dataReportGrid tbody .icheck');
					checkAll.on('ifChecked ifUnchecked', function(event) {
						if (event.type == 'ifChecked') {
							checkboxes.iCheck('check');
							$('#dataReportGrid tbody tr').addClass('active');
						} else {
							checkboxes.iCheck('uncheck');
							$('#dataReportGrid tbody tr').removeClass('active');
						}
					});
					checkboxes.on('ifChanged', function(event) {
						if (checkboxes.filter(':checked').length == checkboxes.length) {
							checkAll.prop('checked', 'checked');
						} else {
							checkAll.removeProp('checked');
						}
						checkAll.iCheck('update');

						if ($(this).is(':checked')) {
							$(this).closest('tr').addClass('active');
						} else {
							$(this).closest('tr').removeClass('active');
						}
					});

					// 添加行选中点击事件
					$('#dataReportGrid tbody tr').on('click', function() {
						$(this).toggleClass('active');
						if ($(this).hasClass('active')) {
							$(this).find('.icheck').iCheck('check');
						} else {
							$(this).find('.icheck').iCheck('uncheck');
						}
					});
					}
			    });		 
				}, "json");
		}
			 

		
		addTable();
		//查询数据
		function queryData(){
			addTable();
			
		}	
		
		 $('.exportData').on('click', function() {
			 var url = ctx + '/dpThemeLog/exportData.action';
			 url += "?msgType=" + $("#messageType").val() + "&beginDate=" + $("#beginDate").val() + "&endDate=" + $("#endDate").val()
			 + "&sblx=" + $("#sblx").val() +"&status=" + $("#dataStatus").val();
             document.location.href = url;
		    });
		 
		// 重置
		function clearData() {
			$('#messageType').val('1').trigger("change");
			resetSearchConditions('#beginDate,#endDate,#dataStatus,#sblx');
			resetDate(start,end);
		}
		
      return {
	     "clearData" : clearData,
	     "queryData": queryData	    
        }
})();