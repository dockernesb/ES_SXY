var hisTask = function () {
    $("#status").select2({
        placeholder: '上报状态',
        language: 'zh-CN'
    });
    resizeSelect2('#status');

    $('#status').val(null).trigger("change");

    // 获取标签数据量
    function getReportLogDataCount(params) {
        $.getJSON(CONTEXT_PATH + '/dp/task/getReportLogDataCount.action', params, function (data) {
            if (data && data.length > 0) {
                var reportData = data[0];
                reportData.ALL_SIZE = reportData.ALL_SIZE || '0';
                reportData.YIWEN_SIZE = reportData.YIWEN_SIZE || '0';
                reportData.ALL_YIWEN_SIZE = reportData.ALL_YIWEN_SIZE || '0';
                reportData.GENGXIN_SIZE = reportData.GENGXIN_SIZE || '0';
                reportData.WGL_SIZE = reportData.WGL_SIZE || '0';
                reportData.YOUXIAO_SIZE = reportData.YOUXIAO_SIZE || '0';

                if (String(reportData.YIWEN_SIZE).length > 4 || String(reportData.ALL_YIWEN_SIZE).length > 4) {
                    $('#sbyws').css('font-size', '17px');
                }
                $('#sbyws').html('<span style="color: red;">' + reportData.YIWEN_SIZE + '</span>/' + reportData.ALL_YIWEN_SIZE + '');
                $('#sbzs').html(reportData.ALL_SIZE);// 上报量
                $('#sbgxs').html(reportData.GENGXIN_SIZE);// 更新量
                $('#sbwgl').html(reportData.WGL_SIZE);// 未关联量
                $('#sbrks').html(reportData.YOUXIAO_SIZE);// 入库量
            }
        });
    }

    getReportLogDataCount({deptId: $.trim($("#deptId").val())});

    $.getJSON(ctx + "/system/dictionary/listValues.action?groupKey=reportWay", function (result) {
        var data = result.items;
        var op = "<option value=' '>全部方式</option>";
        for (var i = 0; i < data.length; i++) {
            op += "<option value='" + data[i].id + "'>" + data[i].text + "</option>";
        }

        $("#reportWay").html(op);
        // 初始下拉框
        $("#reportWay").select2({
            placeholder: '上报方式',
            language: 'zh-CN'
        });

        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
        resizeSelect2('#reportWay');
        $('#reportWay').val(null).trigger("change");
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

    // 创建一个Datatable
    var table = $('#taskGrid').DataTable({
        ajax: {
            url: ctx + "/dp/task/hisList.action",
            type: "post",
            data: {
                deptId: $('#deptId').val()
            }
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,// 如果是服务器方式，必须要设置为true
        processing: true,// 设置为true,就会有表格加载时的提示
        columns: [{
            "data": "TASK_CODE",
            "render": function opFormatter(value, type, row) {
                var imgUrl = ctx + '/app/images/dataReport/';
                var _title = '';
                if (row.REPORT_WAY == '0') {
                    imgUrl += 'hand.png';
                    _title = '手动录入';
                }
                if (row.REPORT_WAY == '1') {
                    imgUrl += 'file.png';
                    _title = '文件上传';
                }
                if (row.REPORT_WAY == '2') {
                    imgUrl += 'db.png';
                    _title = '数据库上报';
                }
                if (row.REPORT_WAY == '3') {
                    imgUrl += 'ftp.png';
                    _title = 'FTP上报';
                }
                if (row.REPORT_WAY == '4') {
                    imgUrl += 'webservice.png';
                    _title = '接口上报';
                }
                return '<img title="' + _title + '" src="' + imgUrl + '"> ' + value;
            }
        }, {
            "data": "NAME"
        }, {
            "data": "ALL_SIZE"
        }, {
            "data": "YIWEN_SIZE",
            "render": function opFormatter(value, type, row) {
                return '<span style="color:red;">' + value + '</span>/' + row.ALL_YIWEN_SIZE;
            }
        }, {
            "data": "GENGXIN_SIZE",
            "render": function (value, type, row) {
                if (isNull(row.GENGXIN_SIZE)) {
                    return 0;
                } else {
                    return value;
                }
            }
        }, {
            "data": "YOUXIAO_SIZE",// 入库量
            "render": function (value, type, row) {
                if (isNull(row.YOUXIAO_SIZE)) {
                    return 0;
                } else {
                    return value;
                }
            }
        }, {
            "data": "WGL_SIZE",
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return '0';
                }
                return value;
            }
        }, {
            "data": "CREATE_DATE"
        }, {
            "data": "POINT_STATUS",
            "render": function (value, type, row) {
                // 完成节点
                var _width = '0%';
                var _title = '';
                if (value == '0') {
                    _title = '未开始';
                } else if (value == '1') {
                    _width = '34%';
                    _title = '1 of 3  数据上报';
                } else if (value == '2') {
                    _width = '67%';
                    _title = '2 of 3  规则校验';
                } else if (value == '3') {
                    _width = '100%';
                    _title = '3 of 3  关联入库';
                }
                var _html = '<div title="' + _title + '" class="progress progress-striped" role="progressbar" style="margin-bottom: 0px;">';
                _html += '<div class="progress-bar progress-bar-success" style="width: ' + _width + ';"></div>';
                _html += '</div>';
                return _html;

            }
        }, {
            "data": "TABLE_STATUS",
            "render": function (value, type, row) {
                if (value == '超时') {
                    return '<span style="color:red;">超时</span>';
                } else {
                    return '正常';
                }
            }
        }],
        drawCallback: function (settings) {
            // 添加行选中点击事件
            $('#taskGrid tbody tr').on('click', function () {
                if ($(this).hasClass('active')) {
                    $(this).removeClass('active');
                } else {
                    table.$('tr.active').removeClass('active');
                    $(this).addClass('active');
                }
            });
        },
        createdRow: function (row, data, dataIndex) {
            $(row).children('td').eq(2).attr('style', 'text-align: right;');
            $(row).children('td').eq(3).attr('style', 'text-align: right;');
            $(row).children('td').eq(4).attr('style', 'text-align: right;');
            $(row).children('td').eq(5).attr('style', 'text-align: right;');
            $(row).children('td').eq(6).attr('style', 'text-align: right;');
        }
    });

    // 上报数据明细
    function dataDetail(erorData) {
        log(erorData);
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var taskCode = row.TASK_CODE;// 任务编号
            var id = row.LOGIC_TABLE_ID;// logintableId
            var reportWay = row.REPORT_WAY;// 上报方式
            var deptId = row.SYS_DEPARTMENT_ID;
            var confirmStatus = row.CONFIRM_STATUS;// 确认状态
            var versionId = row.TABLE_VERSION_ID;// 确认状态
            log(row);
            var url = ctx + '/dp/historyDataReport/dataReport.action?taskCode=' + taskCode + "&erorData=" + erorData + "&reportWay=" + reportWay + "&logicTableId=" + id + "&deptId=" + deptId + "&confirmStatus=" + confirmStatus + "&versionId=" + versionId;
            $("div#childBox").html("");
            $("div#parentBox").hide();
            $("div#childBox").show();
            $("div#childBox").load(url);
            $("div#childBox").prependTo("#topBoxMore");
        } else {
            $.alert('请勾选要操作的批次。');
        }
    }

    // 按条件查询
    function conditionSearch() {
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["tableName"] = $.trim($("#tableName").val());
            data["taskCode"] = $.trim($("#taskCode").val());
            data["reportWay"] = $.trim($("#reportWay").val());
            data["status"] = $.trim($("#status").val());
            data["deptId"] = $.trim($("#deptId").val());
            data["startDate"] = $.trim($("#startDate").val());
            data["endDate"] = $.trim($("#endDate").val());
            table.ajax.reload();
        }

        var params = {
            tableName: $.trim($("#tableName").val()),
            taskCode: $.trim($("#taskCode").val()),
            reportWay: $.trim($("#reportWay").val()),
            status: $.trim($("#status").val()),
            deptId: $.trim($("#deptId").val()),
            startDate: $.trim($("#startDate").val()),
            endDate: $.trim($("#endDate").val())
        }
        getReportLogDataCount(params);
    }

    // 重置查询条件
    function conditionReset() {
        resetSearchConditions('#tableName,#taskCode,#reportWay,#startDate,#endDate,#status', function () {
            resetDate(start, end);
        });
    }


    // 数据处理日志
    function dealLog() {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var taskCode = selectRows[0].TASK_CODE;
            $.openWin({
                title: '处理日志',
                type: 2,
                content: ctx + '/dp/task/dataProcessLog.action?taskCode=' + taskCode,
                maxmin : false,
                btn: ['关闭'],
                area: ['900px', '600px']
            });

        } else {
            $.alert('请勾选要操作的批次。');
        }
    }

    // 未关联数据
    function wglData() {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var taskCode = row.TASK_CODE;// 上报批次编号
            var logicTableId = row.LOGIC_TABLE_ID;// logintableId
            var reportWay = row.REPORT_WAY;
            $.post(ctx + "/dp/task/isHasRelation.action?logicTableId=" + logicTableId+"&taskCode="+taskCode, function (result) {
            	if (result == "0") {
                    var url = ctx + '/dp/task/toNoRelatedDetail.action?pageType=2&logicTableId=' + logicTableId + "&taskCode=" + taskCode + "&reportWay=" + reportWay;
                    $("div#childBox").html("");
                    $("div#parentBox").hide();
                    $("div#childBox").show();
                    $("div#childBox").load(url);
                    $("div#childBox").prependTo("#topBoxMore");
            	}else if(result == "1"){
		    		$.alert('机构设立登记表数据为本地法人基础数据，不涉及未关联数据');
				}else if(result == "2"){
					 $.alert('该批次未产生未关联数据!');
				}
            });
        } else {
            $.alert('请勾选要操作的批次。');
        }
    }

    //  3.0.2产品整改:插入错误的数据下载 ------------------------begin---------------------
    function errorDataDownload() {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var taskCode = row.TASK_CODE;
            $.post(CONTEXT_PATH + '/dp/task/checkErrorFile.action', {
                taskCode: taskCode
            }, function (data) {
                var data = eval('(' + data + ')');
                if (!data.result) {
                    $.alert('当前批次没有产生错误文件!');
                } else {
                	var url = CONTEXT_PATH + "/dp/task/downLoadErrorFile.action?taskCode=" + taskCode;
                    window.location = url;
                }
            });
        } else {
            $.alert('请勾选要操作的批次。');
        }
    }

    
    //  3.0.2产品整改:插入错误的数据下载 ------------------------end---------------------
    return {
        conditionSearch: conditionSearch,
        conditionReset: conditionReset,
        dataDetail: dataDetail,
        dealLog: dealLog,
        wglData: wglData,
        table: table,
        errorDataDownload:errorDataDownload
    }
}();