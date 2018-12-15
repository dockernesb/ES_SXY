var dq = (function() {
    var category1 = [];
	var seriesData1 = [];
    var legendData2 = ['未处理','已修改','已处理','已忽略'];
    var seriesData2 = [];
    var legendData3 = [];
    var seriesData3 = [];
    var category4 = [];
    var seriesData4 = [];
    var category5 = [];
    var seriesData5 = [];
    var category6 = [];
    var seriesData6 = [];
    var tableData = [];
    var schemaTableData = [];
    var currentDeptName = "";// 当前选中的部门
    var currentSchemaName = "";// 当前选中的目录
    var excelNames = "数据质量统计-部门统计";
    var schemaExcelNames = "数据质量统计-目录统计";

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

    $.getJSON(ctx + "/system/department/getDeptList.action?userType=3", function(result) {
        // 初始下拉框
        $("#deptId").select2({
            placeholder : '选择部门',
            language : 'zh-CN',
            data : result
        });
        resizeSelect2($("#deptId"));
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
        $('#deptId').val(null).trigger("change");
    });

    // 获取各状态的任务数量
    function getErrorCount() {
    	var deptId = $("#deptId").val();
    	var schemaName = $("#schemaName").val();
    	var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorCount.action',{
        	sysDeptId : deptId,
			schemaName : schemaName,
            startDate : startDate,
			endDate : endDate
		}, function (data) {
			 $('#ywzs').html(data.ywzs);// 疑问总数
			 //$('#ywlxzs').html(data.ywlxzs);// 疑问类型总数
			 $('#xgzs').html(data.xgzs);// 修改总数
			 $('#clzs').html(data.clzs);//  处理总数
			 $('#hlzs').html(data.hlzs);// 忽略总数
			 $('#xgl').html((data.ywzs==0?0:100 * data.xgzs/(data.clzs+data.ywzs)).toFixed(2));// 修改率
			 $('#cll').html((data.ywzs==0?0:100 * data.clzs/(data.clzs+data.ywzs)).toFixed(2));// 处理率
			 $('#hll').html((data.ywzs==0?0:100 * data.hlzs/(data.clzs+data.ywzs)).toFixed(2));// 忽略率
        });
    }
    
    var dbXData_errData = [];
	var dbYData_errData = [];// y轴数据

    // 获取疑问数据饼图数据
    function getErrorStatisticsData() {
        var deptId = $("#deptId").val();
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        $.post(ctx + "/dataQuality/getStatusStatistics.action", {
            sysDeptId : deptId,
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate
        }, function(result) {
            seriesData2 = [];
            dbXData_errData = [];
        	dbYData_errData = [];
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
            
            /*for (var i=0; i<codeData.length; i++) {
                var temp = codeData[i];
                legendData3.push(temp.NAME);
                seriesData3.push({value: temp.VALUE, name: temp.NAME});
            }

            if (seriesData3.length == 0) {
                seriesData3 = [{value:0, name:"暂无数据"}];
            }*/

            initDeptPie();
			initTypePie(dbXData_errData, dbYData_errData);
        });
    }

    // 获取疑问数据状态图数据
    function getErrorHandleSituation(callback, isDeptGroup) {
        var deptId = $("#deptId").val();
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorHandleSituation.action',{
            sysDeptId : deptId,
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate,
            isDeptGroup : isDeptGroup
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

            if (isDeptGroup == 1) {
                seriesData1 = [];
                category1 = data.CATEGORY || [];

                seriesData1.push(wcl);
                seriesData1.push(ycl);
                seriesData1.push(yhl);
                seriesData1.push(yxg);

                if (category1.length > 0) {
                    currentDeptName = category1[0];
                } else {
                    currentDeptName = "";
                }
            } else {
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
            }

            if (callback instanceof Function) {
                callback();
            }
        });
    }

    // 疑问数据处理情况月度统计
    function getErrorHandleMonthStatistics(callback, isDeptGroup) {
        var linkDeptName = currentDeptName;
        var linkSchemaName = currentSchemaName;
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        if (isDeptGroup == 1 && linkDeptName == "") {
            seriesData4 = [];
            category4 = [];
            if (callback instanceof Function) {
                callback();
            }
            return;
        }

        if (isDeptGroup != 1 && linkSchemaName == "") {
            seriesData6 = [];
            category6 = [];
            if (callback instanceof Function) {
                callback();
            }
            return;
        }

        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorHandleMonthStatistics.action',{
            linkDeptName : linkDeptName,
            linkSchemaName : linkSchemaName,
            startDate : startDate,
            endDate : endDate,
            isDeptGroup : isDeptGroup
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

            if (isDeptGroup == 1) {
                seriesData4 = [];
                category4 = data.CATEGORY || [];

                seriesData4.push(wcl);
                seriesData4.push(ycl);
                seriesData4.push(yhl);
                seriesData4.push(yxg);
            } else {
                seriesData6 = [];
                category6 = data.CATEGORY || [];

                seriesData6.push(wcl);
                seriesData6.push(ycl);
                seriesData6.push(yhl);
                seriesData6.push(yxg);
            }
            if (callback instanceof Function) {
                callback();
            }
        });
    }

    // 疑问数据量统计-表格
    function getErrorDataTable(callback, isDeptGroup) {
        var deptId = $("#deptId").val();
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        $.getJSON(CONTEXT_PATH + '/dataQuality/getErrorDataTable.action',{
            sysDeptId : deptId,
            schemaName : schemaName,
            startDate : startDate,
            endDate : endDate,
            isDeptGroup : isDeptGroup
        }, function (data) {
            if (isDeptGroup == 1) {
                tableData = data;
            } else {
                schemaTableData = data;
            }

            if (callback instanceof Function) {
                callback();
            }
        });
    }
    var myChart1 = echarts.init(document.getElementById("dataQualityBar"), "green");
	var myChart2 = echarts.init(document.getElementById("errorDataStatusPie"), "macarons");
	var myChart3 = echarts.init(document.getElementById("errorDataCodesPie"), "macarons");
    var myChart4 = echarts.init(document.getElementById("dataQualityTrend"), "macarons");
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

        myChart1.showLoading();
        myChart2.showLoading();
        myChart3.showLoading();
		myChart4.showLoading();
        myChart5.showLoading();
        myChart6.showLoading();

        getErrorCount();

        getErrorStatisticsData();

        var isDeptGroup = 1; // 部门分组查询
        // 获取部门对疑问数据处理数据
        getErrorHandleSituation(function(){
            initDeptBar();
            myChart1.on('click', function (param){
                var name = param.name;
                linkageSearch(name, isDeptGroup);
            });
            getErrorHandleMonthStatistics(function(){
                initDeptTrend();
            }, isDeptGroup)
		}, isDeptGroup)

        getErrorDataTable(function(){
            initTable();
        }, isDeptGroup)

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

        getErrorDataTable(function(){
            initSchemaTable();
        })

        goSchemaBack();
        goBack();

	}

	//		初始化部门柱状图
	function initDeptBar() {
        myChart1.clear();
		myChart1.setOption({
		    title: {
		        x: 'center',
		        text: '疑问数据处理情况统计',
		        subtext: '统计各部门对疑问数据的处理情况'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		    	// x: '70%',
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
		            data: category1
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
                   startValue: category1?category1[0]:0,
                   endValue: category1?category1[11]:0
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
		    series: seriesData1
		});
		myChart1.hideLoading();
		myChart1.resize();
	}

    //		初始化目录柱状图
    function initSchemaBar() {
        myChart5.clear();
        myChart5.setOption({
            title: {
                x: 'center',
                text: '疑问数据处理情况统计',
                subtext: '统计各目录的疑问数据的处理情况'
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                // x: '70%',
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
                    axisLabel: {
                        formatter:  function (val) {
                            if(val >= 10000){//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val/10000+'万'
                            }
                            return val + '条';
                        }
                    },
                    show: true
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

    //		初始化各部门疑问数据处理情况月度统计趋势图
    function initDeptTrend() {
        myChart4.clear();
        myChart4.setOption({
            title: {
                x: 'center',
                text: '疑问数据处理情况月度统计',
                subtext: '统计'+(currentDeptName||'部门')+'疑问数据的月度处理情况'
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                // x: '70%',
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
                    data: category4
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
                    startValue: category4?category4[category4.length-6]:0,
                    endValue: category4?category4[category4.length]:0
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
                // x: '70%',
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
                subtext: '统计部门目录中所有疑问数据的数据状态',
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
				text : '各部门疑问数据量统计',
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
		        subtext: '统计各部门数据目录的疑问数据类型',
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
            	show : false
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
	
	//创建一个部门Datatable
	var table = $('#dataTable').DataTable({
        ordering: true,        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: true,
        columns: [
          	{"data": null,
              render: function (data, type, row, meta) {
                  // 显示行号
                  var startIndex = meta.settings._iDisplayStart;
                  return startIndex + meta.row + 1;
              } ,
                "orderable" : false
            },
            {"data" : "DEPARTMENT_NAME",
                type: 'chinese-string',
                render : function (data, type, row) {
                    var str = '<a href="javascript:;" onclick="dq.showDetail(\'' + row.ID + '\')">' + data + '</a>';
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
            var columnTogglerContent = $('#fk_enter_btns').clone();
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

    //创建一个目录Datatable
    var schemaTable = $('#dataSchemaTable').DataTable({
        ordering: true,
        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: true,
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
                    var str = '<a href="javascript:;" onclick="dq.showSchemaDetail(\''+ data +'\');">' + data + '</a>';
                    return str;
                }},
            {"data" : "ALL_SIZE"},
            {"data" : "YXG_SIZE"},
            {"data" : "YCL_SIZE"},
            {"data" : "YHL_SIZE"},
            {"data" : "XGL"},
            {"data" : "CLL"},
            {"data" : "HLL"}
        ],
        initComplete: function (settings, data) {
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
	function initTable() {
		table.clear().draw();
		table.rows.add(tableData).draw();
	}

    //		初始化表格数据
    function initSchemaTable() {
        schemaTable.clear().draw();
        schemaTable.rows.add(schemaTableData).draw();
    }

	searchDataSize();

    function conditionReset(){
        resetSearchConditions('#startDate, #endDate, #deptId, #schemaName');
        resetDate(start,end);
    }

    // 导出
	function exportData(isDeptGroup) {
        loading();
        var deptId = $("#deptId").val();
        var schemaName = $("#schemaName").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var titles = "目录名称,疑问数据总数,修改总数,处理总数,忽略总数,修改率,处理率,忽略率";
        var columns = "NAME,ALL_SIZE,YXG_SIZE,YCL_SIZE,YHL_SIZE,XGL,CLL,HLL";
        var fileName = schemaExcelNames;
        if (isDeptGroup == 1) {
            fileName = excelNames;
            titles = "部门名称,疑问数据总数,修改总数,处理总数,忽略总数,修改率,处理率,忽略率";
            columns = "DEPARTMENT_NAME,ALL_SIZE,YXG_SIZE,YCL_SIZE,YHL_SIZE,XGL,CLL,HLL";
        }

        var url = ctx + '/dataQuality/exportData.action?isDeptGroup='+isDeptGroup;

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'sysDeptId', 'value': deptId}));
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
    function linkageSearch(name, isDeptGroup){
        currentDeptName = "";
        currentSchemaName = "";
        if (isDeptGroup == 1) {
            currentDeptName = name;
            getErrorHandleMonthStatistics(function(){
                initDeptTrend();
            }, isDeptGroup)
        } else {
            currentSchemaName = name;
            getErrorHandleMonthStatistics(function(){
                initSchemaTrend();
            })
        }
    }

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
            },
            {"data" : "ALL_SIZE"},
            {"data" : "YXG_SIZE"},
            {"data" : "YCL_SIZE"},
            {"data" : "YHL_SIZE"},
            {"data" : "XGL"},
            {"data" : "CLL"},
            {"data" : "HLL"}],
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
            "data": "DEPARTMENT_NAME", // 部门名称
            type: 'chinese-string'
        }, {"data": "ALL_SIZE"},
            {"data": "YXG_SIZE"},
            {"data": "YCL_SIZE"},
            {"data": "YHL_SIZE"},
            {"data": "XGL"},
            {"data": "CLL"},
            {"data" : "HLL"}],
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

    function showDetail(deptId) {
        $('#detail_deptId').val(deptId);
        deptTable_detail.clear().draw();

        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var tableName = $("#tableName").val();
        var url = ctx + "/dataQuality/getDeptTableDetailData.action";
        $.getJSON(url, {
            startDate: startDate,
            endDate: endDate,
            deptId: deptId,
            tableName: tableName
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

        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        // var tableName = $("#tableName").val();
        var url = ctx + "/dataQuality/getErrorDataTable.action";
        $.getJSON(url, {
            startDate: startDate,
            endDate: endDate,
            isDeptGroup: '1',
            // deptId: deptId,
            schemaName: name
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

    // 导出部门详细
    function exportDeptDetailData() {
        loading();
        var deptId = $('#detail_deptId').val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var tableName = $("#tableName").val();
        var titles = "目录名称,疑问数据总数,修改总数,处理总数,忽略总数,修改率,处理率,忽略率";
        var columns = "NAME,ALL_SIZE,YXG_SIZE,YCL_SIZE,YHL_SIZE,XGL,CLL,HLL";

        var url = ctx + '/dataQuality/exportDeptTableDetailData.action' ;

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'schemaName', 'value': tableName}));
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
        var schemaName = $("#detail_schemaName").val();

        var titles = "部门名称,疑问数据总数,修改总数,处理总数,忽略总数,修改率,处理率,忽略率";
        var columns = "DEPARTMENT_NAME,ALL_SIZE,YXG_SIZE,YCL_SIZE,YHL_SIZE,XGL,CLL,HLL";

        var url = ctx + '/dataQuality/exportSchemaTableDetailData.action' ;

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'schemaName', 'value': schemaName}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'isDeptGroup', 'value': '1'}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
    }

    return {
        exportDeptDetailData: exportDeptDetailData,
        exportSchemaDetailData: exportSchemaDetailData,
        showDetail: showDetail,
        goBack: goBack,
        showSchemaDetail: showSchemaDetail,
        goSchemaBack: goSchemaBack,
        exportData : exportData
    };
})();






