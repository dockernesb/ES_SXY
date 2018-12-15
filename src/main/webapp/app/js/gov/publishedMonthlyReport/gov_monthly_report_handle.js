(function () {

    $("#backBtn,#backBtn2").click(function() {
        $("div#handleDiv").hide();
        $("div#mainListDiv").show();
        var selectArr = recordSelectNullEle();
        $("div#mainListDiv").prependTo('#topDiv');
        callbackSelectNull(selectArr);
        resetIEPlaceholder();
        var activeIndex = recordDtActiveIndex(gl.table);
        gl.table.ajax.reload(function(){
            callbackDtRowActive(gl.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
        gl.tableSum.ajax.reload(function(){
            callbackDtRowActive(gl.tableSum);
        }, false);
    });

    var month = {
        elem: '#month',
        format: 'YYYY-MM',
        max: '2099-12', //最大日期
        istime: false,
        istoday: false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose: function(datas){

        }
    };
    laydate(month);

    var validator = $('#submit_form').validateForm({
        month : {
            required : true
        },
        webUrl : {
            required : true,
            url : true
        },
        xzxkCssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzcfCssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzxkBdwgssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzcfBdwgssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzxkBssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzcfBssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzxkWbssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzcfWbssl : {
            required : true,
            digits : true,
            range : [0, 999999999999]
        },
        xzxkWbsyj : {
            maxlength : 1000
        },
        xzcfWbsyj : {
            maxlength : 1000
        }
    });

    validator.form();

    $("#submitBtn").click(function() {
        if (!validator.form()) {
            $.alert("表单验证不通过！");
            return;
        }
        loading();
        $("#submit_form").ajaxSubmit({
            url : ctx + "/publishedMonthlyReport/saveMonthlyReport.action",
            success : function(result) {
                loadClose();
                if (result.result) {
                    $.alert(result.message, 1, function() {
                        $("#backBtn").click();
                    });
                } else {
                    $.alert(result.message, 2);
                }
            },
            dataType : "json"
        });
    });

})();