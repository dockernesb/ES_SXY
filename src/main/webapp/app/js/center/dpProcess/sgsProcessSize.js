var dataSize = (function() {
	
	/******************************* 初始化**********************************************************/
	
	var start = {
			elem : '#startDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30', // 最大日期
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#startDate', datas);
				end.min = datas; // 开始日选好后，重置结束日的最小日期
				end.start = datas // 将结束日的初始值设定为开始日
			}
		};
		var end = {
			elem : '#endDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30',
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#endDate', datas);
				start.max = datas; // 结束日选好后，重置开始日的最大日期
			}
		};
	laydate(start);
	laydate(end);
	
	// 开始时间
	var startDate = $("#startDate").val();
	// 结束时间
	var endDate = $("#endDate").val();
	
	
	
	
	 //创建一个Datatable
   var table = $('#dataTable').DataTable({
       ordering: true,
       order: [],
       searching: false,
       autoWidth: false,
       lengthChange: true,
       pageLength: 10,
       serverSide: false,//如果是服务器方式，必须要设置为true
       processing: true,//设置为true,就会有表格加载时的提示
       paging: false,
       columns: [
           {"data": null,
               render: function (data, type, row, meta) {
                   // 显示行号
                   var startIndex = meta.settings._iDisplayStart;
                   return startIndex + meta.row + 1;                } ,
               "orderable" : false
           }, {
               "data" : "DEPTNAME" , 
               type:'chinese-string'
           }, {
               "data" : "ALLSIZE" 
           }, {
               "data" : "XKSIZE_L" 
           }, {
               "data" : "XKSIZE_P" 
           }, {
               "data" : "CFSIZE_L" 
           }, {
               "data" : "CFSIZE_P" 
           }],
           initComplete: function (settings, data) {
               var $div = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
               $div.append('<a class="btn btn-sm blue" style="float: right;" href="javascript:;" onclick="dataSize.exportDeptData();">导出</a>');
           },
			"drawCallback" : function(settings) {

			},
       drawCallback: function (settings, data) {
           var api = this.api();
           var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
           api.column(0).nodes().each(function (cell, i) {
               cell.innerHTML = startIndex + i + 1;
           });
       }
   });
	
	function getDeptByCode(){
		$("#deptId").empty();
		var code;
		var type = $("input[name='dataOrigin']:checked").val();
		if(type=='sz')
			code = 'A'
		if(type=='qx')
			code = 'B'				
		$.getJSON(ctx + "/dpProcess/getDeptList.action",{"code":code}, function(result) {
			// 初始下拉框
			$("#deptId").select2({
				placeholder : '部门选择',
				language : 'zh-CN',
				data : result
			});
			
			$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
			resizeSelect2($("#deptId"));
			$('#deptId').val(null).trigger("change");
		});
	}
	
	$(function(){
		getDeptByCode();
		conditionSearch();
		$('input:radio[name="dataOrigin"]').change(function(){  
	         if($(this).is(":checked")){  
	        	 conditionSearch();
	        	 getDeptByCode();
	          } 
	      });
		$('input:radio[name="dimension"]').change(function(){  
	         if($(this).is(":checked")){  
	        	 conditionSearch();
	          } 
	      });
	});
	

	/******************************* 初始化 end*****************************************************/
	
	
	/************************************查询 begin************************************************/
	
	function getConditions(){
		var params = {};
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var type = $("input[name='dataOrigin']:checked").val();
		var dimension = $("input[name='dimension']:checked").val();
		var deptId = $("#deptId").val();
		params.startDate = startDate;
		params.endDate = endDate;
		params.type = type;
		params.dimension = dimension;
		params.deptId = deptId;
		return params
	}
	
	//查询入库量
	function conditionSearch() {
		//获取查询条件
		var params = getConditions();
		if (startDate && endDate && startDate > endDate) {
			$.alert('开始日期不能大于结束日期！');
			return;
		}
		queryMonthBarData();
		queryBarData();
		publicityDataRank();
		queryDataTable();
	}
	
	
	// 重置
	function conditionReset() {
		resetSearchConditions('#startDate,#endDate,#deptId');
		$("input[name='dataOrigin']:eq(0)").attr("checked",'checked'); 
		$("input[name='dimension']:eq(0)").attr("checked",'checked'); 
		resetDate(start,end);
	}
	
	/************************************查询 end*********************************************************/
	
var myChart0 = echarts.init(document.getElementById("monthBar"));

