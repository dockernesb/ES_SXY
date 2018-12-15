var dp=(function (){

    $("#dataStatus").select2({
        placeholder : '全部状态',
        language : 'zh-CN',
        minimumResultsForSearch : -1
    });
    $('#dataStatus').val('0').trigger("change");
    resizeSelect2($("#dataStatus"));

    $("#messageType").select2({
        placeholder : '信息类型',
        language : 'zh-CN',
        minimumResultsForSearch : -1
    });
    $('#messageType').val('1').trigger("change");
    $('#messageType').on("change",function(){
        getJson();
    });
    resizeSelect2($("#messageType"));


    function getJson(){
        $.getJSON(ctx +"/dpTheme/getCoulmnName.action",{
            'msgType':$("#messageType").val()
        },function(result){
            //初始化之前先清空下拉内容
            $("#tableCoulmnName option").remove();
            // 初始下拉框
            $("#tableCoulmnName").select2({
                placeholder : '查询字段',
                allowClear : false,
                language : 'zh-CN',
                data : result
            }).on("change",function(){
                changeCoumlnName();
            });

            $('#tableCoulmnName').val(null).trigger("change");
            resizeSelect2('#tableCoulmnName');
            $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
        },"json");
    }
    getJson();
    //查询字段
    function changeCoumlnName(){

        var tableCoulmnName = $.trim($('#tableCoulmnName').val());
        if(tableCoulmnName == null || tableCoulmnName == ""){
            $('#tableCoulmnNameValue').prop("disabled", "disabled");
            $('#tableCoulmnNameValue').val("");
            resetIEPlaceholder();
        }else{
            $('#tableCoulmnNameValue').removeAttr("disabled");
        }
    }
    /*$.getJSON(ctx + "/dpTheme/getMsgTypeSelect.action", function(result) {
        // 初始下拉框
        $("#messageType").select2({
            placeholder : '信息类型',
            allowClear : false,
            language : 'zh-CN',
            data : result
        });
        $('#messageType').val(null).trigger("change");
        resizeSelect2('#messageType');
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });*/

    var start = {
        elem: '#beginDate',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', //最大日期
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
        format: 'YYYY-MM-DD',
        max: '2099-12-30',
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

    var arr = new Array();//var arr =[];
    var table;
    //创建一个Datatable
    function addTable(){
        $("#tablePanel").children().remove();
        $("#tablePanel").append('<table class="table table-striped table-hover table-bordered" id="dataReportGrid" style="width: 2000px"><thead><tr id="tableId" class="heading"><th class="table-checkbox"><input type="checkbox" class="icheck checkall"></th></tr></thead></table>');
        $.post(ctx + "/dpChineseTheme/getMsgColumns.action", {
            'msgType': $("#messageType").val()
        }, function(data) {
            if (table) {
                table = null;
                arr = [];
            }
            $("#tableId").children(":not(:first)").remove();
            $("#dataTable_column_toggler").children().remove();
            for(var i =0;i<data.length;i++){
                $("#dataTable_column_toggler").append('<label><input type="checkbox" class="icheck" checked data-column="'+(i+1)+'">'+data[i].comments+ '</label>');

            }
            loadClose();
            arr.push({
                "data" : "ID", "render": function(data, type, full) {
                    var opts = '<input type="checkbox" class="icheck"/>';
                    return opts;
                }
            });
            for(var i =0;i<data.length;i++){
                $("#tableId").append('<th>'+data[i].comments+'</th>');
                arr.push({
                    "data" : data[i].columnName
                });
            }
            $("#tableId").append('<th>上报信用中国状态</th><th>操作</th>');
            arr.push({
                "data" : "CHINESE_STATUS",
                "render": function(data,type,full){
                    var str='';
                    if(data ==0){
                        str="未提交";
                    }else if (data ==1){
                        str="提交成功";
                    }else if(data ==2){
                        str="提交失败";
                    }
                    return str;
                }
            });
            arr.push({
                "data": null,
                "render" : function(data, type, full){
                    var str = '';
                    if(data.CHINESE_STATUS ==0 ||data.CHINESE_STATUS ==2){
                        str += '<button type="button" class="btn green btn-xs" onclick="dp.commitData(\''+full.ID+'\');">提交</button>';
                    }else{
                        str='已提交';
                    }
                    return str;
                }
            })
            table = $('#dataReportGrid').DataTable({
                ajax: {
                    url: ctx + "/dpChineseTheme/themePage/tableList.action",
                    type: "post",
                    data: {
                        msgType : $("#messageType").val(),
                        tableCoulmn :$.trim($("#tableCoulmnName").val()),
                        coulmnValue :$.trim($("#tableCoulmnNameValue").val()),
                        beginDate :$.trim($("#beginDate").val()),
                        endDate : $.trim($("#endDate").val()),
                        status : $.trim($("#dataStatus").val())
                    }
                },
                ordering: false,
                searching: false,
                autoWidth: false,
                lengthChange: true,
                pageLength: 10,
                serverSide: true,//如果是服务器方式，必须要设置为true
                processing: true,//设置为true,就会有表格加载时的提示
                columns: arr,
                initComplete : function(settings, data) {
                    var columnTogglerContent = $('#columnTogglerContent').clone();
                    $(columnTogglerContent).removeClass('hide');
                    var columnTogglerDiv = $('#dataReportGrid').parent().parent().find('.columnToggler');
                    $(columnTogglerDiv).html(columnTogglerContent);

                    $(columnTogglerContent).find('input[type="checkbox"]').iCheck({
                        labelHover : false,
                        checkboxClass : 'icheckbox_square-blue',
                        radioClass : 'iradio_square-blue',
                        increaseArea : '20%'
                    });
                    // 显示隐藏列
                    $(columnTogglerContent).find('input[type="checkbox"]').on('ifChanged', function (e) {
                        e.preventDefault();
                        // Get the column API object
                        var column = table.column($(this).attr('data-column'));
                        console.log(column);
                        // Toggle the visibility
                        column.visible(!column.visible());
                    });
                },
                drawCallback : function(settings) {
                    $('#dataReportGrid .checkall').iCheck('uncheck');
                    $('#dataReportGrid .checkall, #dataReportGrid tbody .icheck').iCheck({
                        labelHover : false,
                        cursor : true,
                        checkboxClass : 'icheckbox_square-blue',
                        radioClass : 'iradio_square-blue',
                        increaseArea : '20%'
                    });

                    // 列表复选框选中取消事件
                    var checkAll = $('#dataReportGrid .checkall');
                    var checkboxes = $('#dataReportGrid tbody .icheck');
                    checkAll.on('ifChecked ifUnchecked', function(event) {
                        if (event.type == 'ifChecked') {
                            checkboxes.iCheck('check');
                            $('#dataReportGrid tbody tr').addClass('active');
                        } else {
                            checkboxes.iCheck('uncheck');
                            $('#dataReportGrid tbody tr').removeClass('active');
                        }
                    });
                    checkboxes.on('ifChanged', function(event) {
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
                    $('#dataReportGrid tbody tr').on('click', function() {
                        $(this).toggleClass('active');
                        if ($(this).hasClass('active')) {
                            $(this).find('.icheck').iCheck('check');
                        } else {
                            $(this).find('.icheck').iCheck('uncheck');
                        }
                    });
                }
            });

        }, "json");
    }

    addTable();
    //查询数据
    function queryData(){
        var tableCoulmnName =  $.trim($('#tableCoulmnName').val());//查询字段名
        if(tableCoulmnName != null && tableCoulmnName != ""){
            var tableCoulmnValue= $('#tableCoulmnNameValue').val();//查询字段内容
            if(tableCoulmnValue == null || tableCoulmnValue == ""){
                $.alert('请添加查询字段内容!', 1);
                return;
            }
        }

        addTable();
    }

    //提交数据
    function commitData(id){
        layer.confirm("确定提交吗？", {
            icon : 3,
        }, function(index) {
            layer.close(index);
            loading();
            $.post(CONTEXT_PATH + "/dpChineseTheme/commitDataList.action",{
                    'id': id,
                    'msgType': $("#messageType").val()
                },
                function(data){
                    loadClose();
                    if (!data.result) {
                        $.alert(data.message?data.message:'上报失败', 2);
                        queryData();
                    } else {
                        layer.close(index);
                        $.alert(data.message?data.message:'上报成功', 1);
                        queryData();
                    }
                },"json");
        });

    }



    $("#commitChineseData").click(function(){
        commitChinese();
    });

    function commitChinese(){
        var msg = "确认要提交这些数据吗？";
        var rows = new Array();
        var selectedRows = table.rows('.active').data();
        $.each(selectedRows, function(i, selectedRowData) {
            rows.push(selectedRowData);
        });

        // check
        if (isNull(rows) || rows.length == 0) {
            $.alert('请勾选至少一条记录！');
            return;
        }

        var dataArray = new Array();
        $.each(rows, function(i, row) {
            dataArray.push(row.ID);
        });

        layer.confirm(msg, {
            icon : 3,
        }, function(index) {
            loading();
            $.post(CONTEXT_PATH +"/dpChineseTheme/batchCommitDataList.action",{
                'ids' : JSON.stringify(dataArray),
                'msgType' : $("#messageType").val()
            }, function(data){
                loadClose();
                if (!data.result) {
                    $.alert(data.message, 2);
                } else {
                    /*layer.close(index);
                    layer.confirm(data.message, {
                        icon : 1,
                        btn : [ '下载校验报告', '取消' ]
                    },function(){
                         viewPdf(data.message);
                    });*/
                    $.alert(data.message, 1);
                    queryData();
                }
            },"json");
        });

    }
    // 重置
    function clearData() {
        $('#messageType').val('1').trigger("change");
        $('#dataStatus').val('0').trigger("change");
        $('#tableCoulmnNameValue').val("");//查询字段内容
        $('#tableCoulmnNameValue').prop("disabled", "disabled");
        $('#tableCoulmnName.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
        resetIEPlaceholder();
        resetSearchConditions('#beginDate,#endDate,#tableCoulmnName');
        resetDate(start,end);
    }

    return {
        "clearData" : clearData,
        "queryData": queryData,
        "commitData" :commitData

    }
})();