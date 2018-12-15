var zjxxdaDetail = (function () {

    // 返回中介信息档案列表页面
    function goBackList() {
        var selectArr = recordSelectNullEle();
        $("div#fatherDiv").prependTo("#topBox");
        callbackSelectNull(selectArr);
        $("div#fatherDiv").show();
        $("div#childDiv").hide();
    }

    var tableZyzz = $('#zyzzGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjZyzzList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").html()

                }
            },
            serverSide: true,// 如果是服务器方式，必须要设置为true
            processing: true,// 设置为true,就会有表格加载时的提示
            lengthChange: true,// 是否允许用户改变表格每页显示的记录数
            pageLength: 10,
            searching: false,// 是否允许Datatables开启本地搜索
            paging: true,
            ordering: false,
            autoWidth: false,
            columns: [
                {"data": "ZZ_ZSMC"},
                {"data": "ZZ_ZSBH"},
                {"data": "ZZ_DJ"},
                {"data": "STATEMC"}
                ],
            initComplete : function(settings, data) {
                var info = tableZyzz.page.info();
                var dataRows = info.recordsTotal;
                if (dataRows != 0) {
                    $("#zyzzTs").html(dataRows);
                }
            }
        });
    var tableZyry = $('#zyryGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjZyryList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").html()

                }
            },
            serverSide: true,// 如果是服务器方式，必须要设置为true
            processing: true,// 设置为true,就会有表格加载时的提示
            lengthChange: true,// 是否允许用户改变表格每页显示的记录数
            pageLength: 10,
            searching: false,// 是否允许Datatables开启本地搜索
            paging: true,
            ordering: false,
            autoWidth: false,
            columns: [
                {"data": "XM"},
                {"data": "XM"},
                {"data": "XM"},
                {"data": "STATE"}
                ],
            initComplete : function(settings, data) {
                var info = tableZyry.page.info();
                var dataRows = info.recordsTotal;
                if (dataRows != 0) {
                    $("#zyryTs").html(dataRows);
                }
            }
        });
    var tablePjdj = $('#pjdjGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjPjdjList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").html()

                }
            },
            serverSide: true,// 如果是服务器方式，必须要设置为true
            processing: true,// 设置为true,就会有表格加载时的提示
            lengthChange: true,// 是否允许用户改变表格每页显示的记录数
            pageLength: 10,
            searching: false,// 是否允许Datatables开启本地搜索
            paging: true,
            ordering: false,
            autoWidth: false,
            columns: [
                {"data": "PJND"},
                {"data": "PJDJ"},
                {"data": "PJJG"},
                {"data": "PJND"}
                ],
            initComplete : function(settings, data) {
                var info = tablePjdj.page.info();
                var dataRows = info.recordsTotal;
                if (dataRows != 0) {
                    $("#pjdjTs").html(dataRows);
                }
            }
        });
    var tableXycn = $('#xycnGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjXycnList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").html()

                }
            },
            serverSide: true,// 如果是服务器方式，必须要设置为true
            processing: true,// 设置为true,就会有表格加载时的提示
            lengthChange: true,// 是否允许用户改变表格每页显示的记录数
            pageLength: 10,
            searching: false,// 是否允许Datatables开启本地搜索
            paging: true,
            ordering: false,
            autoWidth: false,
            columns: [
                {"data": "CREATE_TIME"},
                {"data": "CNLB"},
                {"data": "DEPT_NAME"},
                {"data": "CN_FILE",
                    "render": function (data, type, row) {
                        log(row)
                        var str = '';
                        if (data) {
                            str = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="downloadFile(\'' + data.uploadFileId + '\')">下载</a>';
                        }
                        return str;
                    }
                },
                {"data" : "STATUS", // 黑名单状态
                    "render" : function(data, type, row) {
                        var str = '';
                        if (data == '0') {
                            str = '未列入';
                        } else if (data == '1') {
                            str = '已列入';
                        } else if (data == '2') {
                            str = '已过期';
                        }
                        return str;
                    }
                }
            ],
            initComplete : function(settings, data) {
                var info = tableXycn.page.info();
                var dataRows = info.recordsTotal;
                if (dataRows != 0) {
                    $("#xycnTs").html(dataRows);
                }
            }
        });

    if($("#czlcId").val()!=''){
        $("#uploadCzlc").show();
        $("#czlcTs").hide();
    }else{
        $("#uploadCzlc").hide();
        $("#czlcTs").show();
    }
    if($("#fwxmId").val()!=''){
        $("#uploadFwxm").show();
        $("#fwxmTs").hide();
    }else{
        $("#uploadFwxm").hide();
        $("#fwxmTs").show();
    }
    return {
        "goBackList": goBackList
    };

})();
