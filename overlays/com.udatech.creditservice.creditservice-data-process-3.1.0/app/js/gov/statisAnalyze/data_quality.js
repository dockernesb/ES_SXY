var dq = (function() {
    var legendData2 = ['未处理','已修改','已处理','已忽略'];
    var seriesData2 = [];
    var legendData3 = [];
    var seriesData3 = [];
    var category5 = [];
    var seriesData5 = [];
    var category6 = [];
    var seriesData6 = [];
    var schemaTableData = [];
    var schemaExcelNames = "数据质量统计";
    var currentSchemaName = "";// 当前选中的目录

	var start = {
		elem: '#startDate',
		format: 'YYYY-MM-DD',
		max: '2099-12-30', //最大日期
		istime: false,
		istoday: false,// 是否显示今天
		isclear : false, // 是否显示清空
		issure : false, // 是否显示确认
		choose: function(datas){
            laydatePH('#startDate', datas);
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

    // 获取各状态的任务数量
    function getErrorCount() {
    	var schemaName = $("#schemaName").val();
    	var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorCount.action',{
			schemaName : schemaName,
            startDate : startDate,
			endDate : endDate
		}, function (data) {
			 $('#ywzs').html(data.ywzs);// 疑问总数
			 //$('#ywlxzs').html(data.ywlxzs);// 疑问类型总数
			 $('#xgzs').html(data.xgzs);// 修改总数
			 $('#clzs').html(data.clzs);//  处理总数
			 $('#hlzs').html(data.hlzs);// 忽略总数
            $('#xgl').html((data.ywzs==0?0:100 * data.xgzs/data.ywzs).toFixed(2));// 修改率
            $('#cll').html((data.ywzs==0?0:100 * data.clzs/data.ywzs).toFixed(2));// 处理率
            $('#hll').html((data.ywzs==0?0:100 * data.hlzs/data.ywzs).toFixed(2));// 忽略率
        });
    }

    var dbXData_errData = [];
	var dbYData_errData = [];// y轴数据
    
    // 获取疑问数据饼图数据
    function getErrorStatisticsData(callback) {
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        $.post(ctx + "/dataQuality/getStatusStatistics.action", {
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate
        }, function(result) {
            seriesData2 = [];
            seriesData3 = [];
            legendData3 = [];
            json = eval("(" + result + ")");
            var statusData = json.statusData;

            var wcl_val = 0;
            var yxg_val = 0;
            var ycl_val = 0;
            var yhl_val = 0;

            for (var i=0; i<statusData.length; i++) {
                var temp = statusData[i];
                if (temp.NAME == '未处理') {
                    wcl_val = temp.VALUE;
                } else if (temp.NAME == '已修改') {
                    yxg_val = temp.VALUE;
                } else if (temp.NAME == '已处理') {
                    ycl_val = temp.VALUE;
                } else {
                    yhl_val = temp.VALUE;
                }
            }

            seriesData2.push({name : '未处理', value : wcl_val});
            seriesData2.push({name : '已修改', value : yxg_val});
            seriesData2.push({name : '已处理', value : ycl_val});
            seriesData2.push({name : '已忽略', value : yhl_val});

            if (seriesData2.length == 0) {
                seriesData2 = [{value:0, name:"暂无数据"}];
            }

            var codeData = json.codeData;
            
            if ( ! $.isEmptyObject(codeData) ) {
            	dbXData_errData = codeData.INVALID_SIZE;
            	dbYData_errData = codeData.DEPTNAME;
			}
            
            initDeptPie();
			initTypePie(dbXData_errData, dbYData_errData);
            /*for (var i=0; i<codeData.length; i++) {
                var temp = codeData[i];
                legendData3.push(temp.NAME);
                seriesData3.push({value: temp.VALUE, name: temp.NAME});
            }

            if (seriesData3.length == 0) {
                seriesData3 = [{value:0, name:"暂无数据"}];
            }

            if (callback instanceof Function) {
                callback();
            }*/

        });
    }

    // 获取疑问数据状态图数据
    function getErrorHandleSituation(callback) {
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorHandleSituation.action',{
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate
        }, function (data) {

            var wcl = {
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
                name:'未处理',
                    type:'bar',
                data:data.WCL_SIZE
            }

            var ycl = {
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
                name:'已处理',
                type:'bar',
                data:data.YCL_SIZE
            }

            var yhl = {
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
                name:'已忽略',
                type:'bar',
                data:data.YHL_SIZE
            }

            var yxg = {
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
                name:'已修改',
                type:'bar',
                data:data.YXG_SIZE
            }


            seriesData5 = [];
            category5 = data.CATEGORY || [];

            seriesData5.push(wcl);
            seriesData5.push(ycl);
            seriesData5.push(yhl);
            seriesData5.push(yxg);

            if (category5.length > 0) {
                currentSchemaName = category5[0];
            } else {
                currentSchemaName = "";
            }

            if (callback instanceof Function) {
                callback();
            }
        });
    }

    // 疑问数据处理情况月度统计
    function getErrorHandleMonthStatistics(callback) {
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var linkSchemaName = currentSchemaName;

        if (linkSchemaName == "") {
            seriesData6 = [];
            category6 = [];
            if (callback instanceof Function) {
                callback();
            }
            return;
        }

        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorHandleMonthStatistics.action',{
            linkSchemaName : linkSchemaName,
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate
        }, function (data) {
            var wcl = {
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
                name:'未处理',
                type:'line',
                data:data.WCL_SIZE
            }

            var ycl = {
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
                name:'已处理',
                type:'line',
                data:data.YCL_SIZE
            }

            var yhl = {
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
                name:'已忽略',
                type:'line',
                data:data.YHL_SIZE
            }

            var yxg = {
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
                name:'已修改',
                type:'line',
                data:data.YXG_SIZE
            }

            seriesData6 = [];
            category6 = data.CATEGORY || [];

            seriesData6.push(wcl);
            seriesData6.push(ycl);
            seriesData6.push(yhl);
            seriesData6.push(yxg);

            if (callback instanceof Function) {
                callback();
            }
        });
    }

    // 疑问数据量统计-表格
    function getErrorDataTable(callback) {
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorDataTable.action',{
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate
        }, function (data) {

             schemaTableData = data;

            if (callback instanceof Function) {
                callback();
            }
        });
    }
	var myChart2 = echarts.init(document.getElementById("errorDataStatusPie"), "macarons");
	var myChart3 = echarts.init(document.getElementById("errorDataCodesPie"), "macarons");
    var myChart5 = echarts.init(document.getElementById("dataQualitySchemaBar"), "macarons");
    var myChart6 = echarts.init(document.getElementById("dataQualitySchemaTrend"), "macarons");

	$("#searchBtn").click(function() {
		searchDataSize();
	});

    $("#resetBtn").click(function() {
        conditionReset();
    });

	//查询数据质量
	function searchDataSize() {

        // Tab2各图表宽度需要手动设置，否则图表显示不全
        $('#dataQualityBar').width($('#deptDiv').width());
        $('#dataQualityTrend').width($('#deptDiv').width());
        $('#dataQualitySchemaBar').width($('#deptDiv').width());
        $('#dataQualitySchemaTrend').width($('#deptDiv').width());


		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		
		if (startDate && endDate && startDate > endDate) {
			$.alert('开始日期不能大于结束日期！');
			return;
		}

        myChart2.showLoading();
        myChart3.showLoading();
        myChart5.showLoading();
        myChart6.showLoading();

        getErrorCount();

        getErrorStatisticsData();

        // 获取目录疑问数据
        getErrorHandleSituation(function(){
            initSchemaBar();
            myChart5.on('click', function (param){
                var name = param.name;
                linkageSearch(name);
            });
            getErrorHandleMonthStatistics(function(){
                initSchemaTrend();
            });
        });

        getErrorHandleMonthStatistics(function(){
            initSchemaTrend();
        });

        getErrorDataTable(function(){
            initSchemaTable();
        })

	}

    //		初始化目录柱状图
    function initSchemaBar() {
        myChart5.clear();
        myChart5.setOption({
            title: {
                x: 'center',
                text: '疑问数据处理情况统计',
                subtext: '统计本部门各目录的疑问数据的处理情况'
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                top:50,
                data: ['未处理','已修改','已处理','已忽略']
            },
            toolbox : {
                show : true,
                x : '60',
                feature : {
                    restore : {
                        show : true
                    },
                    saveAsImage : {
                        show : true
                    }
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
                    data: category5
                }
            ],
            yAxis: [
                {
                    minInterval: 1,//最小刻度
                    type: 'value',
                    splitArea: { show: true },
                    show: true,
                    axisLabel: {
                        formatter:  function (val) {
                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }
                            return val + '条';
                        }
                    }
                }
            ],
            dataZoom: [
                {
                    type: 'inside',
                    startValue: category5?category5[0]:0,
                    endValue: category5?category5[11]:0
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
            series: seriesData5
        });
        myChart5.hideLoading();
        myChart5.resize();
    }

    //		初始化各目录下疑问数据处理情况月度统计趋势图
    function initSchemaTrend() {
        myChart6.clear();
        myChart6.setOption({
            title: {
                x: 'center',
                text: '疑问数据处理情况月度统计',
                subtext: '统计'+(currentSchemaName||'目录')+'疑问数据的月度处理情况'
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                top:50,
                data: ['未处理','已修改','已处理','已忽略']
            },
            toolbox: {
                show: true,
                x: 80,
                feature: {
                    mark: false,
                    magicType : {show: true, type: ['line', 'bar']},
                    dataView: {show: false, readOnly: false},
                    restore: {show: true},
                    saveAsImage: {show: true}
                }
            },
            toolbox : {
                show : true,
                x : '60',
                feature : {
                    restore : {
                        show : true
                    },
                    saveAsImage : {
                        show : true
                    }
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
                    data: category6
                }
            ],
            yAxis: [
                {
                    minInterval: 1,//最小刻度
                    type: 'value',
                    splitArea: { show: true },
                    show: true,
                    axisLabel: {
                        formatter:  function (val) {
                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }
                            return val + '条';
                        }
                    }
                }
            ],
            dataZoom: [
                {
                    type: 'inside',
                    startValue: category6?category6[category6.length-6]:0,
                    endValue: category6?category6[category6.length]:0
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
            series: seriesData6
        });
        myChart6.hideLoading();
        myChart6.resize();
    }

	//  初始化疑问数据数据状态比饼图
	function initDeptPie() {
        myChart2.clear();
        myChart2.setOption({
            title : {
                text: '疑问数据状态统计',
                subtext: '统计本部门目录的疑问数据状态',
                x:'center'
            },
            tooltip : {
                trigger: 'item',
                formatter: "{b} : {c} ({d}%)"
            },
            toolbox : {
                show : true,
                left: '5%',
                feature : {
                    restore : {
                        show : true
                    },
                    saveAsImage : {
                        show : true
                    }
                }
            },
            calculable : true,
            legend: {
                orient: 'vertical',
                bottom: '50%',
                left: '5%',
                data: legendData2
            },
            series : [
                {
                    type:'pie',
                    radius : 110,
                    center: ['58%', '50%'],
                    data:seriesData2
                }
            ]
        });
        myChart2.hideLoading();
        myChart2.resize();
	}
	var labelRight = {
		    normal: {
		        position: 'right'
		    }
		};

	//	初始化疑问数据数据类型比饼图
	function initTypePie(dbXData_errData, dbYData_errData) {
		
		var dataSeries = [];
		var dataY = [];
    	
    	for (var i = dbXData_errData.length - 1; i >= 0; i--){
    		var fontwidth = dbYData_errData[i].length*12;
    		var barwidth = dbXData_errData[i]*0.01*217;
    		var obj = {};
    		obj.value = dbXData_errData[i];
    		if (fontwidth > barwidth) {
    			obj.label = labelRight;
    		}
    		dataSeries.push(obj);
    	}
    	
    	for (var i = dbYData_errData.length - 1; i >= 0; i--){
    		var obj = {};
    		obj.value = dbYData_errData[i];
    		dataY.push(obj);
    	}
		
		var option = {
			title : {
				text : '部门疑问数据量统计',
				subtext : '',
				left : 'center'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : { // 坐标轴指示器，坐标轴触发有效
					type : 'line' // 默认为直线，可选为：'line' | 'shadow'
				},
				formatter : function (params, ticket, callback) {
					var tipStr = "";
					if (params != null && params.length > 0 && params[0].name != '') {
						tipStr += "部门："+params[0].name + "<br />";
						for (var i = 0;i < params.length;i++) {
							if ( params[i].value >= 10000 && params[i].value < 100000000) {
								tipStr += params[i].seriesName + " : " + (params[i].value/10000).toFixed(2) +"万条"+"<br />";
							} else if ( params[i].value >= 100000000 ) {
								tipStr += params[i].seriesName + " : " + (params[i].value/100000000).toFixed(2) +"亿条"+ "<br />";
							} else {
								tipStr += params[i].seriesName + " : " + params[i].value +"条"+ "<br />";
							}
						}
					}
					return tipStr;
                }
			},
			toolbox : {
                show : true,
                left: '0',
                feature : {
                    restore : {
                        show : true
                    },
                    saveAsImage : {
                        show : true
                    }
                }
            },
			grid : {
				top : '10%',
				left: '7%',
				borderWidth : 1,
				x : 50,
				x2 : 70,
				y2 : 120
			},
			legend: {
				show : false
		    },
		    xAxis: {
		        type: 'value',
		        name: '',
		        minInterval: 5,//最小刻度
				show : true,
				axisLabel: {
	            	formatter:  function (val) {
		            	if(val >= 10000 && val < 100000000){//当纵轴刻度数字超过4位数时，如355000户，则显示35.5万户；
		            		val = val/10000 + "万"
		            	} else if ( val >= 100000000){
		            		val = val/100000000 + "亿"
		            	}
		            	return val;
	                }
		        }
		    },
		    /*yAxis: {
		        type: 'category',
		        nameGap: 5,
		        inverse: true,
		        data: dbYData_errData,
		        axisLabel : {
					formatter: function (name) {
                   	if ( ! $.isEmptyObject(name) ) {
                   		return (name.length > 5 ? (name.slice(0,5)+"...") : name );
                   	}
                        
                   }
				},
		    },*/
		    
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
		        data: dataY
		    },
			
			textStyle: {
				color: '#666'
			},
			series: [
		        {
		        	name : '疑问数据量',
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
			/*series: function(){
		    	var serie = [];
		    	var item1={
	    			name:'疑问数据量',
		            type:'bar',
		            itemStyle: {
                        normal: {
                            color: '#FFAF8D',
                            //以下为是否显示
                            label: {
                                show: false
                            }
                        }
                    },
		            data: dbXData_errData,
		    	}
		    	serie.push(item1);
				return serie;
		    }()*/
		};
		myChart3.clear();
		myChart3.setOption(option);
		myChart3.hideLoading();
	}
	/*function initTypePie() {
        myChart3.clear();
		myChart3.setOption({
		    title : {
		        text: '疑问数据类型统计',
		        subtext: '统计本部门数据目录的疑问数据类型',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{b} : {c} ({d}%)"
		    },
            toolbox : {
                show : true,
                left: '0',
                feature : {
                    restore : {
                        show : true
                    },
                    saveAsImage : {
                        show : true
                    }
                }
            },
		    calculable : true,
            legend: {
                orient: 'vertical',
                top: '25%',
                left: '0',
                data: legendData3
            },
		    series : [
		        {
		            type:'pie',
		            radius : 110,
                    label: {
                        normal: {
                            show: false
                        }
                    },
		            center: ['58%', '50%'],
		            data:seriesData3
		        }
		    ]
		});
		myChart3.hideLoading();
		myChart3.resize();
	}*/
	
    //创建一个目录Datatable
    var schemaTable = $('#dataSchemaTable').DataTable({
        ordering: true,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: true,
        order: [],
        columns: [
            {"data": null,
                render: function (data, type, row, meta) {
                    // 显示行号
                    var startIndex = meta.settings._iDisplayStart;
                    return startIndex + meta.row + 1;
                } ,
                "orderable" : false
            },
            {"data" : "NAME", type: 'chinese-string',
                render : function (data, type, row) {
                    var str = '<a href="javascript:;" onclick="dq.showDetail(\''+ data +'\');">' + data + '</a>';
                    return str;
                }},
            {"data" : "ALL_SIZE"},
            {"data" : "YXG_SIZE"},
            {"data" : "YCL_SIZE"},
            {"data" : "YHL_SIZE"},
            {"data" : "XGL"},
            {"data" : "CLL"},
            {"data" : "HLL"}
        ], initComplete: function (settings, data) {
            var columnTogglerContent = $('#fk_enter_btns_2').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(schemaTable.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
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

    //		初始化表格数据
    function initSchemaTable() {
        schemaTable.clear().draw();
        schemaTable.rows.add(schemaTableData).draw();
    }

	searchDataSize();

    function conditionReset(){
        resetSearchConditions('#startDate, #endDate, #schemaName');
        resetDate(start,end);
    }

    // 导出
	function exportData() {
        loading();
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var titles = "目录名称,疑问数据总数,修改总数,处理总数,忽略总数,修改率,处理率,忽略率";
        var columns = "NAME,ALL_SIZE,YXG_SIZE,YCL_SIZE,YHL_SIZE,XGL,CLL,HLL";
        var fileName = schemaExcelNames;

        var url = ctx + '/dataQuality/exportData.action';

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'schemaName', 'value': schemaName}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'excelName', 'value': fileName}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
	}

    // 联动查询
    function linkageSearch(name){
        currentSchemaName = name;

        getErrorHandleMonthStatistics(function(){
            initSchemaTrend();
        })
    }


    var table_detail = $('#dataTable_detail').DataTable({
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
            "data" : "CREATE_TIME" , // 时间
            type:'chinese-string'
        },
            {"data" : "ALL_SIZE"},
            {"data" : "YXG_SIZE"},
            {"data" : "YCL_SIZE"},
            {"data" : "YHL_SIZE"},
            {"data" : "XGL"},
            {"data" : "CLL"},
            {"data" : "HLL"}],
        initComplete: function (settings, data) {
            var columnTogglerContent = $('#detail_btn').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(table_detail.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
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

    function showDetail(name) {
        $("#detail_schemaName").val(name);
        table_detail.clear().draw();

        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var url = ctx + "/dataQuality/queryDetailsBySchema.action";
        $.getJSON(url, {
            startDate: startDate,
            endDate: endDate,
            // deptId: deptId,
            schemaName: name
        }, function (data) {
            table_detail.rows.add(data).draw();
        });

        $('#fatherDiv').hide();
        $('#sonDiv').show();
    }

    // 导出详细
    function exportDetailData() {
        loading();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var tableName = $("#detail_schemaName").val();
        var titles = "时间,疑问数据总数,修改总数,处理总数,忽略总数,修改率,处理率,忽略率";
        var columns = "CREATE_TIME,ALL_SIZE,YXG_SIZE,YCL_SIZE,YHL_SIZE,XGL,CLL,HLL";

        var url = ctx + '/dataQuality/exportDetailsBySchemaData.action';

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'schemaName', 'value': tableName}));
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

    function goBack() {
        $('#sonDiv').hide();
        $('#fatherDiv').show();
    }

    return {
        exportDetailData: exportDetailData,
        showDetail : showDetail,
        goBack : goBack,
        exportData : exportData
    };
})();






