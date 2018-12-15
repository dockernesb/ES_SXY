var hisTaskMore = function () {
    $("#status").select2({
        placeholder: '上报状态',
        language: 'zh-CN'
    });

    resizeSelect2('#status');

    $('#status').val(null).trigger("change");

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
    var table = $('#taskGridMore').DataTable({
        ajax: {
            url: ctx + "/dp/task/hisList.action",
            type: "post",
            data: {
                deptId: $('#deptId').val(),
                logicTableId: $('#logicTableId').val(),
                versionId: $('#versionId').val()
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
            "data": "ALL_SIZE"
        }, {
            "data": "YIWEN_SIZE",
            "render": function opFormatter(value, type, row) {
                return '<span style="color:red;">' + value + '</span>';
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
            $('#taskGridMore tbody tr').on('click', function () {
                if ($(this).hasClass('active')) {
                    $(this).removeClass('active');
                } else {
                    table.$('tr.active').removeClass('active');
                    $(this).addClass('active');
                }
            });
        },
        createdRow: function (row, data, dataIndex) {
            $(row).children('td').eq(1).attr('style', 'text-align: right;');
            $(row).children('td').eq(2).attr('style', 'text-align: right;');
            $(row).children('td').eq(3).attr('style', 'text-align: right;');
            $(row).children('td').eq(4).attr('style', 'text-align: right;');
            $(row).children('td').eq(5).attr('style', 'text-align: right;');
        }
    });

    // 上报数据明细
    function dataDetail(erorData) {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var taskCode = row.TASK_CODE;// 任务编号
            var id = row.LOGIC_TABLE_ID;// logintableId
            var reportWay = row.REPORT_WAY;// 上报方式
            var deptId = row.SYS_DEPARTMENT_ID;
            var confirmStatus = row.CONFIRM_STATUS;// 确认状态
            var versionId = row.TABLE_VERSION_ID;//版本ID

            var url = ctx + '/dp/historyDataReport/dataReport.action?taskCode=' + taskCode + "&erorData=" + erorData + "&reportWay=" + reportWay + "&logicTableId=" + id + "&toMore=tomore" + "&deptId=" + deptId + "&confirmStatus=" + confirmStatus + "&versionId=" +versionId;
            $("div#childBoxMore").html("");
            $("div#parentBoxMore").hide();
            $("div#childBoxMore").show();
            $("div#childBoxMore").load(url);
            $("div#childBoxMore").prependTo("#topBoxMore");
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
            data["taskCode"] = $.trim($("#taskCode").val());
            data["reportWay"] = $.trim($("#reportWay").val());
            data["status"] = $.trim($("#status").val());
            data["logicTableId"] = $.trim($("#logicTableId").val());
            data["deptId"] = $.trim($("#deptId").val());
            data["startDate"] = $.trim($("#startDate").val());
            data["endDate"] = $.trim($("#endDate").val());
            table.ajax.reload();
        }
    }

    // 重置查询条件
    function conditionReset() {
        resetSearchConditions('#taskCode,#reportWay,#startDate,#endDate,#status', function () {
            resetDate(start, end);
        });
    }

    // 返回
    function goBack() {
        $("div#childBox").hide();
        $("div#parentBox").show();
        var selectArr = recordSelectNullEle();
        $("div#parentBox").prependTo("#topBox");
        callbackSelectNull(selectArr);
        var activeIndex = recordDtActiveIndex(govTask.table);// 父页面的列表id
        govTask.table.ajax.reload(function () {
            callbackDtRowActive(govTask.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
        resetIEPlaceholder();
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

    // 未关联数据,pageType：0数据上报页面，1更多页面,2上报记录页面
    function wglData() {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var taskCode = row.TASK_CODE;// 上报批次编号
            var logicTableId = $.trim($("#logicTableId").val())
            var reportWay = row.REPORT_WAY;
            $.post(ctx + "/dp/task/isHasRelation.action?logicTableId=" + logicTableId+"&taskCode="+taskCode, function (result) {
            	if (result == "0") {
                    var url = ctx + '/dp/task/toNoRelatedDetail.action?pageType=1&logicTableId=' + logicTableId + "&taskCode=" + taskCode + "&reportWay=" + reportWay;
                    $("div#childBoxMore").html("");
                    $("div#parentBoxMore").hide();
                    $("div#childBoxMore").show();
                    $("div#childBoxMore").load(url);
                    $("div#childBoxMore").prependTo("#topBoxMore");
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

    return {
        conditionSearch: conditionSearch,
        conditionReset: conditionReset,
        dataDetail: dataDetail,
        goBack: goBack,
        dealLog: dealLog,
        wglData: wglData,
        table: table
    }
}();