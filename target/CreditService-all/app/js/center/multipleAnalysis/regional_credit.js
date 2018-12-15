var regionalCredit = (function() {
	$("#hyhf").select2();
	$("#qylx").select2();
	$("#zcgm").select2();
	$("#qynl").select2();
	
/**** 区域信用分布和增减情况柱状图 ****/
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
	var tongbiYData = [];// 同比y轴数据
	
	$(function(){
		// 行业划分赋值
		multiCommon.getIndustryList();
		
		conditionSearch(1);
		
		myChart1.on('click', function (param){ 
			var name = param.name;
			linkageSearch(name);
	    });  	
	});
	
	// 根据区域名称查询行政区划增环比情况
	function linkageSearch(qyname){
		flag = true;
		
		var params = getConditions();
		trendsSearch(params, qyname)
		
		// 行业表格数据
		searchTalbe(params, qyname);
	}

	
	// 查询行政区划表格数据
	function searchTalbe(params, xzqName) {
		
		if (xzqName) {
			selectedName = xzqName;
		}
		
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["creditTheme"] = params.creditTheme;
			data["trendType"] = params.trendType;
			data["statistcContent"] = params.statistcContent;
			data["industryType"] = params.industryType;
			data["age"] = params.age;
			data["type"] = params.type;
			data["registeredScale"] = params.registeredScale;
			data["dateStr"] = params.dateStr;
			data["regionalName"] = xzqName;
			table.ajax.reload();
		}
	}
	
	// 初始化柱状图
	function initBar() {
		var option = {
			title : {
				text : '区域分布',
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
				x2 : 35,
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
	function initTrendsBar(qyname) {
		var name = '信用企业数';
		var data = ['信用企业数','环比','同比']
    	var zhibiao2 = $("input[name='zhibiao2']:checked").val();
		if (zhibiao2 == 2) {//累计不显示同比
			name='信用记录数';
			data = ['信用记录数','环比','同比']
		}
		var qynameStr = "";
		if (qyname) {
			qynameStr += qyname + "-";
		}
		option = {
			title : {
				text : qynameStr + '区域趋势',
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
					var zhibiao1 = $("input[name='zhibiao1']:checked").val();
					// 累计
					if (zhibiao1 == 1) {
						valName = "累计值";
					} 
					if (params && params.length > 0) {
						for (var i = 0;i < params.length;i++) {
							if (params[i].seriesName == "信用企业数"||params[i].seriesName == "信用记录数") {
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
		    series: function(){
		    	var serie = [];
		    	
		    	var item1={
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
		    	}
		    	serie.push(item1);
		    	
		    	var item2={
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
		    	serie.push(item2);
		    	
		    	var zhibiao1 = $("input[name='zhibiao1']:checked").val();
				if (zhibiao1 == 2) {//累计不显示同比
			    	var item3={
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
			    	serie.push(item3);
				}
				return serie;
		    }()
		};
		myChart2.clear();
		myChart2.setOption(option);
		myChart2.hideLoading();
	}
	
    function conditionSearch(type){
    	flag = false;
    	
		myChart1.showLoading();
		//myChart2.showLoading();
		var params = getConditions();
		
		// 行政区划分布情况查询
		distributionSearch(params);
		
		// 行政区划趋势查询
		trendsSearch(params);
		
	    // 行政区划表格数据
		if (type == 1) {

        initTable(params);
		} else {
			searchTalbe(params);
		}
	}
	
	// 区域分布情况查询
	function distributionSearch(params){
		    params.chartTheme = 1;
			$.post(ctx + '/center/regionalCredit/queryRegionalCredit.action', params,
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
	
	// 区域趋势分析查询
	function trendsSearch(params, qyname){
		    params.chartTheme = 2;
		    params.regionalName = qyname;
			$.post(ctx + '/center/regionalCredit/queryRegionalCredit.action', params,
				function(data) {
				 trendsXData = [];
			        trendsYData = [];
			        tongbiYData = [];
			        huanbiYData = [];
			        var zhibiao1 = $("input[name='zhibiao1']:checked").val();
			        if (data.IDX.CATEGORY) {
			        	trendsXData = data.IDX.CATEGORY;
			        }
			        if (data.IDY) {
			            trendsYData = data.IDY.TOTAL;
			        	huanbiYData = data.IDY.HUANBI;
			        	// 新增情况同比
			        	if (zhibiao1 == '2') {
			        		tongbiYData = data.IDY.TONGBI;
			        	}
			        }
				initTrendsBar(qyname);
				}, "json");
	}
	
	var table;
	var flag = false;
	var selectedName;
	// 初始化表格数据
	function initTable(params){
		var url = ctx + '/center/regionalCredit/queryRegionalCreditTable.action';
	    table = $('#dataTable').DataTable({
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
					var str =  $("#startDate").val();
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
					var str = "0%";
					if (data != null) {
						str = data + "%";
					}
					return str;
				}
			},{
				"data" : "LJHUANBI",
				"render" : function(data, type, row) {
					var str = data + "%";
					return str;
				}
			}]
		});
	}
	
	// 获取查询条件的值
	function getConditions(){
		// 信用主题
		var xyzt = $("input[name='xyzt']:checked").val();
		
		// 统计指标1 累计 新增
		var zhibiao1 = $("input[name='zhibiao1']:checked").val();
		
		// 统计指标2 主体数量 记录数量
		var zhibiao2 = $("input[name='zhibiao2']:checked").val();
		
		// 行政区划划分
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
		
		// 企业年龄
		var qynl = $.trim($("#qynl").select2('val'));
		var qynlArr = qynl.split(",");
		var isQynlAll = false;
		for (var i = 0;i < qynlArr.length;i++){
			if (qynlArr[i] == 0) {
				isQynlAll = true;
				break;
			}
		}
		if (isQynlAll) {
			qynl = null;
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
		
		var params = {creditTheme : xyzt, trendType : zhibiao1, statistcContent : zhibiao2, industryType : hyhf, age : qynl, type : qylx, registeredScale : zcgm, dateStr : tjsj};
		
		return params;
	}
	
	// 重置
	function conditionReset(){
		$("#cxjl").attr("checked", true);
		$("#xinz").attr("checked", true);
		$("#zhuti").attr("checked", true);
		$("#hyhf").val(['0']).trigger('change');
		$("#qylx").val(['0']).trigger('change');
		$("#zcgm").val(['0']).trigger('change');
		$("#qynl").val(['0']).trigger('change');
		$("#startDate").val(startDate);
	}
	
	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset
	}
})();
