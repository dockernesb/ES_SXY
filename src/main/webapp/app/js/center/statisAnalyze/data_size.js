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
	
	 //查询市
    $.getJSON(ctx + "/dataSize/getDeptListByType.action?queryType=1", function (result) {
        $("#deptId_1").select2({
            placeholder: '统计部门',
            language: 'zh-CN',
            width:'60%',
            data: result,
            templateSelection: function (selection) {
                return selection.text;
            }
        });
        resizeSelect2($("#deptId_1"));
    });
    //查询区
    $.getJSON(ctx + "/dataSize/getDeptListByType.action?queryType=2", function (result) {
        $("#deptId_2").select2({
            placeholder: '统计部门',
            language: 'zh-CN',
            width:'60%',
            data: result,
            templateSelection: function (selection) {
                return selection.text;
            }
        });
        resizeSelect2($("#deptId_2"));
    });
     //查询省
    $.getJSON(ctx + "/dataSize/getDeptListByType.action?queryType=3", function (result) {
        $("#deptId_3").select2({
            placeholder: '统计部门',
            language: 'zh-CN',
            width:'60%',
            data: result,
            templateSelection: function (selection) {
                return selection.text;
            }
        });
        resizeSelect2($("#deptId_3"));
    });
	
	
	// 统计主题
	var manualCategory = "0"; // 手动上传
	var fileCategory = "1"; // 文件上传
	var dataBaseCategory = "2"; // 数据库
	var ftpCategory = "3"; // FTP上传
	var webServiceCategory = "4"; // FTP上传
	
	//改变统计主体
	function changeTjzt(){
		var tjzt = $("input[name='tjzt']:checked").val();
		$("#dept1Div").attr("style","width:250px");
		if(tjzt==1){//市
			$("#dept1Div").show();
			$("#dept2Div").hide();
			$("#dept3Div").hide();
			$("#dept1Div").attr("style","width:250px");
		}else if(tjzt == 2){//区
			$("#dept1Div").hide();
			$("#dept2Div").show();
			$("#dept3Div").hide();
			$("#dept2Div").attr("style","width:250px");
		}else{//省
			$("#dept1Div").hide();
			$("#dept2Div").hide();
			$("#dept3Div").show();
			$("#dept3Div").attr("style","width:250px");
		}
	}
	
	//创建一个Datatable
	var table;
	
	var myChart1;
	var myChart2;
	var myChart3;
	var myChart4;
	var myChart5;
	var myChart6;
    var myChart7;

	$(function(){
		
		myChart1 = echarts.init(document.getElementById("dataSizePie"), "macarons");
		myChart2 = echarts.init(document.getElementById("dataIncrease"), "macarons");
		myChart3 = echarts.init(document.getElementById("dataSizeBar"), "green");
		myChart4 = echarts.init(document.getElementById("dataStack"), "macarons");
		myChart5 = echarts.init(document.getElementById("deptDataSizeBar"), "green");
		myChart6 = echarts.init(document.getElementById("deptDataStack"), "macarons");
        myChart7 = echarts.init(document.getElementById("dataTypePie"), "macarons");

		conditionSearch();
		
	});
	
	var currentDeptName = "";//默认选中部门
	var currentSchemaName = "";//默认选中目录
	/******************************* 初始化 end*****************************************************/
	
	
	/************************************查询 begin************************************************/
	
	function getConditions(){
		var params = {};
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var tableName = $("#tableName").val();
		var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
		params.startDate = startDate;
		params.endDate = endDate;
		params.tableName = tableName;
		params.deptId = deptId;
		params.deptQueryType= tjzt;
		return params
	}
	
	//查询入库量
	function conditionSearch() {
		// Tab2各图表宽度需要手动设置，否则图表显示不全
        $('#deptDataSizeBar').width($('#deptDiv').width());
        $('#deptDataStack').width($('#deptDiv').width());
        $('#dataSizeBar').width($('#deptDiv').width());
        $('#dataStack').width($('#deptDiv').width());
        $('#dataIncrease').width($('.col-md-6').width());
        $('#dataTypePie').width($('.col-md-6').width());
        
		//获取查询条件
		var params = getConditions();
		
		if (startDate && endDate && startDate > endDate) {
			$.alert('开始日期不能大于结束日期！');
			return;
		}
		
		//统计总量
		getAllTotalByCategory(params);
		
		//加载图表
		loadChart(params);
		
	}
	
	
	function loadChart(params){
		
		params.category = '';
		
		myChart1.showLoading();
		myChart2.showLoading();
		myChart3.showLoading();
		myChart4.showLoading();
		myChart5.showLoading();
		myChart6.showLoading();
        myChart7.showLoading();
		
		getSchemaPieData(params,function() {
			initSchemaPie();//上报量饼图
		});
		
		
		getIncreaseData(params,function() {
			initIncrease();//上报方式饼图
		});

        getTypePieData(params, function () {
            initTypePie();//按数据类型统计上报量饼图
        });
		
		getSchemaBarData(params,function() {
			initSchemaBar();//上报量柱状图
			myChart3.on('click', function (param){
                var name = param.name;
                linkageSearch(name, 1,params);
            });
			getStackData(params,function() {
				initStack();//上报量堆叠图
			});
		});
		
		
		
		getDeptBarData(params,function() {
			initDeptBar();//上报量柱状图
			myChart5.on('click', function (param){
                var name = param.name;
                linkageSearch(name, 2,params);
            });
			getDeptStackData(params,function() {
				initDeptStack();//上报量堆叠图
			});
		});
		
		
		
		//目录表格
		getDataTable(function(){
            initTable();
        })
        
        //部门表格
        getDeptDataTable(function(){
            initDeptTable();
        })

        goSchemaBack();
        goBack();
    }
	
	
	// 重置
	function conditionReset() {
		resetSearchConditions('#startDate,#endDate,#tableName,#deptId');
		resetDate(start,end);
		$("#city").attr("checked","checked");
		changeTjzt();
		$('#deptId_1').val("   ").trigger("change");
		$('#deptId_2').val("   ").trigger("change");
		$('#deptId_3').val("   ").trigger("change");
	}
	
	/************************************查询 end*********************************************************/
	
	/*****************************************加载统计主题  begin******************************************/
	
	
	//统计各主题总量
	function getAllTotalByCategory(params){
		//初始化
		$("#sbxxl").html(0);//上报信息类
		$("#sbl").html(0);//上报量
		$("#ywl").html('0.00%');//疑问率
		$("#ywli").html(0);//疑问量
		$("#gxl").html('0.00%');//更新率
		$("#gxli").html(0);//更新量
		$("#rkl").html('0.00%');//入库率
		$("#rkli").html(0);//入库量
		$("#wgll").html('0.00%');//未关联率
		$("#wglli").html(0);//未关联量
		
		$.getJSON(ctx + '/dataSize/getTotalByCategory.action',params, function(data) {
			if(typeof(data.allSize) !="undefined"){
				$("#sbxxl").html(data.schemaSize);//上报信息类
				$("#sbl").html(data.allSize);//上报量
				if(data.allSize !='0'){
					$("#ywl").html(((data.failSize/data.allSize)*100).toFixed(2)+"%");//疑问率
					$("#gxl").html(((data.updateSize/data.allSize)*100).toFixed(2)+"%");//更新率
					$("#rkl").html(((data.successSize/data.allSize)*100).toFixed(2)+"%");//入库率
					$("#wgll").html(((data.notRelatedSize/data.allSize)*100).toFixed(2)+"%");//未关联率
				}
				$("#ywli").html(data.failSize);//疑问量
				$("#gxli").html(data.updateSize);//更新量
				$("#rkli").html(data.successSize);//入库量
				$("#wglli").html(data.notRelatedSize);//未关联量
			}
		});
	}
	
	/*****************************************加载统计主题  end***********************************************/
	
	/*****************************************加载饼图  begin************************************************/
	
	var seriesData1 = [];	
	var seriesData0 = [];
	//获取部门总入库量饼图数据
	function getSchemaPieData(params,callback) {
		params = getConditions();
		params.chartsType = "1";
		$.post(ctx + "/dataSize/queryStorageQuantity.action", 
			params, function(result) {
			seriesData1 = [];
			seriesData0 = [];
			if(result){
				seriesData1.push({value:result.CATEGORY1[0]==null?0:result.CATEGORY1, name:'疑问量'});
				seriesData1.push({value:result.CATEGORY3[0]==null?0:result.CATEGORY3, name:'更新量'});
				seriesData1.push({value:result.CATEGORY4[0]==null?0:result.CATEGORY4, name:'入库量'});
				var sbl = result.CATEGORY0[0]==null?0:result.CATEGORY0;
				var ywl = result.CATEGORY1[0]==null?0:result.CATEGORY1;
				var gxl = result.CATEGORY3[0]==null?0:result.CATEGORY3;
				var rkl = result.CATEGORY4[0]==null?0:result.CATEGORY4;
				var noHandle = parseInt(sbl)-parseInt(ywl)-parseInt(gxl)-parseInt(rkl);
				if(noHandle < 0){
					noHandle = 0
				}
				seriesData1.push({value:noHandle, name:'待处理量'});
			}
			
			if (seriesData0.length == 0) {
				seriesData0 = [{value:0, name:"暂无数据"}];
			}
			
			if (seriesData1.length == 0) {
				seriesData1 = [{value:0, name:"暂无数据"}];
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}

	  //	初始化部门入库量占比饼图
	function initSchemaPie() {
		myChart1.setOption({
			title : {
		        subtext: '统计部门上报数据的入库量、更新量、疑问量和待处理量',
		        x:'center'
		    },
		    legend: {
		    	bottom: '50%',
			    left: '5%',
                top: '10%',
		        orient: 'vertical',
		        data:['入库量','更新量','疑问量','待处理量']
		    },
		    tooltip: {
		        trigger: 'item',
		        formatter: "{c} ({d}%)"
		    },
		    toolbox: {
		        show: true,
		        x: 30,
		        feature: {
		        	restore : {
						show : true
					},
		            saveAsImage: {show: true}
		        }
		    },
		    series: [
		        {
		            name:'征集数据统计',
		            type:'pie',
		            radius: ['40%', '55%'],//半径
		            avoidLabelOverlap: false,
		            label: {
		                normal: {
		                    show: false,
		                    position: 'center'
		                },
		                emphasis: {
		                    show: true,
		                    textStyle: {
		                        fontSize: '16',
		                        fontWeight: 'bold'
		                    },
		                    formatter : function (val)  {
		                    	if(val.data){
		                    		return val.data.name+"\n\n "+val.data.value;
		                    	}

							}
		                }
		            },
		            data:seriesData1
		        }
		    ]
		});
		
		myChart1.hideLoading();
		myChart1.resize();
	}
	
	
	/*****************************************加载饼图  end****************************************************/
	
	/*****************************************加载上报方式饼图  begin*************************************************/
	
	var seriesData2 = [];	
	var seriesData20 = [];
	//获取部门总入库量饼图数据
	function getIncreaseData(params,callback) {
		params.chartsType = "4";
		$.post(ctx + "/dataSize/queryStorageQuantity.action",
			params, function(result) {
			seriesData2= [];
			seriesData20 = [];
			if(result){
				seriesData2.push({value:result.CATEGORY0, name:'手动录入'});
				seriesData2.push({value:result.CATEGORY1, name:'文件上传'});
				seriesData2.push({value:result.CATEGORY2, name:'数据库上报'});
				seriesData2.push({value:result.CATEGORY3, name:'FTP上报'});
				seriesData2.push({value:result.CATEGORY4, name:'接口上报'});
			}
			if (seriesData2.length == 0) {
				seriesData2 = [{value:0, name:"暂无数据"}];
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}

	  //	初始化部门入库量占比饼图
	function initIncrease() {
		myChart2.setOption({
			  title: {
			        subtext: '按上报方式统计各部门上报数据量占比情况',
			        left: 'center'
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: "{b} : {c} ({d}%)"
			    },
			    calculable : true,
			    legend: {
			         orient: 'vertical',
			        bottom: '50%',
			        left: '5%',
                    top: '10%',
			        data: ['手动录入', '文件上传','数据库上报','FTP上报','接口上报']
			    },
			    toolbox: {
			        show: true,
			        x: 20,
			        feature: {
			        	restore : {
							show : true
						},
			            saveAsImage: {show: true}
			        }
			    },
			    series : [
			        {
			            type: 'pie',
			            name:'上报方式',
			            radius : '50%',
			            bottom:'30%',
			            center: ['58%', '50%'],
			            selectedMode: 'single',
			            data:seriesData2
			            ,
			            itemStyle: {
			                emphasis: {
			                    shadowBlur: 10,
			                    shadowOffsetX: 0,
			                    shadowColor: 'rgba(0, 0, 0, 0.5)'
			                }
			            }
			        }
			    ]
		});
		
		myChart2.hideLoading();
		myChart2.resize();
	}
	

	/*******************************************加载上报方式饼图  end ****************************************/

    /******************************************加载数据类别饼图 begin*************************************/
    $('#dataTypePie').hide();
    $('.dataType li').click(function () {
        var currentText = $(this).text();
        if (currentText === $('.dataType li').eq(0).text()) {
            $('#dataTypePie').hide();
            $('#dataIncrease').show();
        } else if (currentText === $('.dataType li').eq(1).text()) {
            $('#dataIncrease').hide();
            $('#dataTypePie').show();
        }
    });

    var seriesData7 = [];
    var legend = [];

    //获取数据类型占比数据
    function getTypePieData(params, callback) {
        $.post(ctx + "/dataSize/getReceiptsByCategory.action", params, function (result) {
            seriesData7 = [];
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    var temp = result[i];
                    seriesData7.push({value: temp.successSize, name: temp.category});
                    legend.push(temp.category);
                }
            }
            if (seriesData7.length === 0) {
                seriesData7 = [{value: 0, name: "暂无数据"}];
            }
            if (callback instanceof Function) {
                callback();
            }
        }, "json");
    }

    function initTypePie() {
        myChart7.setOption({
            title: {
                subtext: '按照数据类型统计部门上报数据的类型占比情况',
                x: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: "{b} : {c} ({d}%)"
            },
            calculable: true,
            legend: {
                orient: 'vertical',
                bottom: '50%',
                left: '5%',
                top: '10%',
                data: legend
            },
            toolbox: {
                show: true,
                x: 20,
                feature: {
                    restore: {
                        show: true
                    },
                    saveAsImage: {show: true}
                }
            },
            series: [
                {
                    name: '数据类型',
                    type: 'pie',
                    radius: 110,
                    center: ['50%', '50%'],
                    data: seriesData7
                }
            ]
        });
        myChart7.hideLoading();
        myChart7.resize();
    }

    /******************************************加载数据类别饼图 end*************************************/


	/*****************************************加载目录柱状图  begin**************************************/
	
	var tableData = [];
	var legendData3 = [];	//	入库数据量目录列表
	var seriesData3 = [];	//	部门目录入库数据量列表
	
    //	获取部门各个目录入库量柱状图数据
	function getSchemaBarData(params,callback) {
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		params.startDate=startDate;
		params.endDate=endDate;
		params.chartsType = "3";
		$.post(ctx + "/dataSize/queryStorageQuantity.action",
		 params, function(result) {
			tableData = [];
			legendData3 = [];	//	入库数据量目录列表
			seriesData3 = [];	//	部门目录入库数据量列表
			if(result){
				tableData = result;
				legendData3 = result.NAME;
				if(legendData3.length > 0){
					currentSchemaName=legendData3[0];
				}
				seriesData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#D7504B';
		                    },
							lineStyle:{
								color:'#D7504B'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'上报量',
		            type:'bar',
		            data:result.ALLSIZE
				});
			
				seriesData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#B6A9FA';
		                    },
							lineStyle:{
								color:'#B6A9FA'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
		            stack: '总量',
					name:'疑问量',
		            type:'bar',
		            data:result.FAILSIZE
				});
				seriesData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#7d8014';
		                    },
							lineStyle:{
								color:'#7d8014'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'更新量',
					stack: '总量',
		            type:'bar',
		            data:result.UPDATESIZE
				});
				seriesData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#60C0DD';
		                    },
							lineStyle:{
								color:'#60C0DD'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'入库量',
		            type:'bar',
		            stack: '总量',
		            data:result.SUCCESSSIZE
				});
				
				seriesData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#9BCA63';
		                    },
							lineStyle:{
								color:'#9BCA63'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'未关联量',
		            type:'bar',
		            data:result.NOTRELATEDSIZE
				});

			}else{
				//没有数据时
				currentSchemaName = "";
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}
	
	//初始化柱状图
	function initSchemaBar() {
		myChart3.clear();
		myChart3.setOption({
		    title: {
		        x: 'center',
		        text: '数据目录上报情况统计',
		        subtext: '统计各数据目录的上报情况及数据处理状态'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		    	// left: '60%',
                top:50,
		    	data: ['上报量','疑问量','更新量','入库量','未关联量']
		    },
		    toolbox: {
		        show: true,
		        x: 80,
		        feature: {
		        	restore : {
						show : true
					},
		            saveAsImage: {show: true}
		        }
		    },
		    calculable: false,
		    grid: {
                top:100,
		        borderWidth: 1,
		        x: 70,
		        x2: 60,
		        y2 : 140
		    },
		    xAxis: [
		        {
		            type: 'category',
		            show: true,
		            axisLabel:{
		            	rotate:-45,
		            },
		            boundaryGap: true,
		            axisLine: {onZero: true},
		            data: legendData3
		        }
		    ],
		    yAxis: [
		        {
		            type: 'value',
		            splitArea: { show: true },
		            show: true,
		            axisLabel : {
						formatter : function(val) {
	                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
	                            val = val/10000+'万'
	                        }

							return val+"条";
						}
					}
		        }
		    ],
		    dataZoom: [
	            {
            	   type: 'inside',
                   startValue: legendData3?legendData3[0]:0,
                   endValue: legendData3?legendData3[11]:0
	            },
	            {
	               show: true,
	               height: 40,
	               type: 'slider',
	               top: '90%',
	               right : '10%',
				   left : '8%',
	               xAxisIndex: [0],
	               start: 0,
	               end: 5
	            }
	        ],
		    series: seriesData3
		});
		myChart3.hideLoading();
		myChart3.resize();
	}
	
	
	/*****************************************加载目录柱状图  end***********************************************/
	
	/*****************************************数据上报月度统计  begin***********************************************/
	var seriesData4 = [];   //入库量、有效量、疑问量
	var xAxisValue4 = [];
	
	//获取趋势数据
	function getStackData(params,callback) {
		params.chartsType = "2";
		if(currentSchemaName !=""){
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			params.startDate=startDate;
			params.endDate=endDate;
			params.tableName =  currentSchemaName;
			$.post(ctx + "/dataSize/queryStorageQuantity.action",
					params, function(result) {
					if(result){
						seriesData4 = []; 
						xAxisValue4 = [];
						xAxisValue4=result.STARTDATE;
						seriesData4.push({
							name:'上报量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#D7504B';
									},
									lineStyle:{
										color:'#D7504B'
									}
								}
							},
				            data:result.ALLSIZE
						});
						seriesData4.push({
							name:'疑问量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#B6A9FA';
									},
									lineStyle:{
										color:'#B6A9FA'
									}
								}
							},
				            data:result.FAILSIZE
						});
						seriesData4.push({
							name:'更新量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#7d8014';
									},
									lineStyle:{
										color:'#7d8014'
									}
								}
							},
				            data:result.UPDATEPROCESS
						});
						
						seriesData4.push({
							name:'入库量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#60C0DD';
									},
									lineStyle:{
										color:'#60C0DD'
									}
								}
							},
				            data:result.SUCCESSSIZE
						});
						seriesData4.push({
							name:'未关联量',
					        type:'line',
				            itemStyle : {
								normal : {
									color : function(params) {     
										return '#9BCA63';
									},
									lineStyle:{
										color:'#9BCA63'
									}
								}
							},
				            data:result.NOTRELATEDSIZE
						});
					}
					if (callback instanceof Function) {
						callback();
					}
				}, "json");
		}else{
			seriesData4 = []; 
			xAxisValue4 = [];
			if (callback instanceof Function) {
				callback();
			}
		}
		
		
	}

	//		初始化趋势图
	function initStack() {
		myChart4.clear();
		 myChart4.setOption({
	            title: {
	                x: 'center',
	                text: '数据上报月度统计',
	                subtext: '统计'+(currentSchemaName||'目录')+'的月度上报情况'
	            },
	            tooltip: {
	                trigger: 'axis'
	            },
	            legend: {
	                // x: '60%',
                    top:50,
	                data: ['上报量','疑问量','更新量','入库量','未关联量']
	            },
	            toolbox: {
	                show: true,
	                x: 80,
	                feature: {
	                	restore : {
							show : true
						},
	                    saveAsImage: {show: true}
	                }
	            },
	            calculable: false,
	            grid: {
                    top:100,
	                borderWidth: 1,
	                x: 70,
	                x2: 60,
	                y2 : 100
	            },
	            xAxis: [
	                {
	                    type: 'category',
	                    show: true,
	                    axisLabel:{
	                        rotate:-45,
	                    },
	                    boundaryGap: true,
	                    axisLine: {onZero: true},
	                    data: xAxisValue4
	                }
	            ],
	            yAxis: [
	                {
	                    type: 'value',
	                    splitArea: { show: true },
	                    show: true,
	                    axisLabel : {
							formatter : function(val) {
		                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
		                            val = val/10000+'万'
		                        }

								return val+"条";
							}
						}
	                }
	            ],
	            dataZoom: [
	                {
	                    type: 'inside',
	                    startValue: xAxisValue4?xAxisValue4[xAxisValue4.length-6]:0,
	                    endValue: xAxisValue4?xAxisValue4[xAxisValue4.length]:0
	                },
	                {
	                    show: true,
	                    height: 40,
	                    type: 'slider',
	                    top: '90%',
	                    xAxisIndex: [0],
	                    start: 0,
	                    end: 5
	                }
	            ],
	            series: seriesData4
	        });
	        myChart4.hideLoading();
	        myChart4.resize();
	}
	/*****************************************数据上报月度统计  end***********************************************/
	
	
	/****************************************加载表格  begin *************************************************/
	var tableData = [];
	function getDataTable(callback) {
		var startDate = $("#startDate").val();
		var  endDate =$("#endDate").val();
		var tableName = $("#tableName").val();
		var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
		var url = ctx + "/dataSize/queryTableDetails.action";
		 $.getJSON(url,{
			 startDate:startDate,
			 endDate:endDate,
			 tableName:tableName,
			 deptId:deptId,
			 deptQueryType:queryType,
			 chartsType:"3"
	     }, function (data) {
	         tableData = [];
	
	         tableData = data;
	
	         if (callback instanceof Function) {
	             callback();
	         }
	     });
		}
	 
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
                  return startIndex + meta.row + 1;
              } ,
                "orderable" : false
			}, {
				"data" : "NAME" , //目录名称
				type:'chinese-string',
                render : function (data, type, row) {
                    var str = '<a href="javascript:;" onclick="dataSize.showSchemaDetail(\''+ data +'\');">' + data + '</a>';
                    return str;
                }
			}, {
				"data" : "ALLSIZE" //上报量
			}, {
				"data" : "FAILSIZE" //疑问量
			}, {
				"data" : "UPDATESIZE" //更新量
			}, {
				"data" : "SUCCESSSIZE" //入库量
			}, {
				"data" : "NOTRELATEDSIZE" //未关联量
			},{
				"data" : "FAILSIZERATE"//疑问率
			},{
				"data" : "UPDATESIZERATE"//更新率
			},{
				"data" : "SUCCSIZERATE"//入库率
			},{
				"data" : "NOTRELATEDSIZERATE"//未关联率
			}],
	         initComplete: function (settings, data) {
	            var columnTogglerContent = $('#schema_btn').clone();
	            $(columnTogglerContent).removeClass('hide');
	            var columnTogglerDiv = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
	            $(columnTogglerDiv).html(columnTogglerContent);
	        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });
	
 	 //	初始化表格数据
	function initTable() {
		table.clear().draw();
		table.rows.add(tableData).draw();
	}

    //创建一个Datatable
    var schemaTable_detail = $('#schemaDataTable_detail').DataTable({
        ordering: true,
        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
		columns: [{
				"data": null,
				render: function (data, type, row, meta) {
					// 显示行号
					var startIndex = meta.settings._iDisplayStart;
					return startIndex + meta.row + 1;
				},
				"orderable": false
			}, {
                "data" : "NAME" , // 部门名称
                type:'chinese-string'
            }, {
                "data" : "ALLSIZE" //上报量
            }, {
                "data" : "FAILSIZE" //疑问量
            }, {
                "data" : "UPDATESIZE" //更新量
            }, {
                "data" : "SUCCESSSIZE" //入库量
            }, {
                "data" : "NOTRELATEDSIZE" //未关联量
            },{
                "data" : "FAILSIZERATE"//疑问率
            },{
                "data" : "UPDATESIZERATE"//更新率
            },{
                "data" : "SUCCSIZERATE"//入库率
            },{
                "data" : "NOTRELATEDSIZERATE"//未关联率
            }],
        initComplete: function (settings, data) {
            var columnTogglerContent = $('#detail_schema_btn').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(schemaTable_detail.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
            $(columnTogglerDiv).html(columnTogglerContent);
        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });
	
	// 导出
	function exportData() {
        loading();
    	var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var tableName = $("#tableName").val();
		var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		//TODO
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
        var titles = "目录名称,上报量,疑问量,更新量,入库量,未关联量,疑问率,更新率,入库率,未关联率";
        var columns = "NAME,ALLSIZE,FAILSIZE,UPDATESIZE,SUCCESSSIZE,NOTRELATEDSIZE,FAILSIZERATE,UPDATESIZERATE,SUCCSIZERATE,NOTRELATEDSIZERATE";

        var url = ctx + '/dataSize/exportData.action?chartsType=3';

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'tableName', 'value': tableName}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': deptId}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptQueryType', 'value': queryType}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        
        _form.append($("<input>", {'type': 'hidden', 'name': 'excelName', 'value': '数据量统计-目录统计'}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
	}

	/************************************加载表格  end ********************************************************/
/*****************************************加载部门柱状图  begin**************************************/
	
	var tableDeptData = [];
	var legendDeptData3 = [];	//	入库数据量目录列表
	var seriesDeptData3 = [];	//	部门目录入库数据量列表
	
    //	获取部门各个目录入库量柱状图数据
	function getDeptBarData(params,callback) {
		params = getConditions();
		params.chartsType = "5";
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		params.startDate=startDate;
		params.endDate=endDate;
		$.post(ctx + "/dataSize/queryStorageQuantity.action",
		 params, function(result) {
			tableDeptData = [];
			legendDeptData3 = [];	//	入库数据量目录列表
			seriesDeptData3 = [];	//	部门目录入库数据量列表
			if(result){
				tableDeptData = result;
				legendDeptData3 = result.NAME;
				if(legendDeptData3.length > 0){
					currentDeptName = legendDeptData3[0]
				}
				seriesDeptData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#D7504B';
		                    },
							lineStyle:{
								color:'#D7504B'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'上报量',
		            type:'bar',
		            data:result.ALLSIZE
				});
			
				seriesDeptData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#B6A9FA';
		                    },
							lineStyle:{
								color:'#B6A9FA'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
		            stack: '总量',
					name:'疑问量',
		            type:'bar',
		            data:result.FAILSIZE
				});
				seriesDeptData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#7d8014';
		                    },
							lineStyle:{
								color:'#7d8014'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'更新量',
					stack: '总量',
		            type:'bar',
		            data:result.UPDATESIZE
				});
				seriesDeptData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#60C0DD';
		                    },
							lineStyle:{
								color:'#60C0DD'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'入库量',
		            type:'bar',
		            stack: '总量',
		            data:result.SUCCESSSIZE
				});
				
				seriesDeptData3.push({
					itemStyle: {
		                normal: {
		                    color: function(params) {
		                        return '#9BCA63';
		                    },
							lineStyle:{
								color:'#9BCA63'
							},
		                    label: {
		                        show: false,
		                        position: 'top',
		                        formatter: '{c}'
		                    }
		                }
		            },
					name:'未关联量',
		            type:'bar',
		            data:result.NOTRELATEDSIZE
				});
			}else{
					//没有数据时
				currentDeptName = "";
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}
	
	//初始化柱状图
	function initDeptBar() {
		myChart5.clear();
		myChart5.setOption({
		    title: {
		        x: 'center',
		        text: '部门上报数据情况统计',
		        subtext: '统计各部门的上报情况及数据处理状态'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
                // bottom: '50%',
		    	// left: '60%',
                top: 50,
		    	data: ['上报量','疑问量','更新量','入库量','未关联量']
		    },
		    toolbox: {
		        show: true,
		        x: 80,
		        feature: {
		        	restore : {
						show : true
					},
		            saveAsImage: {show: true}
		        }
		    },
		    calculable: false,
		    grid: {
		    	top: 100,
		        borderWidth: 1,
		        x: 70,
		        x2: 60,
		        y2 : 140
		    },
		    xAxis: [
		        {
		            type: 'category',
		            show: true,
		            axisLabel:{
		            	rotate:-45,
		            },
		            boundaryGap: true,
		            axisLine: {onZero: true},
		            data: legendDeptData3
		        }
		    ],
		    yAxis: [
		        {
		            type: 'value',
		            splitArea: { show: true },
		            show: true,
		            axisLabel : {
						formatter : function(val) {
	                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
	                            val = val/10000+'万'
	                        }

							return val+"条";
						}
					}
		        }
		    ],
		    dataZoom: [
	            {
            	   type: 'inside',
                   startValue: legendDeptData3?legendDeptData3[0]:0,
                   endValue: legendDeptData3?legendDeptData3[11]:0
	            },
	            {
	               show: true,
	               height: 40,
	               type: 'slider',
	               top: '90%',
	               right : '10%',
				   left : '8%',
	               xAxisIndex: [0],
	               start: 0,
	               end: 5
	            }
	        ],
		    series: seriesDeptData3
		});
		myChart5.hideLoading();
		myChart5.resize();
	}
	
	
	/*****************************************加载部门柱状图  end***********************************************/
	
	/*****************************************数据上报月度统计（部门）  begin***********************************************/
	var seriesDeptData4 = [];   //入库量、有效量、疑问量
	var xAxisDeptValue4 = [];
	//获取趋势数据
	function getDeptStackData(params,callback) {
		params.chartsType = "6";
		seriesDeptData4 = [];   //入库量、有效量、疑问量
		xAxisDeptValue4 = [];
		params.tableName = $("#tableName").val();
		if(currentDeptName !=""){
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
			params.startDate=startDate;
			params.endDate=endDate;
			params.deptName =  currentDeptName;
			$.post(ctx + "/dataSize/queryStorageQuantity.action",
					params, function(result) {
					seriesDeptData4 = [];
					xAxisDeptValue4 = [];
					if(result){
						xAxisDeptValue4=result.STARTDATE;
						seriesDeptData4.push({
							name:'上报量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#D7504B';
									},
									lineStyle:{
										color:'#D7504B'
									}
								}
							},
				            data:result.ALLSIZE
						});
						seriesDeptData4.push({
							name:'疑问量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#B6A9FA';
									},
									lineStyle:{
										color:'#B6A9FA'
									}
								}
							},
				            data:result.FAILSIZE
						});
						seriesDeptData4.push({
							name:'更新量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#7d8014';
									},
									lineStyle:{
										color:'#7d8014'
									}
								}
							},
				            data:result.UPDATEPROCESS
						});
						
						seriesDeptData4.push({
							name:'入库量',
					        type:'line',
					        itemStyle : {
								normal : {
									color : function(params) {     
										return '#60C0DD';
									},
									lineStyle:{
										color:'#60C0DD'
									}
								}
							},
				            data:result.SUCCESSSIZE
						});
						seriesDeptData4.push({
							name:'未关联量',
					        type:'line',
				            itemStyle : {
								normal : {
									color : function(params) {     
										return '#9BCA63';
									},
									lineStyle:{
										color:'#9BCA63'
									}
								}
							},
				            data:result.NOTRELATEDSIZE
						});
					}
					
					if (callback instanceof Function) {
						callback();
					}
				}, "json");
		}else{
			if (callback instanceof Function) {
				callback();
			}
		}
		
	}

	//		初始化趋势图
	function initDeptStack() {
		 myChart6.clear();
		 myChart6.setOption({
	            title: {
	                x: 'center',
	                text: '数据上报月度统计',
	                subtext: '统计'+(currentDeptName||'部门')+'的月度上报情况'
	            },
	            tooltip: {
	                trigger: 'axis'
	            },
	            legend: {
                    top: 50,
	                data: ['上报量','疑问量','更新量','入库量','未关联量']
	            },
	            toolbox: {
	                show: true,
	                x: 80,
	                feature: {
	                	restore : {
							show : true
						},
	                    saveAsImage: {show: true}
	                }
	            },
	            calculable: false,
	            grid: {
                    top: 100,
	                borderWidth: 1,
	                x: 70,
	                x2: 60,
	                y2 : 100
	            },
	            xAxis: [
	                {
	                    type: 'category',
	                    show: true,
	                    axisLabel:{
	                        rotate:-45,
	                    },
	                    boundaryGap: true,
	                    axisLine: {onZero: true},
	                    data: xAxisDeptValue4
	                }
	            ],
	            yAxis: [
	                {
	                    type: 'value',
	                    splitArea: { show: true },
	                    show: true,
	                    axisLabel : {
							formatter : function(val) {
		                        if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
		                            val = val/10000+'万'
		                        }

								return val+"条";
							}
						}
	                }
	            ],
	            dataZoom: [
	                {
	                    type: 'inside',
	                    startValue: xAxisDeptValue4?xAxisDeptValue4[xAxisDeptValue4.length-6]:0,
	                    endValue: xAxisDeptValue4?xAxisDeptValue4[xAxisDeptValue4.length]:0
	                },
	                {
	                    show: true,
	                    height: 40,
	                    type: 'slider',
	                    top: '90%',
	                    xAxisIndex: [0],
	                    start: 0,
	                    end: 5
	                }
	            ],
	            series: seriesDeptData4
	        });
	        myChart6.hideLoading();
	        myChart6.resize();
	}
	/*****************************************数据上报月度统计（部门）  end***********************************************/
	
	
	/****************************************加载部门表格  begin *************************************************/
	var tableDeptData = [];
	function getDeptDataTable(callback) {
		var startDate = $("#startDate").val();
		var  endDate =$("#endDate").val();
		var tableName = $("#tableName").val();
		var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
		var url = ctx + "/dataSize/queryTableDetails.action";
		 $.getJSON(url,{
			 startDate:startDate,
			 endDate:endDate,
			 tableName:tableName,
			 deptId:deptId,
			 deptQueryType:queryType,
			 chartsType:"5"
	     }, function (data) {
	    	 tableDeptData = [];
	
	    	 tableDeptData = data;
	
	         if (callback instanceof Function) {
	             callback();
	         }
	     });
		}
	 
	//创建一个Datatable
	var deptTable = $('#deptDataTable').DataTable({
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
                  return startIndex + meta.row + 1;
              } ,
                "orderable" : false
			}, {
				"data" : "NAME" , //部门名称
				type:'chinese-string',
				render : function (data, type, row) {
					var str = '<a href="javascript:;" onclick="dataSize.showDetail(\'' + row.ID + '\')">' + data + '</a>';
					return str;
                }
			}, {
				"data" : "ALLSIZE" //上报量
			}, {
				"data" : "FAILSIZE" //疑问量
			}, {
				"data" : "UPDATESIZE" //更新量
			}, {
				"data" : "SUCCESSSIZE" //入库量
			}, {
				"data" : "NOTRELATEDSIZE" //未关联量
			},{
				"data" : "FAILSIZERATE"//疑问率
			},{
				"data" : "UPDATESIZERATE"//更新率
			},{
				"data" : "SUCCSIZERATE"//入库率
			},{
				"data" : "NOTRELATEDSIZERATE"//未关联率
			}],
	         initComplete: function (settings, data) {
	            var columnTogglerContent = $('#export_dept_btn').clone();
	            $(columnTogglerContent).removeClass('hide');
	            var columnTogglerDiv = $(deptTable.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
	            $(columnTogglerDiv).html(columnTogglerContent);
	        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });

    //创建一个Datatable
    var deptTable_detail = $('#deptDataTable_detail').DataTable({
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
                "data" : "NAME" , // 目录名称
                type:'chinese-string'
            }, {
                "data" : "ALLSIZE" //上报量
            }, {
                "data" : "FAILSIZE" //疑问量
            }, {
                "data" : "UPDATESIZE" //更新量
            }, {
                "data" : "SUCCESSSIZE" //入库量
            }, {
                "data" : "NOTRELATEDSIZE" //未关联量
            },{
                "data" : "FAILSIZERATE"//疑问率
            },{
                "data" : "UPDATESIZERATE"//更新率
            },{
                "data" : "SUCCSIZERATE"//入库率
            },{
                "data" : "NOTRELATEDSIZERATE"//未关联率
            }],
        initComplete: function (settings, data) {
            var columnTogglerContent = $('#detail_dept_btn').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(deptTable_detail.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
            $(columnTogglerDiv).html(columnTogglerContent);
        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });

  //	初始化表格数据
	function initDeptTable() {
		deptTable.clear().draw();
		deptTable.rows.add(tableDeptData).draw();
	}

	// 导出
	function exportDeptData() {
        loading();
    	var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var tableName = $("#tableName").val();
		var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
        var titles = "部门名称,上报量,疑问量,更新量,入库量,未关联量,疑问率,更新率,入库率,未关联率";
        var columns = "NAME,ALLSIZE,FAILSIZE,UPDATESIZE,SUCCESSSIZE,NOTRELATEDSIZE,FAILSIZERATE,UPDATESIZERATE,SUCCSIZERATE,NOTRELATEDSIZERATE";

        var url = ctx + '/dataSize/exportData.action?chartsType=5';

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'tableName', 'value': tableName}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': deptId}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptQueryType', 'value': queryType}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'excelName', 'value': '数据量统计-部门统计'}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
	}

    // 导出部门详细
    function exportDeptDetailData() {
        loading();
        var deptId = $('#detail_deptId').val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var tableName = $("#tableName").val();
        var titles = "目录名称,上报量,疑问量,更新量,入库量,未关联量,疑问率,更新率,入库率,未关联率";
        var columns = "NAME,ALLSIZE,FAILSIZE,UPDATESIZE,SUCCESSSIZE,NOTRELATEDSIZE,FAILSIZERATE,UPDATESIZERATE,SUCCSIZERATE,NOTRELATEDSIZERATE";

        var url = ctx + '/dataSize/exportDeptDetailData.action' ;

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'tableName', 'value': tableName}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': deptId}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        // _form.append($("<input>", {'type': 'hidden', 'name': 'excelName', 'value': '数据量统计'}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
    }

    // 导出目录详细
    function exportSchemaDetailData() {
        loading();
        // var deptId = $('#detail_deptId').val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var tableName = $("#detail_schemaName").val();
        var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		//TODO
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
        var titles = "部门名称,上报量,疑问量,更新量,入库量,未关联量,疑问率,更新率,入库率,未关联率";
        var columns = "NAME,ALLSIZE,FAILSIZE,UPDATESIZE,SUCCESSSIZE,NOTRELATEDSIZE,FAILSIZERATE,UPDATESIZERATE,SUCCSIZERATE,NOTRELATEDSIZERATE";

        var url = ctx + '/dataSize/exportSchemaDetailData.action' ;

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'tableName', 'value': tableName}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': deptId}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptQueryType', 'value': queryType}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
    }

	/************************************加载表格部门  end ********************************************************/
	function linkageSearch(name, chartType,params){
        currentDeptName = "";
        currentSchemaName = "";
        if (chartType == 1) {//目录
        	currentSchemaName = name;
        	getStackData(params,function() {
    			initStack();//上报量堆叠图
    		});
        } else {
        	currentDeptName = name;
        	getDeptStackData(params,function() {
    			initDeptStack();//上报量堆叠图
    		});
        }
    }

    function showDetail(deptId) {
		$('#detail_deptId').val(deptId);
        deptTable_detail.clear().draw();
    	var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		//TODO
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var tableName = $("#tableName").val();
        var url = ctx + "/dataSize/queryTableDetailsByDeptId.action";
        $.getJSON(url, {
            startDate: startDate,
            endDate: endDate,
            deptId: deptId,
            tableName: tableName,
            deptQueryType:queryType
        }, function (data) {
            deptTable_detail.rows.add(data).draw();
        });

        $('#dept_fatherDiv').hide();
        $('#dept_sonDiv').show();
    }

    function goBack() {
		$('#dept_sonDiv').hide();
		$('#dept_fatherDiv').show();
    }

    function showSchemaDetail(name) {
        $("#detail_schemaName").val(name);
        schemaTable_detail.clear().draw();
        var tjzt = $("input[name='tjzt']:checked").val();
		var deptId = "";
		var queryType = tjzt;
		if(tjzt == 1){
			deptId =  $("#deptId_1").val();
		}else if(tjzt == 2){
			deptId =  $("#deptId_2").val();
		}else if(tjzt == 3){
			deptId =  $("#deptId_3").val();
		}
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        // var tableName = $("#tableName").val();
        var url = ctx + "/dataSize/queryTableDetails.action";
        $.getJSON(url, {
            startDate: startDate,
            endDate: endDate,
            deptId: deptId,
            tableName: name,
            deptQueryType:queryType
        }, function (data) {
            schemaTable_detail.rows.add(data).draw();
        });

        $('#schema_fatherDiv').hide();
        $('#schema_sonDiv').show();
    }

    function goSchemaBack() {
		$('#schema_sonDiv').hide();
		$('#schema_fatherDiv').show();
    }

	return {
        conditionSearch: conditionSearch,
        exportSchemaData: exportData,
        exportDeptDetailData: exportDeptDetailData,
        exportSchemaDetailData: exportSchemaDetailData,
        showDetail: showDetail,
        goBack: goBack,
        showSchemaDetail: showSchemaDetail,
        goSchemaBack: goSchemaBack,
        exportDeptData: exportDeptData,
        conditionReset: conditionReset,
        changeTjzt:changeTjzt
	}
})();





