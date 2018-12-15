(function () {

    var validator = $('#submit_form').validateForm({
        desc : {
            required : false,
            maxlength : 100
        },
        //   一、工作组织推进力度（分值：40分）
        score100100 : {
            required : true,
            digits : true,
            range : [0, 2]
        },
        score100101 : {
            required : true,
            digits : true,
            range : [0, 10]
        },
        score100102 : {
            required : true,
            digits : true,
            range : [0, 4]
        },
        score100103 : {
            required : true,
            digits : true,
            range : [0, 14]
        },
        score100104 : {
            required : true,
            digits : true,
            range : [0, 10]
        },
        //  二、向市级公共信用信息平台报送信息（分值：30分）
        score101100 : {
            required : true,
            digits : true,
            range : [0, 2]
        },
        score101101 : {
            required : true,
            digits : true,
            range : [0, 8]
        },
        score101102 : {
            required : true,
            digits : true,
            range : [0, 1]
        },
        score101103 : {
            required : true,
            digits : true,
            range : [0, 6]
        },
        score101104 : {
            required : true,
            digits : true,
            range : [0, 6]
        },
        score101105 : {
            required : true,
            digits : true,
            range : [0, 6]
        },
        score101106 : {
            required : true,
            digits : true,
            range : [0, 1]
        },
        //  三、双公示工作情况（分值：30分）
        score102100 : {
            required : true,
            digits : true,
            range : [0, 12]
        },
        score102101 : {
            required : true,
            digits : true,
            range : [0, 12]
        },
        score102102 : {
            required : true,
            digits : true,
            range : [0, 6]
        },
        //  四、工作创新（加分项，分值：10分）
        score103100 : {
            required : true,
            digits : true,
            range : [0, 6]
        },
        score103101 : {
            required : true,
            digits : true,
            range : [0, 4]
        }
    });

    validator.form();

    $("a.accordion-toggle").click(function () {
        setTimeout(function () {
            validator.form();
        }, 500);
    });

    $("#backBtn,#backBtn2").click(function () {
        $("div#handleDiv").hide();
        $("div#mainListDiv").show();
        var selectArr = recordSelectNullEle();
        $("div#mainListDiv").prependTo('#topDiv');
        callbackSelectNull(selectArr);
        resetIEPlaceholder();
        var activeIndex = recordDtActiveIndex(gl.table);
        gl.table.ajax.reload(function () {
            callbackDtRowActive(gl.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
    });

    $("#bmfj").cclUpload({
        "type" : "file",
        "showList" : true,
        "multiple" : false,
        "supportTypes" : ["doc", "docx", "zip", "rar"]
    });

    //  保存
    $("#saveBtn").click(function () {
        if (!validator.form()) {
            $.alert("表单验证不通过！");
            loadClose();
            return;
        }
        loading();
        govSaveAchievements(function(json) {
            loadClose();
            if (json.result) {
                $.alert("保存成功！", 1, function() {
                    $("#backBtn").click();
                });
            } else {
                $.alert(json.message || "保存失败！", 2);
            }
        });
    });
    
    function govSaveAchievements(callback) {
        var list = [];
        $.each($("textarea.score-input"), function (i, obj) {
            var deptScore = $.trim($(obj).val());
            var deptDesc = $.trim($("textarea.desc-input:eq(" + i + ")").val());
            var id = $(obj).attr("id");
            var kpiItemCode = id.replace("score", "");
            var kpiCode = kpiItemCode.substring(0, 3);
            list.push({
                "kpiCode" : kpiCode,
                "kpiItemCode" : kpiItemCode,
                "deptScore": deptScore,
                "deptDesc": deptDesc
            });
        });
        $.post(ctx + "/achievements/govSaveAchievements.action", {
            "id" : $("#id").val(),
            "kpis" : JSON.stringify(list),
            "bmfjName" : $("input[name='bmfjName']").val(),
            "bmfjPath" : $("input[name='bmfjPath']").val()
        }, function(json) {
            if (callback instanceof Function) {
                callback(json);
            }
        }, "json");
    }

    //  提交
    $("#submitBtn").click(function() {
        if (!validator.form()) {
            $.alert("表单验证不通过！");
            loadClose();
            return;
        }
        layer.confirm("提交后不能修改绩效评分，确认提交吗？", {icon : 3}, function(index) {
            layer.close(index);
            loading();
            govSaveAchievements(function(json) {
                if (json.result) {
                    $("#id").val(json.message);
                    govCommitAchievements();
                } else {
                    loadClose();
                    $.alert(json.message || "提交失败！", 2);
                }
            });
        });
    });

    function govCommitAchievements() {
        $.post(ctx + "/achievements/govCommitAchievements.action", {
            "id" : $("#id").val()
        }, function(json) {
            loadClose();
            if (json.result) {
                $.alert("提交成功！", 1, function() {
                    $("#backBtn").click();
                });
            } else {
                $.alert(json.message || "提交失败！", 2);
            }
        }, "json");
    }

})();