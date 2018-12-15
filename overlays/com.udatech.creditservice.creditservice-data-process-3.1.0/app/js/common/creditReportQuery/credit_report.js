(function () {
    var themeInfoJson = $.evalJSON(themeInfo);

    // 初始化一级资源对应的表格列头
    $.each(themeInfoJson, function (i, theme) {// 一级资源
        var detailHtml = '';
        $.each(theme.children, function (j, themeTwo) {// 二级资源
            detailHtml += '<h4 class="tableTitle">' + themeTwo.text + '</h4>';
            detailHtml += '<table class="table table-striped table-hover table-bordered" id="grid_' + themeTwo.id + '_' + j + '">';
            detailHtml += '<thead><tr class="heading">';

            // 加载表格列头信息
            detailHtml += '<th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th>';
            $.each(themeTwo.columns, function (k, column) {// 二级资源列字段信息
                detailHtml += '<th>' + column.columnAlias + '</th>';
            });
            detailHtml += '</tr></thead></table>';
        });
        $('#' + theme.id + '_detailDiv').html(detailHtml);
    });

    // 初始化一级资源对应的表格内容
    $.each(themeInfoJson, function (i, theme) {// 一级资源
        var detailDivId = theme.id + '_detailDiv';
        var detailHtml = '';
        $.each(theme.children, function (j, themeTwo) {// 二级资源
            // 表格数据
            var gridData = themeTwo.data;
            var columns = new Array();
            columns.push({
                "data": null,// checkBox
                "render": function (data, type, row) {
                    return '<input type="checkbox" name="checkThis" class="icheck">';
                }
            });
            $.each(themeTwo.columns, function (k, column) {// 二级资源列字段信息
                columns.push({
                    "data": column.columnName
                });
            });

            // 加载表格内容信息
            var tableId = '#grid_' + themeTwo.id + '_' + j;
            var table = $(tableId).DataTable({// 创建一个Datatable
                dom: '<t>r<"tfoot"lp>',
                lengthChange: true,// 是否允许用户改变表格每页显示的记录数
                pageLength: 10,
                searching: false,// 是否允许Datatables开启本地搜索
                ordering: false,
                autoWidth: false,
                paging: true, // 禁用分页
                data: gridData,
                // 使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
                // data 这里是固定不变的
                columns: columns,
                createdRow: function (row, data, dataIndex) {
                    if (data.STATUS == '2') { // 已修复的数据，特殊显示,红色
                        $(row).css({
                            'background-color': '#e35b5a',
                            'color': '#fff'
                        });
                    }
                    if (data.isObjection == "true" || data.isObjection) { // 有争议的数据，特殊显示，黄色
                        $(row).css({
                            'background-color': '#daae2b',
                            'color': '#fff'
                        });
                    }

                    if (data.isRepair == "true" || data.isRepair) { // 修复中的数据，特殊显示，紫色
                        $(row).css({
                            'background-color': '#884898',
                            'color': '#fff'
                        });
                    }
                },
                initComplete: function (settings, ajaxResultJson) {
                    // ajaxResultJson 如果使用ajax选项来获取数据，则得到服务器返回的数据，否则是 undefined
                    $.each(table.data(), function (rowIndex, rowData) {
                        // 显示默认选中数据
                        var row = table.row(rowIndex).node();
                        if (rowData.checked == true) {
                            $(row).find('.icheck').iCheck('check');
                        }

                        if (rowData.STATUS == '2') { // 已修复的数据，禁止选中
                            $(row).find('.icheck').iCheck('disable');
                        }

                    });
                },
                drawCallback: function (settings) {
                    $(tableId + ' .checkall, ' + tableId + ' tbody .icheck').iCheck({
                        labelHover: false,
                        cursor: true,
                        checkboxClass: 'icheckbox_square-blue',
                        radioClass: 'iradio_square-blue',
                        increaseArea: '20%'
                    });

                    // 列表复选框选中取消事件
                    var checkAll = $(tableId + ' .checkall');
                    var checkboxes = $(tableId + ' tbody .icheck');
                    checkAll.on('ifChecked ifUnchecked', function (event) {
                        $.each(table.columns({page: 'current'}).data()[0], function (rowIndex, rowData) {
                            var row = table.row(rowIndex).node();
                            if (event.type == 'ifChecked') {
                                // 添加字段选中记录
                                if (rowData.STATUS != '2') { // 已修复的数据，禁止选中
                                    $(row).find('.icheck').iCheck('check');
                                    // 将数据设置为选中状态
                                    setCheckedStatus(rowData, true);
                                }
                            } else {
                                $(row).find('.icheck').iCheck('uncheck');
                                // 将数据设置为未选中状态
                                setCheckedStatus(rowData, false);
                            }
                        });

                    });
                    checkboxes.on('ifChanged', function (event) {
                        if (checkboxes.filter(':checked').length == checkboxes.length) {
                            checkAll.prop('checked', 'checked');
                        } else {
                            checkAll.removeProp('checked');
                        }
                        checkAll.iCheck('update');

                        if ($(this).is(':checked')) {
                            // $(this).closest('tr').addClass('active');
                            // 将数据设置为选中状态
                            setCheckedStatus(table.row($(this).closest('tr')).data(), true);
                        } else {
                            // $(this).closest('tr').removeClass('active');
                            // 将数据设置为未选中状态
                            setCheckedStatus(table.row($(this).closest('tr')).data(), false);
                        }
                    });
                }
            });

        });
    });

    // 设置选中状态
    function setCheckedStatus(rowData, flag) {
        $.each(themeInfoJson, function (i, theme) {// 一级资源
            $.each(theme.children, function (j, themeTwo) {// 二级资源
                if (rowData.themeId == themeTwo.id) {
                    $.each(themeTwo.data, function (k, item) {
                        if (item.UUID == rowData.UUID) {
                            item.checked = flag;
                            return;
                        }
                    });
                }
            });
        });
    }

    // 生成信用报告
    function generateReport() {
        var url = ctx + "/reportQuery/generateReportView.action";
        var body = {
            params: params,
            businessId: businessId,
            templateId: templateId,
            themeInfo: $.toJSON(themeInfoJson)
        };

        loading();// 加载层
        $.post(url, body, function (data) {
            loadClose();
            if (data.result) {
                $.alert('审核成功！', 1, function () {
                    // 报告生成成功，新窗口直接打开生成过的报告页面
                    if (isAcrobatPluginInstall()) {
                        var url = ctx + '/reportQuery/viewReport.action?xybgbh=' + data.message;
                        var newwin = window.open(url);
                        newwin.focus();
                        // 添加信用报告预览日志
                        addPreViewLog(businessId);
                    } else {
                        $.alert("未安装Adobe Reader，无法预览！");
                    }

                    // 报告生成成功，返回审核列表页
                    $(".backBtn").trigger("click");
                });
            } else {
                $.alert('审核失败！', 2);
            }
        }, 'json');
    }

    // 上一步
    $('#preStepBtn').on('click', function (id) {
        $("#applyDetailDiv,#mainListDiv,#auditTwoDiv").hide();
        $("div#auditOneDiv").show();
        var selectArr = recordSelectNullEle();
        $("div#auditOneDiv").prependTo('#topDiv');
        callbackSelectNull(selectArr);
        resetIEPlaceholder();
    });

    // 保存审核信息
    function saveReportAudit(status) {
        $.post(ctx + "/creditReport/reportApplyAudit.action", {
            "id": businessId,
            "status": status,
            "zxshyj": zxshyj
        }, function (result) {
            if (result.result) {
                if (status == 1) {
                    // 审核通过，生成报告
                    generateReport();
                } else {
                    $.alert('审核成功！', 1, function () {
                        $(".backBtn").trigger("click");// 审核不通过，返回审核列表页
                    });
                }
            } else {
                $.alert(result.message, 2);
            }
        }, "json");
    }

    $("#shtgBtn").click(function () {
        layer.confirm("确认审核通过吗？", {
            icon: 3,
        }, function (index) {
            saveReportAudit(1);
        });
    });

    $("#shbtgBtn").click(function () {
        layer.confirm("确认审核不通过吗？", {
            icon: 3,
        }, function (index) {
            saveReportAudit(2);
        });
    });

    // 返回列表页
    $(".backBtn").click(function () {
        $("#applyDetailDiv,#auditOneDiv,#auditTwoDiv").hide();
        $("div#mainListDiv").show();
        var selectArr = recordSelectNullEle();
        $("div#mainListDiv").prependTo('#topDiv');
        callbackSelectNull(selectArr);
        var activeIndex = recordDtActiveIndex(centerReport.table);
        centerReport.table.ajax.reload(function () {
            callbackDtRowActive(centerReport.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
        resetIEPlaceholder();
    });
})();