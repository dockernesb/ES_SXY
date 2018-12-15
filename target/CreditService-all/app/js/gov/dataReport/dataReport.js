var dataReport = (function () {

    $("#tableCoulmnName").select2({
        placeholder: '查询字段',
        language: 'zh-CN'
    }).on("change", function () {
        changeCoumlnName();
    });

    resizeSelect2('#tableCoulmnName');
    $('#tableCoulmnName').val(null).trigger("change");

    $.getJSON(ctx + "/system/dictionary/listValues.action", {
        groupKey: 'reportWay'
    }, function (result) {
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
    }, "json");

    $("#reprotDataStatus").select2({
        width: 100,
        placeholder: '数据状态',
        language: 'zh-CN'
    });
    resizeSelect2('#reprotDataStatus');
    $('#reprotDataStatus').val(null).trigger("change");

    var start = {
        elem: '#beginDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        istime: false,
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#beginDate', datas);
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

    var category = $('#choseTitle').val(); //
    var choseTitle = $('#choseTitle').val(); // 选择的标签页
    var taskCode = $('#taskCode').val();// 任务编号
    var nameList = $("input#nameList").val();
    var codeList = $("input#codeList").val();
    var typeList = $("input#typeList").val();
    var tableId = $("input#tableId").val();
    var reportName = $("input#reportName").val();
    var errorTaskCode = $("input#errorTaskCode").val();
    var checkTime = $("input#checkTime").val();
    var rulesList = $("input#rulesList").val();
    var requiredGroupList = $("input#requiredGroupList").val();

    if (nameList) {
        nameList = eval(nameList);
    }
    if (codeList) {
        codeList = eval(codeList);
    }
    if (typeList) {
        typeList = eval(typeList);
    }
    if (rulesList) {
        rulesList = eval(rulesList);
    }
    if (checkTime) {
        checkTime = eval(checkTime);
    }
    if (requiredGroupList) {
        requiredGroupList = eval(requiredGroupList);
    }
    if (requiredGroupList == null || requiredGroupList.length == 0) {
        $("#warningMsgDiv").hide();
        $("#editWarningMsgDiv").hide();
    }

    log(errorTaskCode);

    if (errorTaskCode == 'true') {
        $.alert("上报批次编号信息错误！", 2, function () {
            goBack();
        });
    } else {
        var columns = new Array();
        columns.push({
            "data": null
            // 复选框
        });
        columns.push({
            "data": "TASK_CODE"
            // 上报批次编号
        });
        columns.push({
            "data": "INSERT_TYPE", // 上报方式
            "render": function (data, type, row) {
                var str = '';
                if (data == "0") {
                    str = "手动录入";
                } else if (data == "1") {
                    str = "文件上传";
                } else if (data == "2") {
                    str = "数据库上报";
                } else if (data == "3") {
                    str = "FTP上报";
                } else if (data == "4") {
                    str = "接口上报";
                } else {
                    str = "未知";
                }

                return str;
            }
        });

        columns.push({
            "data": "STATUS", // 数据状态
            "render": function (data, type, row) {
                var str = '';
                if (data == 0 || data == 9 ) {
                    str = "新增";
                } else if (data == -2 || data == 99) {
                    str = "已删除";
                } else if (data == 1) {
                    str = "已处理";
                } else if (data == -3) {
                    str = "已修改";
                } else {
                    str = "未知";
                }

                return str;
            }
        });

        columns.push({
            "data": "CREATE_TIME" // 更新时间
        });

        for (var i = 0; i < codeList.length; i++) {
            columns.push({
                "data": codeList[i]
            });
        };

        var table = $('#dataReportGrid').DataTable({
            ajax: {
                url: CONTEXT_PATH + '/dp/dataReport/list.action',
                type: 'post',
                data: {
                    tableId: tableId,
                    tableCoulmn: $('#tableCoulmnName').val(),
                    coulmnValue: $('#tableCoulmnNameValue').val(),
                    reprotDataStatus: $('#reprotDataStatus').val(),
                    beginTime: $('#beginDate').val(),
                    taskCode: $('#taskCode').val()
                }
            },
            ordering: false,
            searching: false,
            autoWidth: false,
            lengthChange: true,
            pageLength: 10,
            serverSide: true,// 如果是服务器方式，必须要设置为true
            processing: true,// 设置为true,就会有表格加载时的提示
            columns: columns,
            initComplete: function (settings, data) {
                var columnTogglerContent = $('#columnTogglerContent').clone();
                $(columnTogglerContent).removeClass('hide');
                var columnTogglerDiv = $('#dataReportGrid').parent().parent().find('.columnToggler');
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
            columnDefs: [{
                targets: 0, // checkBox
                render: function (data, type, full) {
                    return '<input type="checkbox" name="checkThis" class="icheck">';
                }
            }],
            drawCallback: function (settings) {
                $('#dataReportGrid .checkall').iCheck('uncheck');
                $('#dataReportGrid .checkall, #dataReportGrid tbody .icheck').iCheck({
                    labelHover: false,
                    cursor: true,
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });

                // 列表复选框选中取消事件
                var checkAll = $('#dataReportGrid .checkall');
                var checkboxes = $('#dataReportGrid tbody .icheck');
                checkAll.on('ifChecked ifUnchecked', function (event) {
                    if (event.type == 'ifChecked') {
                        checkboxes.iCheck('check');
                        $('#dataReportGrid tbody tr').addClass('active');
                    } else {
                        checkboxes.iCheck('uncheck');
                        $('#dataReportGrid tbody tr').removeClass('active');
                    }
                });
                checkboxes.on('ifChanged', function (event) {
                    if (checkboxes.filter(':checked').length == checkboxes.length) {
                        checkAll.prop('checked', 'checked');
                    } else {
                        checkAll.removeProp('checked');
                    }
                    checkAll.iCheck('update');

                    if ($(this).is(':checked')) {
                        $(this).closest('tr').addClass('active');
                    } else {
                        $(this).closest('tr').removeClass('active');
                    }
                });

                // 添加行选中点击事件
                $('#dataReportGrid tbody tr').on('click', function () {
                    $(this).toggleClass('active');
                    if ($(this).hasClass('active')) {
                        $(this).find('.icheck').iCheck('check');
                    } else {
                        $(this).find('.icheck').iCheck('uncheck');
                    }
                });
            }
        });
    }

    // 初始化文件上传
    $(".upload-file").uploadFile({
        showList: false,
        supportTypes: ["xls", "xlsx", "txt"],
        beforeUpload: function () {
            loading();
        },
        callback: function (data) {
            var filePathStr = "";
            var fileNameStr = "";
            var fileArr = data.success;
            if (fileArr.length > 0) {
                for (var i = 0; i < fileArr.length; i++) {
                    filePathStr += fileArr[i].path + ",";
                    fileNameStr += fileArr[i].name + ",";
                }
                uploadFile(filePathStr, fileNameStr);
            }
        }
    });

    // 添加校验规则
    var addValidator = $('#addDataForm').validateForm();
    var editValidator = $('#editDataForm').validateForm();

    // 初始化校验规则
    if (rulesList instanceof Array) {
        for (var i = 0; i < rulesList.length; i++) {
            var rulesMap = rulesList[i];
            for (var code in rulesMap) {
                // 生成验证规则
                var rulesArr = rulesMap[code];
                if (rulesArr) {
                    rulesArr = eval(rulesArr);
                }
                var validType = [];
                if (rulesArr instanceof Array) {
                    for (var k = 0; k < rulesArr.length; k++) {
                        var tips = rulesArr[k].MSG;
                        var patten = rulesArr[k].PATTERN;
                        var ruleName = code;
                        extendRule(ruleName, patten, tips);
                        addValidator.form();
                        editValidator.form();
                        addRules(ruleName);
                    }
                }
            }
        }
    }

    // 扩展校验规则
    function extendRule(name, pattern, tips) {
        jQuery.validator.addMethod(name, function (value, element) {
            return this.optional(element) || (new RegExp(pattern).test(value));
        }, tips);
    }

    function addRules(name) {
        var rules = {};
        rules[name] = true;
        $("#Add" + name).rules("add", rules);
        $("#" + name).rules("add", rules);
    }

    // 验证组合必填
    function validateGroup() {
        if (requiredGroupList instanceof Array) {
            for (var i = 0; i < requiredGroupList.length; i++) {

            }
        }
    }

    // 打开新增页面
    function onAddData() {
        $('#addDataForm')[0].reset();
        $('input').prev('i').attr('class', 'fa');
        addValidator.form();
        $.openWin({
            title: '新增',
            content: $("#winAdd"),
            btnAlign: 'c',
            area: ['600px', '650px'],
            yes: function (index, layero) {
                addData(index);
            }
        });
    }

    function addData(index) {
        if (!addValidator.form()) {
            $.alert("请检查所填信息！");
            return;
        }
        if (checkTime) {
            var isCheck = checkTime[0];
            if (isCheck.IS_CHECK_DATE == 1) {
                var beginTime = new Date($('#Add' + isCheck.BEGIN_DATE_CODE).val());
                var endTime = new Date($('#Add' + isCheck.END_DATE_CODE).val());
                if (beginTime.getTime() > endTime.getTime()) {
                    $.alert("开始时间不能大于结束时间！");
                    return;
                }
            }
        }
        var addDataForm = $("#addDataForm").serialize();
        addDataForm += "&version=" + $("#version").val();
        loading();
        $.post(CONTEXT_PATH + "/dp/dataReport/save.action", addDataForm, function (data) {
            loadClose();
            if (!data.result) {
                $.alert(data.message, 2);
            } else {
                $.alert(data.message, 1);
                layer.close(index);
                table.ajax.reload(null, false);
            }
        }, "json");
    }

    // 打开修改窗口
    function openEdit() {
        var rows = new Array();
        var selectedRows = table.rows('.active').data();
        $.each(selectedRows, function (i, selectedRowData) {
            rows.push(selectedRowData);
        });
        // check
        if (isNull(rows) || rows.length == 0) {
            $.alert('请勾选要操作的记录');
            return;
        }

        if (rows.length > 1) {
            $.alert('一次只能修改一条记录');
            return;
        }

        var row = selectedRows[0];

        var status = row.STATUS;
        if (status == 1) {
            $.alert('已处理记录无法修改');
            return;
        }

        var editId = row.ID;// 修改的记录id
        var taskCodes = new Array();
        taskCodes.push(row.TASK_CODE);
        $.post(CONTEXT_PATH + "/dp/dataReport/checkTaskCode.action", {
            taskCodes: JSON.stringify(taskCodes)
        }, function (data) {
            if (data.result) {
                $('#editDataForm')[0].reset();
                loading();
                $.post(CONTEXT_PATH + "/dp/dataReport/getEditData.action", {
                    editId: editId,
                    tableId: tableId
                }, function (data) {
                    var data = eval(data);
                    loadClose();
                    for (var i = 0; i < codeList.length; i++) {
                        var colName = codeList[i];
                        $('#' + codeList[i]).val(data[colName]);
                    }
                    $('#editId').val(editId);
                    $.openWin({
                        title: '修改',
                        content: $("#winEdit"),
                        btnAlign: 'c',
                        area: ['600px', '650px'],
                        yes: function (index, layero) {
                            editData(index);
                        }
                    });
                    $('input').prev('i').attr('class', 'fa');
                    editValidator.form();
                }, "json");
            } else {
                $.alert('已上报确认的批次数据不允许修改！批次编号【' + data.message + '】');
            }
        }, "json");
    }

    // 修改数据
    function editData(index) {
        if (!editValidator.form()) {
            $.alert("请检查所填信息！");
            return;
        }
        if (checkTime) {
            var isCheck = checkTime[0];
            if (isCheck.IS_CHECK_DATE == 1) {
                var beginTime = new Date($('#' + isCheck.BEGIN_DATE_CODE).val());
                var endTime = new Date($('#' + isCheck.END_DATE_CODE).val());
                if (beginTime.getTime() > endTime.getTime()) {
                    $.alert("开始时间不能大于结束时间！");
                    return;
                }
            }
        }

        var editDataForm = $("#editDataForm").serialize();
        editDataForm += "&isReportViewEdit=1";// 添加是数据上报页面修改的标识位，因为疑问数据页面的修改也调用的此方法
        loading();
        $.post(CONTEXT_PATH + "/dp/dataReport/edit.action", editDataForm, function (data) {
            loadClose();
            if (!data.result) {
                $.alert(data.message, 2);
            } else {
                $.alert(data.message, 1);
                layer.close(index);
                table.ajax.reload(null, false);
            }
        }, "json");
    }

    // 删除
    function deleteData() {
        var rows = new Array();
        var selectedRows = table.rows('.active').data();
        $.each(selectedRows, function (i, selectedRowData) {
            rows.push(selectedRowData);
        });

        // check
        if (isNull(rows) || rows.length == 0) {
            $.alert('请勾选要操作的记录');
            return;
        }

        var dataArray = new Array();
        var taskCodes = new Array();
        $.each(rows, function (i, row) {
            dataArray.push(row.ID);
            taskCodes.push(row.TASK_CODE);
        });

        $.post(CONTEXT_PATH + "/dp/dataReport/checkTaskCode.action", {
            taskCodes: JSON.stringify(taskCodes)
        }, function (data) {
            if (data.result) {
                layer.confirm('确认要删除这些数据吗？', {
                    icon: 3
                }, function (index) {
                    loading();
                    $.post(CONTEXT_PATH + "/dp/dataReport/delete.action", {
                        ids: JSON.stringify(dataArray),
                        tableId: tableId
                    }, function (data) {
                        loadClose();
                        if (!data.result) {
                            $.alert('删除数据失败!', 2);
                        } else {
                            layer.close(index);
                            $.alert('删除数据成功!', 1);
                            table.ajax.reload(null, false);
                        }
                    }, "json");
                });
            } else {
                $.alert('已上报确认的批次数据不允许删除！批次编号【' + data.message + '】');
            }
        }, "json");
    }

    // 打开下载模板页面
    function openDownload() {
        var templateFilePath = $('#templateFilePath').val();
        $.post(CONTEXT_PATH + '/dp/dataReport/checkFile.action', {
            filePath: templateFilePath
        }, function (data) {
            var data = eval('(' + data + ')');
            if (!data.result) {
                $.alert('没有模板文件!');
            } else {
                $.openWin({
                    title: '下载模板',
                    content: $("#winDownload"),
                    btnAlign: 'c',
                    btn: ['关闭窗口'],
                    area: ['470px', '320px'],
                    yes: function (index, layero) {
                        layer.close(index);
                    }
                });
            }
        });
    }

    // 下载模板
    function downloadByType(type) {
        var index = layer.index;
        layer.close(index);
        var templateFilePath = $('#templateFilePath').val();
        var filePath = "";
        if (type == "doc") {
            filePath = templateFilePath + "-数据上报接口说明文档" + "." + type;
        } else {
            filePath = templateFilePath + "." + type;
        }
        var url = CONTEXT_PATH + "/dp/dataReport/downLoadFile.action?filePath=" + filePath;
        window.location = url;
    }

    // 上传文件
    function uploadFile(filePathStr, fileNameStr) {
        loading();
        $.post(CONTEXT_PATH + '/dp/dataReport/uploadFile.action', {
            tableStatus: $('#tableStatus').val(),
            fileNameStr: fileNameStr,
            filePathStr: filePathStr,
            versionId: $("#version").val()
        }, function (data) {
            loadClose();
            var data = eval('(' + data + ')');
            if (!data.result) {
                $.alert(data.message);
            } else {
                $.alert(data.message);
                table.ajax.reload(null, false);
            }
        });
    }

    // 返回
    function goBack() {
        $("div#childBox").html('');// 置空以免样式冲突
        $("div#childBox").hide();
        $("div#parentBox").show();
        // ie9下会因为prependTo方式导致select2控件值为null时会默认显示第一个值，prependTo方式必须放在recordSelectNullEle和callbackSelectNull方法中间
        var selectArr = recordSelectNullEle();
        $("div#parentBox").prependTo("#topBox");
        callbackSelectNull(selectArr);
        var activeIndex = recordDtActiveIndex(govTask.table);
        govTask.table.ajax.reload(function () {
            callbackDtRowActive(govTask.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
        resetIEPlaceholder();
    }


    function queryData() {

        var tableCoulmnName = $.trim($('#tableCoulmnName').val());// 查询字段名
        if (tableCoulmnName != null && tableCoulmnName != "") {

            var tableCoulmnValue = $('#tableCoulmnNameValue').val();// 查询字段内容
            if (tableCoulmnValue == null || tableCoulmnValue == "") {
                $.alert('请添加查询字段内容!', 1);
                return;
            }
        }
        var data = table.settings()[0].ajax.data;

        if (!data) {
            data = {};
            table.settings()[0].ajax["data"] = data;
        }
        data["tableCoulmn"] = $.trim($("#tableCoulmnName").val());
        data["coulmnValue"] = $.trim($("#tableCoulmnNameValue").val());
        data["reportWay"] = $('#reportWay').val();
        data["reprotDataStatus"] = $.trim($("#reprotDataStatus").val());
        data["taskCode"] = $.trim($("#taskCode").val());
        data["beginTime"] = $.trim($("#beginDate").val());
        data["endTime"] = $.trim($("#endDate").val());

        table.ajax.reload();
    }

    function clearData() {
        resetIEPlaceholder();
        resetDate(start, end);
        resetSearchConditions('#tableCoulmnName,#reportWay,#reprotDataStatus,#tableCoulmnNameValue,#taskCode,#beginDate,#endDate');
        $('#tableCoulmnNameValue').prop("disabled", "disabled");

        if ($('#bqBtn').hasClass("btn-info")) {
            $("#beginDate").next('.phTips').hide();
            $("#beginDate").val($("#beginTime").val());
            $("#beginDate").prop('disabled', true);

            end.min = $("#beginTime").val(); // 开始日选好后，重置结束日的最小日期
            end.start = $("#beginTime").val();
        } else {
            $("#beginDate").prop('disabled', false);
        }
    }

    // 查询字段
    function changeCoumlnName() {

        var tableCoulmnName = $.trim($('#tableCoulmnName').val());
        if (tableCoulmnName == null || tableCoulmnName == "") {
            $('#tableCoulmnNameValue').val("");
            $('#tableCoulmnNameValue').prop("disabled", "disabled");
            resetIEPlaceholder();
        } else {
            $('#tableCoulmnNameValue').removeAttr("disabled");
        }
    }

    function queryErrorData() {
        table.ajax.reload();
    }

    // 获取列表数据（0：本期，1：全部数据。 默认本期）
    function getData(type) {
        $("#beginDate").prop('disabled', false);
        resetDate(start, end);
        resetSearchConditions('#beginDate,#endDate');
        if (type == 0) {
            $("#beginDate").next('.phTips').hide();
            $('#beginDate').val($('#beginTime').val());
            $("#beginDate").prop('disabled', true);
            $('#bqBtn').removeClass('btn-default').addClass('btn-info');
            $('#allBtn').removeClass('btn-info').addClass('btn-default');
            $('label.upload-file, .sbbtn').show();

            end.min = $("#beginTime").val(); // 开始日选好后，重置结束日的最小日期
            end.start = $("#beginTime").val();
        }
        if (type == 1) {
            $('#allBtn').removeClass('btn-default').addClass('btn-info');
            $('#bqBtn').removeClass('btn-info').addClass('btn-default');
            $('label.upload-file, .sbbtn').hide();
        }

        queryData();
    }

    // 默认是本周期数据，禁用开始时间
    $("#beginDate").prop('disabled', true);
    end.min = $("#beginTime").val(); // 开始日选好后，重置结束日的最小日期
    end.start = $("#beginTime").val();

    return {
        "deleteData": deleteData,
        "openEdit": openEdit,
        "downloadByType": downloadByType,
        "openDownload": openDownload,
        "onAddData": onAddData,
        "goBack": goBack,
        "queryData": queryData,
        "queryErrorData": queryErrorData,
        "clearData": clearData,
        "getData": getData
    }
})();