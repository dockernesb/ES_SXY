var zjxxdaAdd = (function () {
    // 组织冒泡事件，防止点击事件和拖动事件冲突
    window.setTimeout(function(){
        try{
            stopBubble();
        }catch(e){

        }
    },1500);
    var zzsxq = {
        elem: '#zzsxq',
        format: 'YYYY-MM-DD',
        max: '2099-12-31',
        istime: false,
        istoday: false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose: function(datas){
            // laydatePH('#zzsxq', datas);
            // zzsxq.max = datas; //结束日选好后，重置开始日的最大日期
            zyzzTableValidator.form();
        }
    };
    laydate(zzsxq);
    var zzjzq = {
        elem: '#zzjzq',
        format: 'YYYY-MM-DD',
        max: '2099-12-31',
        istime: false,
        istoday: false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose: function(datas){
            // laydatePH('#zzjzq', datas);
            // zzjzq.max = datas; //结束日选好后，重置开始日的最大日期
            zyzzTableValidator.form();
        }
    };
    laydate(zzjzq);
    // 返回中介信息档案列表页面
    function goBackList() {
        var selectArr = recordSelectNullEle();
        $("div#fatherDiv").prependTo("#topBox");
        callbackSelectNull(selectArr);
        $("div#fatherDiv").show();
        $("div#childDiv").hide();
    }

    function conditionSearch() {

    }
    function conditionReset() {

    }

    var jbxxXx=true;
    var zyzzXx=false;
    var zyryXx=false;
    var pjdjXx=false;
    var xycnXx=false;
    $("#jbxxXx").show();
    $("#zyzzXx").hide();
    $("#zyryXx").hide();
    $("#pjdjXx").hide();
    $("#xycnXx").hide();
    $("#jbxxDiv").click(function (e) {
        if(jbxxXx){
            $("#jbxxXx").hide();
            jbxxXx=false;
        }else{
            $("#jbxxXx").show();
            jbxxXx=true;
        }
    })
    $("#zyzzDiv").click(function () {
        if(zyzzXx){
            $("#zyzzXx").hide();
            zyzzXx=false;
        }else{
            $("#zyzzXx").show();
            zyzzXx=true;
        }
    })
    $("#zyryDiv").click(function () {
        if(zyryXx){
            $("#zyryXx").hide();
            zyryXx=false;
        }else{
            $("#zyryXx").show();
            zyryXx=true;
        }
    })
    $("#pjdjDiv").click(function () {
        if(pjdjXx){
            $("#pjdjXx").hide();
            pjdjXx=false;
        }else{
            $("#pjdjXx").show();
            pjdjXx=true;
        }
    })
    $("#xycnDiv").click(function () {
        if(xycnXx){
            $("#xycnXx").hide();
            xycnXx=false;
        }else{
            $("#xycnXx").show();
            xycnXx=true;
        }
    })

    // 基本信息校验
    var jbxxTableValidator = $("#jbxxForm").validateForm({
        jgqc: {
            required: true,
            // rangelength:[2,50],//3.1.0 版本号
            // tableName: []
        },
        tyshxydm: {
            required: true,
        },
        zzjgdm: {
            required: true,
        },
        tyshxydm: {
            required: true,
        },
        swJgdm: {
            required: true,
        },
        frdbFzr: {
            required: true,
        },
        jydz: {
            required: true,
        },
        wz: {
            required: true,
        },
        lxdh: {
            required: true,
        },
        deptId: {
            required: true,
        },
        fwsx: {
            required: true,
        },
        sfyj: {
            required: true,
        },
        sfbz: {
            required: true,
        },
        fwxm: {
            required: true,
        },
        czlc: {
            required: true,
        },
        dysp: {
            required: true,
        }
    });
    jbxxTableValidator.form();

    // 执业资质校验
    var zyzzTableValidator = $("#addZyzzForm").validateForm({
        zzZsmc: {
            required: true,
            // rangelength:[2,50],//3.1.0 版本号
            // tableName: []
        },
        zzZsbh: {
            required: true,
        },
        zzDj: {
            required: true,
        },
        xknr: {
            required: true,
        },
        zzsxqTime: {
            required: true,
        },
        zzjzqTime: {
            required: true,
        }
    });
    zyzzTableValidator.form();

    // 执业人员校验
    var zyryTableValidator = $("#addZyryForm").validateForm({
        xm: {
            required: true,
            // rangelength:[2,50],//3.1.0 版本号
            // tableName: []
        },
        sfzh: {
            required: true,
        },
        zzZsmc: {
            required: true,
        },
        zzZsbh: {
            required: true,
        },
        zzDj: {
            required: true,
        }
    });
    zyryTableValidator.form();

    // 评价等级校验
    var pjdjTableValidator = $("#addPjdjForm").validateForm({
        pjjg: {
            required: true,
            // rangelength:[2,50],//3.1.0 版本号
            // tableName: []
        }
    });
    pjdjTableValidator.form();


    //基本信息
    $("#saveJbxx").click(function (e) {
        e.stopPropagation();
        // loading();
        $("#jbxxForm").ajaxSubmit({
            url : ctx + "/sszj/zjxxdaAddData.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg("保存成功", {
                        icon : 1,
                        anim : 1
                    });
                    $("#jbxxId").val(result.message);
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    })

    //执业资质 模板下载
    $("#downLoadZyzz").click(function (e) {
        e.stopPropagation();
        loading();
        window.location.href = CONTEXT_PATH + "/sszj/templateDownloadZyzz.action";
        loadClose();
    })

    //执业资质 批量导入
    $("#leadZyzz").cclUpload({
        supportTypes : [ "xls", "xlsx" ], // 支持的文件类型(文件类型为img时，默认支持"jpg","jpeg","gif","bmp","png")
        callback : function(data) {
            var filePathStr = "";
            var fileNameStr = "";
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    filePathStr += data[i].path + ",";
                    fileNameStr += data[i].name + ",";
                }
                batchAddZyzz(filePathStr, fileNameStr);
            }
        }
    });

    // 批量上传--执业资质
    function batchAddZyzz(filePathStr, fileNameStr) {
        var tyshxydm=$("#tyshxydm").val();
        if(tyshxydm==null || tyshxydm ==''){
            $.alert("请先保存基本信息", 2);
            return;
        }
        loading();
        $.post(CONTEXT_PATH + '/sszj/batchAddZyzz.action', {
            filePathStr : filePathStr,
            fileNameStr : fileNameStr,
            tyshxydm : tyshxydm
        }, function(data) {
            var data = eval('(' + data + ')');
            tableZyzz.ajax.reload();
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

    //手动录入执业资质信息弹出框
    $("#goByHandZyzz").click(function (e) {
        e.stopPropagation();
        var tyshxydm=$("#tyshxydm").val();
        if(tyshxydm==null || tyshxydm==''){
            $.alert("请先保存基本信息", 2);
            return;
        }
        // 手工录入
        $('#addZyzzForm')[0].reset();
        $("#tyshxydmZyzz").val($("#tyshxydm").val());
        zyzzTableValidator.form();
        $.openWin({
            title : '手动录入执业资质',
            content : $("#winAddZyzz"),
            btnAlign : 'c',
            area : [ '600px', '510px' ],
            yes : function(index, layero) {
                manualAddZyzz(index);
            }
        });
    })
    // 手工录入 提交执业资质
    function manualAddZyzz(index) {

        $("#addZyzzForm").ajaxSubmit({
            url : ctx + "/sszj/zyzzAddData.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                    var data = tableZyzz.settings()[0].ajax.data;
                    if (!data) {
                        data = {};
                        table.settings()[0].ajax["data"] = data;
                    }
                    data["tyshxydm"] = $("#tyshxydm").val();
                    tableZyzz.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }

    //执业人员 获取系统
    $("#getZyzz").click(function (e) {
        e.stopPropagation();
        var jgmc=$("#jgqc").val();
        var tyshxydm=$("#tyshxydm").val();
        if(tyshxydm==null || tyshxydm ==''){
            $.alert("请先保存基本信息", 2);
            return;
        }
        if(jgmc==null||jgmc==''){
            $.alert("请先保存基本信息",2);
            return;
        }
        $.post(ctx + "/sszj/getZyzzHqxt.action", {
            "jgmc" : jgmc,
            "tyshxydm" : tyshxydm
        }, function(data) {
            loadClose();
            if (data.result) {
                layer.msg(data.message, {
                    icon : 1,
                    anim : 1
                });
                var data = tableZyzz.settings()[0].ajax.data;
                if (!data) {
                    data = {};
                    table.settings()[0].ajax["data"] = data;
                }
                data["tyshxydm"] = $("#tyshxydm").val();
                tableZyzz.ajax.reload();
            } else {
                $.alert(data.message, 2);
            }
        }, "json");


    })

    //执业人员 模板下载
    $("#downLoadZyry").click(function (e) {
        e.stopPropagation();
        loading();
        window.location.href = CONTEXT_PATH + "/sszj/templateDownloadZyry.action";
        loadClose();
    })
    //执业人员 批量导入
    $("#leadZyry").cclUpload({
        supportTypes : [ "xls", "xlsx" ], // 支持的文件类型(文件类型为img时，默认支持"jpg","jpeg","gif","bmp","png")
        callback : function(data) {
            var filePathStr = "";
            var fileNameStr = "";
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    filePathStr += data[i].path + ",";
                    fileNameStr += data[i].name + ",";
                }
                batchAddZyry(filePathStr, fileNameStr);
            }
        }
    });
    // 批量上传--执业人员
    function batchAddZyry(filePathStr, fileNameStr) {
        var tyshxydm=$("#tyshxydm").val();
        if(tyshxydm==null || tyshxydm ==''){
            $.alert("请先保存基本信息", 2);
            return;
        }
        loading();
        $.post(CONTEXT_PATH + '/sszj/batchAddZyry.action', {
            filePathStr : filePathStr,
            fileNameStr : fileNameStr,
            tyshxydm : tyshxydm
        }, function(result) {
            var result = eval('(' + result + ')');
            var data = tableZyry.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["tyshxydm"] = $("#tyshxydm").val();
            tableZyry.ajax.reload();
            layer.open({
                type : 1, // Page层类型
                area : [ '600px', '400px' ],
                title : '批量导入解析结果',
                shade : 0.6, // 遮罩透明度
                anim : 1, // 0-6的动画形式，-1不开启
                content : '<div style="padding:10px 20px;">' + result.message + '</div>'
            });
            loadClose();
        });
    }

    //执业人员 手动录入
    $("#goByHandZyry").click(function (e) {
        e.stopPropagation();
        // 手工录入
        $('#addZyryForm')[0].reset();
        $("#tyshxydmZyry").val($("#tyshxydm").val());
        zyryTableValidator.form();
        $.openWin({
            title : '手动录入执业人员',
            content : $("#winAddZyry"),
            btnAlign : 'c',
            area : [ '600px', '410px' ],
            yes : function(index, layero) {
                manualAddZyry(index);
            }
        });
    })
    // 手工录入 提交执业人员
    function manualAddZyry(index) {
        $("#addZyryForm").ajaxSubmit({
            url : ctx + "/sszj/zyryAddData.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                    var data = tableZyry.settings()[0].ajax.data;
                    if (!data) {
                        data = {};
                        table.settings()[0].ajax["data"] = data;
                    }
                    data["tyshxydm"] = $("#tyshxydm").val();
                    tableZyry.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }

    //评价等级
    $("#goByHandPjdj").click(function (e) {
        e.stopPropagation();
        // 手工录入
        $('#addPjdjForm')[0].reset();
        $("#tyshxydmPjdj").val($("#tyshxydm").val());
        pjdjTableValidator.form();
        $.openWin({
            title : '手动录入评价等级',
            content : $("#winAddPjdj"),
            btnAlign : 'c',
            area : [ '600px', '410px' ],
            yes : function(index, layero) {
                manualAddPjdj(index);
            }
        });
    })
    // 手工录入 提交评价等级
    function manualAddPjdj(index) {
        $("#addPjdjForm").ajaxSubmit({
            url : ctx + "/sszj/pjdjAddData.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                    var data = tablePjdj.settings()[0].ajax.data;
                    if (!data) {
                        data = {};
                        table.settings()[0].ajax["data"] = data;
                    }
                    data["tyshxydm"] = $("#tyshxydm").val();
                    tablePjdj.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }


    //信用承诺
    $("#goByHandXycn").click(function (e) {
        e.stopPropagation();
        // 手工录入
        $('#addXycnForm')[0].reset();
        $("#tyshxydmXycn").val($("#tyshxydm").val());
        $(".preview-img-panel").children(":first").remove();
        log($(".preview-img-panel").next().length)
        $.openWin({
            title : '手动录入信用承诺',
            content : $("#winAddXycn"),
            btnAlign : 'c',
            area : [ '600px', '410px' ],
            yes : function(index, layero) {
                manualAddXycn(index);
            }
        });
    })
    // 手工录入 提交信用承诺
    function manualAddXycn(index) {
        $("#addXycnForm").ajaxSubmit({
            url : ctx + "/sszj/xycnAddData.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                    var data = tableXycn.settings()[0].ajax.data;
                    if (!data) {
                        data = {};
                        table.settings()[0].ajax["data"] = data;
                    }
                    data["tyshxydm"] = $("#tyshxydm").val();
                    tableXycn.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }


    var tableZyzz = $('#zyzzGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjZyzzList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").val()

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
                {"data": "STATEMC"},
                {"data": "STATE",
                    "render": function (data, type, row) {
                        var opts ="";
                        if(data=='1'){
                            opts +=   "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='zjxxdaAdd.updateZyzz(\"" + row.ID + "\")'>修改</a>";
                            opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='zjxxdaAdd.deleteZyzz(\"" + row.ID + "\", \"0\")'>删除</a>";
                        }
                        return opts;
                    }
                }]
        });
    var tableZyry = $('#zyryGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjZyryList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").val()

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
                {"data": "STATE"},
                {"data": "STATE",
                "render": function (data, type, row) {
                    var opts = "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='zjxxdaAdd.updateZyry(\"" + row.ID + "\")'>修改</a>";
                    opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='zjxxdaAdd.deleteZyry(\"" + row.ID + "\", \"0\")'>删除</a>";
                    return opts;
                }
            }]
        });
    var tablePjdj = $('#pjdjGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjPjdjList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").val()

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
                {"data": "PJND"},
                {"data": null,
                    "render": function (data, type, row) {
                        var opts ="<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='zjxxdaAdd.updatePjdj(\"" + row.ID + "\")'>修改</a>";
                            opts += "<a href='javascript:void(0);' class='opbtn btn btn-xs green-meadow' onclick='zjxxdaAdd.deletePjdj(\"" + row.ID + "\", \"0\")'>删除</a>";
                        return opts;
                    }
                }]
        });
    var tableXycn = $('#xycnGrid').DataTable(// 创建一个Datatable
        {
            ajax: {
                url: CONTEXT_PATH + "/sszj/getSszjXycnList.action",
                type: 'post',
                data: {
                    "tyshxydm": $("#tyshxydm").val()

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
                            var str = '';
                            if (data) {
                                str = '<a href="javascript:;" class="opbtn btn btn-xs green-meadow" onclick="zjxxdaAdd.viewPdf(\'' + data.uploadFileId + '\')">预览</a>';
                                str += '<a href="javascript:;" class="opbtn btn btn-xs red" onclick="zjxxdaAdd.deleteFileInfo(\'' + data.uploadFileId + '\', \'' + data.businessId + '\')">删除</a>';
                            } else {
                                str = '<a href="javascript:;" class="opbtn btn btn-xs blue uploadPdf" id="' + row.ID + '">上传</a>&nbsp;&nbsp;';
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
            initComplete : function(settings, json) {
                addUploadBtnListener();
            },
            drawCallback : function(settings, json) {
                addUploadBtnListener();
            }
        });

    // 在线预览PDF
    function viewPdf(uploadFileId) {
        var url = ctx + "/common/viewPdf.action?uploadFileId=" + uploadFileId;
        window.open(url, uploadFileId);
    }

    function addUploadBtnListener() {
        $("a.uploadPdf").uploadFile({
            supportTypes : ["pdf"],
            showList : false,
            multiple : false,
            callback : function(fileInfo, $self) {
                if (fileInfo.success.length > 0) {
                    saveXycnFileInfo(fileInfo, $self);
                }
            }
        });
    }

    //	保存信用承诺文件信息
    function saveXycnFileInfo(fileInfo, $self) {
        loading();
        $.post(ctx + "/sszj/saveXycnFileInfo.action", {
            "businessId" : $self.attr("id"),
            "fileName" : fileInfo.success[0].name,
            "filePath" : fileInfo.success[0].path,
            "icon" : fileInfo.success[0].icon
        }, function(result) {
            loadClose();
            conditionSearch();
            if (result.result) {
                layer.msg("操作成功！", {
                    icon : 1,
                    anim : 1
                });
                var data = tableXycn.settings()[0].ajax.data;
                if (!data) {
                    data = {};
                    table.settings()[0].ajax["data"] = data;
                }
                data["tyshxydm"] = $("#tyshxydm").val();
                tableXycn.ajax.reload();
            } else {
                $.alert(result.message, 2);
            }
        }, "json");
    }


    //	删除信用承诺文件信息
    function deleteFileInfo(uploadFileId, businessId) {
        layer.confirm("确定删除承诺附件吗？", {
            icon : 3,
        }, function(index) {
            loading();
            $.post(ctx + "/sszj/deleteXycnFileInfo.action", {
                "uploadFileId" : uploadFileId,
                "businessId" : businessId
            }, function(result) {
                loadClose();
                conditionSearch();
                if (result.result) {
                    layer.msg("操作成功！", {
                        icon : 1,
                        anim : 1
                    });
                    var data = tableXycn.settings()[0].ajax.data;
                    if (!data) {
                        data = {};
                        table.settings()[0].ajax["data"] = data;
                    }
                    data["tyshxydm"] = $("#tyshxydm").val();
                    tableXycn.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            }, "json");
        });
    }

    //删除执业资质列表对应数据
    function deleteZyzz(id) {
        $.post(ctx + "/sszj/deleteZyzz.action", {
            "id" : id,
        }, function(data) {
            loadClose();
            if (data.result) {
                layer.msg(data.message, {
                    icon : 1,
                    anim : 1
                });
                tableZyzz.ajax.reload();
            } else {
                $.alert(data.message, 2);
            }
        }, "json");
    }
    //修改执业资质列表对应数据
    function updateZyzz(id) {

        $('#addZyzzForm')[0].reset();
        $.post(ctx + "/sszj/getOneZyzzById.action", {
            "id" : id,
        }, function(data) {
            if (data.id!=null) {
                $("#idZyzz").val(data.id);
                $("#tyshxydmZyzz").val(data.tyshxydm);
                $("#zzzsmcZyzz").val(data.zzZsmc);
                $("#zzzsbhZyzz").val(data.zzZsbh);
                $("#zzdjZyzz").val(data.zzDj);
                $("#xknr").val(data.xknr);
                $("#zzsxq").val(data.zzsxqTime.substring(0,10));
                $("#zzjzq").val(data.zzjzqTime.substring(0,10));
                $("#createTimeZyzz").val(data.createTime.substring(0,10));
                $("#createIdZyzz").val(data.createId);
                $("#stateZyzz").val(data.state);
                $.openWin({
                    title : '修改信用资质',
                    content : $("#winAddZyzz"),
                    btnAlign : 'c',
                    area : [ '600px', '410px' ],
                    yes : function(index, layero) {
                        manualUpdateXyzz(index);
                    }
                });
            } else {
                $.alert("未查到该条数据", 2);
            }
        }, "json");
    }
    function manualUpdateXyzz() {
        $("#addZyzzForm").ajaxSubmit({
            url : ctx + "/sszj/updateZyzz.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                    tableZyzz.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }

    //删除执业人员列表对应数据
    function deleteZyry(id) {
        $.post(ctx + "/sszj/deleteZyry.action", {
            "id" : id,
        }, function(data) {
            loadClose();
            if (data.result) {
                layer.msg(data.message, {
                    icon : 1,
                    anim : 1
                });
                tableZyry.ajax.reload();
            } else {
                $.alert(data.message, 2);
            }
        }, "json");
    }
    //修改执业人员列表对应数据
    function updateZyry(id) {

        $('#addZyryForm')[0].reset();
        $.post(ctx + "/sszj/getOneZyryById.action", {
            "id" : id,
        }, function(data) {
            if (data.id!=null) {
                $("#idZyry").val(data.id);
                $("#tyshxydmZyry").val(data.tyshxydm);
                $("#xm").val(data.xm);
                $("#sfzh").val(data.sfzh);
                $("#zzzsmcZyry").val(data.zzZsmc);
                $("#zzzsbhZyry").val(data.zzZsbh);
                $("#zzdjZyry").val(data.zzDj);

                $.openWin({
                    title : '修改信用资质',
                    content : $("#winAddZyry"),
                    btnAlign : 'c',
                    area : [ '600px', '410px' ],
                    yes : function(index, layero) {
                        manualUpdateXyry(index);
                    }
                });
            } else {
                $.alert("未查到该条数据", 2);
            }
        }, "json");
    }
    function manualUpdateXyry() {
        $("#addZyryForm").ajaxSubmit({
            url : ctx + "/sszj/updateZyry.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                    tableZyry.ajax.reload();
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }

    //删除评价等级列表对应数据
    function deletePjdj(id) {
        $.post(ctx + "/sszj/deletePjdj.action", {
            "id" : id,
        }, function(data) {
            loadClose();
            if (data.result) {
                layer.msg(data.message, {
                    icon : 1,
                    anim : 1
                });
                tablePjdj.ajax.reload();
            } else {
                $.alert(data.message, 2);
            }
        }, "json");
    }
    //修改评价等级列表对应数据
    function updatePjdj(id) {

        $('#addPjdjForm')[0].reset();
        $.post(ctx + "/sszj/getOnePjdjById.action", {
            "id" : id,
        }, function(data) {
            if (data.id!=null) {
                $("#idPjdj").val(data.id);
                $("#tyshxydmPjdj").val(data.tyshxydm);
                $("#pjnd").val(data.pjnd);
                $("#pjdj").val(data.pjdj);
                $("#pjjg").val(data.pjjg);
                $.openWin({
                    title : '修改信用资质',
                    content : $("#winAddPjdj"),
                    btnAlign : 'c',
                    area : [ '600px', '410px' ],
                    yes : function(index, layero) {
                        manualUpdatePjdj(index);
                    }
                });
            } else {
                $.alert("未查到该条数据", 2);
            }
        }, "json");
    }
    function manualUpdatePjdj() {
        $("#addPjdjForm").ajaxSubmit({
            url : ctx + "/sszj/updatePjdj.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    tablePjdj.ajax.reload();
                    layer.msg(result.message, {
                        icon : 1,
                        anim : 1
                    });
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    }

    $("#uploadCzlc").cclUpload({
        supportTypes : ["jpg","png", "pdf"],
        showList : false,
        multiple : false,
        callback : function(fileInfo, $self) {
            if (fileInfo.length > 0) {
                saveJbxxFileInfo(fileInfo, $self,'czlc');
            }
        }
    });

    $("#uploadFwxm").cclUpload({
        supportTypes : ["jpg","png", "pdf"],
        showList : false,
        multiple : false,
        callback : function(fileInfo, $self) {
            if (fileInfo.length > 0) {
                saveJbxxFileInfo(fileInfo, $self,'fwxm');

            }
        }
    });

    //保存涉审中介附件信息
    function saveJbxxFileInfo(fileInfo, $self,type) {
        loading();
        $.post(ctx + "/sszj/saveJbxxFileInfo.action", {
            "businessId" : $("#jbxxId").val(),
            "fileType" :type,
            "fileName" : fileInfo[0].name,
            "filePath" : fileInfo[0].path,
            "icon" : fileInfo[0].icon
        }, function(result) {
            loadClose();
            conditionSearch();
            if (result.result) {
                layer.msg("操作成功！", {
                    icon : 1,
                    anim : 1
                });
                if(type=='czlc'){
                    $("#fileBusinessIdCzlc").val(result.message);
                    $("#uploadCzlc").hide();
                    $("#uploadCzlc").next().hide();
                    $("#deleteCzlc").show();
                }else if(type=='fwxm'){
                    $("#fileBusinessIdFwxm").val(result.message);
                    $("#uploadFwxm").hide();
                    $("#uploadFwxm").next().hide();
                    $("#deleteFwxm").show();
                }
            } else {
                $.alert(result.message, 2);
            }
        }, "json");
    }

    $("#deleteCzlc").click(function () {
        layer.confirm("确定删除操作流程附件吗？", {
            icon : 3,
        }, function(index) {
            loading();
            $.post(ctx + "/sszj/deleteJbxxFileInfo.action", {
                "fileType" : 'czlc',
                "businessId" : $("#fileBusinessIdCzlc").val()
            }, function(result) {
                loadClose();
                conditionSearch();
                if (result.result) {
                    layer.msg("操作成功！", {
                        icon : 1,
                        anim : 1
                    });
                    // $("#uploadCzlc").show();
                    $("#uploadCzlc").next().show();
                    $("#deleteCzlc").hide();
                } else {
                    $.alert(result.message, 2);
                }
            }, "json");
        });
    })

    $("#deleteFwxm").click(function () {
        layer.confirm("确定删除服务项目附件吗？", {
            icon : 3,
        }, function(index) {
            loading();
            $.post(ctx + "/sszj/deleteJbxxFileInfo.action", {
                "fileType" : 'fwxm',
                "businessId" : $("#fileBusinessIdFwxm").val()
            }, function(result) {
                loadClose();
                conditionSearch();
                if (result.result) {
                    layer.msg("操作成功！", {
                        icon : 1,
                        anim : 1
                    });
                    $("#fileBusinessIdFwxm").val(result.message);
                    // $("#uploadFwxm").show();
                    $("#uploadFwxm").next().show();
                    $("#deleteFwxm").hide();
                } else {
                    $.alert(result.message, 2);
                }
            }, "json");
        });
    })

    if($("#czlcFj").val()!=''){
        $("#fileBusinessIdCzlc").val($("#czlcFj").val());
        $("#uploadCzlc").next().hide();
        $("#deleteCzlc").show();
    }
    if($("#fwxmFj").val()!=''){
        $("#fileBusinessIdFwxm").val($("#fwxmFj").val());
        $("#uploadFwxm").next().hide();
        $("#deleteFwxm").show();
    }

    $("#uploadImgCnlb").cclUpload({
        "supportTypes" : ["jpg", "png", "pdf"],
        "type" : "file",
        "showList" : true,
        "multiple" : false,
        "isExamine" : true
    });

    return {
        // "showDetail": showDetail,
        // "changeLicensingStatus": changeLicensingStatus,
        "conditionSearch": conditionSearch,
        "conditionReset": conditionReset,
        "goBackList": goBackList,
        "updateZyzz":updateZyzz,
        "deleteZyzz":deleteZyzz,
        "updateZyry":updateZyry,
        "deleteZyry":deleteZyry,
        "updatePjdj":updatePjdj,
        "deletePjdj":deletePjdj,
        "deleteFileInfo" : deleteFileInfo,
        "viewPdf" : viewPdf
    };

})();
