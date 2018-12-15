var govTask = function () {
    var versionId = $.trim($("#versionId").val()); //用于存放第一个查询的版本ID
    $("#status").select2({
        placeholder: '全部状态',
        minimumResultsForSearch: -1
    });
    $('#status').val(null).trigger("change");
    resizeSelect2('#status');

    // 初始化查询版本下拉，默认要选中一个版本
    $.getJSON(ctx + "/dp/task/getVersionSelect.action", function (result) {
        $("#version").select2({
            language: 'zh-CN',
            allowClear: false,
            data: result
        });
        resizeSelect2('#version');
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });

    getTaskStatusCount();
    // 获取各状态的任务数量
    function getTaskStatusCount() {
        $.getJSON(CONTEXT_PATH + '/dp/task/getTaskStatusCount.action',{
            tableName : $.trim($("#tableName").val()),
            status : $.trim($("#status").val()),
            version : isNull($("#version").val()) ? versionId : $("#version").val()
        }, function (data) {
            if (data) {
                var sbzs = data.sbzs || '0';
                var sbrks = data.sbrks || '0';
                var sbgxs = data.sbgxs || '0';
                var sbyws = data.sbyws || '0';
                var sbywzs = data.sbywzs || '0';
                var wsbsjl = data.wsbsjl || '0';
                var sbsjl = data.sbsjl || '0';

                if (String(wsbsjl).length > 4 || String(sbsjl).length > 4) {
                    $('#wsbsjl').css('font-size', '17px');
                }
                if (String(sbyws).length > 4 || String(sbywzs).length > 4) {
                    $('#sbyws').css('font-size', '17px');
                }
                $('#wsbsjl').html('<span style="color: red;">' + wsbsjl + '</span>/' + sbsjl + '');
                $('#sbyws').html('<span style="color: red;">' + sbyws + '</span>/' + sbywzs + '');
                $('#sbzs').html(sbzs);// 上报量
                $('#sbgxs').html(sbgxs);// 更新量
                $('#sbrks').html(sbrks);// 入库量
            }
        });
    }

    // 创建一个Datatable
    var table = $('#taskGrid').DataTable({
        ajax: {
            url: ctx + "/dp/task/list.action",
            type: "post",
            data: {
                deptId: $('#deptId').val(),
                version : versionId
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
            "className": 'details-control',
            "orderable": false,
            "data": null,
            "defaultContent": '<div class="icon">&nbsp;</div>'
        }, {
            "data": "NAME",
            "render": function (value, type, row) {
                var str = '';
                str += '<a href="javascript:void(0);" onclick="govTask.toSchemaDetail(\'' + row.ID + '\',\'' + row.TABLE_VERSION_ID + '\',this);">' + row.NAME + '</a>';
                return str;
            }
        }, {
            "data": "TASK_PERIOD",
            "render": periodFormatter
        }, {
            "data": "ALL_SIZE",
            "render": function (value, type, row) {
                var str = value;
                if (isNull(value)) {
                    str = 0;
                }
                return str;
            }
        }, {
            "data": "YIWEN_SIZE",
            "render": function (value, type, row) {
                return '<span style="color:red;">' + value + '</span>/' + row.ALL_YIWEN_SIZE;
            }
        }, {
            "data": "GENGXIN_SIZE",
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return 0;
                }
                return value;
            }
        }, {
            "data": "YOUXIAO_SIZE",// 入库量=有效量
            "render": function (value, type, row) {
                if (row.ALL_SIZE == 0 && row.YIWEN_SIZE == 0) {
                    return 0;// 该判断匹配无数据上报时，有效量直接展示为0
                }

                if (isNull(value)) {
                    return 0;
                }
                return value;
            }
        }, {
            "data": "WGL_SIZE",
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return 0;
                }
                return value;
            }
        }, {
            "data": "LAST_TIME",
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return '--';
                }
                return value;
            }
        }, {
            "data": "ENDTIME",
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return '--';
                } else {
                    return value.substr(0, 10) + ' 23:59:59';
                }
            }
        }, {
            "data": "STATUS",
            "render": function (value, type, row) {
                if (value == '超时') {
                    return '<span style="color:red;">超时</span>';
                }
                return value;
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
            $(row).children('td').eq(3).attr('style', 'text-align: right;');
            $(row).children('td').eq(4).attr('style', 'text-align: right;');
            $(row).children('td').eq(5).attr('style', 'text-align: right;');
            $(row).children('td').eq(6).attr('style', 'text-align: right;');
            $(row).children('td').eq(7).attr('style', 'text-align: right;');
        }
    });

    // 行明细点击事件
    $('#taskGrid tbody').on('click', 'td.details-control', function () {
        var tr = $(this).closest('tr');
        // 关闭其他已展开的行
        $.each($(tr).siblings(), function (i, item) {
            $(item).removeClass('shown');
            table.row($(item)).child.hide();
        });

        var row = table.row(tr);
        if (row.child.isShown()) { // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        } else { // Open this row
            row.child(showRowDetail(row.data())).show();
            tr.addClass('shown');
        }
    });

    // 显示行明细
    function showRowDetail(rowData) {
        var _html = '';
        $.ajax({
            type: "POST",
            dataType: 'json',
            url: ctx + '/dp/task/hisList.action',
            data: {
                versionId: rowData.TABLE_VERSION_ID,
                deptId: rowData.DEPT_ID,
                logicTableId: rowData.ID,
                length: 5
            },
            async: false,
            success: function (result) {
                _html = '<table class="table table-bordered"><thead><tr>';
                _html += '<th style="width: 130px;">上报批次编号 </th>';
                _html += '<th style="text-align: center">上报量</th>';
                _html += '<th style="text-align: center">疑问量</th>';
                _html += '<th style="text-align: center">更新量</th>';
                _html += '<th style="text-align: center">入库量</th>';
                _html += '<th style="text-align: center;width: 60px;">未关联量</th>';
                _html += '<th style="width: 140px;">上报时间</th>';
                _html += '<th style="width: 90px;">处理流程</th>';
                _html += '<th style="width: 60px;">上报状态</th>';
                _html += '</tr></thead>';
                _html += '<tbody>';
                $.each(result.data, function (i, item) {
                    _html += '<tr>';

                    var imgUrl = ctx + '/app/images/dataReport/';
                    var _title = '';
                    if (item.REPORT_WAY == '0') {
                        imgUrl += 'hand.png';
                        _title = '手动录入';
                    }
                    if (item.REPORT_WAY == '1') {
                        imgUrl += 'file.png';
                        _title = '文件上传';
                    }
                    if (item.REPORT_WAY == '2') {
                        imgUrl += 'db.png';
                        _title = '数据库上报';
                    }
                    if (item.REPORT_WAY == '3') {
                        imgUrl += 'ftp.png';
                        _title = 'FTP上报';
                    }
                    if (item.REPORT_WAY == '4') {
                        imgUrl += 'webservice.png';
                        _title = '接口上报';
                    }
                    _html += '<td><img title="' + _title + '" src="' + imgUrl + '"> ' + item.TASK_CODE + '</td>';

                    _html += '<td style="text-align: right">' + item.ALL_SIZE + '</td>';
                    _html += '<td style="text-align: right"><span style="color:red;">' + item.YIWEN_SIZE + '</span></td>';
                    if (isNull(item.GENGXIN_SIZE)) {
                        _html += '<td style="text-align: right">0</td>';
                    } else {
                        _html += '<td style="text-align: right">' + item.GENGXIN_SIZE + '</td>';
                    }

                    if (isNull(item.YOUXIAO_SIZE)) {
                        _html += '<td style="text-align: right">0</td>';
                    } else {
                        _html += '<td style="text-align: right">' + item.YOUXIAO_SIZE + '</td>';
                    }
                    _html += '<td style="text-align: right">' + item.WGL_SIZE + '</td>';

                    _html += '<td>' + item.CREATE_DATE + '</td>';

                    // 完成节点
                    var _width = '0%';
                    var _title = '';
                    if (item.POINT_STATUS == '0') {
                        _title = '未开始';
                    } else if (item.POINT_STATUS == '1') {
                        _width = '34%';
                        _title = '1 of 3  数据上报';
                    } else if (item.POINT_STATUS == '2') {
                        _width = '67%';
                        _title = '2 of 3  规则校验';
                    } else if (item.POINT_STATUS == '3') {
                        _width = '100%';
                        _title = '3 of 3  关联入库';
                    }
                    _html += '<td><div title="' + _title + '" class="progress progress-striped" role="progressbar" style="margin-bottom: 0px;">';
                    _html += '<div class="progress-bar progress-bar-success" style="width: ' + _width + ';"></div>';
                    _html += '</div></td>';

                    if (item.TABLE_STATUS == '超时') {
                        _html += '<td><span style="color:red;">超时</span></td>';
                    } else {
                        _html += '<td>正常</td>';
                    }
                    _html += '</tr>';
                });
                _html += '</tbody></table>';
                _html += '<a href="javascript:govTask.showMore(\'' + rowData.NAME + '\',\'' + rowData.ID + '\',\'' + rowData.DEPT_ID + '\',\'' + rowData.TABLE_VERSION_ID + '\')" style="float:right;">更多信息>></a>';
            }
        });
        return _html;
    }

    // 显示更多信息
    function showMore(name, id, deptId, versionId) {
        var url = ctx + '/dp/task/toMore.action';
        $("div#childBox").html("");
        $("div#parentBox").hide();
        $("div#childBox").show();
        $("div#childBox").load(url, {
            deptId: deptId,
            logicTableId: id,
            name: name,
            versionId : versionId
        });
        $("div#childBox").prependTo("#topBox");
        resetIEPlaceholder();
    }

    // 征集周期格式化显示
    function periodFormatter(value, type, row) {
        if (value == '0') {
            return '周';
        } else if (value == '1') {
            return '月';
        } else if (value == '2') {
            return '季度';
        } else if (value == '3') {
            return '半年';
        } else if (value == '4') {
            return '年';
        } else if (value == '5') {
            return '天';
        } else if (value == '6') {
            return '不限周期';
        }else {
            return '';
        }
    }

    // 上报方式格式化显示
    function reprotWayFormatter(value) {
        if (value == '0') {
            return '手动录入';
        } else if (value == '1') {
            return '文件上传';
        } else if (value == '2') {
            return '数据库上报';
        } else if (value == '3') {
            return 'FTP上报';
        } else if (value == "4") {
            return "接口上报";
        } else {
            return '';
        }
    }

    // 按条件查询
    function conditionSearch(type) {
        getTaskStatusCount();
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["version"] = $.trim($("#version").val());
            data["tableName"] = $.trim($("#tableName").val());
            data["status"] = $.trim($("#status").val());
            data["deptId"] = $.trim($("#deptId").val());
            table.ajax.reload(null, type == 1 ? true : false);// 刷新列表还保留分页信息
        }
    }

    // 重置查询条件
    function conditionReset() {
        $("#version").val(versionId).trigger("change");
        resetSearchConditions('#tableName,#status');
    }

    // 上报/维护数据/疑问数据
    function reportedData(showErrorData) {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var url = ctx + '/dp/dataReport/dataReport.action';
            $("div#childBox").html("");
            $("div#parentBox").hide();
            $("div#childBox").show();
            $("div#childBox").load(url, {
                deptId: row.DEPT_ID,
                logicTableId: row.ID,
                beginTime: row.BEGINTIME,
                tableStatus: row.STATUS,
                showErrorData: showErrorData,
                queryType: 1,
                versionId : $("#version").val()
            });
            $("div#childBox").prependTo("#topBox");
            resetIEPlaceholder();
        } else {
            $.alert('请先选择要操作的目录。');
        }
    }

    // 无数据上报
    function noData() {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];

            layer.confirm('您确认无数据上报吗？', {
                icon: 3
            }, function (idx) {
                loading();
                $.post(ctx + "/dp/task/noData.action", {
                    deptId: row.DEPT_ID,
                    tableStatus: row.STATUS,
                    logicTableId: row.ID
                }, function (data) {
                    loadClose();
                    if (!data.result) {
                        $.alert('操作失败！', 2);
                    } else {
                        conditionSearch();
                        $.alert('操作成功！', 1);
                        layer.close(idx);
                    }
                }, "json");
            });
        } else {
            $.alert('请先选择要操作的目录。');
        }
    }


    // 未关联数据
    function wglData() {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            $.post(ctx + "/dp/task/isHasRelation.action?logicTableId=" + row.ID, function (result) {
                if (result == "0") {
                    var url = ctx + '/dp/task/toNoRelatedDetail.action?pageType=0&logicTableId=' + row.ID;
                    $("div#childBox").html("");
                    $("div#childBox").load(url);
                    $("div#parentBox").hide();
                    $("div#childBox").show();
                    $("div#childBox").prependTo("#topBox");
                    resetIEPlaceholder();
                } else if (result == "1") {
                    $.alert('机构设立登记表数据为本地法人基础数据，不涉及未关联数据');
                } else if (result == "2") {
                    $.alert('该目录未产生未关联数据!');
                }
            });
        } else {
            $.alert('请先选择要操作的目录。');
        }
    }

    /*----------------------------目录详情----------------------------------*/

    // 目录详情弹框
    function toSchemaDetail(id,versionId) {
        log(versionId);
        $.getJSON(ctx + '/schema/grant/getDetail.action', {
            id: id, //dp_logic_table的ID
            versionId: versionId //目录版本的ID
        }, function (result) {
            var schema = result.schema;
            $('#nameTd').val(schema.name);
            $('#codeTd').val(schema.code);
            $('#rtaskPeriod').val(schema.taskPeriodVo);
            if (!isNull(schema.days)) {
                $('#rdays').val(schema.days + '天');
            }
            $('#rtableDesc').val(schema.tableDesc);

            $("#dataCategory").val(schema.dataCategoryVo);
            var table = $('#schemaTable').DataTable({
                dom: '<t>r<"tfoot"lp>',
                destroy: true,// 如果需要重新加载的时候请加上这个
                lengthChange: false,// 是否允许用户改变表格每页显示的记录数
                searching: false,// 是否允许Datatables开启本地搜索
                ordering: false,
                autoWidth: false,
                paging: false,
                pageLength: 5,
                data: result.data,
                // 使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
                // data 这里是固定不变的
                columns: [{
                    "data": "name"
                }, {
                    "data": "code"
                }, {
                    "data": "type"
                }, {
                    "data": "len"
                }, {
                    "data": "isNullable",
                    "render": nullableFormatter
                }, {
                    "data": "requiredGroup"
                }, {
                    "data": "postil"
                }]
            });
            $.openWin({
                title: '目录详情',
                content: $("#schemaDiv"),
                area: ['900px', '550px'],
                btn: ["关闭"],
                btnAlign: 'r'
            });
        });
    }

    // 格式化必填显示
    function nullableFormatter(data, type, full) {
        if (data === 0) {
            return "是";
        } else {
            return "否";
        }
    }


    return {
        conditionSearch: conditionSearch,
        conditionReset: conditionReset,
        reportedData: reportedData,
        noData: noData,
        wglData: wglData,
        showMore: showMore,
        toSchemaDetail: toSchemaDetail,
        table: table
    }
}();