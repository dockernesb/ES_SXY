var gl = (function () {

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
            url: ctx + "/publishedMonthlyReport/getGovList.action",
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

    function refreshTable(beginDate, endDate) {
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["beginDate"] = beginDate || "";
            data["endDate"] = endDate || "";
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
            tableSum.ajax.reload();
        }
    }

    //创建一个Datatable
    var tableSum = $('#dataTableSum').DataTable({
        ajax: {
            url: ctx + "/publishedMonthlyReport/getGovSumList.action",
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
    
    $("#addBtn").click(function () {
        toMonthlyReportHandle();
    });

    $("#editBtn").click(function () {
        var nodes = table.rows('.active').data();
        if (nodes.length == 1) {
            var node = nodes[0];
            toMonthlyReportHandle(node.id);
        } else {
            $.alert('请在列表中选择要修改的月报!');
        }
    });

    function toMonthlyReportHandle(id) {
        // addDtSelectedStatus(_this);
        var url = ctx + "/publishedMonthlyReport/toMonthlyReportHandle.action?id=" + (id || "");
        $("div#handleDiv").html("");
        $("div#handleDiv").load(url);
        $("div#handleDiv").prependTo("#topBox");
        $("div#mainListDiv").hide();
        $("div#handleDiv").show();
        resetIEPlaceholder();
    }

    $("#delBtn").click(function () {
        var nodes = table.rows('.active').data();
        if (nodes.length == 1) {
            var node = nodes[0];
            layer.confirm("确认删除吗？", {icon : 3}, function(index) {
                layer.close(index);
                loading();
                $.post(ctx + "/publishedMonthlyReport/deleteMonthlyReport.action", {
                    "id" : node.id
                }, function(data) {
                    loadClose();
                    if (data.result) {
                        refreshTable();
                        $.alert("操作成功！", 1);
                    } else {
                        $.alert(data.message || "", 2);
                    }
                }, "json");
            });
        } else {
            $.alert('请在列表中选择要删除的月报!');
        }
    });

    //	搜索
    function conditionSearch() {
        var beginDate = $.trim($('#beginDate').val());
        var endDate = $.trim($('#endDate').val());
        refreshTable(beginDate, endDate);
    }

    //		重置
    function conditionReset() {
        resetSearchConditions('#beginDate,#endDate');
        resetDate(start,end);
    }

    return {
        conditionSearch : conditionSearch,
        conditionReset : conditionReset,
        table : table,
        tableSum : tableSum
    };

})();