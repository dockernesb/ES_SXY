var licensingList = (function () {
    /*定义一个全局数组，记录列表选中的数据勾线导出*/
    var rowIds = [];
    $("#status").select2({
        placeholder: '全部状态',
        minimumResultsForSearch: -1,
        language: 'zh-CN'
    });
    $("#status").val(null).trigger('change');
    resizeSelect2($("#status"));

    var start = {
        elem: '#startDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        min: '1900-01-01', // 最小日期
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
        max: '2099-12-30', // 最大日期
        min: '1900-01-01', // 最小日期
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#endDate', datas);
            start.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };

    var publicityStartDate = {
        elem: '#publicityStartDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        min: '1900-01-01', // 最小日期
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#publicityStartDate', datas);
            publicityEndDate.min = datas; // 开始日选好后，重置结束日的最小日期
            publicityEndDate.start = datas // 将结束日的初始值设定为开始日
        }
    };
    var publicityEndDate = {
        elem: '#publicityEndDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        min: '1900-01-01', // 最小日期
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#publicityEndDate', datas);
            publicityStartDate.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);
    laydate(publicityStartDate);
    laydate(publicityEndDate);

    var table = $('#licensingGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/center/publicity/getLicensingList.action",
                type: 'post'
            },
            serverSide: true,// 如果是服务器方式，必须要设置为true
            processing: true,// 设置为true,就会有表格加载时的提示
            lengthChange: true,// 是否允许用户改变表格每页显示的记录数
            pageLength: 10,
            searching: false,// 是否允许Datatables开启本地搜索
            paging: true,
            ordering: false,
            autoWidth: false,
            columns: [{
                "data": "", // checkBox
                render: function (data, type, full) {
                    return '<input type="checkbox" name="checkThis" class="icheck">';
                }
            }, {
                "data": "XMMC",
                "visible": true
            }, {
                "data": "XZXDRMC",
                "render": function (data, type, row) {
                    var str = "";
                    if (!isNull(data)) {
                        str = "<a href='javascript:void(0);' onclick='licensingList.showDetail(\"" + row.ID + "\")'>" + data + "</a>";
                    }
                    return str;
                }
            }, {
                "data": "TYSHXYDM",
                "visible": false
            }, {
                "data": "FDDBRSFZH",
                "visible": false
            }, {
                "data": "SPLB"
            }, {
                "data": "XKSXQ"
            }, {
                "data": "XKJG"
            }, {
                "data": "BMMC"
            }, {
                "data": "CREATE_TIME"
            }, {
                "data": "STATUS",
                "render": function (data, type, row) {
                    if (data == 0) {
                        return "正常";
                    } else if (data == 1) {
                        return "撤销";
                    } else if (data == 2) {
                        return "异议";
                    } else if (data == 3) {
                        return "其他";
                    } else {
                        return "未知";
                    }
                }
            }, {
                "data": null,
                "render": function (data, type, row) {
                    var opts = "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='licensingList.showDetail(\"" + row.ID + "\")'>查看</a>";
                    if (row.STATUS == 1) {
                        opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='licensingList.changeLicensingStatus(\"" + row.ID + "\", \"0\")'>恢复公示</a>";
                    } else if (row.STATUS == 0) {
                        opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='licensingList.changeLicensingStatus(\"" + row.ID + "\", \"1\")'>取消公示</a>";
                    }
                    return opts;
                }
            }],
            initComplete: function (settings, data) {
                var columnTogglerContent = $('#columnTogglerContent').clone();
                $(columnTogglerContent).removeClass('hide');
                var columnTogglerDiv = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
                $(columnTogglerDiv).html(columnTogglerContent);

                $(columnTogglerContent).find('input[type="checkbox"]').iCheck({
                    labelHover: false,
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });

                // 显示隐藏列
                $(columnTogglerContent).find('input[type="checkbox"]').on('ifChanged', function (e) {
                    e.preventDefault();
                    // Get the column API object
                    var column = table.column($(this).attr('data-column'));
                    // Toggle the visibility
                    column.visible(!column.visible());
                });
            },
            drawCallback: function (settings) {
                $('#licensingGrid .checkall').iCheck('uncheck');
                $('#licensingGrid .checkall, #licensingGrid tbody .icheck').iCheck({
                    labelHover: false,
                    cursor: true,
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });

                // 列表复选框选中取消事件
                var checkAll = $('#licensingGrid .checkall');
                var checkboxes = $('#licensingGrid tbody .icheck');
                checkAll.on('ifChecked ifUnchecked', function (event) {
                    if (event.type == 'ifChecked') {
                        checkboxes.iCheck('check');
                        $('#licensingGrid tbody tr').addClass('active');
                    } else {
                        checkboxes.iCheck('uncheck');
                        $('#licensingGrid tbody tr').removeClass('active');
                    }
                });
                checkboxes.on('ifChanged', function (event) {
                    if (checkboxes.filter(':checked').length == checkboxes.length) {
                        checkAll.prop('checked', 'checked');
                    } else {
                        checkAll.removeProp('checked');
                    }
                    checkAll.iCheck('update');
                    var selectedData = table.rows($(this).closest('tr')).data();
                    if ($(this).is(':checked')) {
                        $(this).closest('tr').addClass('active');
                        if (!rowIds.contains(selectedData[0].ID)) {
                            rowIds.push(selectedData[0].ID)
                        }
                    } else {
                        rowIds.remove(selectedData[0].ID);
                        $(this).closest('tr').removeClass('active');
                    }
                });

                // 添加行选中点击事件
                $('#licensingGrid tbody tr').on('click', function () {
                    $(this).toggleClass('active');
                    if ($(this).hasClass('active')) {
                        $(this).find('.icheck').iCheck('check');
                    } else {
                        $(this).find('.icheck').iCheck('uncheck');
                    }
                });
            }
        });

    // 开始|停止公示
    function changeLicensingStatus(id, status) {
        var tips = status == 0 ? "确认恢复公示吗？" : "确认取消公示吗？";
        layer.confirm(tips, {
            icon: 3
        }, function (index) {
            loading();
            $.post(CONTEXT_PATH + "/center/publicity/changeLicensingStatus.action", {
                "id": id,
                "status": status
            }, function (data) {
                loadClose();
                if (!data.result) {
                    $.alert('操作失败!', 2);
                } else {
                    layer.close(index);
                    $.alert('操作成功!', 1);
                    conditionSearch();
                }
            }, "json");
        });
    }

    // 显示行政许可详情
    function showDetail(id) {
        loading();
        $.getJSON(CONTEXT_PATH + "/center/publicity/getDetailLicensingById.action", {
            id: id
        }, function (data) {
            loadClose();
            var detail = data;
            $.each($("span.text"), function (i, obj) {
                var id = $(obj).attr("id");
                var text = detail[id] || "&nbsp;";
                if (id == "DQZT") {
                    switch (text) {
                        case '0' :
                            text = '正常';
                            break;
                        case '1' :
                            text = '撤销';
                            break;
                        case '2' :
                            text = '异议';
                            break;
                        case '3' :
                            text = '其他';
                            break;
                        default :
                            text = '未知';
                            break;
                    }
                }
                if (id == "SYFW") {//信息使用范围（公示，内部共享，授权查询）
                    switch (text) {
                        case '0' :
                            text = '公示';
                            break;
                        case '1' :
                            text = '内部共享';
                            break;
                        case '2' :
                            text = '授权查询';
                            break;
                        default :
                            text = '未知';
                            break;
                    }
                }


                $(obj).html(text);
                $(obj).attr("title", text);
            });

            $.openWin({
                title: '行政许可信息',
                content: $("#details"),
                btnAlign: 'c',
                btn: ["关闭"],
                area: ['600px', '520px'],
                yes: function (index, layero) {
                    layer.close(index);
                }
            });
        })
    }

    $("#startPublicity").click(function () {
        publicity(true);
    });
    $("#cancelPublicity").click(function () {
        publicity(false);
    });
    $("#exportResult").click(function () {
        exportResult();
    });

    function publicity(isStart) {
        var msg = "确认要公示这些数据吗？";
        if (!isStart) {
            msg = "确认要取消公示这些数据吗？";
        }
        var rows = new Array();
        var selectedRows = table.rows('.active').data();
        $.each(selectedRows, function (i, selectedRowData) {
            rows.push(selectedRowData);
        });

        // check
        if (isNull(rows) || rows.length == 0) {
            $.alert('请勾选至少一条记录！');
            return;
        }

        var dataArray = new Array();
        $.each(rows, function (i, row) {
            dataArray.push(row.ID);
        });

        layer.confirm(msg, {
            icon: 3
        }, function (index) {
            loading();
            $.post(CONTEXT_PATH + "/center/publicity/batchChangeLicensingStatus.action", {
                ids: JSON.stringify(dataArray),
                isStart: isStart
            }, function (data) {
                loadClose();
                if (!data.result) {
                    $.alert('操作失败!', 2);
                } else {
                    layer.close(index);
                    $.alert('操作成功!', 1);
                    table.ajax.reload();
                }
            }, "json");
        });

    }

    // 导出查询结果
    function exportResult() {

        var rows = new Array();
        var selectedRows = table.rows().data();
        $.each(selectedRows, function (i, selectedRowData) {
            rows.push(selectedRowData);
        });

        // check
        if (isNull(rows) || rows.length == 0) {
            $.alert('无数据，不可导出！');
            return;
        }
        if (rowIds.length !== 0) {
            layer.confirm('确定按照所有勾选数据进行导出吗？', {}, function () {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                document.location = CONTEXT_PATH + "/center/publicity/exportLicensingResult.action?rowIds=" + rowIds;
            });

        } else {
            layer.confirm('确定要导出全部数据记录吗？', {}, function () {
                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
                document.location = CONTEXT_PATH + "/center/publicity/exportLicensingResult.action";
            });
        }

    }

    // 查询按钮
    function conditionSearch() {
        rowIds = [];//清空选中的数据
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["xzxdr"] = $.trim($('#xzxdr').val());
            data["xkjg"] = $.trim($('#xkjg').val());
            data["bmmc"] = $.trim($('#bmmc').val());
            data["startDate"] = $.trim($('#startDate').val());
            data["endDate"] = $.trim($('#endDate').val());
            data["publicityStartDate"] = $.trim($('#publicityStartDate').val());
            data["publicityEndDate"] = $.trim($('#publicityEndDate').val());
            data["status"] = $.trim($('#status').val());
            table.ajax.reload();
        }
    }

    // 重置
    function conditionReset() {
        resetSearchConditions('#xzxdr,#startDate,#endDate,#xkjg,#bmmc,#publicityStartDate,#publicityEndDate,#status');
        resetDate(start, end, publicityStartDate, publicityEndDate);
    }

    return {
        "showDetail": showDetail,
        "changeLicensingStatus": changeLicensingStatus,
        "conditionSearch": conditionSearch,
        "conditionReset": conditionReset
    };

})();
