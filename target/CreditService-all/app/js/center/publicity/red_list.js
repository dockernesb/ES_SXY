var redList = (function () {
    /*定义一个全局数组，记录列表选中的数据勾线导出*/
    var rowIds = [];

    $("#status").select2({
        placeholder: '全部状态',
        minimumResultsForSearch: -1,
        language: 'zh-CN'
    });
    $("#status").val(null).trigger('change');
    resizeSelect2($("#status"));

    var startDate = {
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
            endDate.min = datas; // 开始日选好后，重置结束日的最小日期
            endDate.start = datas // 将结束日的初始值设定为开始日
        }
    };
    var endDate = {
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
            startDate.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };
    laydate(startDate);
    laydate(endDate);

    var table = $('#redGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/center/publicity/getRedList.action",
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
                "data": "JGQC",
                "render": function (data, type, row) {
                    var str = "";
                    if (!isNull(data)) {
                        str = "<a href='javascript:void(0);' onclick='redList.showDetail(\"" + row.ID + "\")'>" + data + "</a>";
                    }
                    return str;
                }
            }, {
                "data": "ZZJGDM",
                "visible": false
            }, {
                "data": "GSZCH",
                "visible": false
            }, {
                "data": "TYSHXYDM"
            }, {
                "data": "RYMC"
            }, {
                "data": "TGRQ"
            }, {
                "data": "BMMC"
            }, {
                "data": "GSJZQ"
            }, {
                "data": "STATUS",
                "render": function (data, type, row) {
                    if (data == 1) {
                        return "待公示";
                    } else if (data == 2) {
                        return "公示中";
                    } else if (data == 3) {
                        return "已公示";
                    }
                    return "";
                }
            }, {
                "data": null,
                "render": function (data, type, row) {
                    var opts = "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='redList.showDetail(\"" + row.ID + "\")'>查看</a>";
                    if (row.STATUS == 1) {
                        opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='redList.changeRedStatus(\"" + row.ID + "\", \"2\")'>开始公示</a>";
                    } else if (row.STATUS == 2) {
                        opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='redList.changeRedStatus(\"" + row.ID + "\", \"3\")'>停止公示</a>";
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
                    log("colum");
                    log(column);
                    column.visible(!column.visible());
                });
            },
            drawCallback: function (settings) {
                $('#redGrid .checkall').iCheck('uncheck');
                $('#redGrid .checkall, #redGrid tbody .icheck').iCheck({
                    labelHover: false,
                    cursor: true,
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });

                // 列表复选框选中取消事件
                var checkAll = $('#redGrid .checkall');
                var checkboxes = $('#redGrid tbody .icheck');
                checkAll.on('ifChecked ifUnchecked', function (event) {
                    if (event.type == 'ifChecked') {
                        checkboxes.iCheck('check');
                        $('#redGrid tbody tr').addClass('active');
                    } else {
                        checkboxes.iCheck('uncheck');
                        $('#redGrid tbody tr').removeClass('active');
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
                $('#redGrid tbody tr').on('click', function () {
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
    function changeRedStatus(id, status) {
        var tips = status == 2 ? "确认开始公示吗？" : "确认停止公示吗？";
        layer.confirm(tips, {
            icon: 3
        }, function (index) {
            loading();
            $.post(CONTEXT_PATH + "/center/publicity/changeRedStatus.action", {
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

    // 显示红榜详情
    function showDetail(id) {
        loading();
        $.getJSON(CONTEXT_PATH + "/center/publicity/getDetailRedById.action", {
            id: id
        }, function (data) {
            loadClose();
            var detail = data;
            $.each($("span.text"), function (i, obj) {
                var id = $(obj).attr("id");
                var text = detail[id] || "&nbsp;";
                $(obj).html(text);
                $(obj).attr("title", text);
            });

            $.openWin({
                title: '社会法人诚实守信红名单信息',
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


    // 查询按钮
    function conditionSearch() {
        rowIds = [];//清空选中的数据
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["qymc"] = $.trim($('#qymc').val());

            data["gszch"] = $.trim($('#gszch').val());

            data["zzjgdm"] = $.trim($('#zzjgdm').val());

            data["tyshxydm"] = $.trim($('#tyshxydm').val());

            data["tgbm"] = $.trim($('#tgbm').val());

            data["startDate"] = $.trim($('#startDate').val());

            data["endDate"] = $.trim($('#endDate').val());

            data["status"] = $.trim($('#status').val());

            table.ajax.reload();
        }
    }

    $("#exportResult").click(function () {
        exportResult();
    });

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
                document.location = CONTEXT_PATH + "/center/publicity/exportDetailRed.action?rowIds=" + rowIds;
            });
        } else {
            layer.confirm('确定要导出全部数据记录吗？', {}, function () {

                layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});

                var _qymc = $.trim($('#qymc').val());
                var _gszch = $.trim($('#gszch').val());
                var _zzjgdm = $.trim($('#zzjgdm').val());
                var _tyshxydm = $.trim($('#tyshxydm').val());
                var _tgbm = $.trim($('#tgbm').val());
                var _startDate = $.trim($('#startDate').val());
                var _endDate = $.trim($('#endDate').val());
                var _status = $.trim($('#status').val());
                var url = CONTEXT_PATH + "/center/publicity/exportDetailRed.action"

                var _form = $("<form></form>", {
                    'id': 'importExcel',
                    'method': 'post',
                    'action': url,
                    'target': "_self",
                    'style': 'display:none'
                }).appendTo($('body'));


                // 将隐藏域加入表单
                //企业名称
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'qymc',
                    'value': _qymc
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'gszch',
                    'value': _gszch
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'zzjgdm',
                    'value': _zzjgdm
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'tyshxydm',
                    'value': _tyshxydm
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'tgbm',
                    'value': _tgbm
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'startDate',
                    'value': _startDate
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'endDate',
                    'value': _endDate
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': '_endDate',
                    'value': _endDate
                }));
                _form.append($("<input>", {
                    'type': 'hidden',
                    'name': 'status',
                    'value': _status
                }));

                _form.trigger('submit');

            });
        }


    }


    // 重置
    function conditionReset() {
        resetSearchConditions('#qymc,#gszch,#zzjgdm,#tyshxydm,#tgbm,#startDate,#endDate,#status');
        resetDate(startDate, endDate);
    }

    return {
        "showDetail": showDetail,
        "changeRedStatus": changeRedStatus,
        "conditionSearch": conditionSearch,
        "conditionReset": conditionReset
    };

})();
