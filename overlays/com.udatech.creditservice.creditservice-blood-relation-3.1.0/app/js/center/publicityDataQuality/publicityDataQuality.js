var publicityDataQuality = (function() {
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

	$(function() {
		queryBarData();
		publicityDataRank();
	});

	var url = ctx + '/center/publicityDataQuality/queryPublicityDQTable.action';
	var table = $('#dataTable').DataTable({
		ajax : {
			url : url,
			type : 'post',
			data : {
				queryType :  $("input[name='sgs']:checked").val(),
			}
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		pageLength : 10,
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		ordering : true,
		autoWidth : false,
		aaSorting: [[ 5, "desc" ]],
	    aoColumnDefs : [ { "bSortable": false, "aTargets": [ 0, 1, 2, 3, 4] }],
		columns : [ {
			"data" : null,
			render : function(data, type, row, meta) {
				// 显示行号
				var startIndex = meta.settings._iDisplayStart;
				return startIndex + meta.row + 1;
			}
		}, {
			"data" : "CATEGORY"
		}, {
			"data" : "ALLSIZE"
		}, {
			"data" : "PROCESSSIZE"
		}, {
			"data" : "GLSIZE"
		}, /*{
			"data" : "SHIXIAOSIZE"
		},*/ {
			"data" : "YXRATIO",
			"render" : function(data, type, row) {
				var str = "0%";
				if (data != null) {
					str = data + "%";
				}
				return str;
			}
		}, {
			"data" : "GLRATIO",
			"render" : function(data, type, row) {
				var str = "0%";
				if (data != null) {
					str = data + "%";
				}
				return str;
			}
		}, {
			"data" : "SXRATIO",
			"render" : function(data, type, row) {
				var str = "0%";
				if (data != null) {
					str = data + "%";
				}
				return str;
			}
		} ]
	});

	var myChart1 = echarts.init(document.getElementById("publicityBar"));
	
	var dbXData= [];// x轴类目
	var dbYData_YX = [];// y轴数据,入库量
	var dbYData_UN = [];// y轴数据,入库量
	var dbYData_ALL = [];// y轴数据,上报量
	// 初始化双公示数据质量分析柱状图
	function initBar() {
		var option = {
			title : {
				text : '双公示数据质量分析',
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
				data : dbXData
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
		            	var zhibiao2 = $("input[name='zhibiao2']:checked").val();
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
		        data:['上报数据量','入库数据量','未关联数据量']
			},
			series :  function(){
				var series = [];
				var item1 = {
						name : "上报数据量",
						type : 'bar',
						stack : '上报数据量',
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
						data : dbYData_ALL
					};
				series.push(item1);
					
				var item2 = {
						name : "入库数据量",
						type : 'bar',
						stack : '入库数据量',
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
						data : dbYData_YX
					};
				series.push(item2);

				var item3 = {
						name : "未关联数据量",
						type : 'bar',
						stack : '未关联数据量',
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
									return '#FFDAB9';
								},
								lineStyle : {
									color : '#FFDAB9'
								}
							}
						},
						data : dbYData_UN
					};
				series.push(item3);
				return series;
			}()
		};
		myChart1.clear();
		myChart1.setOption(option);
		myChart1.hideLoading();
	}
	
	var myChart2 = echarts.init(document.getElementById('sgsAccuracyRank'));
	
	var labelRight = {
	    normal: {
	        position: 'right'
	    }
	};
	 
	// 初始化报送入库率排行柱状图
	function initAccuracyRankChart(category, total){
	    	
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
	    		        text: '报送入库率排行',
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
	    					var tooltipD = params[0].name + ":" + value + "%";
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
	    		        max : 100,
	    		        axisTick: {
	    		            show: false
	    		        },
	    		        axisLabel: 
		    		        {formatter: function (value, index) {
				        			return value+"%";
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
	    		        	name : '报送入库率排行',
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
	 
	var myChart3 = echarts.init(document.getElementById('sgsEffectiveRank'));
	
	// 初始化报送时效率排行柱状图
	function initEffectiveRankChart(category, total){
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
	    		        text: '报送时效性排行',
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
	    					var tooltipD = params[0].name + ":" + value + "%";
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
	    		        max : 100,
	    		        axisTick: {
	    		            show: false
	    		        },
	    		        axisLabel: 
	    		        	{formatter: function (value, index) {
	    		        			return value+"%";
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
	    		        	name : '报送时效性排行',
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
	
	// 双公示数据质量柱状图数据源
	function queryBarData(){
			var params = {
				queryType : $("input[name='sgs']:checked").val(),
				beginTime : $("#startDate").val(),
				endTime : $("#endDate").val()
			};
			$.post(ctx + '/center/publicityDataQuality/queryPublicityDataQuality.action', params,
				function(data) {
				dbXData = data.CATEGORY;
				dbYData_UN = data.UNRELATIONSIZE;
				dbYData_YX = data.PROCESSSIZE;
				dbYData_ALL = data.ALLSIZE;
				initBar();
				}, "json");
	}
	
	// 双公示数据质量排行
	function publicityDataRank(type) {
		var params = {
			queryType : $("input[name='sgs']:checked").val(),
			beginTime : $("#startDate").val(),
			endTime : $("#endDate").val()
		};
		$.post(ctx + '/center/publicityDataQuality/queryPublicityDQRanking.action',
				params, function(data) {
			      var accuracy = data.accuracy;
				  if (accuracy != null) {
					  var category = accuracy.CATEGORY;
					  var yxRatio = accuracy.YXRATIO;
					  initAccuracyRankChart(category, yxRatio);
				  }
				  
				  var effective = data.effective;
				  if (effective != null) {
					  var category = effective.CATEGORY;
					  var sxRatio = effective.SXRATIO;
					  initEffectiveRankChart(category, sxRatio);
				  }
				}, "json");
	}
	
	// 带条件的查询
	function queryData() {
		
		var data = table.settings()[0].ajax.data;

		if (!data) {
			data = {};
			table.settings()[0].ajax["data"] = data;
		}
		
		var sgsType = $("input[name='sgs']:checked").val();
		
		data["queryType"] = sgsType;
		data["beginTime"] = $('#startDate').val();
		data["endTime"] = $('#endDate').val();
		
		table.ajax.reload();
	}
	
	// 查询
	function conditionSearch() {
		queryBarData();
		publicityDataRank();
		queryData();
	}
	
	// 重置
	function conditionReset(){
		$("#xzxk").attr("checked", true);
		resetSearchConditions('#startDate,#endDate');
		resetDate(start,end);
	}
	
	// 双公示数据质量统计
	function dataQualityStatistics(sgsType) {
		var url = '/center/publicityDataQuality/queryPublicityDataQuality.action';
		var params = {
			queryType : sgsType,
			beginTime : $("#startDate").val(),
			endTime : $("#endDate").val()
		};
		$.post(ctx + url, function(data) {

		}, "json");
	}

	return {
		conditionSearch : conditionSearch,
		conditionReset  : conditionReset 
	}
})();
