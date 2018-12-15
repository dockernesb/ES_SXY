var dataTrace = (function(){
	var tables = [];	//	表集合
	// 每栏第一个label的相对于svg元素初始偏移量
	var firstPoint = {x:31, y:97};
	var secondPoint = {x:247, y:97};
	var thirdPoint = {x:463, y:97};
	
	// label和分割线起始y轴位置
	var topDis2 = 55;
	
	// 第一栏，第二栏label之间的高度
	var firstH = 60;
	
	// 第三栏label之间的高度
	var thirdH = 60;
	
	var sjcj = [],sjcl=[],sjwh=[];
     
	var tableHeadArr = [];
	// 虚线的高度
	var dashHeight;
   
	var currentNodeId;
	
	$.post(ctx + "/theme/getThemeInfo.action", {
		zyyt : "6"
	}, function(json) {
		var tableHeadIndex = 0;
		for (var i=0; i<json.length; i++) {
			var categray = json[i] || {};
			if (categray.children) {
				var children = categray.children;
				for (var j=0; j<children.length; j++) {
					var dataWrapperId  = "DataTables_Table_"+tableHeadIndex+"_wrapper" ;
					tableHeadArr.push({tableName : children[j].dataTable, dataWrapperId : dataWrapperId, column : children[j].column});
					tableHeadIndex++;
				}
			}
		}
		initCategray(json);
	}, "json");
	
	
	function initCategray(json) {
		if (json.length > 0) {
			var $tabLabels = $("#winAdd").find("ul.nav-tabs");
			var $tabContents = $("#winAdd").find("div.tab-content");
			$tabLabels.empty();
			$tabContents.empty();
			for (var i=0; i<json.length; i++) {
				var categray = json[i] || {};
					if (categray.children) {
						var label = categray.text || "";
						var tabId = "lay_tab_" + i;
						var shtml;
						if (categray.children.length > 1) {
							 shtml = '<div style="margin-top:10px">';
						} else {
							 shtml = '<div>';
						}
					    shtml += '<div style="margin-bottom:10px">业务提示：还原截止某时点时信用主体在该数据目录下所有数据记录明细及数据状态信息。</div>'+
							'截止时间：<a href="javascript:void(0);" id="threeDaysBefore' + i + '" onclick="dataTrace.findByTimePoint(this, 1, ' + i + ');" class="btn default btn-sm">三天前 </a>'+
							'<a href="javascript:void(0);" onclick="dataTrace.findByTimePoint(this, 2, ' + i + ');" class="btn default btn-sm">一周前 </a>'+
							'<a href="javascript:void(0);" onclick="dataTrace.findByTimePoint(this, 3, ' + i + ');" class="btn default btn-sm">一个月前 </a>'+
							'<a href="javascript:void(0);" onclick="dataTrace.findByTimePoint(this, 4, ' + i + ');" class="btn default btn-sm">三个月前 </a>'+
							'<a href="javascript:void(0);" onclick="dataTrace.findByTimePoint(this, 5, ' + i + ');" class="btn default btn-sm">半年前 </a>'+
							'<a href="javascript:void(0);" onclick="dataTrace.findByTimePoint(this, 6, ' + i + ');" class="btn default btn-sm">一年前 </a>'+
							'<input type="text" class="form-control date-icon" style="width:140px;display:inline-block;margin:0 10px" id="startDate' + i + '" readonly="readonly" placeholder="截止时间" />'+
							'<button type="button" class="btn btn-info btn-md form-search" onclick="dataTrace.conditionSearch(\''+i+'\');">'+
						        '<i class="fa fa-search"></i>查询'+
					        '</button>'+
							'<button type="button" class="btn btn-default btn-md form-search" onclick="dataTrace.conditionReset(' + i + ');">'+
								'<i class="fa fa-rotate-left"></i>重置'+
							'</button>'+
						'</div>';
					    
					    var dataTable = "";
					    if (categray.children.length == 1) {
					    	dataTable = categray.children[0].dataTable;
					    } 

					    if (i == 0) {
							$tabLabels.append('<li class="active"><a href="#' + tabId + '" data-toggle="tab"  dataTable='+dataTable+'>' + label + '<span class="count ' + tabId + '"></span></a></li>');
							$tabContents.append('<div class="tab-pane active" id="' + tabId + '">' + shtml + '</div>');
						} else {
							$tabLabels.append('<li><a href="#' + tabId + '" data-toggle="tab" dataTable='+dataTable+'>' + label + '<span class="count ' + tabId + '"></span></a></li>');
							$tabContents.append('<div class="tab-pane" id="' + tabId + '">' + shtml + '</div>');
						}
						
						// 默认三天前
						$("#startDate" + i).val(getBeforeDate(0));
						
						var start = {
								elem : '#startDate' + i,
								format : 'YYYY-MM-DD',
								max : '2099-12-30', // 最大日期
								width : 100,
								istime : false,
								istoday : false,// 是否显示今天
								isclear : false, // 是否显示清空
								issure : false // 是否显示确认
							};
						
						  var d = new Date();
						  d = d.format("yyyy-MM-dd");
						  // 设置只能选择当前日期之前的时间
						  start.max = d;
						  
						  laydate(start);
						
						  initTableList(categray.children, tabId, label, categray.id, i);
					}
			}
		}
		
	
		$(".tab-content .tab-pane").hide();
		$("#lay_tab_0").show();
		
		$(".nav-tabs li").click(function(){
			$(".nav-tabs li").removeClass("active");
			$(this).addClass("active");
			var contentId = $(this).find("a").attr("href");
			$(".tab-content .tab-pane").removeClass("active").hide();
			$(contentId).addClass("active").show();
			var index = Number(contentId.split("#lay_tab_")[1]);
			conditionSearch(index);
		});
	}
	
	function initTableList(tableList, tabId, categrayText, id, index) {
		var len = tableList.length;
		if (len > 0) {
			var $div = $('<div style="background-color:#fff;font-size:16px;width:calc(100% - 34px);"></div>');
			
			for (var i=0; i<len; i++) {
				if (tableList[i].column && tableList[i].column.length > 0) {
					var tableInfo = tableList[i];
					var label = tableInfo.text || "";
					if (len > 1) {
						$div.append('<a href="javascript:;" class="myBtn" dataTable="'+ (tableInfo.dataTable || '') +'" style="margin:0px;color:#666;text-decoration:none;">' + label + '</a>');
						if (i < len - 1) {
							$div.append('&nbsp;&nbsp;|&nbsp;&nbsp;');
						}
					}
					initTable(tableInfo, tabId, categrayText, label, id, len, index);
				}
			}
			
			if (len >= 2) {
				$div.children("a.myBtn:first").attr("selected",true).css("color", "#E35A5A");
				$("#" + tabId).prepend($div);
				$.each($div.children("a.myBtn"), function(i, obj) {
					$(obj).click(function() {
						$div.children("a.myBtn").attr("selected",false).css("color", "#666");
						$(this).attr("selected",true).css("color", "#E35A5A");
						$("#" + tabId).children("div.gridDiv").hide();
						$("#" + tabId).children("div.gridDiv:eq(" + i + ")").show();
						//removeDiv();
						conditionSearch(index);
					});
				});
			}
			
			$("#" + tabId).children("div.gridDiv:first").show();
		}
	}
	
	function initTable(tableInfo, tabId, categrayText, tableText, id,len,index) {
		if (tableInfo.column.length > 0) {
			var dataTable = tableInfo.dataTable || "";
			var category = categrayText + " ( " + tableText + " ) ";
			var columns = [];
			var $div = $('<div class="gridDiv" style="display:none;"></div>');
			var $table = $('<table class="table table-striped table-bordered table-hover" style="min-width: 100%;"></table>');
			var $tr = $('<tr role="row" class="heading"></tr>');
			
			tableInfo.column.unshift({COLUMN_NAME : 'inserttime',COLUMN_COMMENTS : '时间'},{COLUMN_NAME : 'item',COLUMN_COMMENTS : '事项'});
            var orderColName = "";// 排序字段
            var orderType = ""; // 排序类型
			for (var i=0; i<tableInfo.column.length; i++) {
				var col = tableInfo.column[i];
				$tr.append('<th style="white-space:nowrap;">' + (col.COLUMN_COMMENTS || "") + '</th>');
				if (col.COLUMN_NAME == 'inserttime' || col.COLUMN_NAME == 'item') {
					columns.push({"data" : (col.COLUMN_NAME || "")});
				} else {
					columns.push({"data" : "content." + (col.COLUMN_NAME || "")});
				}
                var data_order = col.DATA_ORDER;
                if (data_order != null && data_order != "") {
                    orderType = data_order;
                    orderColName = col.COLUMN_NAME;
                }
			}
			$tr.append('<th style="white-space:nowrap;">记录追溯</th>');
			columns.push({"data":null});
			$table.append('<thead></thead><tbody></tbody>');
			$table.children('thead').append($tr);
			$div.append($table);
			$("#" + tabId).append($div);
			var endTime = $("#startDate" + index).val();
			var table = $table.DataTable({
		        ajax: {
		            url: ctx + "/dataTrace/getBusinessTraceability.action",
		            type: "post",
		            data: {
		            	tableName: dataTable,
		            	endTime : endTime,
		            	id : qyid,
                        orderColName : orderColName,
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
		        scrollX:        true,
		        scrollCollapse: true,
		        paging: false,
		        fixedColumns:   {
		            leftColumns: 0,
		            rightColumns: 1
		        },
		        columns: columns,
		        // 固定列
		        columnDefs : [ {
					targets : columns.length - 1, // 类别
					render : function(data, type, row) {
						var returnHtml = '&nbsp;&nbsp;<button type="button" class="btn bg-yellow-gold btn-xs" onclick="dataTrace.openRecordTrace(\'' + data.ID + '\',\''+data.inserttime+'\',\''+dataTable+'\');">记录追溯</button>';
						return returnHtml;
					}
				}],
				drawCallback : function(settings) {
					$("#" + tabId + " .dataTables_scrollHeadInner").width("100%");
					removeDiv();
				}
		    });
			
			
			
			tables.push(table);
		}
	}
	
	// 查询
	function conditionSearch(index) {
		refreshTable(index);
	}
	
	// 重置
	function conditionReset(index) {
		findByTimePoint(document.getElementById("threeDaysBefore" + index), 0 , index);
	}
	
	function removeDiv(){
		var selectedTable = $("#winAdd .tab-content .active").find("a[selected='selected']").attr("dataTable");
		if (!selectedTable) {
			selectedTable = $("#winAdd .nav-tabs .active a").attr("dataTable");
		}
		
		var wraperId = ""
			
		for (var i = 0;i < tableHeadArr.length;i++) {
			if (tableHeadArr[i].tableName == selectedTable) {
				wraperId = tableHeadArr[i].dataWrapperId;
				break;
			}
		}
			
		var divWidth = $("#" + wraperId + " .dataTables_scrollBody").width();
		
	    var tableWidth = $("#" + wraperId + " .dataTables_scrollHeadInner .dataTable").width();
	    
	    if (tableWidth <= divWidth) {
	    	$("#" + wraperId + " .DTFC_RightWrapper").hide();
	    } else {
	    	$("#" + wraperId + " .DTFC_RightWrapper").show();
	    }
	}
    // 刷新表格
	function refreshTable(index) {
		var selectedTable = $("#winAdd .tab-content .active").find("a[selected='selected']").attr("dataTable");
		if (!selectedTable) {
			selectedTable = $("#winAdd .nav-tabs .active a").attr("dataTable");
		}
		if (tables.length > 0) {
			for (var i=0; i<tables.length; i++) {
				var table = tables[i];
				if (table) {
					var data = table.settings()[0].ajax.data;
					if (selectedTable == data.tableName) {
						data["endTime"] = $("#startDate" + index).val();
						table.ajax.reload();
					}
				}
			}
		}
	}
	
	// 获取前n天的日期
	function getBeforeDate(n){
	    var n = n;
	    var d = new Date();
	    var year = d.getFullYear();
	    var mon=d.getMonth()+1;
	    var day=d.getDate();
	    if(day <= n){
	            if(mon>1) {
	               mon=mon-1;
	            }
	           else {
	             year = year-1;
	             mon = 12;
	             }
	           }
	          d.setDate(d.getDate()-n);
	          year = d.getFullYear();
	          mon=d.getMonth()+1;
	          day=d.getDate();
	     s = year+"-"+(mon<10?('0'+mon):mon)+"-"+(day<10?('0'+day):day);
	     return s;
	}
	
	// 根据时间点查询
	function findByTimePoint(obj, type, catelogIndex) {
		if (!isNull(obj) && type != 0) {
	        $(obj).parent().children().removeClass("yellow");
			$(obj).addClass("yellow");
		} else {
			 $(obj).parent().children().removeClass("yellow");
		}
		
		var $startDate =$("#startDate" + catelogIndex);
		switch(type) {
		    // 当天
		    case 0 :
				$startDate.val(getBeforeDate(0));
				break;
		    // 三天前
			case 1 :
				$startDate.val(getBeforeDate(3));
				break;
			// 一周前
			case 2 :
				$startDate.val(getBeforeDate(7));
				break;
			// 一个月前
			case 3 :
				$startDate.val(getBeforeDate(30));
				break;
			// 三个月前
			case 4 :
				$startDate.val(getBeforeDate(90));
				break;
			// 半年前
			case 5 :
				$startDate.val(getBeforeDate(180));
				break;
		    // 一年前
			default: 
				$startDate.val(getBeforeDate(365));
				break;
		}
	}
	
	// 打开记录追溯窗口
	function openRecordTrace(id, insertTime, dataTable){
		$.openWin({
			title : '记录追溯',
			content : $("#winRecordTrace"),
			btnAlign : 'c',
			btn : [],
			area : [ '60%', '80%' ],
			yes : function(index, layero) {
				layer.close(index);
			}
		});
		
		$("#qymcDiv").html(qymc);
		gainRecords(id, insertTime, qymc, dataTable);
	}
	
    // 获取三个库节点数据
    function gainRecords(id, insertTime, qymc, dataTable){
    	currentNodeId = insertTime + id;
    	$.post(ctx + "/dataTrace/getRecordTraceability.action", {
    		id : id
    	}, function(json) {
    		     sjcj = json.sjcj;
    		     sjcl = json.sjcl;
    		     sjwh = json.sjwh;
    			 dashHeight = sjwh.length * 150;
    		     $('#container').height(dashHeight);
    			 generateCharts(qymc, dataTable);
    	}, "json");
    }
    
    // 生成图表
    function generateCharts(qymc, dataTable) {
    	$('#container').highcharts({
	        chart: {
	            backgroundColor: 'white',
	            events: {
	                load: function () {
	                    var ren = this.renderer, colors = Highcharts.getOptions().colors;
	                    
	                    // 分割线
	                    cutOffLine(ren);
	                    
	                    // 头部
	                    renderHead(ren);
	                  
	                    // label
	                    loopDrawLabel(ren, 'sjcj',sjcj,"#666");
	                    loopDrawLabel(ren, 'sjcl',sjcl,colors[0]);
	                    loopDrawLabel(ren, 'sjwh',sjwh,"#5fc6b7");
	                
	                    // line
	                    loopDrawLine(ren,'', 'sjcj','sjcl',sjcj,sjcl);
	                    loopDrawLine(ren,'', 'sjcl','sjwh',sjcl,sjwh);
	                    loopDrawLine(ren,'updownArrow', 'sjwh','sjwh',sjwh,sjwh);
	                }
	            }
	        },
	        title: {
	            text: '',
	            style: {
	                color: 'black'
	            }
	        },
	        credits:{
	        	enabled:false//去掉highchars的版权声明
	        }
	    });
    	
    	 for(var i = 0;i< sjcj.length;i++){
    		 $("#sjcj"+i).click(function(){
    			 var content = eval("("+$(this).get(0).getAttribute("content")+")");
    			 $("#detailTime").html($(this).get(0).getAttribute("insertTime"));
        		 $("#traceState").html($(this).get(0).getAttribute("item"));
    			 $.openWin({
    					title : qymc,
    					content : $("#winViewTraceDetail"),
    					btnAlign : 'c',
    					area : [ '625px', '427px' ],
    					yes : function(index, layero) {
    						layer.close(index);
    					}
    				});
    			 renderDetail(content, dataTable);
    		 })
    	 }
    	 
    	 for(var i = 0;i< sjcl.length;i++){
    		 $("#sjcl"+i).click(function(){
    			 var content = eval("("+$(this).get(0).getAttribute("content")+")");
    			 $("#detailTime").html($(this).get(0).getAttribute("insertTime"));
        		 $("#traceState").html($(this).get(0).getAttribute("item"));
    			 $.openWin({
    				    title : qymc,
    					content : $("#winViewTraceDetail"),
    					btnAlign : 'c',
    					area : [ '625px', '427px' ],
    					yes : function(index, layero) {
    						layer.close(index);
    					}
    				});
    			 renderDetail(content, dataTable);
    		 })
    	 }
    	 
    	 for(var i = 0;i< sjwh.length;i++){
    		 $("#sjwh"+i).click(function(){
        		 var content = eval("("+$(this).get(0).getAttribute("content")+")");
        		 $("#detailTime").html($(this).get(0).getAttribute("insertTime"));
        		 $("#traceState").html($(this).get(0).getAttribute("item"));
    			 $.openWin({
    				 title : qymc,
    					content : $("#winViewTraceDetail"),
    					btnAlign : 'c',
    					area : [ '625px', '427px' ],
    					yes : function(index, layero) {
    						layer.close(index);
    					}
    				});
    			 renderDetail(content, dataTable);
    		 })
    	 }
    	 
    }
	
    // 记录追溯详细信息
    function renderDetail(content, dataTable){
    	var fieldHtml = "<tbody>";
    	for (var i = 0;i < tableHeadArr.length;i++) {
			if (tableHeadArr[i].tableName == dataTable) {
				var columns = tableHeadArr[i].column;
				for (var j=0;j < columns.length;j++) {
					if (columns[j].COLUMN_NAME != 'item' && columns[j].COLUMN_NAME != 'inserttime') {
                        var columnName = content[columns[j].COLUMN_NAME] || content['I_'+columns[j].COLUMN_NAME] || '';
                        fieldHtml += "<tr><th width='30%'>"+columns[j].COLUMN_COMMENTS+"</th><td width='40%'>" + columnName + "</td></tr>";
					}
				}
				break;
			}
		}
    	
        fieldHtml += "</tbody>";	
		$("#detailTable").html(fieldHtml);	
    }
    
	// 分割线
	function cutOffLine(ren) {
		 
        ren.path(['M', 216, topDis2, 'L', 216, topDis2 + dashHeight])
            .attr({
            'stroke-width': 2,
            stroke: 'silver',
            dashstyle: 'dash'
        })
            .add();
        
        ren.path(['M', 432, topDis2, 'L', 432, topDis2 + dashHeight])
            .attr({
            'stroke-width': 2,
            stroke: 'silver',
            dashstyle: 'dash'
        })
            .add();
        
	}
	
	// 头部渲染
	function renderHead(ren){
          ren.label('数据采集', 83, topDis2)
              .css({
            	  fontWeight:'bold',
            	  color : '#999'
          })
              .add();
          ren.label('数据处理', 295, topDis2)
              .css({
            	  fontWeight:'bold',
            	  color : '#999'
          })
              .add();
          ren.label('数据维护/应用', 496, topDis2)
              .css({
            	  fontWeight:'bold',
            	  color : '#999'
          })
              .add();
	}
	
	// 循环画出label
	function loopDrawLabel(ren,id,arr,fillColor,color,opacity){
		for(var i = 0; i < arr.length;i++) {
	    var e;
	    if (i != 0) {
	    	e = document.getElementById(id + (i-1)).getBBox();
	    }
	    
	    var x,y,h;
	    // 第一栏
	    if (id == 'sjcj') {
	    	x = firstPoint.x;
	    	h = firstH;
	    	y = firstPoint.y + (h + (i == 0 ? 0 : e.height))*i;
	    } else if (id == 'sjcl') {// 第二栏
	    	x = secondPoint.x;
	    	h = firstH;
	    	y = secondPoint.y + (h + (i == 0 ? 0 : e.height))*i;
	    } else {// 第三栏
	    	h = thirdH;
			var sjwh_w = 0;
	   	    for (var j = 0;j < i;j++) {
		   		var ej = document.getElementById(id + j).getBBox();
		   		sjwh_w += Number(ej.height) + h;
	   	    }
	   	    x = thirdPoint.x;
	   	    y = thirdPoint.y + sjwh_w;
	    }
		 
	    
	    var insertTime = arr[i].insertTime;
	    var dataTraceId = arr[i].content.ID;
	    var dataTraceIdP = arr[i].content.ID_P;
	    var fillColor = fillColor || "red";
	    var color = color || 'white';
	    var strokeColor = color;
	    var fontWeight = 'normal';

	    // 当前节点高亮显示
	    if (currentNodeId == (insertTime + dataTraceId) || currentNodeId == (insertTime + dataTraceIdP)) {
	    	strokeColor = "#e35b5a";
	    	fontWeight = 'bold';
	    	x = x - 3;// 字体加粗后导致label位置不居中
	    }
	    
		ren.label((insertTime || '') + '<br/>' + (arr[i].item || ''), x, y)
		            .attr({ 
		            id : id + i,
		            fill: fillColor,
		            sign : arr[i].sign || '',
		            pointTo : arr[i].pointTo || '',
		            insertTime : arr[i].insertTime || '',
		            item : arr[i].item || '',
		            content : JSON.stringify(arr[i].content) || '',
		            stroke: strokeColor,
		            'stroke-width': 2,
		            padding: 8,
		            r: 5  // 圆角
		            }) .css({
		                color: color,
		                cursor:'pointer',
		                fontWeight : fontWeight
		            }).add();
		}
	}

	/** 两数组循环匹配两两关联的元素并画箭头
	 *  ren:highcharts对象, type:表示起点和终点的元素位置差别的类别,id1和id2分别表示起止元素的id前缀,arr1和arr2表示起止栏目的数组
	 */
	function loopDrawLine(ren,type,id1, id2, arr1, arr2, color){
		for (var i = 0; i < arr1.length;i++) {
			var arr1dom = document.getElementById(id1 + i);
			var arr1_item = arr1dom.getBBox();
		     	
			// labal偏移的坐标
			var xyArr = getOffset(arr1dom);
			var x1 = xyArr[0];
			var y1 = xyArr[1];
			var sX, sY;
			// 箭头起始点的坐标
			if (type == "updownArrow") {
				sX = x1 + arr1_item.width/2;
				sY = y1 + arr1_item.height;
			} else {
				sX = x1 + arr1_item.width;
		    	sY = y1 + arr1_item.height/2;
			}
	     
		    var arr1_pointTo = arr1[i].pointTo;
		     	
			for (var j = 0; j < arr2.length;j++) {
				
				if (arr1_pointTo == arr2[j].sign) {
					var eX, eY;
					var arr2dom = document.getElementById(id2 + j);
					var arr2_item = arr2dom.getBBox();
			       	
					var xyArr = getOffset(arr2dom);
					var x2 = xyArr[0];
					var y2 = xyArr[1];
			       	
			       	// 箭头结束点的坐标
			       	if (type == "updownArrow") {
			       		eX = x2 + arr2_item.width/2;
			       		eY = y2;
			       	} else {
			       	    eX = x2;
			               eY = y2 + arr2_item.height/2;
			       	}
			       	var p = drawLineArrow(sX,sY,eX,eY);
			       	ren.path(p)
			               .attr({
			               'stroke-width': 1.5,
			               stroke: color || '#ccc'
			           }).add();
			       	
			  	}
			} 
		} 
	}

	// 根据两点坐标画箭头,type默认箭头向右
	function drawLineArrow(x1,y1,x2,y2,type){
	    var slopy,cosy,siny;
		var Par=10.0;
	    var x3,y3;
		slopy=Math.atan2((y1-y2),(x1-x2));   
	    cosy=Math.cos(slopy);   
	    siny=Math.sin(slopy); 
	 	 
	 	  path="M"+","+x1+","+y1+",L"+","+x2+","+y2 +",";
		     
	      if (type == "r" || !type) {
	    	  x3 = x2;
	    	  y3 = y2;
	      } else {
	    	  x3 = x1;
	    	  y3 = y1;
	      }
		  path +="M"+","+x3+","+y3 +",";
		  
		  if (type == "r" || !type) {
			  path +="L"+","+(Number(x3)+Number(Par*cosy-(Par/2.0*siny)))+","+(Number(y3)+Number(Par*siny+(Par/2.0*cosy)))+",";

			  path +="M"+","+(Number(x3)+Number(Par*cosy+Par/2.0*siny)+","+ (Number(y3)-Number(Par/2.0*cosy-Par*siny)))+",";
		  } else {
			  path +="L"+","+(-Number(x3)-Number(Par*cosy-(Par/2.0*siny)))+","+(-Number(y3)-Number(Par*siny+(Par/2.0*cosy)))+",";

			  path +="M"+","+(-Number(x3)-Number(Par*cosy+Par/2.0*siny)+","+ (-Number(y3)+Number(Par/2.0*cosy-Par*siny)))+",";
		  }
		 
		  path +="L"+","+x3+","+y3;

		  return path.split(",");
	}
	
	// 根据DOM元素获取初始偏移值
	function getOffset(dom){
		var params = [];
		var x1 = 0;
		var y1 = 0;
		if (isIE()){
			var translate = dom.getAttribute("transform");
			var strarr = translate.split(" ");
			x1 = Number(strarr[0].replace(/[^0-9]/ig,""));
			y1 = Number(strarr[1].replace(/[^0-9]/ig,""));
		} else {
		    x1 = dom.transform.animVal[0].matrix.e;
			y1 = dom.transform.animVal[0].matrix.f;
		}
		params.push(x1);
		params.push(y1);
		return params;
	}
	
	// 判断浏览器是否是ie
	function isIE() { //ie?  
	    if (window.ActiveXObject || "ActiveXObject" in window)  
	        return true;  
	    else  {
	 	   return false;  
	    }
	}
	
	return {
		'loopDrawLabel' : loopDrawLabel,
		'loopDrawLine' : loopDrawLine,
		'cutOffLine' : cutOffLine,
		'renderHead' : renderHead,
        'gainRecords' : gainRecords,
        'conditionSearch' : conditionSearch,
        'conditionReset' : conditionReset,
        'findByTimePoint' : findByTimePoint,
        'openRecordTrace' : openRecordTrace,
        'qymc' : qymc
	}
	
})();