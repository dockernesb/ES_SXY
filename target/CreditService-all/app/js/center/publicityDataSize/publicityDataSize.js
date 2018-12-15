var pds = (function () {

    var zt = "";
    var startDate = "";
    var endDate = "";
    var deptId = "";

    var deptAs = [];
    var deptBs = [];

    $.getJSON(ctx + "/system/department/getDeptList.action", function (result) {
        if (result && result.length > 0) {
            for (var i=0; i<result.length; i++) {
                var row = result[i];
                var code = row.code || "";
                if (code && code.length > 0) {
                    var prefix = code.substring(0, 1);
                    if (prefix == "A") {
                        deptAs.push(row);
                    } else if (prefix == "B") {
                        deptBs.push(row);
                    }
                }
            }
            initDept(deptBs.length > 0 ? deptBs : deptAs);
        }
    });

    // 初始下拉框
    function initDept(depts) {
        $("#deptId").select2().select2("destroy");
        $("#deptId option").remove();
        $("#deptId").select2({
            placeholder: '全部部门',
            allowClear: false,
            language: 'zh-CN',
            data: depts
        });
        $('#deptId').val(null).trigger("change");
        resizeSelect2($("#deptId"));
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '0px');
    }

    $("input[name='zt']").click(function() {
        var val = $(this).val();
        if ("A" == val) {
            initDept(deptAs);
        } else if ("B" == val) {
            initDept(deptBs);
        }
    });

    var start = {
        elem: '#startDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
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
            start.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);

    var table = $('#dataTable').DataTable({
        serverSide: false,// 如果是服务器方式，必须要设置为true
        processing: true,// 设置为true,就会有表格加载时的提示
        lengthChange: true,// 是否允许用户改变表格每页显示的记录数
        pageLength: 10,
        searching: false,// 是否允许Datatables开启本地搜索
        paging: true,
        ordering: false,
        autoWidth: false,
        columns: [{
            "data": null,
            render: function (data, type, row, meta) {
                // 显示行号
                var startIndex = meta.settings._iDisplayStart;
                return startIndex + meta.row + 1;
            }
        }, {
            "data": "DEPT_NAME"
        }, {
            "data": "ALL_SIZE"
        }, {
            "data": "XZXK_SIZE"
        }, {
            "data": "XZCF_SIZE"
        }, {
            "data": "LAST_TIME"
        }],
        initComplete: function (settings, data) {
            var $div = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
            $div.append('<a class="btn btn-sm blue" style="float: right;" href="javascript:;" onclick="pds.exportData();">导出</a>');
        }
    });

    var myChart1 = echarts.init(document.getElementById("repairAnalysisBar"));

    var myChartXk = echarts.init(document.getElementById('sgsXzxkSort'));

    var myChartCf = echarts.init(document.getElementById('sgsXzcfSort'));

    var dbXData = [];// x轴类目
    var dbCFYData = [];// 行政处罚y轴数据
    var dbXKYData = [];// 行政许可y轴数据
    var dbToolTipPercent = []; // 百分比


    // 初始化柱状图
    function initBar() {
        var option = {
            title: {
                text: '双公示上报量统计',
                subtext: '',
                left: 'center'
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: { // 坐标轴指示器，坐标轴触发有效
                    type: 'line' // 默认为直线，可选为：'line' | 'shadow'
                },
                formatter: function (params, ticket, callback) {
                    var value0 = params[0].value || 0;
                    var value1 = params[1].value || 0;
                    var tooltipD = params[0].name + "<br />"
                        + params[0].seriesName + " : " + value0 + "<br />"
                        + params[1].seriesName + " : " + value1;
                    return tooltipD;
                }
            },
            toolbox: {
                show: true,
                left: '20',
                top: '50',
                feature: {
                    mark: {
                        show: true
                    },
                    magicType: {
                        show: true,
                        type: ['line']
                    },
                    restore: {
                        show: true
                    },
                    saveAsImage: {
                        show: true
                    }
                }
            },
            grid: {
                top: '100',
                borderWidth: 1,
                containLabel: true,// 防止label溢出
                x: 40,
                x2: 60,
                y2: 80 //图表底部距离
            },
            legend: {
                top: '50',
                right: '50',
                data: ['行政许可', '行政处罚']
            },
            xAxis: [{
                type: 'category',
                show: true,
                /*axisLabel : {
                     rotate : -45
                 },*/
                boundaryGap: true,
                axisLine: {
                    onZero: true
                },
                data: dbXData
            }],
            yAxis: [{
                type: 'value',
                splitArea: {
                    show: true
                },
                minInterval: 1,// 最小刻度
                show: true,
                axisLabel: {
                    formatter: function (val) {
                        var unit = "条";

                        if (val >= 10000) {//当纵轴刻度数字超过4位数时，如355000条，则显示35.5万条；
                            val = val / 10000 + '万'
                        }

                        return val + unit;
                    }
                }
            }],
            dataZoom: [{
                type: 'inside',
                startValue: dbXData[0],
                endValue: dbXData[5]
            }, {
                show: true,
                height: 40,
                type: 'slider',
                top: '90%',
                right: '8%',
                left: '8%'
            }],
            textStyle: {
                color: '#666'
            },
            series: function () {
                var series = [];
                var item1 = {
                    name: "行政许可",
                    type: 'bar',
                    stack: '行政许可',
                    label: {
                        normal: {
                            show: true,
                            position: 'inside',
                            formatter: function (data) {
                                return data.value == 0 ? '' : data.value;
                            }
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                return '#fbb321';
                            },
                            lineStyle: {
                                color: '#fbb321'
                            }
                        }
                    },
                    data: dbXKYData
                };
                series.push(item1);

                var item2 = {
                    name: "行政处罚",
                    type: 'bar',
                    stack: '行政处罚',
                    label: {
                        normal: {
                            show: true,
                            position: 'inside',
                            formatter: function (data) {
                                return data.value == 0 ? '' : data.value;
                            }
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                return '#a69ae4';
                            },
                            lineStyle: {
                                color: '#a69ae4'
                            }
                        }
                    },
                    data: dbCFYData
                };
                series.push(item2);
                return series;
            }()
        };
        myChart1 = echarts.init(document.getElementById("repairAnalysisBar"));
        myChart1.setOption(option);
        myChart1.hideLoading();
    }

    initBar();

    function initXZXK(list) {
        var category = [];
        var dataSeries = [];

        if (list && list.length > 0) {
            sortList(list, 1);
            var result = processData(list, 1);
            if (result) {
                category = result.category || [];
                dataSeries = result.dataSeries || [];
            }
        }

        var option = {
            title: {
                text: '行政许可排行',
                left: 70,
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
                axisLabel: {
                    formatter: function (val) {

                        if (val >= 10000) {//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                            val = val / 10000 + '万'
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
                    formatter: function (val) {

                        if (val >= 10000) {//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                            val = val / 10000 + '万'
                        }

                        return val;
                    }
                },
                data: category
            },
            series: [
                {
                    name: '行政许可',
                    type: 'bar',
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                return '#fbb321';
                            },
                            lineStyle: {
                                color: '#fbb321'
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            formatter: function (data) {
                                return data.name;
                            }
                        }
                    },
                    data: dataSeries
                }
            ]
        };
        myChartXk = echarts.init(document.getElementById('sgsXzxkSort'));
        myChartXk.setOption(option);
    }

    function initXZCF(list) {
        var category = [];
        var dataSeries = [];

        if (list && list.length > 0) {
            sortList(list, 2);
            var result = processData(list, 2);
            if (result) {
                category = result.category || [];
                dataSeries = result.dataSeries || [];
            }
        }

        var option = {
            id: 'bar',
            zlevel: 1,
            type: 'bar',
            symbol: 'none',
            title: {
                text: '行政处罚排行',
                left: 70,
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
                axisLabel: {
                    formatter: function (val) {

                        if (val >= 10000) {//当纵轴刻度数字超过4位数时，如355000，则显示35.5万；
                            val = val / 10000 + '万'
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
                    name: '行政处罚',
                    type: 'bar',
                    data: dataSeries,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                return '#a69ae4';
                            },
                            lineStyle: {
                                color: '#a69ae4'
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            formatter: function (data) {
                                return data.name;
                            }
                        }
                    }
                }
            ]
        };
        myChartCf = echarts.init(document.getElementById('sgsXzcfSort'));
        myChartCf.setOption(option);
    }

    function sortList(list, type) {
        if (list && list.length > 0) {
            for (var i=0; i<list.length; i++) {
                var m = list[i];
                for (var j=0; j<i; j++) {
                    var n = list[j];
                    var mv = (type == 1) ? (m.XZXK_SIZE || 0) : (m.XZCF_SIZE || 0);
                    var nv = (type == 1) ? (n.XZXK_SIZE || 0) : (n.XZCF_SIZE || 0);
                    if (mv < nv) {
                        list[i] = n;
                        list[j] = m;
                    }
                }
            }
        }
        return list;
    }
    
    function processData(list, type) {
        var category = [];
        var dataSeries = [];
        var result = {category:category, dataSeries:dataSeries};
        if (list) {
            var len = list.length;
            var start = len - 5;
            start = start > 0 ? start : 0;
            for (var i = start; i < len; i++) {
                var row = list[i];
                category.push(row.DEPT_NAME || "");
                if (type == 1) {
                    dataSeries.push(row.XZXK_SIZE || 0);
                } else {
                    dataSeries.push(row.XZCF_SIZE || 0);
                }
            }
        }
        return result;
    }

    initXZXK([]);
    initXZCF([]);

    function conditionSearch() {
        zt = $("input[name='zt']:checked").val();
        startDate = $("#startDate").val();
        endDate = $("#endDate").val();
        deptId = $("#deptId").val() || "";

        $.post(ctx + "/publicityDataSize/getDataSize.action", {
            zt: zt,
            startDate: startDate,
            endDate: endDate,
            deptId: deptId
        }, function (list) {
            if (list) {
                dbXData = [];
                dbXKYData = [];
                dbCFYData = [];
                for (var i = 0; i < list.length; i++) {
                    var row = list[i];
                    dbXData.push(row.DEPT_NAME || "");
                    dbXKYData.push(row.XZXK_SIZE || 0);
                    dbCFYData.push(row.XZCF_SIZE || 0);
                }
                initBar(list);
                table.rows().remove();
                table.rows.add(list).draw();
                initXZXK(list);
                initXZCF(list);
            }
        }, "json");
    }

    function conditionReset() {
        $("input[name='zt']:eq(0)").prop("checked", "checked");
        resetSearchConditions('#startDate,#endDate,#deptId');
        resetDate(start,end);
        $("#ztb").click();
    }

    conditionSearch();
    
    function exportData() {
        var url = ctx + '/publicityDataSize/exportData.action';
        url += "?zt=" + zt + "&startDate=" + startDate + "&endDate=" + endDate + "&deptId=" + deptId;
        document.location.href = url;
    }

    return {
        conditionSearch: conditionSearch,
        conditionReset: conditionReset,
        exportData: exportData
    }

})();