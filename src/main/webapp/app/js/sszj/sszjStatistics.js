var sszjStatistics = (function () {

    var start = {
        elem: '#startDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#startDate', datas);
            end.min = datas; // 开始日选好后，重置结束日的最小日期
            end.start = datas // 将结束日的初始值设定为开始日
        }
    };
    var end = {
        elem: '#endDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30',
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#endDate', datas);
            start.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);


    var myChart1;
    var myChart2;

    $(function () {

        myChart1 = echarts.init(document.getElementById("JgdjBar"), "macarons");
        myChart2 = echarts.init(document.getElementById("ZjxxBar"), "macarons");

        conditionSearch("isFirst");

    });


    //搜索
    function conditionSearch(isFirst) {
        //获取查询条件
        var params = {};
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        params.startDate = startDate;
        params.endDate = endDate;

        //校验
        if (startDate && endDate && startDate > endDate) {
            $.alert('开始日期不能大于结束日期！');
            return;
        }

        //统计总量
        getTotalData(params);

        //加载图表
        loadChart(params);

        if (!isFirst) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["startDate"] = startDate;
            data["endDate"] = endDate;
            table.ajax.reload();
        }

    }

    //重置
    function conditionReset() {
        resetDate(start, end);
        resetSearchConditions('#startDate,#endDate');
    }

    //统计各主题总量
    function getTotalData(params) {

        $.getJSON(ctx + '/sszj/tjfx/getTotalData.action', params, function (data) {
            if (data) {
                $("#glbm").html(data.GLBMSIZE);//管理部门
                $("#sszj").html(data.SSZJSIZE);///涉审中介
                $("#cyry").html(data.CYRYSIZE);//从业人员
                $("#pjxx").html(data.PJXXSIZE);//评价信息
            }


        });
    }

    function loadChart(params) {

        myChart1.showLoading();
        myChart2.showLoading();

        getJgdjBarData(params, function () {
            initJgdjBar();//机构等级柱状图
        });


        getZjxxBarData(params, function () {
            initZjxxBar();//涉审中介监管信息柱状图
        });

    }


    var xAxisData1 = ['A', 'B', 'C', 'D', '无'];
    var yAxisDate1 = [];
    var seriesData1 = [];

    function getJgdjBarData(params, callback) {
        $.post(ctx + "/sszj/tjfx/getJgdjBarData.action", params, function (data) {
            yAxisDate1 = [];
            seriesData1 = [];
            yAxisDate1.push(data.A);
            yAxisDate1.push(data.B);
            yAxisDate1.push(data.C);
            yAxisDate1.push(data.D);
            yAxisDate1.push(data.无);
            seriesData1.push({
                itemStyle: {
                    normal: {
                        color: function (params) {
                            return '#5665d5';
                        },
                        lineStyle: {
                            color: '#5665d5'
                        },
                        label: {
                            show: true,
                            position: 'top',
                            formatter: '{c}',
                            textStyle: {
                                color: 'black',
                                fontSize: 16
                            }
                        }
                    }
                },
                name: '机构数量',
                type: 'bar',
                data: yAxisDate1
            });
            if (callback instanceof Function) {
                callback();
            }
        }, "json");
    }

    function initJgdjBar() {
        myChart1.clear();
        myChart1.setOption({
            title: {
                x: 'center',
                text: '机构等级分析'
            },
            tooltip: {
                trigger: 'axis'
            },
            toolbox: {
                show: true,
                x: 80,
                feature: {
                    restore: {
                        show: true
                    },
                    saveAsImage: {show: true},
                    magicType: {show: true, type: ['line', 'bar']}
                }
            },
            calculable: false,
            grid: {
                top: 100,
                borderWidth: 1,
                x: 70,
                x2: 60,
                y2: 140
            },
            abel: {
                normal: {
                    show: true,
                    position: 'inside'
                }
            },
            xAxis: [
                {
                    type: 'category',
                    show: true,
                    axisLabel: {
                        textStyle: {
                            color: '#100e41',
                            fontSize: '20'
                        }
                    },
                    boundaryGap: true,
                    axisLine: {onZero: true},
                    data: xAxisData1
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    splitArea: {show: true},
                    show: true,
                    axisLabel: {
                        formatter: function (val) {
                            if (val >= 10000) {//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val / 10000 + '万'
                            }

                            return val + "条";
                        }
                    }
                }
            ],
            dataZoom: [
                {
                    type: 'inside'
                },
                {
                    show: true,
                    height: 40,
                    type: 'slider',
                    top: '90%',
                    right: '10%',
                    left: '8%',
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

    var xAxisData2 = [];
    var yAxisDate2_sszj = [];
    var yAxisDate2_pjxx = [];
    var seriesData2 = [];

    function getZjxxBarData(params, callback) {
        $.post(ctx + "/sszj/tjfx/getZjxxBarData.action", params, function (data) {
            xAxisData2 = [];
            yAxisDate2_sszj = [];
            yAxisDate2_pjxx = [];
            seriesData2 = [];
            if (data) {
                $.each(data, function (index, object) {
                    xAxisData2.push(object.DEPT_NAME);
                    yAxisDate2_sszj.push(object.SSZJSIZE);
                    yAxisDate2_pjxx.push(object.PJDJSIZE);
                })
            }
            seriesData2.push({
                itemStyle: {
                    normal: {
                        color: function (params) {
                            return '#f09c60';
                        },
                        lineStyle: {
                            color: '#f09c60'
                        },
                        label: {
                            show: true,
                            position: 'top',
                            formatter: '{c}',
                            textStyle: {
                                color: 'black',
                                fontSize: 16
                            }
                        }
                    }
                },
                name: '上报中介数量',
                type: 'bar',
                data: yAxisDate2_sszj
            });

            seriesData2.push({
                itemStyle: {
                    normal: {
                        color: function (params) {
                            return '#15a8e3';
                        },
                        lineStyle: {
                            color: '#15a8e3'
                        },
                        label: {
                            show: true,
                            position: 'top',
                            formatter: '{c}',
                            textStyle: {
                                color: 'black',
                                fontSize: 16
                            }
                        }
                    }
                },
                name: '评价信息数量',
                type: 'bar',
                data: yAxisDate2_pjxx
            });

            if (callback instanceof Function) {
                callback();
            }
        }, "json");
    }

    function initZjxxBar() {
        myChart2.clear();
        myChart2.setOption({
            title: {
                x: 'center',
                text: '涉审中介监管信息统计',
                subtext: '统计各部门的中介基础信息和中介评价信息上报情况'
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                // left: '60%',
                top: 50,
                data: ['上报中介数量', '评价信息数量']
            },
            toolbox: {
                show: true,
                x: 80,
                feature: {
                    restore: {
                        show: true
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
                y2: 140
            },
            xAxis: [
                {
                    type: 'category',
                    show: true,
                    axisLabel: {
                        rotate: -45
                    },
                    boundaryGap: true,
                    axisLine: {onZero: true},
                    data: xAxisData2

                }
            ],
            yAxis: [
                {
                    type: 'value',
                    splitArea: {show: true},
                    show: true,
                    axisLabel: {
                        formatter: function (val) {
                            if (val >= 10000) {//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                                val = val / 10000 + '万'
                            }

                            return val + "条";
                        }
                    }
                }
            ],
            dataZoom: [
                {
                    type: 'inside'
                },
                {
                    show: true,
                    height: 40,
                    type: 'slider',
                    top: '90%',
                    right: '10%',
                    left: '8%',
                    xAxisIndex: [0],
                    start: 0,
                    end: 5
                }
            ],
            series: seriesData2
        });
        myChart2.hideLoading();
        myChart2.resize();
    }


    var table = $('#dataTable').DataTable({
        ajax: {
            url: CONTEXT_PATH + "/sszj/tjfx/getDataTable.action",
            type: 'post'
        },
        ordering: true,
        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: true,
        columns: [
            {
                "data": null,
                render: function (data, type, row, meta) {
                    // 显示行号
                    var startIndex = meta.settings._iDisplayStart;
                    return startIndex + meta.row + 1;
                },
                "orderable": false
            }, {
                "data": "DEPT_NAME"
            }, {
                "data": "SSZJSIZE" //中介基本信息
            }, {
                "data": "CYRYSIZE" //机构从业人员
            }, {
                "data": "PJDJSIZE" //中介评价信息
            }, {
                "data": "HEJISIZE" //合计数
            }],
        initComplete: function (settings, data) {
            var columnTogglerContent = $('#fk_enter_btns_2').clone();
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
        },
        "footerCallback": function( tfoot, data, start, end, display ) {
            debugger;
            //小计数
            var zjxxCount = 0;
            var cyryCount = 0;
            var pjxxCount = 0;
            var hejiCount = 0;
            if (data) {
                $.each(data, function (index, object) {
                    zjxxCount += object.SSZJSIZE;
                    cyryCount += object.CYRYSIZE;
                    pjxxCount += object.PJDJSIZE;
                    hejiCount += object.HEJISIZE;
                });
            }
            $('tfoot').find('th').eq(1).html(zjxxCount);
            $('tfoot').find('th').eq(2).html(cyryCount);
            $('tfoot').find('th').eq(3).html(pjxxCount);
            $('tfoot').find('th').eq(4).html(hejiCount);
        }
    });


    function exportData() {
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        layer.confirm('确定导出吗？', {}, function () {
            layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
            document.location = CONTEXT_PATH + "/sszj/tjfx/exportData.action?startDate=" + startDate + "&endDate=" + endDate;
        });
    }

    return {
        "conditionSearch": conditionSearch,
        "conditionReset": conditionReset,
        "exportData": exportData
    }
})();