//初始化双公示数据分析柱状图
function initMonthBar(data) {
	var dbXData= [];// x轴类目
	var dbYData_XK = [];// y轴数据,许可入库量
	var dbYData_CF = [];// y轴数据,许可入库量
	if(data){
		dbXData = data.MON;
		dbYData_XK = data.XKSIZE;
		dbYData_CF = data.CFSIZE;
	}
	
	var option = {
		title : {
			text : '双公示月度统计',
			subtext : '',
			left : 'center'
		},
		tooltip : {
			trigger : 'axis',
			axisPointer : { // 坐标轴指示器，坐标轴触发有效
				type : 'line' // 默认为直线，可选为：'line' | 'shadow'
			}
		},
		toolbox : {
			show : true,
			left : '20',
			top : '50',
			feature : {
				mark : {
					show : true
				},
				magicType : {
					show : true,
					type : [ 'line']
				},
				restore : {
					show : true
				},
				saveAsImage : {
					show : true
				}
			}
		},
		grid : {
			top : '100',
			borderWidth : 1,
			containLabel : true,// 防止label溢出
			x : 40,
			x2 : 60,
			y2 : 80 //图表底部距离
		},
		xAxis : [ {
			type : 'category',
			show : true,
			boundaryGap : true,
			axisLine : {
				onZero : true
			},
			data :dbXData
		} ],
		yAxis : [ {
			type : 'value',
			splitArea : {
				show : true
			},
			minInterval: 1,//最小刻度
			show : true,
			axisLabel: {
	            formatter:  function (val) {
	            	var unit = "条";
	            	if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
	            		val = val/10000+'万'
	            	}
	            	return val + unit;
                }
	        }
		} ],
		dataZoom :  [{type : 'inside',
		   startValue: dbXData[0],
		   endValue: dbXData[11]	 
		},{
			show : true,
			height : 40,
			type : 'slider',
			top : '90%',
			right : '8%',
			left : '8%'
		}],
		textStyle: {
			color: '#666'
		},
		legend: {
	    	top : '50',
			right : '55',
	        data:['行政许可','行政处罚']
		},
		series : function(){
			var series = [];
			var item1 = {
					name : "行政许可",
					type : 'bar',
					stack : '行政许可',
					label : {
						normal : {
							show : true,
							position : 'inside',
							formatter : function(data) {
								return data.value == 0 ? '' : data.value;
							}
						}
					},
					itemStyle : {
						normal : {
							color : function(params) {
								return '#fbb321';
							},
							lineStyle : {
								color : '#fbb321'
							}
						}
					},
					data : dbYData_XK
				};
			series.push(item1);
				
			var item2 = {
					name : "行政处罚",
					type : 'bar',
					stack : '行政处罚',
					label : {
						normal : {
							show : true,
							position : 'inside',
							formatter : function(data) {
								
								return data.value == 0 ? '' : data.value;
							}
						}
					},
					itemStyle : {
						normal : {
							color : function(params) {
								return '#a69ae4';
							},
							lineStyle : {
								color : '#a69ae4'
							}
						}
					},
					data : dbYData_CF
				};
			series.push(item2);
			return series;
		}()
	};
	myChart0.clear();
	myChart0.setOption(option);
	myChart0.hideLoading();
}

// 双公示数据质量柱状图数据源
function queryMonthBarData(){
		var params = getConditions();
		$.post(ctx + '/dpProcess/querySgsMonthBar.action', params,
			function(data) {
			initMonthBar(data);
			}, "json");
}




