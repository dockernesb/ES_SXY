var businessApplication = (function() {

	$.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
		// 初始下拉框
		$("#xqbm").select2({
			placeholder : '全部部门',
			allowClear : false,
			language : 'zh-CN',
			data : result
		});
		$('#xqbm').val(null).trigger("change");
		resizeSelect2($("#xqbm"));
		$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '0px');
		
	});
	
	var start = {
		elem : '#startDate',
		format : 'YYYY-MM-DD',
		max : '2099-12-30', // 最大日期
		istime : false,
		istoday : false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose : function(datas) {
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
			start.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(start);
	laydate(end);

	// 内容分析
	var dbXData= [];// x轴类目
	var dbYData = [];// y轴数据
	var dbToolTipPercent = []; // 百分比
	var dbCFYData = [];// 行政处罚y轴数据
	var dbXKYData = [];// 行政许可y轴数据
	
	// 内容趋势累计
	var trendsLJXData = [];// x轴类目
	var trendsLJYData = [];// y轴数据
	var huanbiYData = [];// 环比y轴数据
	
	// 内容趋势新增
	var trendsXZXData = [];// x轴类目
	var trendsXZYData = [];// y轴数据
	var tongbiYData = [];// 同比y轴数据
	
	// 当前所选主题
	var selectedElementIndex = 1;
	
	// 维度分析
	var dimension = "";
	
	var contentBarTitle = "报告用途分析";
	var trendBarLJTitle = "用途-累计趋势分析";
	var trendBarXZTitle = "用途-新增趋势分析";
	
	var legendName = "报告申请数";
	
	var headingTitle = "报告用途";
	var headingTitle1 = "报告用途本期占比";
	
	var toolTip = "报告申请数量";
	// 柱状图宽度
	var barWidth = 100;
	
	// 父级选中名称
	var selectedName ="";
	
	// 统计主题
	var reportCategory = 1; // 信用报告
	var objectionCategory = 2; // 异议申诉
	var repairCategory = 3; // 信用修复
	var checkCategory = 4; // 信用核查
	var publicityCategory = 5; // 双公示

	var myChart1 = echarts.init(document.getElementById("repairAnalysisBar"));
	
	var myChart2 = echarts.init(document.getElementById("repairTrendLeijiBar"));
	
	var myChart3 = echarts.init(document.getElementById("repairTrendXinzeBar"));

	var myChartCf = echarts.init(document.getElementById('sgsXzcfSort'));
	
	var myChartXk = echarts.init(document.getElementById('sgsXzxkSort'));
	
	
	// 初始化柱状图
	function initBar() {
		var option = {
			title : {
				text : contentBarTitle,
				subtext : '',
				left : 'center'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function(params, ticket, callback) {
					var value = typeof(params[0].value)=="undefined"?0:params[0].value;
					var tooltipD = params[0].name + "<br />"
						+ params[0].seriesName + " : " + value
						+ "<br />" + "所占比例 : "
						+ dbToolTipPercent[params[0].dataIndex] + "%";
					if (selectedElementIndex == 5) {
						if(params.length == 1){
							tooltipD = params[0].name + "<br />"
							+ params[0].seriesName + " : " + value + "<br />"
						}else if(params.length == 2){
							var value1 = typeof(params[1].value)=="undefined"?0:params[1].value;
							tooltipD = params[0].name + "<br />"
							+ params[0].seriesName + " : " + value + "<br />"
							+ params[1].seriesName + " : " + value1;
						}
					}
					return tooltipD;
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
						type : [ 'line' ]
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
			legend: {
		    	top : '50',
				right : '50',
		        data: ['行政许可','行政处罚']
		    },
			xAxis : [ {
				type : 'category',
				show : true,
			   	/*axisLabel : {
					rotate : -45
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
				minInterval : 1,// 最小刻度
				show : true,
				axisLabel : {
					formatter : function(val) {
						var unit = "条";

                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000条，则显示35.5万条；
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
			series : function(){
				var series = [];
				if (selectedElementIndex == 5) {
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
							barWidth : barWidth,
							data : dbXKYData
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
							barWidth : barWidth,
							data : dbCFYData
						};
					series.push(item2);
				} else {
					var item1 = {
							name : toolTip,
							type : 'bar',
							stack : '任务量',
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
							barWidth : barWidth,
							data : dbYData
						};
						series.push(item1);
				}
				return series;
			}()
		};
		myChart1.setOption(option);
		myChart1.hideLoading();
	}

	// 没有滚动轴
	function initBarNoAxis() {
		var option = {
			title : {
				text : contentBarTitle,
				subtext : '',
				left : 'center'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function(params, ticket, callback) {
					var value = typeof(params[0].value)=="undefined"?0:params[0].value;
					var pecent = typeof(dbToolTipPercent[params[0].dataIndex])=="undefined"?0:dbToolTipPercent[params[0].dataIndex];
                    pecent= pecent==null?0:pecent;
					var tooltipD = params[0].name + "<br />"
							+ params[0].seriesName + " : " + value
							+ "<br />" + "所占比例 : "
							+ pecent + "%";
                    return tooltipD;
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
						type : [ 'line' ]
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
			legend: {
		    	top : '50',
				right : '50',
		        data: ['行政许可','行政处罚']
		    },
			xAxis : [ {
				type : 'category',
				show : true,
			   	/*axisLabel : {
					rotate : -45
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
				minInterval : 1,// 最小刻度
				show : true,
				axisLabel : {
					formatter : function(val) {
						var unit = "条";

                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000条，则显示35.5万条；
                            val = val/10000+'万'
                        }

						return val + unit;
					}
				}
			} ],
			textStyle: {
				color: '#666'
			},
			series : [ {
				name : toolTip,
				type : 'bar',
				stack : '任务量',
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
				barWidth : barWidth,
				data : dbYData
			} ]
		};
		myChart1.setOption(option);
		myChart1.hideLoading();
	}
	
	//信用报告增加自然人统计
	function initCreditReport() {
		var option = {
			title : {
				text : contentBarTitle,
				subtext : '',
				left : 'center'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function(params, ticket, callback) {
					var value;
					var pecent;
					var tooltipD;
					
					value = typeof(params[0].value)=="undefined"?0:params[0].value;
					pecent = typeof(dbToolTipPercent[params[0].dataIndex])=="undefined"?0:dbToolTipPercent[params[0].dataIndex];
					tooltipD = params[0].name + "<br />"
							+ params[0].seriesName + " : " + value
							+ "<br />" + "所占比例 : "
							+ pecent + "%";
					if (value == "'-'") {
						value = typeof(params[1].value)=="undefined"?0:params[1].value;
						pecent = typeof(dbToolTipPercent[params[1].dataIndex])=="undefined"?0:dbToolTipPercent[params[1].dataIndex];
						tooltipD = params[1].name + "<br />"
						+ params[1].seriesName + " : " + value
						+ "<br />" + "所占比例 : "
						+ pecent + "%";
					}
					
					return tooltipD;
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
						type : [ 'line' ]
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
			legend: {
		    	top : '50',
				right : '50',
		        data: ['企业法人','自然人']
		    },
			xAxis : [ {
				type : 'category',
				show : true,
			   	axisLabel : {
					rotate : -45,
					interval :0
				},
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
				minInterval : 1,// 最小刻度
				show : true,
				axisLabel : {
					formatter : function(val) {
						var unit = "条";

                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000条，则显示35.5万条；
                            val = val/10000+'万'
                        }

						return val + unit;
					}
				}
			} ],
			textStyle: {
				color: '#666'
			},
			series : [ {
				name : '企业法人',
				type : 'bar',
				stack : '任务量',
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
//				barWidth : barWidth,
				data : dbLegalYData
			},
			{
				name : '自然人',
				type : 'bar',
				stack : '任务量',
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
//				barWidth : barWidth,
				data : dbNaturalYData
			}]
		};
		myChart1.setOption(option);
		myChart1.hideLoading();
	}
	
	
    function initMap(category, total){
    	var sum = 0;
    	
    	var dataSeries = [];
    	for (var i = 0; i < total.length; i++){
    		sum += parseInt(total[i]);
    	}
    	
    	for (var i = 0; i < total.length; i++){
    		var obj = {};
    		obj.value = total[i];
    		if (sum == 0 || total[i] / sum < 0.3) {
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
    		        trigger: 'axis'
    		    },
    		    grid: {
    		        top: '40'
    		    },
    		    xAxis: {
    		        type: 'value',
    		        minInterval: 1,//最小刻度
    		        axisLabel : {
    					formatter : function(val) {

                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }

    						return val;
    					}
    				},
    		        splitLine: {
    		            show: false
    		        },
    		        axisLine: {
    		            show: false
    		        },
    		        axisTick: {
    		            show: false
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
    		        	name : '行政处罚',
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
   	myChartCf.setOption(option);
   }
    
    var labelRight = {
    	    normal: {
    	        position: 'right'
    	    }
    };
 
    function initMapXk(category, total){
    	var sum = 0;
    	
    	var dataSeries = [];
    	for (var i = 0; i < total.length; i++){
    		sum += parseInt(total[i]);
    	}
    	
    	for (var i = 0; i < total.length; i++){
    		var obj = {};
    		obj.value = total[i];
    		if (sum == 0 || total[i] / sum < 0.3) {
    			obj.label = labelRight;
    		}
    		dataSeries.push(obj);
    	}
    	var option = {
    		    title: {
    		        text: '行政许可排行',
    		        left :70,
    		        textStyle: {
    		        	fontSize: 15
    		        	}
    		    },
    		    tooltip: {
    		        trigger: 'axis'
    		    },
    		    grid: {
    		        top: '40'
    		    },
    		    xAxis: {
    		        type: 'value',
    		        minInterval: 1,//最小刻度
    		        axisLabel : {
    					formatter : function(val) {

                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }

    						return val;
    					}
    		        },
    		        splitLine: {
    		            show: false
    		        },
    		        axisLine: {
    		            show: false
    		        },
    		        axisTick: {
    		            show: false
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
    		            },
    		            formatter : function(val) {

                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }

    						return val;
    					}
    		        },
    		        data: category
    		    },
    		    series: [
    		        {
    		        	name : '行政许可',
    		            type: 'bar',
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
						},
    		            data: dataSeries
    		        }
    		    ]
    		};
   	myChartXk.setOption(option);
   }
    
	// 内容趋势累计柱状图
	function initTrendsLJBar(name) {
		var nameStr = trendBarLJTitle;
		if (name) {
			trendBarLJTitleArr = trendBarLJTitle.split("-");
			nameStr = name + "-" + trendBarLJTitleArr[1];
		}
		option = {
			title : {
				text :nameStr,
				subtext : '',
				left : 'center'
			},
		    tooltip: {
		        trigger: 'axis',
	        	axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function (params, ticket, callback) {
					var tipStr = "";
					var valName = "累计值";
					if (params && params.length > 0) {
						for (var i = 0;i < params.length;i++) {
							if (params[i].seriesName == legendName) {
								tipStr += params[i].name +  "<br />";
								tipStr += valName + " : " + params[i].value +  "<br />";
							} else if (params[i].seriesName == "环比") {
								tipStr += params[i].seriesName + " : " + params[i].value + "%<br />";
					 		} else {
					 			var tongbi;
								if (params[i].value != undefined) {
							    	tongbi = params[i].value + "%";
							    } else {
							    	tongbi = "-";
							    }
					 			tipStr += params[i].seriesName + " : " + tongbi + "<br />";
							}
								
						}
					}
					
					return tipStr;
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
						type : [ 'bar' ,'line','line' ]
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
				y2 : 100
			},
		    legend: {
		    	top : '50',
				right : '0',
		        data:[legendName,'环比']
		    },
		    xAxis: [
		        {
		            type: 'category',
		            show : true,
		            axisLabel : {
						rotate : -45,
					},
					boundaryGap : true,
					axisLine : {
						onZero : true
					},
		            data: trendsLJXData
		        }
		    ],
		    yAxis: [
		        {
		            type: 'value',
		            name: '',
		            position: 'left',
		            /* min: 0,
		            max: 250,
		            interval: 50,*/
		            minInterval: 1,//最小刻度
		            axisLabel: {
		            	formatter:  function (val) {
			            	var unit = "条";

                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000条，则显示35.5万条；
                                val = val/10000+'万'
                            }

			            	return val + unit;
		                }
		            }
		        },
		        {
		            type: 'value',
		            name: '',
		            position: 'right',
		            axisLabel: {
		                formatter: '{value} %'
		            }
		        }
		    ],
		    dataZoom : [{
				type : 'inside'	,
				startValue: trendsLJXData[trendsLJXData.length-6],
				endValue: trendsLJXData[trendsLJXData.length]
			    }, {
				show : true,
				height : 40,
				type : 'slider',
				top : '90%',
				right : '12%',
				left : '12%'
			} ],
		    series: [
		        {
		            name:legendName,
		            type:'bar',
		            data: trendsLJYData,
			        itemStyle : {
						normal : {
							color : function(params) {     
								return '#b0e181';
							},
							lineStyle:{
								color:'#b0e181'
							}
						}
					}
		        },
		        {
		            name:'环比',
		            type:'line',
		            yAxisIndex: 1,
		            data:huanbiYData,
		            itemStyle : {
						normal : {
							color : function(params) {
								return '#e1a4df';
							},
							lineStyle:{
								color:'#e1a4df'
							}
						}
					}
		        }
		    ]
		};
		myChart2.setOption(option);
		myChart2.hideLoading();
	}
	
	// 内容趋势新增柱状图
	function initTrendsXZBar(name) {
		var nameStr = trendBarXZTitle;
		if (name) {
			trendBarXZTitleArr = trendBarXZTitle.split("-");
			nameStr = name + "-" + trendBarXZTitleArr[1];
		}
		option = {
			title : {
				text :nameStr,
				subtext : '',
				left : 'center'
			},
		    tooltip: {
		        trigger: 'axis',
	        	axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function (params, ticket, callback) {
					var tipStr = "";
					var valName = "新增值";
					if (params && params.length > 0) {
						for (var i = 0;i < params.length;i++) {
							if (params[i].seriesName == legendName) {
								tipStr += params[i].name +  "<br />";
								tipStr += valName + " : " + params[i].value +  "<br />";
							} else if (params[i].seriesName == "环比") {
								tipStr += params[i].seriesName + " : " + params[i].value + "%<br />";
					 		} else {
					 			var tongbi;
								if (params[i].value != undefined) {
							    	tongbi = params[i].value + "%";
							    } else {
							    	tongbi = "-";
							    }
					 			tipStr += params[i].seriesName + " : " + tongbi + "<br />";
							}
								
						}
					}
					
					return tipStr;
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
						type : [ 'bar' ,'line','line' ]
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
				//containLabel : true,// 防止label溢出
				x2 : 120,
				y2 : 100
			},
		    legend: {
		    	top : '50',
				right : '0',
		        data:[legendName,'环比','同比']
		    },
		    xAxis: [
		        {
		            type: 'category',
		            show : true,
		            axisLabel : {
						rotate : -45,
					},
					boundaryGap : true,
					axisLine : {
						onZero : true
					},
		            data: trendsXZXData
		        }
		    ],
		    yAxis: [
		        {
		            type: 'value',
		            name: '',
		            position: 'left',
		            /* min: 0,
		            max: 250,
		            interval: 50,*/
		            minInterval: 1,//最小刻度
		            axisLabel: {
		            	formatter:  function (val) {
			            	var unit = "条";

                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000条，则显示35.5万条；
                                val = val/10000+'万'
                            }

			            	return val + unit;
		                }
		            }
		        },
		        {
		            type: 'value',
		            name: '',
		            position: 'right',
		            axisLabel: {
		                formatter: '{value} %'
		            }
		        },
		        {
		            type: 'value',
		            name: '',
		            offset: 150,
		            position: 'right',
		            axisLabel: {
		                formatter: '{value} %'
		            }
		        }
		    ],
		    dataZoom : [ {
				type : 'inside',
				startValue: trendsXZXData[trendsXZXData.length-6],
				endValue: trendsXZXData[trendsXZXData.length]
		    }, {
				show : true,
				height : 40,
				type : 'slider',
				top : '90%',
				right : '10%',
				left : '10%'
			} ],
		    series: [
		        {
		            name:legendName,
		            type:'bar',
		            data: trendsXZYData,
			        itemStyle : {
						normal : {
							color : function(params) {     
								return '#a69ae4';
							},
							lineStyle:{
								color:'#a69ae4'
							}
						}
					}
		        }, {
		            name:'环比',
		            type:'line',
		            yAxisIndex: 1,
		            data:huanbiYData,
		            itemStyle : {
						normal : {
							color : function(params) {
								return '#e1a4df';
							},
							lineStyle:{
								color:'#e1a4df'
							}
						}
					}
		        },
		        {
		            name:'同比',
		            type:'line',
		            yAxisIndex: 1,
		            data:tongbiYData,
		            itemStyle : {
						normal : {
							color : function(params) {
								return '#fbb321';
							},
							lineStyle:{
								color:'#fbb321'
							}
						}
					}
		        }
		    ]
		};
		myChart3.setOption(option);
		myChart3.hideLoading();
	}
	

	$(function(){
		
		
		conditionSearch(1);
	
		chartBindClick();
		
		toggleBox(document.getElementById("xybgDiv"),1);
	
	});
	
	function chartBindClick(){
		myChart1.on('click', function (param){ 
			switch(selectedElementIndex) {
		    case 2: 
				table=table1;
		    	break;
		    case 3: 
				table=table1;
		    	break;
		    case 4: 
				table=table1;
		    	break;
		    case 5: 
		    	table=table2;
		        break;
		    default:
			    table=table1;
		        break;
			}
			var name = param.name;
			linkageSearch(name);
	    });  
	}
	
	function conditionSearch(type) {
		var params = getConditions();
		
		flag = false;
		
		 if(selectedElementIndex == 5){
			$("#dataTable").hide();
			$("#dataTable2").show();
			if(!table2){
				initTable2(params);
			}else{
				table = table2;
				searchTalbe(params);
			}
		 }else{
			 $("#dataTable2").hide();
			 $("#dataTable").show();
			 if (type == 1) {
					initTable(params,type);
				} else {
					searchTalbe(params);
				}
				
		 }
		
		// 重新初始化否则部分动态的属性值无法替换
	    myChart2 = echarts.init(document.getElementById("repairTrendLeijiBar"));
		
		myChart3 = echarts.init(document.getElementById("repairTrendXinzeBar"));
		
		$("#headingTitle").html(headingTitle);
		$("#headingTitle2").html(headingTitle1);
		$("#headingTitle3").html(headingTitle1);
		
		contentAnalysisSearch(params);
		if (selectedElementIndex == 5) {
			publicityRank(1);
			publicityRank(2);
		} else {
			contentTrendSearch(params, 1);// 累计
			contentTrendSearch(params, 2);// 新增
		}
		getAllTotalByCategory(params);
	}

	// 获取查询条件的值
	function getConditions() {
     var params = {};
     params.category = selectedElementIndex;
	 var xyzt = $("input[name='xyzt']:checked").val();
	 switch(selectedElementIndex) {
	    case 2: 
	    	if (xyzt == 1) {
	    		params.dimension = 1;	
	    		legendName = "异议记录数";
	    		headingTitle = "申诉内容";
	    		headingTitle1 = "申诉内容本期占比";
	    		contentBarTitle = "申诉内容分析";
				trendBarLJTitle = "申诉内容-累计趋势分析";
				trendBarXZTitle = "申诉内容-新增趋势分析";
				toolTip = "异议记录数量";
		   	} else {
		   		params.dimension = 2; 
		   		legendName = "异议申请数";
	    		headingTitle = "数据提供部门";
	    		headingTitle1 = "提供部门本期占比";
	    		contentBarTitle = "数据提供部门分析";
				trendBarLJTitle = "部门-累计趋势分析";
				trendBarXZTitle = "部门-新增趋势分析";
				toolTip = "异议申请数量";
		   	}
	    	break;
	    case 3: 
	    	if (xyzt == 1) {
	    		params.dimension = 3;	
	    		legendName = "修复记录数";
	    		headingTitle = "修复内容";
	    		headingTitle1 = "修复内容本期占比";
	    		contentBarTitle = "修复内容分析";
				trendBarLJTitle = "修复内容-累计趋势分析";
				trendBarXZTitle = "修复内容-新增趋势分析";
				toolTip = "修复记录数量";
		   	} else {
		   		params.dimension = 2;
		   		legendName = "修复申请数";
		   		headingTitle = "数据提供部门";
	    		headingTitle1 = "提供部门本期占比";
	    		contentBarTitle = "数据提供部门分析";
				trendBarLJTitle = "部门-累计趋势分析";
				trendBarXZTitle = "部门-新增趋势分析";
				toolTip = "修复申请数量";
		   	}
	    	break;
	    case 4: 
	    	if (xyzt == 1) {
	    		params.dimension = 4; 
	    		headingTitle = "审查类别";
	    		headingTitle1 = "审查类别本期占比";
	    		contentBarTitle = "审查类别分析";
				trendBarLJTitle = "审查类别-累计趋势分析";
				trendBarXZTitle = "审查类别-新增趋势分析";
		   	} else {
		   		params.dimension = 5; 
		   		headingTitle = "申请部门";
	    		headingTitle1 = "申请部门本期占比";
	    		contentBarTitle = "申请部门分析";
				trendBarLJTitle = "申请部门-累计趋势分析";
				trendBarXZTitle = "申请部门-新增趋势分析";
		   	}
	    	toolTip = "企业记录数";
	    	legendName = "企业记录数";
	    	break;
	    case 5: 
	    	if (xyzt == 1) {
	    		params.dimension = 7;
	    	} else {
	    		params.dimension = 6;
	    	}
	        legendName = "报告申请数";
	       // headingTitle = "双公示分析";
    		//headingTitle1 = "报告用途本期占比";
    		contentBarTitle = "双公示分析";
			//trendBarLJTitle = "用途-累计趋势分析";
			//trendBarXZTitle = "用途-新增趋势分析";
			//toolTip = "报告申请数量";
	        break;
	    default:
	    	params.dimension = "";
	        legendName = "报告申请数";
	        headingTitle = "报告用途";
    		headingTitle1 = "报告用途本期占比";
    		contentBarTitle = "报告用途分析";
			trendBarLJTitle = "用途-累计趋势分析";
			trendBarXZTitle = "用途-新增趋势分析";
			toolTip = "报告申请数量";
	        break;
	}
	 
	// 开始时间
	var startDate = $("#startDate").val();
	// 结束时间
	var endDate = $("#endDate").val();
	//双公示增加部门查询
	if (selectedElementIndex == 5) {
		var department = $("#xqbm").val();
		params.department = department;
	}
	params.startDate = startDate;
	params.endDate = endDate;
	return params;
	}
    
	// 查询各主题申诉数量
	function getAllTotalByCategory(params) {
		// 信用报告
		getTotalByCategory(params, reportCategory);
		// 异议申诉
		getTotalByCategory(params, objectionCategory);
		 // 信用修复
		getTotalByCategory(params, repairCategory);
		// 信用核查
		getTotalByCategory(params, checkCategory);
		// 双公示
		getTotalByCategory(params, publicityCategory);
	}
	
	// 根据各种统计主题和统计时间阶段统计数量
	function getTotalByCategory(params, category) {
		params.category = category;
		$.post(ctx + '/center/businessApplication/getTotalByCategory.action',
				params, function(data) {
					switch(category) {
					case reportCategory:
						$("#xybg").html(data.total);
						break;
					case objectionCategory:
						$("#yycl").html(data.total);
						break;
					case repairCategory:
						$("#xyxf").html(data.total);
						break;
					case publicityCategory:
						$("#sgs").html(data.total);
						break;
					default:
						$("#xyhc").html(data.total);
						break;
					}
				}, "json");
	}
	
	// 内容分析查询
	function contentAnalysisSearch(params) {
		params.chartTheme = 1;
		var url = '/center/businessApplication/queryBusinessApplication.action';
		if (selectedElementIndex == 5) {
			url = '/center/businessApplication/queryPublicity.action';
			$("#repairAnalysisBar").width("70%");
		} else {
			$("#repairAnalysisBar").width("100%");
		}
		
		$.post(ctx + url,
				params, function(data) {
					dbXData = [];
					dbYData = [];
					dbCFYData = [];
					dbXKYData = [];
					//信用报告分析增加自然人统计
					dbLegalYData = [];
					dbNaturalYData = [];
					if (data.IDX.CATEGORY) {
						dbXData = data.IDX.CATEGORY;
					}
					if (selectedElementIndex == 5) {
						if (data.IDY.CF_TOTAL) {
							dbCFYData = data.IDY.CF_TOTAL;
						}
						if (data.IDY.XK_TOTAL) {
							dbXKYData = data.IDY.XK_TOTAL;
						}
						//信用报告分析增加自然人统计
					} else if (selectedElementIndex == 1) {		
						if (data.IDY.TOTAL) {
							var dbTotalData = data.IDY.TOTAL;
							var dbKeyData = data.IDY.GROUP_KEY;
							for (var i = 0; i < dbKeyData.length; i++) {
								if (dbKeyData[i] == 'applyReportPurpose') {
									dbLegalYData.push(dbTotalData[i]);
									dbNaturalYData.push("'-'");
								} else if (dbKeyData[i] == 'applyPReportPurpose') {
									dbNaturalYData.push(dbTotalData[i]);
									dbLegalYData.push("'-'");
								}
							}
						}
						if (data.IDY.RATING_NUM) {
					        dbToolTipPercent = data.IDY.RATING_NUM;
					    }
					} else {
						if (data.IDY.TOTAL) {
							dbYData = data.IDY.TOTAL;
						}
						if (data.IDY.RATING_NUM) {
					        dbToolTipPercent = data.IDY.RATING_NUM;
					    }
					}
					
					var xyzt = $("input[name='xyzt']:checked").val();
					
					// 初始化为了消除滚动轴相互影响
					myChart1 = echarts.init(document.getElementById("repairAnalysisBar"));
					
					chartBindClick();  
					// 部门数达到一定数量显示拖动轴
					if ((selectedElementIndex != 1) && xyzt != 1 && dbXData.length > 20 || selectedElementIndex == 5) {
						initBar();
					//信用报告分析增加自然人统计
					} else if (selectedElementIndex == 1) {
						initCreditReport();
					} else {
						initBarNoAxis();
					}
					
					
				}, "json");
	}

	// 根据行业名称查询行业增环比情况和行业分级情况
	function linkageSearch(name){
		flag = true;
		
		var params = getConditions();
		
		contentTrendSearch(params, 1, name);// 累计
		
		contentTrendSearch(params, 2, name);// 新增
		
		searchTalbe(params, name);
	}
	
	// 内容趋势查询
	function contentTrendSearch(params, trendType, name) {
		params.chartTheme = 2;
		params.trendType = trendType;
		params.parentCondition = name;
		$.post(ctx + '/center/businessApplication/queryBusinessApplication.action',
				params, function(data) {
			        if (trendType == 1) {
			        	huanbiYData = [];
			            trendsLJXData = [];
					    trendsLJYData = [];
					    if (data.IDX.CATEGORY) {
					    	trendsLJXData = data.IDX.CATEGORY;
						}
						if (data.IDY.TOTAL) {
							trendsLJYData = data.IDY.TOTAL;
							huanbiYData = data.IDY.HUANBI;
						}
						initTrendsLJBar(name);
			        } else {
			            tongbiYData = [];
					    huanbiYData = [];
			        	trendsXZXData = [];
					    trendsXZYData = [];
					    if (data.IDX.CATEGORY) {
					    	trendsXZXData = data.IDX.CATEGORY;
						}
						if (data.IDY.TOTAL) {
							trendsXZYData = data.IDY.TOTAL;
							huanbiYData = data.IDY.HUANBI;
							tongbiYData = data.IDY.TONGBI;
						}
						initTrendsXZBar(name);
			        }
				}, "json");
	}
	
	// 双公示排行
	function publicityRank(type) {
		var params = getConditions();
		params.publicityType = type;
		$.post(ctx + '/center/businessApplication/queryPublicityRanking.action',
				params, function(data) {
			      var ranking = data.ranking;
			      if (ranking != null && ranking.length > 0) {
			    	var category = [];
			    	var total = [];
			    	for (var i = 0;i < ranking.length;i++) {
			    		category.push(ranking[i].CATEGORY);
			    		total.push(ranking[i].TOTAL);
			    	}
			    	if (type == 1) {
			    		initMapXk(category, total);
			    	} else {
			    		initMap(category, total);
			    	}
			      }
				}, "json");
	}
	
	var table;
	var table1;
	var flag = false;
	var selectedName;
	// 初始化表格数据
	function initTable(params, type){
		params.parentCondition = name;
		var url = ctx + '/center/businessApplication/queryBusinessApplicationTable.action';
	    table1 = $('#dataTable').DataTable({
			ajax : {
				url : url,
				data : params,
				type : 'post'
			},
			serverSide : true,// 如果是服务器方式，必须要设置为true
			processing : true,// 设置为true,就会有表格加载时的提示
			lengthChange : true,// 是否允许用户改变表格每页显示的记录数
			pageLength : 10,
			searching : false,// 是否允许Datatables开启本地搜索
			paging : true,
            ordering : true,
            aaSorting: [[ 1, "desc" ]],
            aoColumnDefs : [ { "bSortable": false, "aTargets": [ 0] }],
			autoWidth : false,
			columns : [{
				"data" : null,
				 render : function(data, type, row, meta) {
						// 显示行号
						var startIndex = meta.settings._iDisplayStart;
						return startIndex + meta.row + 1;
				 }
			},{
				"data" : "SHIJIAN",
				"render" : function(data, type, row) {
					var str = getTime();
					if (flag) {
						str = data;
					} else {
						 
					}
					return str;
				}
			}, {
				"data" : "SHIJIAN",
				"render" : function(data, type, row) {
					var str = selectedName;
					if (!flag) {
						str = data;
					}
					return str;
				}
			}, {
				"data" : "XINZENG"
			},{
				"data" : "XZZHANBI",
				"render" : function(data, type, row) {
					var str = "0%";
					if (data != null) {
						str = data + "%";
					}
					return str;
				}
			}, {
				"data" : "XZHUANBI",
				"render" : function(data, type, row) {
					var str = data + "%";
					return str;
				}
			},{
				"data" : "XZTONGBI",
				"render" : function(data, type, row) {
					var str = data + "%";
					return str;
				}
			},{
				"data" : "LEIJI"
			}, {
				"data" : "LJZHANBI",
				"render" : function(data, type, row) {
					var str = (data || 0) + "%";
					return str;
				}
			},{
				"data" : "LJHUANBI",
				"render" : function(data, type, row) {
					var str = data + "%";
					return str;
				}
			}]/*,
			"drawCallback" : function(settings) {
				 if (type == 1) {
					 toggleBox(document.getElementById("xybgDiv"), 1);
				 }
			}*/
		});
	}
	
	var table2;
	// 初始化表格数据
	function initTable2(params){
		var url = ctx + '/center/businessApplication/queryPublicityTable.action';
	    table2 = $('#dataTable2').DataTable({
			ajax : {
				url : url,
				data : params,
				type : 'post'
			},
			serverSide : true,// 如果是服务器方式，必须要设置为true
			processing : true,// 设置为true,就会有表格加载时的提示
			lengthChange : true,// 是否允许用户改变表格每页显示的记录数
			pageLength : 10,
			searching : false,// 是否允许Datatables开启本地搜索
			paging : true,
            ordering : true,
            aaSorting: [[ 1, "desc" ]],
            aoColumnDefs : [ { "bSortable": false, "aTargets": [ 0] }],
			autoWidth : false,
			columns : [{
				"data" : null,
				 render : function(data, type, row, meta) {
						// 显示行号
						var startIndex = meta.settings._iDisplayStart;
						return startIndex + meta.row + 1;
				 }
			},{
				"data" : "CATEGORY"
			},{
				"data" : "TOTAL"
			}, {
				"data" : "XK_TOTAL"
			},{
				"data" : "CF_TOTAL"
			}, {
				"data" : "CREATE_TIME"
			}]
		});
	}
	
	// 查询行业表格数据
	function searchTalbe(params, name) {
		if (name) {
			selectedName = name;
		}
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["department"] = params.department;
			data["dimension"] = params.dimension;
			data["category"] = params.category;
			data["startDate"] = params.startDate;
			data["endDate"] = params.endDate;
			data["parentCondition"] = name;
			table.ajax.reload();
		}
	}
	
	// 切换主题
	function toggleBox(obj, index){
		var eleClass = $(obj).find($(".elementsOpa")).attr("class");
    	selectedElementIndex = index;
    	var className = "elementsActive";
    	if (window.ActiveXObject) {
            var reg = /9\.0/;
            var str = navigator.userAgent;
            if (reg.test(str)) {
            	className = "elementsActive1";
            }
    	}
    	$(obj).find($(".elementsOpa")).addClass(className);
    	$(".elementsOpa").not($(obj).find($(".elementsOpa"))).removeClass(className);
    	animate_ie9(obj);
    	correspondingElements();
	}
	
	// ie9实现动画效果
	function animate_ie9(obj){
		if (window.ActiveXObject) {
            var reg = /9\.0/;
            var str = navigator.userAgent;
            if (reg.test(str)) {
            	$(".elementsOpa").removeClass("elementsActive");
            	$(".elementsOpa").stop();
            	$("#overLayer").remove();
            	var div = "<div id='overLayer' class='elementsOpa elementsActive1'></div>";
            	$(obj).find($(".dashboard-stat")).append(div);
            	$(obj).find($(".elementsActive1")).not($("#overLayer")).css({"background-image":"url(" + ctx + "/app/images/overbg.png)","width":"20000px",left:"0px"});
            	$(".elementsOpa").not($(obj).not($("#overLayer")).find($(".elementsOpa"))).css("background-image","none");
            	$(obj).find($(".elementsActive1")).not($("#overLayer")).animate({left:"-20000px"},300000,"linear");
            };
        }
	}
	
	// 不同主题显示不同的页面元素
	function correspondingElements(){
		var weiduspan1 = "";
		var weiduspan2 = "";
		barWidth = "auto";
		$("#weiduDiv").show();
		$("#repairTrendXinzeBar").show();
		$("#repairTrendLeijiBar").show();
		$("#sgsSortBox").hide();
		$("#dataTable_wrapper").show();
		$("#dataTable2_wrapper").hide();
		var xyzt = $("input[name='xyzt']:checked").val();
		switch(selectedElementIndex) {
		    case 2: 
		    	$("#weisgsDiv").hide();
		    	weiduspan1 = "申诉内容分析";
		    	weiduspan2 = "数据提供部门分析";
		    	contentBarTitle = "申诉内容分析";
				trendBarLJTitle = "申诉内容-累计趋势分析";
				trendBarXZTitle = "申诉内容-新增趋势分析";
				$("#zxjlLabel").attr("title","");
				$("#cxjlLabel").attr("title","汇总异议处理申请发起时有异议的所有数据记录");
				table=table1;
		    	break;
		    case 3: 
		    	$("#weisgsDiv").hide();
		    	weiduspan1 = "修复内容分析";
		    	weiduspan2 = "数据提供部门分析";
		    	contentBarTitle = "修复内容分析";
				trendBarLJTitle = "修复内容-累计趋势分析";
				trendBarXZTitle = "修复内容-新增趋势分析";
				barWidth = 100;
				$("#zxjlLabel").attr("title","");
				$("#cxjlLabel").attr("title","汇总信用修复申请发起时待修复的所有数据记录");
				table=table1;
		    	break;
		    case 4: 
		    	$("#weisgsDiv").hide();
		    	weiduspan1 = "审查类别分析";
		    	weiduspan2 = "申请部门分析";
		    	contentBarTitle = "审查类别分析";
				trendBarLJTitle = "审查类别-累计趋势分析";
				trendBarXZTitle = "审查类别-新增趋势分析";
				$("#zxjlLabel").attr("title","汇总信用审查申请发起时各部门提交的待审查企业记录");
				$("#cxjlLabel").attr("title","汇总信用审查申请发起时各审查类别分别涉及的待审查企业记录");
				table=table1;
		    	break;
		    case 5: 
		    	/*$("#weiduDiv").hide();*/
		    	$("#weisgsDiv").show();
		    	weiduspan1 = "上报时间";
		    	weiduspan2 = "决定日期";
		    	$("#repairTrendXinzeBar").hide();
				$("#repairTrendLeijiBar").hide();
				$("#sgsSortBox").show();
				$("#dataTable_wrapper").hide();
				$("#dataTable2_wrapper").show();
		    	contentBarTitle = "双公示分析";
		    	$("#zxjlLabel").attr("title","");
				$("#cxjlLabel").attr("title","");
		    	table=table2;
		        break;
		    default:
		    	$("#weiduDiv").hide();
		        $("#weisgsDiv").hide();
		        contentBarTitle = "报告用途分析";
			    trendBarLJTitle = "用途-累计趋势分析";
			    trendBarXZTitle = "用途-新增趋势分析";
			    barWidth = 100;
			    table=table1;
		        break;
		}
		
		if (selectedElementIndex != 1) {
			$("#weiduspan1").html(weiduspan1);
			$("#weiduspan2").html(weiduspan2);
		}
		
		$("#zxjl").attr("checked", true);
		
		conditionSearch();
		//双公示排行
		if ( selectedElementIndex == 5 ) {
			publicityRank(1);
			publicityRank(2);
		}
	}
	
	// 获取查询截止时间
	function getTime(){
		var tjsj = new Date();	
		var year = tjsj.getFullYear(); 
		var month = tjsj.getMonth() + 1;
		var dateStr = year + "-" + month;
		if ($("#endDate").val()) {
			dateStr = $("#endDate").val().substring(0,7);
		}
		return dateStr;
	}
	
	// 重置
	function conditionReset() {
		$("#zxjl").attr("checked", true);
		resetSearchConditions('#startDate,#endDate,#xqbm');
		resetDate(start,end);
	}

	return {
		conditionReset : conditionReset,
		conditionSearch : conditionSearch,
		toggleBox : toggleBox
	}
})();
