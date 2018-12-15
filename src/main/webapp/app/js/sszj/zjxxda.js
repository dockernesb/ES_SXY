var zjxxda = (function () {
    var rowIds = [];
    var table = $('#zjxxdaGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjJbxxList.action",
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
            },
                {"data": "JGQC",
                    render :function (data,type,row) {
                        var str = '<a href="javascript:;" onclick="zjxxda.showDetail(\''+ row.ID +'\');">' + data + '</a>';
                        return str
                    }
                },
                {"data": "LXDH"},
                {"data": "FRDB_FZR"},
                {"data": "JGQC"},
                {"data": "DEPT_NAME"},
                {"data": "CREATE_TIME"}
            ],
            drawCallback: function (settings) {
                $('#zjxxdaGrid .checkall').iCheck('uncheck');
                $('#zjxxdaGrid .checkall, #zjxxdaGrid tbody .icheck').iCheck({
                    labelHover: false,
                    cursor: true,
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });

                // 列表复选框选中取消事件
                var checkAll = $('#zjxxdaGrid .checkall');
                var checkboxes = $('#zjxxdaGrid tbody .icheck');
                checkAll.on('ifChecked ifUnchecked', function (event) {
                    if (event.type == 'ifChecked') {
                        checkboxes.iCheck('check');
                        $('#zjxxdaGrid tbody tr').addClass('active');
                    } else {
                        checkboxes.iCheck('uncheck');
                        $('#zjxxdaGrid tbody tr').removeClass('active');
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
                $('#zjxxdaGrid tbody tr').on('click', function () {
                    $(this).toggleClass('active');
                    if ($(this).hasClass('active')) {
                        $(this).find('.icheck').iCheck('check');
                    } else {
                        $(this).find('.icheck').iCheck('uncheck');
                    }
                });
            }
        });

    // 中介新增模型
    function toAddModel(id,type) {
        var url = CONTEXT_PATH + "/sszj/zjxxdaAdd.action?type="+type+"&id="+id;
        $("div#childDiv").html("");
        $("div#childDiv").load(url);
        $("div#childDiv").prependTo("#topBox");
        $("div#fatherDiv").hide();
        $("div#childDiv").show();
        resetIEPlaceholder();
    }

    $("#addDept").click(function() {
        toAddModel('','0');
    });

    function conditionSearch() {
        var data = table.settings()[0].ajax.data;
        if (!data) {
            data = {};
            table.settings()[0].ajax["data"] = data;
        }
        data["jgqc"] = $("#jgmc").val();
        data["deptId"] = $("#bmmc").val();
        table.ajax.reload();
    }
    function conditionReset() {
        $("#jgmc").val('');
        $("#bmmc").val('');
        var data = table.settings()[0].ajax.data;
        if (!data) {
            data = {};
            table.settings()[0].ajax["data"] = data;
        }
        data["jgqc"] = $("#jgmc").val();
        data["deptId"] = $("#bmmc").val();
        table.ajax.reload();
    }

    //查看中介详细
    function showDetail(id) {
        toDetailModel(id);
    }

    // 中介详细模型
    function toDetailModel(id) {
        var url = CONTEXT_PATH + "/sszj/zjxxdaDetail.action?id="+id;
        $("div#childDiv").html("");
        $("div#childDiv").load(url);
        $("div#childDiv").prependTo("#topBox");
        $("div#fatherDiv").hide();
        $("div#childDiv").show();
        resetIEPlaceholder();
    }

    // 下载模板
    function templateDownload() {
        loading();
        window.location.href = CONTEXT_PATH + "/center/creditCheck/templateDownload.action";
        loadClose();
    }

    $(".upload-file").cclUpload({
        supportTypes : [ "xls", "xlsx" ], // 支持的文件类型(文件类型为img时，默认支持"jpg","jpeg","gif","bmp","png")
        callback : function(data) {
            var filePathStr = "";
            var fileNameStr = "";
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    filePathStr += data[i].path + ",";
                    fileNameStr += data[i].name + ",";
                }
                batchAdd(filePathStr, fileNameStr);
            }
        }
    });
    // 批量上传
    function batchAdd(filePathStr, fileNameStr) {
        loading();
        $.post(CONTEXT_PATH + '/sszj/batchAdd.action', {
            filePathStr : filePathStr,
            fileNameStr : fileNameStr
        }, function(data) {
            var data = eval('(' + data + ')');
            table.ajax.reload();
            layer.open({
                type : 1, // Page层类型
                area : [ '600px', '400px' ],
                title : '批量导入解析结果',
                shade : 0.6, // 遮罩透明度
                anim : 1, // 0-6的动画形式，-1不开启
                content : '<div style="padding:10px 20px;">' + data.message + '</div>'
            });
            loadClose();
        });
    }
    //删除选中的数据
    function deleteSszj() {
        var checked = table.rows('.active').data();
        var checkedList=[];
        if(checked.length<1){
            $.alert('指标项至少勾选一个！');
            return;
        }
        loading();
        for(var i=0;i<checked.length;i++){
            checkedList.push(checked[i]);
        }
        $.post(ctx + "/sszj/deleteSszj.action", {
            "checkedList" : JSON.stringify(checkedList),
        }, function(data) {
            loadClose();
            if (data.result) {
                $.alert(data.message, 1);
                table.ajax.reload();
            } else {
                $.alert(data.message, 2);
            }
        }, "json");
    }
    //修改选中的数据
    function updateSszj() {
        var checked = table.rows('.active').data();
        if(checked.length!=1){
            $.alert('指标项只能勾选一个！');
            return;
        }
        toAddModel(checked[0].ID,'1');//0-新增 1-修改
    }
    return {
        "showDetail": showDetail,
        "deleteSszj": deleteSszj,
        "templateDownload" : templateDownload,
        "conditionSearch": conditionSearch,
        "conditionReset": conditionReset,
        "updateSszj":updateSszj
    };

})();
