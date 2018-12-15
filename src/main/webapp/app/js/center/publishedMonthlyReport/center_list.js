var cl = (function () {

    var beginDate;
    var endDate;

    $.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
        // 初始下拉框
        $("#deptId").select2({
            placeholder : '全部部门',
            language : 'zh-CN',
            data : result
        });

        resizeSelect2($("#deptId"));
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });

    var start = {
        elem: '#beginDate',
        format: 'YYYY-MM',
        max: '2099-12', //最大日期
        istime: false,
        istoday: false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose: function(datas){
            laydatePH('#beginDate', datas);
            end.min = datas; //开始日选好后，重置结束日的最小日期
            end.start = datas //将结束日的初始值设定为开始日
        }
    };
    var end = {
        elem: '#endDate',
        format: 'YYYY-MM',
        max: '2099-12',
        istime: false,
        istoday: false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose: function(datas){
            laydatePH('#endDate', datas);
            start.max = datas; //结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);

    //创建一个Datatable
    var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/publishedMonthlyReport/getCenterList.action",
            type: "post"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "month"},
            {"data" : "dept.departmentName"},
            {"data" : "webUrl", "visible" : false},
            {"data" : "xzxkCssl"},
            {"data" : "xzxkBdwgssl"},
            {"data" : "xzxkBssl"},
            {"data" : "xzxkWbssl"},
            {"data" : "xzxkWbsyj"},
            {"data" : "xzcfCssl"},
            {"data" : "xzcfBdwgssl"},
            {"data" : "xzcfBssl"},
            {"data" : "xzcfWbssl"},
            {"data" : "xzcfWbsyj"},
            {"data" : "createTime"},
            {"data" : "createUser", "render": function(data, type, full) {
                if (full.createUser) {
                    if (full.createUser.realName) {
                        return full.createUser.realName;
                    } else {
                        return full.createUser.username;
                    }
                }
                return "";
            }},
            {"data" : "updateTime"},
            {"data" : "updateUser.realName", "render": function(data, type, full) {
                if (full.updateUser) {
                    if (full.updateUser.realName) {
                        return full.updateUser.realName;
                    } else {
                        return full.updateUser.username;
                    }
                }
                return "";
            }}
        ],
        initComplete : function(settings, data) {
            var columnTogglerContent = $('#columnTogglerContent').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(table.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
            $(columnTogglerDiv).html(columnTogglerContent);

            $(columnTogglerContent).find('input[type="checkbox"]').iCheck({
                labelHover : false,
                checkboxClass : 'icheckbox_square-blue',
                radioClass : 'iradio_square-blue',
                increaseArea : '20%'
            });

            // 显示隐藏列
            $(columnTogglerContent).find('input[type="checkbox"]').on('ifChanged', function(e) {
                e.preventDefault();
                // Get the column API object
                var column = table.column($(this).attr('data-column'));
                // Toggle the visibility
                column.visible(!column.visible());
            });
        }
    });

    $('#dataTable tbody').on('click', 'tr', function() {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            table.$('tr.active').removeClass('active');
            $(this).addClass('active');
        }
    });

    function refreshTable(_beginDate, _endDate, deptId) {
        beginDate = _beginDate;
        endDate = _endDate;
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["beginDate"] = beginDate || "";
            data["endDate"] = endDate || "";
            data["dept.id"] = deptId || "";
            table.ajax.reload();
        }
        if (tableSum) {
            var data = tableSum.settings()[0].ajax.data;
            if (!data) {
                data = {};
                tableSum.settings()[0].ajax["data"] = data;
            }
            data["beginDate"] = beginDate || "";
            data["endDate"] = endDate || "";
            data["dept.id"] = deptId || "";
            tableSum.ajax.reload();
        }
    }

    //创建一个Datatable
    var tableSum = $('#dataTableSum').DataTable({
        ajax: {
            url: ctx + "/publishedMonthlyReport/getCenterSumList.action",
            type: "post"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: false,
        pageLength: 10,
        paging: false,
        bInfo: false,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "XZXK_CSSL", "render": function(data, type, full) {
                return data || 0;
            }},
            {"data" : "XZXK_BDWGSSL", "render": function(data, type, full) {
                    return data || 0;
                }},
            {"data" : "XZXK_BSSL", "render": function(data, type, full) {
                    return data || 0;
                }},
            {"data" : "XZXK_WBSSL", "render": function(data, type, full) {
                    return data || 0;
                }},
            {"data" : "XZCF_CSSL", "render": function(data, type, full) {
                    return data || 0;
                }},
            {"data" : "XZCF_BDWGSSL", "render": function(data, type, full) {
                    return data || 0;
                }},
            {"data" : "XZCF_BSSL", "render": function(data, type, full) {
                    return data || 0;
                }},
            {"data" : "XZCF_WBSSL", "render": function(data, type, full) {
                    return data || 0;
                }}
        ]
    });

    $("#exportBtn").click(function() {
        $.post(ctx + "/publishedMonthlyReport/exportList.action", {
            "beginDate" : beginDate,
            "endDate" : endDate
        }, function(json) {
            if (json.result) {
                document.location.href = ctx + "/$_virtual_path_$/" + json.message;
            } else {
                $.alert(json.message || "导出失败！", 2);
            }
        }, "json");
    });

    //	搜索
    function conditionSearch() {
        var beginDate = $.trim($('#beginDate').val());
        var endDate = $.trim($('#endDate').val());
        var deptId = $('#deptId').val();
        refreshTable(beginDate, endDate, deptId);
    }

    //		重置
    function conditionReset() {
        resetSearchConditions('#beginDate,#endDate,#deptId');
        resetDate(start,end);
    }

    return {
        conditionSearch : conditionSearch,
        conditionReset : conditionReset
    };

})();