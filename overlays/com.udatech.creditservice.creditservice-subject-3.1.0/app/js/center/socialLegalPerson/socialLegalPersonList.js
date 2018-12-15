var legalPerson = (function () {
    var qylx = '';
    $.getJSON(ctx + "/creditCommon/getIndustry.action", function (result) {
        // 初始下拉框
        $("#shhymc").select2({
            placeholder: '行业类别',
            allowClear: false,
            language: 'zh-CN',
            data: result
        });
        $('#shhymc').val(null).trigger("change");
        resizeSelect2('#shhymc');
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });

    $.getJSON(ctx + "/center/socialLegalPerson/getQylxSelect.action", function (result) {
        // 初始下拉框
        $("#qylxSelect").select2({
            placeholder: '企业类型',
            allowClear: false,
            language: 'zh-CN',
            data: result
        });
        $('#qylxSelect').val(null).trigger("change");
        resizeSelect2('#qylxSelect');
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });

    // 时间框
    var start = {
        elem: '#zcsjs',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        min: '1900-01-01', // 最小日期
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#zcsjs', datas);
            end.min = datas; // 开始日选好后，重置结束日的最小日期
            end.start = datas // 将结束日的初始值设定为开始日
        }
    };
    var end = {
        elem: '#zcsjz',
        format: 'YYYY-MM-DD',
        max: '2099-12-30', // 最大日期
        min: '1900-01-01', // 最小日期
        istoday: false,// 是否显示今天
        isclear: false, // 是否显示清空
        issure: false, // 是否显示确认
        choose: function (datas) {
            laydatePH('#zcsjz', datas);
            start.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);

    // 表格加载数据
    var table = $('#legalPersonGrid').DataTable({
        ajax: {
            url: CONTEXT_PATH + '/center/socialLegalPerson/queryList.action',
            type: 'post'
        },
        serverSide: true,// 如果是服务器方式，必须要设置为true
        processing: false,// 设置为true,就会有表格加载时的提示
        lengthChange: true,// 是否允许用户改变表格每页显示的记录数
        pageLength: 10,
        searching: false,// 是否允许Datatables开启本地搜索
        paging: true,
        ordering: false,
        autoWidth: false,
        columns: [{
            "data": "QYMC"
        }, {
            "data": "SHXYDM"
        }, {
            "data": "ZZJGDM",
            "visible": false
        }, {
            "data": "GSZCH",
            "visible": false
        }, {
            "data": "ZCRQ"
        }, {
            "data": "FDDBR"
        }, {
            "data": "SSHYMC"
        }, {
            "data": "QYLXMC"
        }, {
            "data": "ZCZJ",
            "render": function (data, type, row) {
                if (isNull(data)) {
                    return data;
                } else {
                    return data + "万";
                }
            },
            "visible": false
        }, {
            "data": null,
            "render": function (data, type, row) {
                var str = '';
                str += '<button type="button" class="btn green btn-xs" onclick="legalPerson.toView(\'' + row.ID + '\', this);">查看</button>';
                return str;
            }
        }],
        preDrawCallback: function (settings) {
            loading();
        },
        drawCallback: function (settings) {
            loadClose();
        },
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
                column.visible(!column.visible());
            });
        }
    });

    $('#legalPersonGrid tbody').on('click', 'tr', function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            table.$('tr.active').removeClass('active');
            $(this).addClass('active');
        }
    });

    // 查看详细
    function toView(id, _this) {
        addDtSelectedStatus(_this);
        var url = CONTEXT_PATH + '/center/socialLegalPerson/toView.action?id=' + id;
        $("div#childBox").html("");
        $("div#childBox").load(url);
        $("div#childBox").show();
        $("div#parentBox").hide();
        $("div#childBox").prependTo("#topBox");
        resetIEPlaceholder();
    }

    // 信用图谱
    function toCreditCubic(id) {
        var url = ctx + "/center/creditCubic/toCreditAtlas.action?isOpen=1&qyid=" + id;
        var index = layer.open({
            type: 2,
            area: ['1024px', '600px'],
            content: url,
            title: '信用图谱',
            maxmin: false
        });
        layer.full(index);
    }

    function findByQylx(obj) {
        if (!isNull(obj)) {
            if ($(obj).hasClass("yellow")) {
                $(obj).removeClass("yellow");
                qylx = '';
            } else {
                $(obj).parent().children().removeClass("yellow");
                $(obj).addClass("yellow");
                qylx = $.trim($(obj).html());
            }
        } else {
            qylx = '';
        }
        conditionSearch();
    }

    // 查询按钮
    function conditionSearch() {
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }

            data["qylx"] = qylx;
            data["qymc"] = $.trim($('#qymc').val());
            data["zzjgdm"] = $.trim($('#zzjgdm').val());
            data["gszch"] = $.trim($('#gszch').val());
            data["shxydm"] = $.trim($('#shxydm').val());
            data["zcsjs"] = $.trim($('#zcsjs').val());
            data["zcsjz"] = $.trim($('#zcsjz').val());
            data["sshydm"] = $.trim($('#shhymc').val());
            data["qylxSelect"] = $.trim($('#qylxSelect').val());
            table.ajax.reload();
        }
    }

    // 重置
    function conditionReset() {
        $(".qylxDiv").children().removeClass("yellow");
        qylx = "";
        resetSearchConditions('#qymc,#zzjgdm,#gszch,#shxydm,#zcsjs,#zcsjz,#shhymc,#qylxSelect');
        resetDate(start, end);
    }

    return {
        "toView": toView,
        "toCreditCubic": toCreditCubic,
        "findByQylx": findByQylx,
        "conditionSearch": conditionSearch,
        "conditionReset": conditionReset
    }

})();