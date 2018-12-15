var timeCredit = (function() {
		$("#xzq").select2();
		$("#hyhf").select2();
		$("#qylx").select2();
		$("#zcgm").select2();
/**** 主体设立年份与信用分布对照图 ****/
		
    // 初始化企业年龄时序图
    var isDefault = true;//对照图是否默认格式
    var obj;
    var bp;
    var g;
    function initEnterpriseAgeSequence(data, data1){
    	$("#bp1").html("");
    	//colors: ["#e1a4df", "#7ed1a5", "#fbb321", "#b0e181", "#7dc4f0", "#a69ae4", "#92cfd3", "#fb9678", "#81a1f3", "#eca8ba", "#f6e347"];
		var color ={"不足3年":"#e1a4df", "3至5年":"#7ed1a5",  "5至10年":"#fbb321", "10至20年":"#b0e181", "20至30年":"#7dc4f0", "30年以上":"#a69ae4"};
		var svg = d3.select("#bp1").append("svg").attr("width", 960).attr("height", 800);
	
		svg.append("text").attr("x",250).attr("y",70)
			.attr("class","header").text("信用主体数");
			
		svg.append("text").attr("x",750).attr("y",70)
			.attr("class","header").text("信用记录数");
	
		 g=[svg.append("g").attr("transform","translate(150,100)")
				,svg.append("g").attr("transform","translate(650,100)")];
	
		bp=[ viz.bP()
				.data(data)
				.min(12)
				.pad(1)
				.height(600)
				.width(200)
				.barSize(35)
				.fill(function(d){return color[d.primary]})		
			,viz.bP()
				.data(data1)
				.min(12)
				.pad(1)
				.height(600)
				.width(200)
				.barSize(35)
				.fill(function(d){return color[d.primary]})
		];
				
		[0,1].forEach(function(i){
			g[i].call(bp[i])
			
			g[i].append("text").attr("x",-50).attr("y",-8).style("text-anchor","middle").text("企业年龄");
			g[i].append("text").attr("x", 250).attr("y",-8).style("text-anchor","middle").text("信用记录时间");
			
			g[i].append("line").attr("x1",-100).attr("x2",0);
			g[i].append("line").attr("x1",200).attr("x2",300);
			
			g[i].append("line").attr("y1",610).attr("y2",610).attr("x1",-100).attr("x2",0);
			g[i].append("line").attr("y1",610).attr("y2",610).attr("x1",200).attr("x2",300);
			
			g[i].selectAll(".mainBars")
				.on("mouseover",mouseover)
				.on("click",itemClick)
			    .on("mouseout",mouseout);
	
			g[i].selectAll(".mainBars").append("text").attr("class","label")
				.attr("x",function(d){return (d.part=="primary"? -30: 30)})
				.attr("y",function(d){return +6})
				.text(function(d){return d.key})
				.attr("text-anchor",function(d){return (d.part=="primary"? "end": "start")});
			
			g[i].selectAll(".mainBars").append("text").attr("class","perc")
				.attr("x",function(d){return (d.part=="primary"? -100: 80)})
				.attr("y",function(d){return +6})
				.text(function(d){ return d3.format("0.0%")(d.percent)})
				.attr("text-anchor",function(d){return (d.part=="primary"? "end": "start")});
		});
		 $(document).click(function(event){//点击非图表区域，恢复默认多对多形式
			 if(!isDefault){
				 [0,1].forEach(function(i){
					 bp[i].click(obj);
					 g[i].selectAll(".mainBars").select(".perc")
					 .text(function(d){ return d3.format("0.0%")(d.percent)});
				 });
			 }
			 isDefault = true;
		});
		function mouseover(d){
			obj = d;
			[0,1].forEach(function(i){
				bp[i].mouseover(d);
				g[i].selectAll(".mainBars").select(".perc")
				.text(function(d){ return d3.format("0.0%")(d.percent)});
			});
			isDefault = false;
		}
		function itemClick(d){
			obj = d;
			[0,1].forEach(function(i){
				bp[i].mouseover(d);
				g[i].selectAll(".mainBars").select(".perc")
				.text(function(d){ return d3.format("0.0%")(d.percent)});
			});
			isDefault = true;
			
		}
		function mouseout(d){
			/*[0,1].forEach(function(i){
				bp[i].click(d);
				
				g[i].selectAll(".mainBars").select(".perc")
				.text(function(d){ return d3.format("0.0%")(d.percent)});
			});*/
			isDefault = false;
		}
		d3.select(self.frameElement).style("height", "800px");
    } 
/**** 行业分布和增减情况柱状图 ****/
	var startDate = new Date();
	startDate.setMonth(startDate.getMonth());
	startDate.setDate(1);
	startDate = startDate.format("yyyy-MM");
	$("#startDate").val(startDate);
	$("#startDate").datepicker({
        language: "zh-CN",
        todayHighlight: true,
        format: 'yyyy-mm',
        autoclose: true,
        startView: 'months',
        maxViewMode:'year',
        minViewMode:'months'
    });

	var myChart1 = echarts.init(document.getElementById("industrySpreadBar"));
	var myChart2 = echarts.init(document.getElementById("huanbiBar"));
	
	// 区域分布情况
	var dbXData= [];// x轴类目
	var dbYData = [];// y轴数据
	var dbToolTipPercent = []; // 百分比
	 
	// 区域趋势分析
	var trendsXData= [];// x轴类目
	var trendsYData = [];// y轴数据
	var huanbiYData = [];// 环比y轴数据
	
	// 初始化柱状图
	function initBar() {
		var option = {
			title : {
				text : '企业年龄分布',
				subtext : '',
				left : 'center'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				}, 
				formatter : function (params, ticket, callback) {
					var tooltipD = params[0].name + "<br />" + params[0].seriesName + " : " + params[0].value + "<br />" + "所占比例 : " + dbToolTipPercent[params[0].dataIndex] + "%";
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
				x : 50,
				x2 : 10,
				y2 : 100
			},
			xAxis : [ {
				type : 'category',
				show : true,
				axisLabel : {
					rotate : -45,
					interval :0
				},
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
			            	var unit = "户";
			            	if (zhibiao2 == 2) {
			            		unit = "条";
			            	}
			            	
			            	if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
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
				name : '总任务',
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
						lineStyle:{
							color:'#fbb321'
						}
					}
				},
				data : dbYData
			}]
		};
		myChart1.setOption(option);
		myChart1.hideLoading();
	}

	// 初始化区域趋势柱状图
	function initTrendsBar(qylnName) {
		var name = '信用企业数';
		var data = ['信用企业数','环比']
    	var zhibiao2 = $("input[name='zhibiao2']:checked").val();
		if (zhibiao2 == 2) {//当统计指标选择"记录数量"时，图例应显示“信用记录数”；
			name='信用记录数';
			data = ['信用记录数','环比']
		}
		var qylnNameStr = "";
		if (qylnName) {
			qylnNameStr += qylnName + "-";
		}
		option = {
			title : {
				text : qylnNameStr + '企业年龄趋势',
				subtext : '',
				left : 'center'
			},
		    tooltip: {
		        trigger: 'axis',
	        	axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function (params, ticket, callback) {
				    var valName = "累计值";
					var tipStr = "";
					if (params && params.length > 0) {
						for (var i = 0;i < params.length;i++) {
							if (params[i].seriesName == "信用企业数"||params[i].seriesName == "信用记录数") {
								tipStr += params[i].name +  "<br />";
								tipStr += valName + " : " + params[i].value +  "<br />";
							} else{
								tipStr += params[i].seriesName + " : " + params[i].value + "%<br />";
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
						type : [ 'line', 'bar' ]
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
				x2 : 100,
				y2 : 100
			},
		    legend: {
		    	top : '50',
				right : '0',
		        data:data
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
		            data: trendsXData
		        }
		    ],
		    yAxis: [
		        {
		            type: 'value',
		            name: '',
		            minInterval: 1,//最小刻度
		            axisLabel: {
		            	formatter:  function (val) {
		            		var zhibiao2 = $("input[name='zhibiao2']:checked").val();
			            	var unit = "户";
			            	if (zhibiao2 == 2) {
			            		unit = "条";
			            	}
			            	
			            	if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
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
		            interval: 25,
		            offset: 100,
		            position: 'right',
		            axisLabel: {
		                formatter: '{value} %'
		            }
		        }
		    ],
		    dataZoom : [ {
				type : 'inside',
				startValue: trendsXData[trendsXData.length-6],
				endValue: trendsXData[trendsXData.length],
			}, {
				show : true,
				height : 40,
				type : 'slider',
				top : '90%',
				xAxisIndex : [ 0 ],
				start : 0,
				end : 50
			} ],
		    series: [
		        {
		            name:name,
		            type:'bar',
		            data: trendsYData,
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
		        },
		        {
		            name:'环比',
		            type:'line',
		            yAxisIndex: 1,
		            data:huanbiYData,// 环比y轴数据,
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
		myChart2.clear();
		myChart2.setOption(option);
		myChart2.hideLoading();
	}
	
	$(function(){
		
		// 行政区划赋值
		multiCommon.getRegionalDic();
		// 行业划分赋值
		multiCommon.getIndustryList();
		
		conditionSearch();
		
		myChart1.on('click', function (param){ 
			var name = param.name;
			linkageSearch(name);
	    });
		
	});
	
	function conditionSearch(){
		
		myChart1.showLoading();
		//myChart2.showLoading();
		var params = getConditions();
		
		// 企业年龄分布情况查询
		distributionSearch(params);
		
		// 企业年龄趋势查询
		trendsSearch(params);
		
		// 企业年龄时序记录分布
		classifySearch(params);
	}
	
	// 根据企业年龄查询企业年龄增环比情况
	function linkageSearch(qylnName){
		var params = getConditions();
		trendsSearch(params, qylnName);
	}
	
	// 企业年龄分布情况查询
	function distributionSearch(params){
		    params.chartTheme = 1;
			$.post(ctx + '/center/timeCredit/queryTimeCredit.action', params,
				function(data) {
			        dbXData = [];
			        dbYData = [];
			        if (data.IDX.CATEGORY) {
			        	dbXData = data.IDX.CATEGORY;
			        }
			        if (data.IDY.TOTAL) {
			        	dbYData = data.IDY.TOTAL;
			        }
			        if (data.IDY.RATING_NUM) {
			        	dbToolTipPercent = data.IDY.RATING_NUM;
			        }
				initBar();
				}, "json");
	}
	
	// 企业年龄趋势分析查询
	function trendsSearch(params, qylnName){
		    params.chartTheme = 2;
		    switch (qylnName) {
		        case '不足3年': params.enterpriseAge = "NLA";
		            break;
		        case '3至5年': params.enterpriseAge = "NLB";
		            break;
		        case '5至10年': params.enterpriseAge = "NLC";
		            break;
		        case '10至20年': params.enterpriseAge = "NLD";
		            break;
		        case '20至30年': params.enterpriseAge = "NLE";
		            break;
		        case '30年以上': params.enterpriseAge = "NLF";
		            break;
		        default: params.enterpriseAge = "";
		    }
			$.post(ctx + '/center/timeCredit/queryTimeCredit.action', params,
				function(data) {
			        trendsXData = [];
			        trendsYData = [];
			        huanbiYData = [];
			        if (data.IDX.CATEGORY) {
			        	trendsXData = data.IDX.CATEGORY;
			        }
			        if (data.IDY) {
			            trendsYData = data.IDY.TOTAL;
			        	huanbiYData = data.IDY.HUANBI;
			        }
				initTrendsBar(qylnName);
				}, "json");
	}
	
	// 企业年龄时序情况查询
	function classifySearch(params){
	    params.chartTheme = 3;
		$.post(ctx + '/center/timeCredit/queryTimeCredit.action', params,
			function(data) {
				var qys = eval(data.QIYESERIES);
				var jls = eval(data.JILUSERIES);
				if (qys && qys.length > 0) {
					$("#bp1").css("margin-top", "0px");
					$("#bp1").height(800);
					$("#bp1").removeClass("svgBox-noData");
					initEnterpriseAgeSequence(qys, jls);
				} else {
					$("#bp1").css("margin-top", "60px");
					$("#bp1").height(300);
				    $("#bp1").addClass("svgBox-noData");
			    	var img = "<img src='" + ctx + "/app/images/multipleAnalysis/nodata.png'>";
			    	$("#bp1").html(img);
				}
			}, "json");
	}
	
	// 获取查询条件的值
	function getConditions(){
		// 信用主题
		var xyzt = $("input[name='xyzt']:checked").val();
		
		// 统计指标2 主体数量 记录数量
		var zhibiao2 = $("input[name='zhibiao2']:checked").val();
		
		// 行政区
		var xzq = $.trim($("#xzq").select2('val'));
		var xzqArr = xzq.split(",");
		var isxzqAll = false;
		for (var i = 0;i < xzqArr.length;i++){
			if (xzqArr[i] == 0) {
				isxzqAll = true;
				break;
			}
		}
		if (isxzqAll) {
			xzq = null;
		}
		
		// 企业类型
		var qylx = $.trim($("#qylx").select2('val'));
		var qylxArr = qylx.split(",");
		var isqylxAll = false;
		for (var i = 0;i < qylxArr.length;i++){
			if (qylxArr[i] == 0) {
				isqylxAll = true;
				break;
			}
		}
		if (isqylxAll) {
			qylx = null;
		}
		
		// 行业划分
		var hyhf = $.trim($("#hyhf").select2('val'));
		var hyhfArr = hyhf.split(",");
		var ishyhfAll = false;
		for (var i = 0;i < hyhfArr.length;i++){
			if (hyhfArr[i] == 0) {
				ishyhfAll = true;
				break;
			}
		}
		if (ishyhfAll) {
			hyhf = null;
		}
		
		// 注册规模
		var zcgm = $.trim($("#zcgm").select2('val'));
		var zcgmArr = zcgm.split(",");
		var iszcgmAll = false;
		for (var i = 0;i < zcgmArr.length;i++){
			if (zcgmArr[i] == 0) {
				iszcgmAll = true;
				break;
			}
		}
		if (iszcgmAll) {
			zcgm = null;
		}
		
		// 统计时间
		var tjsj = $("#startDate").val();
		
		var params = {creditTheme : xyzt, region : xzq, industryType : hyhf, statistcContent : zhibiao2, type : qylx, registeredScale : zcgm, dateStr : tjsj, trendType : 1};
		
		return params;
	}
	
	// 重置
	function conditionReset(){
		$("#cxjl").attr("checked", true);
		$("#Leiji").attr("checked", true);
		$("#zhuti").attr("checked", true);
		$("#xzq").val(['0']).trigger('change');
		$("#qylx").val(['0']).trigger('change');
		$("#zcgm").val(['0']).trigger('change');
		$("#hyhf").val(['0']).trigger('change');
		$("#startDate").val(startDate);
	}
	
	return {
		conditionReset : conditionReset,
		conditionSearch : conditionSearch
	} 
})();
