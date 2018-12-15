var collection = function () {
    var versionId = $.trim($("#versionId").val()); //用于存放第一个查询的版本ID
    $("#status").select2({
        placeholder: '全部状态',
        minimumResultsForSearch: -1
    });
    $('#status').val(null).trigger("change");
    resizeSelect2('#status');

    $.getJSON(ctx + "/system/department/getDeptList.action?isIncludedAll=true", function (result) {
        // 初始下拉框
        $("#conditionDeptId").select2({
            placeholder: '全部部门',
            language: 'zh-CN',
            data: result
        });
        resizeSelect2($("#conditionDeptId"));
        $('#conditionDeptId').val(null).trigger("change");

        // 部门下拉框值改变事件
        $("#conditionDeptId").bind("change", function () {
            $('#deptId').val($("#conditionDeptId").val());
        });

        // 初始化查询条件中select2的对齐为题
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });


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

    getTaskStatusCount('isFirst');

    // 获取各状态的任务数量
    function getTaskStatusCount(isFirst) {
        var version;
        if (isFirst) {
            version = versionId;
        } else {
            version = $.trim($("#version").val())
        }
        var tableName = $.trim($("#tableName").val());
        var deptId = $.trim($("#conditionDeptId").val());
        $.getJSON(ctx + '/schema/collection/getTaskStatusCount.action', {
            "tableName": tableName,
            "deptId": deptId,
            "versionId": version
        }, function (data) {
            $('#schemaSize').html(data.schemaSize);// 征集目录总计
            $('#deptSize').html(data.deptSize);// 征集部门总计
            $('#allSize').html(data.allSize);// 上报数据总量
            $('#failSize').html('<span style="color:red;">'+data.untreatedSize+'</span>/'+data.failSize);// 疑问数据总量
            $('#updateSize').html(data.updateSize);// 更新量
            $('#successSize').html(data.successSize);// 入库量
        });
    }


    // 创建一个Datatable
    var table = $('#taskGrid').DataTable({
        ajax: {
            url: ctx + "/schema/collection/list.action",
            type: "post",
            data: {
                versionId: versionId
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
            "data": "NAME",
            "render": function (value, type, row) {
                var str = '';
                str += '<a href="javascript:void(0);" onclick="collection.toSchemaDetail(\'' + row.TABLE_ID + '\',this);">' + row.NAME + '</a>';
                return str;
            }
        }, {
            "data": "TASK_PERIOD",
            "render": periodFormatter
        }, {
            "data": "ALLSIZE",//上报量
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return 0;
                }
                return value;
            }
        }, {
            "data" : "FAILSIZE",//疑问量：未处理/总量
            "render" : function(value, type, row) {
                var str;
                var fallSize = 0;
                if (isNull(row.UNTREATEDSIZE)) {
                    str='<span style="color:red;">0</span>'
                }else{
                    str='<span style="color:red;">' + row.UNTREATEDSIZE + '</span>'
                }
                if (isNull(value)) {
                    fallSize = 0;
                }else{
                    fallSize = row.FAILSIZE;
                }
                return str + "/"+fallSize;
            }
        }, {
            "data": "UPDATESIZE",//更新量
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return 0;
                }
                return value;
            }
        }, {
            "data": "SUCCESSSIZE",//入库量
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return 0;
                }
                return value;
            }
        }, {
            "data": "NOTRELATEDSIZE",
            "render": function (value, type, row) {
                if (isNull(value)) {
                    return 0;
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
        "createdRow": function (row, data, dataIndex) {
            $(row).children('td').eq(1).attr('style', 'text-align: center;')
            $(row).children('td').eq(2).attr('style', 'text-align: right;')
            $(row).children('td').eq(3).attr('style', 'text-align: right;')
            $(row).children('td').eq(4).attr('style', 'text-align: right;')
            $(row).children('td').eq(5).attr('style', 'text-align: right;')
            $(row).children('td').eq(6).attr('style', 'text-align: right;')
        },

    });


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
        } else {
            return '';
        }
    }

    // 按条件查询
    function conditionSearch(type) {
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["tableName"] = $.trim($("#tableName").val());
            data["deptId"] = $.trim($("#conditionDeptId").val());
            data["versionId"] = $.trim($("#version").val());
            table.ajax.reload(null, type == 1 ? true : false);// 刷新列表还保留分页信息
            getTaskStatusCount();
        }
    }

    // 重置查询条件
    function conditionReset() {
        $("#version").val(versionId).trigger("change");
        resetSearchConditions('#tableName,#conditionDeptId');
    }

    /*----------------------------数据明细----------------------------------*/
    function dataDetail(erorData) {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var url = ctx + '/schema/collection/dataReport.action';
            $("div#childBox").html("");
            $("div#childBox").load(url,{
                logicTableId: row.TABLE_ID,
                deptId:$.trim($("#conditionDeptId").val()),
                versionId: $.trim($("#version").val())
            });
            $("div#parentBox").hide();
            $("div#childBox").show();
            $("div#childBox").prependTo("#topBox");
            resetIEPlaceholder();
        } else {
            $.alert('请先选择目录!');
        }
    }

    /*----------------------------疑问数据----------------------------------*/
    function errorDetailInfo(showErrorData) {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            var url = ctx + '/dp/historyDataReport/toErrorDetailInfo.action';
            $("div#childBox").html("");
            $("div#parentBox").hide();
            $("div#childBox").show();
            $("div#childBox").load(url, {
                logicTableId: row.TABLE_ID,
                beginTime: row.BEGINTIME,
                showErrorData: showErrorData,
                queryType: 1,
                deptId: $.trim($("#conditionDeptId").val()),
                versionId: $.trim($("#version").val())
            });
            $("div#childBox").prependTo("#topBox");
            resetIEPlaceholder();
        } else {
            $.alert('请先选择目录!');
        }
    }

    /*----------------------------未关联数据----------------------------------*/
    function noRelatedList(showErrorData) {
        var selectRows = table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            $.post(ctx + "/schema/collection/isHasRelation.action?logicTableId=" + row.TABLE_ID, function (result) {
                if (result == "0") {
                    var url = ctx + '/schema/collection/toNoRelatedList.action';
                    $("div#childBox").html("");
                    $("div#childBox").load(url,{
                        logicTableId: row.TABLE_ID,
                        deptId:$.trim($("#conditionDeptId").val()),
                        versionId: $.trim($("#version").val())
                    });
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
            $.alert('请先选择目录!');
        }
    }

    /*----------------------------目录详情----------------------------------*/

    // 目录详情弹框
    function toSchemaDetail(id) {
        $.getJSON(ctx + '/schema/grant/getDetail.action', {
            id: id,
            versionId: $.trim($("#versionId").val())
        }, function (result) {
            var schema = result.schema;
            $('#nameTd').val(schema.name);
            $('#codeTd').val(schema.code);
            $('#rtaskPeriod').val(schema.taskPeriodVo);
            if (!isNull(schema.days)) {
                $('#rdays').val(schema.days + '天');
            }
            $('#rtableDesc').val(schema.tableDesc);
            $('#dataCategory').val(schema.dataCategoryVo);
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
                    "render": stateFormatter
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
        // 获取授权部门
        $.post(ctx + "/schema/getSchemaDeptList.action", {
            tableId: id,
            versionId: $.trim($("#versionId").val())
        }, function (json) {
            var str = "";
            if (json && json.length > 0) {
                for (var i = 0; i < json.length; i++) {
                    var dept = json[i];
                    if (dept && dept.id) {
                        str += '<li  readonly class="menuList-li" style="  list-style:  none;display: inline-block;border:1px\n' +
                            'solid #cecece; padding: 4px 6px;margin: 0 2px 5px 0; color: #333;">' + dept.departmentName + '</li>';
                    }
                }
            }
            $('#deptsId').html(str);
        }, "json");
    }

    // 格式化必填显示
    function stateFormatter(data, type, full) {
        if (data === 0) {
            return "是";
        } else {
            return "否";
        }
    }

    return {
        errorDetailInfo: errorDetailInfo,
        dataDetail: dataDetail,
        toSchemaDetail: toSchemaDetail,
        conditionSearch: conditionSearch,
        conditionReset: conditionReset,
        noRelatedList: noRelatedList,
        table: table
    }
}();