var myChart1 = echarts.init(document.getElementById("publicityBar"));
	
	// 初始化双公示数据分析柱状图
	function initBar(data) {
		var dbXData= [];// x轴类目
		var dbYData_XK = [];// y轴数据,许可入库量
		var dbYData_CF = [];// y轴数据,许可入库量
		if(data){
			dbXData = data.BMMC;
			dbYData_XK = data.XKSIZE;
			dbYData_CF = data.CFSIZE;
		}
		
		var option = {
			title : {
				text : '双公示分析',
				subtext : '',
				left : 'center'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				}
			},
			toolbox : {
				show : true,
				left : '20',
				top : '50',
				feature : {
					mark : {
						show : true
					},
					magicType : {
						show : true,
						type : [ 'line']
					},
					restore : {
						show : true
					},
					saveAsImage : {
						show : true
					}
				}
			},
			grid : {
				top : '100',
				borderWidth : 1,
				containLabel : true,// 防止label溢出
				x : 40,
				x2 : 60,
				y2 : 80 //图表底部距离
			},
			xAxis : [ {
				type : 'category',
				show : true,
				/*axisLabel : {
					rotate : -45,
					interval :0 // 			
				},*/
				boundaryGap : true,
				axisLine : {
					onZero : true
				},
				data :dbXData
			} ],
			yAxis : [ {
				type : 'value',
				splitArea : {
					show : true
				},
				minInterval: 1,//最小刻度
				show : true,
				axisLabel: {
		            formatter:  function (val) {
		            	var unit = "条";
		            	if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
		            		val = val/10000+'万'
		            	}
		            	return val + unit;
	                }
		        }
			} ],
			dataZoom :  [{type : 'inside',
			   startValue: dbXData[0],
			   endValue: dbXData[11]	 
			},{
				show : true,
				height : 40,
				type : 'slider',
				top : '90%',
				right : '8%',
				left : '8%'
			}],
			textStyle: {
				color: '#666'
			},
			legend: {
		    	top : '50',
				right : '55',
		        data:['行政许可','行政处罚']
			},
			series : function(){
				var series = [];
				var item1 = {
						name : "行政许可",
						type : 'bar',
						stack : '行政许可',
						label : {
							normal : {
								show : true,
								position : 'inside',
								formatter : function(data) {
									return data.value == 0 ? '' : data.value;
								}
							}
						},
						itemStyle : {
							normal : {
								color : function(params) {
									return '#fbb321';
								},
								lineStyle : {
									color : '#fbb321'
								}
							}
						},
						data : dbYData_XK
					};
				series.push(item1);
					
				var item2 = {
						name : "行政处罚",
						type : 'bar',
						stack : '行政处罚',
						label : {
							normal : {
								show : true,
								position : 'inside',
								formatter : function(data) {
									
									return data.value == 0 ? '' : data.value;
								}
							}
						},
						itemStyle : {
							normal : {
								color : function(params) {
									return '#a69ae4';
								},
								lineStyle : {
									color : '#a69ae4'
								}
							}
						},
						data : dbYData_CF
					};
				series.push(item2);
				return series;
			}()
		};
		myChart1.clear();
		myChart1.setOption(option);
		myChart1.hideLoading();
	}
	
	
