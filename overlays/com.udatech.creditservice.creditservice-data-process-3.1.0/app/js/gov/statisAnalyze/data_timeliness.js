var data_timeline = (function () {
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

    var startDate;
    var endDate;

    function initDate() {
        startDate = new Date();
        startDate.setMonth(startDate.getMonth() - 6);
        startDate = startDate.format("yyyy-MM-dd");
        end.min = startDate; //开始日选好后，重置结束日的最小日期
        end.start = startDate;//将结束日的初始值设定为开始日
        $("#startDate").val(startDate);

        endDate = new Date().format("yyyy-MM-dd");
        start.max = endDate; //结束日选好后，重置开始日的最大日期
        $("#endDate").val(endDate);
    }

    initDate();

    var myChart1 = echarts.init(document.getElementById("timelinessBar"), "macarons");
    var myChart2 = echarts.init(document.getElementById("timelinessSchemaTrend"), "macarons");

    // 数据目录上报时效--柱状图
    var list;
    var ml = [];// x轴类目，目录信息
    var zqzcs = [];// 正常周期次数
    var zqlbs = [];// 漏报周期次数
    var zqcss = [];// 超时周期次数
    var defaultLengthbar = 50;

    $("#searchBtn").click(function () {
        searchTimeliness();
    });

    // 初始化图表数据
    function searchTimeliness() {

        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        if (startDate && endDate && startDate > endDate) {
            $.alert('开始日期不能大于结束日期！');
            return;
        }

        myChart1.showLoading();

        $.getJSON(ctx + '/dp/timeliness/getPeriods.action', {
            "isCenter": false,
            "deptId": $('#deptId').val(),
            "name": $('#name').val(),
            "startDate": startDate,
            "endDate": endDate
        }, function (data) {
            // 初始化柱状图
            list = data.list;
            ml = data.ml;
            zqzcs = data.zqzcs;
            zqlbs = data.zqlbs;
            zqcss = data.zqcss;
            if (ml.length <= 10) {
                defaultLengthbar = 100;
            }
            initBar();

            // 柱状图联动查询点击事件
            myChart1.on('click', function (param) {
                myChart2.showLoading();
                getSchemaMonthStatistics({
                        "name": param.name,
                        "deptId": $('#deptId').val(),
                        "startDate": $("#startDate").val(),
                        "endDate": $("#endDate").val()
                    }
                )
            });

            // 加载列表数据
            table.clear().draw();
            table.rows.add(data.list).draw();
            if (ml[0]) {
                // 趋势图默认加载柱状图的第一个目录
                myChart2.showLoading();
                getSchemaMonthStatistics({
                        "name": ml[0],
                        "deptId": $('#deptId').val(),
                        "startDate": $("#startDate").val(),
                        "endDate": $("#endDate").val()
                    }
                )
            } else {
                initSchemaTrend({rq: [], zqzcs: [], zqcss: [], zqlbs: []}, {name: '目录'})
            }

        });
    }

    // 目录周期情况月度统计
    function getSchemaMonthStatistics(obj) {
        $.post(ctx + '/dp/timeliness/getSchemaMonthStatistics.action', obj, function (data) {
            // 初始化指定目录下征集周期上报情况月度统计趋势图
            initSchemaTrend(data, obj);
        }, "json");
    }

    // 初始化指定目录下征集周期上报情况月度统计趋势图
    function initSchemaTrend(data, obj) {
        myChart2.clear();
        var option = {
            title: {
                text: '目录上报时效月度统计',
                subtext: '统计' + obj.name + '数据上报的月度时效性',
                left: 'center'
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            toolbox: {
                show: true,
                left: '50',
                feature: {
                    // mark: false,
                    // magicType: {show: true, type: ['line', 'bar']},
                    // dataView: {show: false, readOnly: false},
                    restore: {show: true},
                    saveAsImage: {show: true}
                }
            },
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: 100
            }, {
                show: true,
                height: 40,
                type: 'slider',
                top: '90%',
                xAxisIndex: [0],
                start: 0,
                end: 50
            }],
            legend: {
                top: 50,
                data: ['正常上报周期数', '超时上报周期数', '漏报周期数']
            },
            grid: {
                top: 100,
                left: '3%',
                right: '4%',
                bottom: '20%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'category',
                    data: data.rq,
                    show: true,
                    axisLabel: {
                        rotate: -45,
                    },
                    boundaryGap: true,
                    axisLine: {onZero: true}
                }
            ],
            yAxis: [
                {
                    type: 'value'
                }
            ],
            series: [
                {
                    name: '正常上报周期数',
                    type: 'line',
                    data: data.zqzcs
                },
                {
                    name: '超时上报周期数',
                    type: 'line',
                    data: data.zqcss
                },
                {
                    name: '漏报周期数',
                    type: 'line',
                    data: data.zqlbs
                }
            ]
        };
        myChart2.setOption(option);
        myChart2.hideLoading();
    }

    // 创建一个Datatable
    var table = $('#dataTable').DataTable({
        ordering: true,
        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,// 如果是服务器方式，必须要设置为true
        processing: true,// 设置为true,就会有表格加载时的提示
        paging: true,
        columns: [{
            // "orderable": false,
            render: function (data, type, row, meta) {
                // 显示行号
                var startIndex = meta.settings._iDisplayStart;
                return startIndex + meta.row + 1;
            } ,
            "orderable" : false
        }, {
            "data": "NAME",
            render : function (data, type, row) {
                var str = '<a href="javascript:;" onclick="data_timeline.showDetail(\''+ data +'\');">' + data + '</a>';
                return str;
            }
        }, {
            "data": "ZQZS"
        }, {
            "data": "ZQZS",
            "render": function (value, type, row) {
                return row.ZQZS - row.ZQCSS - row.ZQLBS;
            }
        }, {
            "data": "ZQZS",
            "render": function (value, type, row) {
                var zqzcs = row.ZQZS - row.ZQCSS - row.ZQLBS;
                if (zqzcs == 0 || row.ZQZS == 0) {
                    return '0%';
                } else {
                    return (zqzcs / row.ZQZS * 100).toFixed(2) + '%';
                }
            }
        }, {
            "data": "ZQCSS"
        }, {
            "data": "ZQCSS",
            "render": function (value, type, row) {
                if (value == 0 || row.ZQZS == 0) {
                    return '0%';
                } else {
                    return (value / row.ZQZS * 100).toFixed(2) + '%';
                }
            }
        }, {
            "data": "ZQLBS"
        }, {
            "data": "ZQLBS",
            "render": function (value, type, row) {
                if (value == 0 || row.ZQZS == 0) {
                    return '0%';
                } else {
                    return (value / row.ZQZS * 100).toFixed(2) + '%';
                }
            }
        }],
        initComplete: function (settings, data) {
            var columnTogglerContent = $('#fk_enter_btns_2').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
            $(columnTogglerDiv).html(columnTogglerContent);

            // 导出
            $(columnTogglerContent).find('.btn').click(function () {
                loading();
                var url = ctx + '/dp/timeliness/exportData.action';
                var _form = $("<form></form>", {
                    'id': 'importExcel',
                    'method': 'post',
                    'action': url,
                    'target': "_self",
                    'style': 'display:none'
                }).appendTo($('body'));

                //将隐藏域加入表单
                _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': $('#deptId').val()}));
                _form.append($("<input>", {'type': 'hidden', 'name': 'name', 'value': $('#name').val()}));
                _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
                _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
                //触发提交事件
                _form.trigger('submit');
                //表单删除
                _form.remove();
                loadClose();
            });
        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });

    // 初始化柱状图
    function initBar() {
        var option = {
            title: {
                text: '目录上报时效统计',
                subtext: '统计部门所有目录上报数据的时效性',
                left: 'center'
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            toolbox: {
                show: true,
                left: '50',
                feature: {
                    // mark: false,
                    // magicType: {show: true, type: ['line', 'bar']},
                    // dataView: {show: false, readOnly: false},
                    restore: {show: true},
                    saveAsImage: {show: true}
                }
            },
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: defaultLengthbar
            }, {
                show: true,
                height: 40,
                type: 'slider',
                top: '90%',
                xAxisIndex: [0],
                start: 0,
                end: 50
            }],
            legend: {
                top: 50,
                data: ['正常上报周期数', '超时上报周期数', '漏报周期数']
            },
            grid: {
                top: 100,
                left: '3%',
                right: '4%',
                bottom: '20%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'category',
                    data: ml,
                    show: true,
                    axisLabel: {
                        rotate: -45,
                    },
                    boundaryGap: true,
                    axisLine: {onZero: true}
                }
            ],
            yAxis: [
                {
                    type: 'value'
                }
            ],
            series: [
                {
                    name: '正常上报周期数',
                    type: 'bar',
                    data: zqzcs
                },
                {
                    name: '超时上报周期数',
                    type: 'bar',
                    data: zqcss
                },
                {
                    name: '漏报周期数',
                    type: 'bar',
                    data: zqlbs
                }
            ]
        };
        myChart1.setOption(option);
        myChart1.hideLoading();
    }


    $(window).resize(function () {
        myChart1.resize();
        myChart2.resize();
    });

    searchTimeliness();

    $("#resetBtn").click(function () {
        resetSearchConditions('#startDate, #endDate, #name');
        initDate();
        resetIEPlaceholder();
    });

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
            "data" : "TIME"  // 时间
        }, {
            "data": "ZQZS"
        }, {
            "data": "ZQZS",
            "render": function (value, type, row) {
                return row.ZQZS - row.ZQCSS - row.ZQLBS;
            }
        }, {
            "data": "ZQZS",
            "render": function (value, type, row) {
                var zqzcs = row.ZQZS - row.ZQCSS - row.ZQLBS;
                if (zqzcs == 0 || row.ZQZS == 0) {
                    return '0%';
                } else {
                    return (zqzcs / row.ZQZS * 100).toFixed(2) + '%';
                }
            }
        }, {
            "data": "ZQCSS"
        }, {
            "data": "ZQCSS",
            "render": function (value, type, row) {
                if (value == 0 || row.ZQZS == 0) {
                    return '0%';
                } else {
                    return (value / row.ZQZS * 100).toFixed(2) + '%';
                }
            }
        }, {
            "data": "ZQLBS"
        }, {
            "data": "ZQLBS",
            "render": function (value, type, row) {
                if (value == 0 || row.ZQZS == 0) {
                    return '0%';
                } else {
                    return (value / row.ZQZS * 100).toFixed(2) + '%';
                }
            }
        }],
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
        var url = ctx + "/dp/timeliness/getSchemaDataByMonth.action";
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

        var url = ctx + '/dp/timeliness/exportDetailsData.action';

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
        // _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        // _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
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
        goBack : goBack
    };
})();