var myChart2 = echarts.init(document.getElementById('xzxkRank'));
	
	var labelRight = {
	    normal: {
	        position: 'left',
	        show: true,
	        position : 'inside'
	    }
	};
	 
	// 初始化报送入库率排行柱状图
	function initXzxkRankChart(category, total){
	    	
	    	var dataSeries = [];
	    	for (var i = 0; i < total.length; i++){
	    		var fontwidth = category[i].length*12;// 12字体大小
	    		var barwidth = total[i]*0.01*217;// 217柱状图宽度
	    		var obj = {};
	    		obj.value = total[i];
	    		if (fontwidth > barwidth) {
	    			obj.label = labelRight;
	    		}
	    		dataSeries.push(obj);
	    	}
	    	var option = {
	    		    id: 'bar',
		            zlevel: 1,
		            type: 'bar',
		            symbol: 'none',
	    		    title: {
	    		        text: '行政许可排行',
	    		        left :70,
	    		        textStyle: {
	    		        	fontSize: 15
	    		        	}
	    		    },
	    		    tooltip : {
	    				trigger : 'axis',
	    				axisPointer : { // 坐标轴指示器，坐标轴触发有效
	    					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
	    				},
	    				formatter : function(params, ticket, callback) {
	    					var value = typeof(params[0].value)=="undefined"?0:params[0].value;
	    					var tooltipD = params[0].name + ":" + value ;
	    					return tooltipD;
	    				}
	    			},
	    		    grid: {
	    		        top: '40'
	    		    },
	    		    xAxis: {
	    		        type: 'value',
	    		        minInterval: 1,
	    		        splitLine: {
	    		            show: false
	    		        },
	    		        axisLine: {
	    		            show: false
	    		        },
	    		        axisTick: {
	    		            show: false
	    		        },
	    		        axisLabel: {
	    		            formatter:  function (val) {
	    		            	if(val >= 1000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
	    		            		val = val/10000+'万'
	    		            	}
	    		            	return val;
	    	                }
	    		        }
	    		    },
	    		    yAxis: {
	    		        type: 'category',
	    		        nameGap: 5,
	    		        axisLine: {
	    		            show: true,
	    		            lineStyle: {
	    		                color: '#ddd'
	    		            }
	    		        },
	    		        axisTick: {
	    		            show: false,
	    		            lineStyle: {
	    		                color: '#ddd'
	    		            }
	    		        },
	    		        axisLabel: {
	    		            interval: 0,
	    		            fontWeight: 'bolder',
	    		            textStyle: {
	    		            	 color: '#FFF'
	    		            }
	    		        },
	    		        data: category
	    		    },
	    		    series: [
	    		        {
	    		        	name : '行政许可排行',
	    		            type: 'bar',
	    		            data: dataSeries,
	    		            itemStyle : {
								normal : {
									color : function(params) {
										return '#fbb321';
									},
									lineStyle : {
										color : '#fbb321'
									}
								}
							},
	    		            label : {
								normal : {
									show : true,
									formatter :function(data){
										return data.name;
									}
								}
							}
	    		        }
	    		    ]
	    		};
	    myChart2.clear();
	   	myChart2.setOption(option);
	}
	 
	var myChart3 = echarts.init(document.getElementById('xzcfRank'));
	
	// 初始化报送时效率排行柱状图
	function initXzcfRankChart(category, total){
		var dataSeries = [];
    	
    	for (var i = 0; i < total.length; i++){
    		var fontwidth = category[i].length*12;
    		var barwidth = total[i]*0.01*217;
    		var obj = {};
    		obj.value = total[i];
    		if (fontwidth > barwidth) {
    			obj.label = labelRight;
    		}
    		dataSeries.push(obj);
    	}
	    	var option = {
	    		    id: 'bar',
		            zlevel: 1,
		            type: 'bar',
		            symbol: 'none',
	    		    title: {
	    		        text: '行政处罚排行',
	    		        left :70,
	    		        textStyle: {
	    		        	fontSize: 15
	    		        	}
	    		    },
	    		    tooltip: {
	    		        trigger: 'axis',
	    		        axisPointer : { // 坐标轴指示器，坐标轴触发有效
	    					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
	    				},
	    				formatter : function(params, ticket, callback) {
	    					var value = typeof(params[0].value)=="undefined"?0:params[0].value;
	    					var tooltipD = params[0].name + ":" + value + "";
	    					return tooltipD;
	    				}
	    		    },
	    		    grid: {
	    		        top: '40'
	    		    },
	    		    xAxis: {
	    		    	type: 'value',
	    		        minInterval: 1,
	    		        splitLine: {
	    		            show: false
	    		        },
	    		        axisLine: {
	    		            show: true
	    		        },
	    		        axisTick: {
	    		            show: false
	    		        },
	    		        axisLabel: {
	    		            formatter:  function (val) {
	    		            	if(val >= 1000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
	    		            		val = val/10000+'万'
	    		            	}
	    		            	return val;
	    	                }
	    		        }
	    		    },
	    		    yAxis: {
	    		        type: 'category',
	    		        nameGap: 5,
	    		        axisLine: {
	    		            show: true,
	    		            lineStyle: {
	    		                color: '#ddd'
	    		            }
	    		        },
	    		        axisTick: {
	    		            show: false,
	    		            lineStyle: {
	    		                color: '#ddd'
	    		            }
	    		        },
	    		        axisLabel: {
	    		            interval: 0,
	    		            fontWeight: 'bolder',
	    		            textStyle: {
	    		            	 color: '#FFF'
	    		            }
	    		        },
	    		        data: category
	    		    },
	    		    series: [
	    		        {
	    		        	name : '行政处罚排行',
	    		            type: 'bar',
	    		            data: dataSeries,
	    		            itemStyle : {
								normal : {
									color : function(params) {
										return '#a69ae4';
									},
									lineStyle : {
										color : '#a69ae4'
									}
								}
							},
	    		            label : {
								normal : {
									show : true,
									formatter :function(data){
										return data.name;
									}
								}
							}
	    		        }
	    		    ]
	    		};
	    myChart3.clear();
	   	myChart3.setOption(option);
	}

	
	
    function queryDataTable() {
    	var param = getConditions();
        table.clear().draw();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var url = ctx + "/dpProcess/queryDataTable.action";
        $.getJSON(url, param, function (data) {
        	table.rows.add(data).draw();
        });
    }
	
	// 双公示数据质量柱状图数据源
	function queryBarData(){
			var params = getConditions();
			$.post(ctx + '/dpProcess/querySgsDataQuality.action', params,
				function(data) {
					initBar(data);
				}, "json");
	}
	// 双公示数据质量排行
	function publicityDataRank() {
		var params = getConditions();
		$.post(ctx + '/dpProcess/querySgsDataRanking.action',
				params, function(data) {
			      var xk = data.xk;
				  if (!$.isEmptyObject(xk)) {
					  var category = xk.BMMC;
					  var yxRatio = xk.XKSIZE;
					  initXzxkRankChart(category, yxRatio);
				  }
				  
				  var cf = data.cf;
				  if (!$.isEmptyObject(cf)) {
					  var category = cf.BMMC;
					  var sxRatio = cf.CFSIZE;
					  initXzcfRankChart(category, sxRatio);
				  }
				}, "json");
	}

	
	  //	初始化表格数据
	function initDataTable() {
		dataTable.clear().draw();
		dataTable.rows.add(tableData).draw();
	}
	
	// 导出
	function exportDeptData() {
        loading();
        var params = getConditions();
        var url = ctx + '/dpProcess/exportSgsData.action';

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': params.startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': params.endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'type', 'value': params.type}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'dimension', 'value': params.dimension}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': params.deptId}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
	}



	return {
        conditionSearch: conditionSearch,
        exportDeptData: exportDeptData,
        conditionReset: conditionReset
        
	}
})();





