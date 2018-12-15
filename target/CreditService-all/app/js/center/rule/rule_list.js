(function () {
    var currentICheck = '0';
    $('.iCheck input').on('ifChecked ', function () {
        currentICheck = $('.iCheck input:checked').val();
        if (currentICheck === '0') {
            $('#table0').removeClass('hidden');
            $('#table1').addClass("hidden");
            $('#table2').addClass("hidden");
            $('#table3').addClass("hidden");
            $('#table4').addClass("hidden");
            $('#table5').addClass("hidden");
        } else if (currentICheck === '1') {
            $('#table1').removeClass('hidden');
            $('#table0').addClass("hidden");
            $('#table2').addClass("hidden");
            $('#table3').addClass("hidden");
            $('#table4').addClass("hidden");
            $('#table5').addClass("hidden");
        } else if (currentICheck === '2') {
            $('#table2').removeClass('hidden');
            $('#table1').addClass("hidden");
            $('#table0').addClass("hidden");
            $('#table3').addClass("hidden");
            $('#table4').addClass("hidden");
            $('#table5').addClass("hidden");
        } else if (currentICheck === '3') {
            $('#table3').removeClass('hidden');
            $('#table1').addClass("hidden");
            $('#table0').addClass("hidden");
            $('#table2').addClass("hidden");
            $('#table4').addClass("hidden");
            $('#table5').addClass("hidden");
        } else if(currentICheck === '4'){
            $('#table4').removeClass('hidden');
            $('#table1').addClass("hidden");
            $('#table0').addClass("hidden");
            $('#table2').addClass("hidden");
            $('#table3').addClass("hidden");
            $('#table5').addClass("hidden");
        } else if(currentICheck === '5'){
            $('#table5').removeClass('hidden');
            $('#table1').addClass("hidden");
            $('#table0').addClass("hidden");
            $('#table2').addClass("hidden");
            $('#table3').addClass("hidden");
            $('#table4').addClass("hidden");
        }
    }).iCheck({
        labelHover: false,
        cursor: true,
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-blue',
        increaseArea: '20%'
    });


    var validator0 = $("#ruleForm0").validateForm({
        "ruleName": {
            required: true,
            maxlength: 200
        },
        "pattern": {
            required: true,
            pattern: [],
            maxlength: 600
        },
        "msg": {
            required: true,
            maxlength: 200
        }
    });

    var validator1 = $("#ruleForm1").validateForm({
        "ruleName": {
            required: true,
            maxlength: 200
        },
        "pluginClassName": {
            required: true,
            maxlength: 100
        },
        "pluginMethodName": {
            required: true,
            maxlength: 100
        },
        "msg": {
            required: true,
            maxlength: 200
        }
    });

    var validator2 = $("#ruleForm2").validateForm({
        "ruleName": {
            required: true,
            maxlength: 200
        },
        "defaultValue": {
            required: true,
            maxlength: 500
        },
        "msg": {
            required: true,
            maxlength: 200
        }
    });

    var validator3 = $("#ruleForm3").validateForm({
        "ruleName": {
            required: true,
            maxlength: 200
        },
        "msg": {
            required: true,
            maxlength: 200
        }
    });
    var validator4 = $("#ruleForm4").validateForm({
        "ruleName": {
            required: true,
            maxlength: 200
        },
        "msg": {
            required: true,
            maxlength: 200
        }
    });
    var validator5 = $("#ruleForm5").validateForm({
        "ruleName": {
            required: true,
            maxlength: 200
        },
        "msg": {
            required: true,
            maxlength: 200
        }
    });
    $.post(ctx + "/rule/getRuleList.action", function (data) {
        if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                var rule = data[i];
                var ruleType = rule.ruleType;
                if (ruleType === '0') {
                    newRule0(rule);
                } else if (ruleType === '1') {
                    newRule1(rule);
                } else if (ruleType === '2') {
                    newRule2(rule);
                } else if (ruleType === '3') {
                    newRule3(rule);
                } else if(ruleType === '4'){
                    newRule4(rule);
                } else if(ruleType === '5'){
                    newRule5(rule);
                }
            }
        }
    }, "json");

    //	新增规则
    function newRule0(rule) {
        var $rule = $("#oneRule0").clone();
        $rule.removeAttr("id");
        $rule.find(".test").attr("name", random.getName());

        if (rule) {
            $rule.find(".id").val(rule.id);
            $rule.find(".type").val(1);
            $rule.find(".pattern").val(rule.pattern);
            $rule.find(".msg").val(rule.msg);
            $rule.find(".ruleName").val(rule.ruleName);
            $rule.find(".userType").attr("id", "userType" + rule.id);
        } else {
            $rule.find(".ruleName").trigger("focus");
        }

        $("#ruleList0").append($rule);
        addListener($rule, '0');

        if (rule) {
            $('#userType' + rule.id).val(rule.userType);
            afterSaveRule($rule, '0');
        }
        validator0.form();
    }

    function newRule1(rule) {
        var $rule = $("#oneRule1").clone();
        $rule.removeAttr("id");

        if (rule) {
            $rule.find(".id").val(rule.id);
            $rule.find(".type").val(1);
            $rule.find(".pluginClassName").val(rule.pluginClassName);
            $rule.find(".pluginMethodName").val(rule.pluginMethodName);
            $rule.find(".msg").val(rule.msg);
            $rule.find(".ruleName").val(rule.ruleName);
            $rule.find(".userType").attr("id", "userType" + rule.id);
        } else {
            $rule.find(".ruleName").trigger("focus");
        }

        $("#ruleList1").append($rule);

        addListener($rule, '1');
        if (rule) {
            $('#userType' + rule.id).val(rule.userType);
            afterSaveRule($rule, '1');
        }
        validator1.form();
    }

    function newRule2(rule) {
        var $rule = $("#oneRule2").clone();
        $rule.removeAttr("id");
        if (rule) {
            $rule.find(".id").val(rule.id);
            $rule.find(".type").val(1);
            $rule.find(".defaultValue").val(rule.defaultValue);
            $rule.find(".msg").val(rule.msg);
            $rule.find(".ruleName").val(rule.ruleName);
            $rule.find(".userType").attr("id", "userType" + rule.id);
        } else {
            $rule.find(".ruleName").trigger("focus");
        }

        $("#ruleList2").append($rule);

        addListener($rule, '2');
        if (rule) {
            $('#userType' + rule.id).val(rule.userType);
            afterSaveRule($rule, '2');
        }

        validator2.form();
    }

    function newRule3(rule) {
        var $rule = $("#oneRule3").clone();
        $rule.removeAttr("id");
        if (rule) {
            $rule.find(".id").val(rule.id);
            $rule.find(".type").val(1);
            $rule.find(".msg").val(rule.msg);
            $rule.find(".ruleName").val(rule.ruleName);
            $rule.find(".userType").attr("id", "userType" + rule.id);
        } else {
            $rule.find(".ruleName").trigger("focus");
        }

        $("#ruleList3").append($rule);

        addListener($rule, '3');
        if (rule) {
            $('#userType' + rule.id).val(rule.userType);
            afterSaveRule($rule, '3');
        }

        validator3.form();
    }
    function newRule4(rule) {
        var $rule = $("#oneRule4").clone();
        $rule.removeAttr("id");
        if (rule) {
            $rule.find(".id").val(rule.id);
            $rule.find(".type").val(1);
            $rule.find(".msg").val(rule.msg);
            $rule.find(".ruleName").val(rule.ruleName);
            $rule.find(".userType").attr("id", "userType" + rule.id);
        } else {
            $rule.find(".ruleName").trigger("focus");
        }

        $("#ruleList4").append($rule);

        addListener($rule, '4');
        if (rule) {
            $('#userType' + rule.id).val(rule.userType);
            afterSaveRule($rule, '4');
        }

        validator4.form();
    }
    function newRule5(rule) {
        var $rule = $("#oneRule5").clone();
        $rule.removeAttr("id");
        if (rule) {
            $rule.find(".id").val(rule.id);
            $rule.find(".type").val(1);
            $rule.find(".msg").val(rule.msg);
            $rule.find(".ruleName").val(rule.ruleName);
            $rule.find(".userType").attr("id", "userType" + rule.id);
        } else {
            $rule.find(".ruleName").trigger("focus");
        }

        $("#ruleList5").append($rule);

        addListener($rule, '5');
        if (rule) {
            $('#userType' + rule.id).val(rule.userType);
            afterSaveRule($rule, '5');
        }

        validator5.form();
    }

    $("#newBtn").click(function () {
        if (currentICheck === '0') {
            newRule0();
        } else if (currentICheck === '1') {
            newRule1();
        } else if (currentICheck === '2') {
            newRule2();
        } else if (currentICheck === '3') {
            newRule3();
        } else if(currentICheck === '4'){
            newRule4();
        } else if(currentICheck === '5'){
            newRule5();
        }
    });

    //		添加事件监听
    function addListener($rule, ruleType) {
        $rule.find(".edit-rule").click(function () {
            editRule($rule, ruleType);
        });
        $rule.find(".cancel-rule").click(function () {
            cancelEditRule($rule, ruleType);
        });
        $rule.find(".save-rule").click(function () {
            saveRule($rule, ruleType);
        });
        $rule.find(".del-rule").click(function () {
            deleteRule($rule, ruleType);
        });
        $rule.hover(function () {
            $rule.css("background-color", "#F5F5F5");
        }, function () {
            $rule.css("background-color", "transparent");
        });
    }

    //		编辑规则
    function editRule($rule, ruleType) {
        var $ruleName = $rule.find(".ruleName");
        var $msg = $rule.find(".msg");
        var $userType = $rule.find(".userType");
        //	备份
        $rule.data("ruleName", $ruleName.val());
        $rule.data("msg", $msg.val());
        $rule.data("userType", $userType.val());
        //	打开编辑状态
        $ruleName.removeAttr("readonly");
        $msg.removeAttr("readonly");
        $userType.removeAttr('disabled');
        if (ruleType === '0') {
            var $pattern = $rule.find(".pattern");
            var $test = $rule.find(".test");
            $rule.data("pattern", $pattern.val());
            $pattern.removeAttr("readonly");
            $test.attr("readonly", "readonly");

        } else if (ruleType === '1') {
            var $pluginClassName = $rule.find(".pluginClassName");
            var $pluginMethodName = $rule.find(".pluginMethodName");
            $rule.data("pluginClassName", $pluginClassName.val());
            $rule.data("pluginMethodName", $pluginMethodName.val());
            $pluginClassName.removeAttr("readonly");
            $pluginMethodName.removeAttr("readonly");

        } else if (ruleType === '2') {
            var $defaultValue = $rule.find(".defaultValue");
            $rule.data("defaultValue", $defaultValue.val());
            $defaultValue.removeAttr("readonly");
        }

        $rule.find(".edit-rule").hide();
        $rule.find(".save-rule").show();
        $rule.find(".cancel-rule").show();

    }

    //		取消编辑
    function cancelEditRule($rule, ruleType) {
        var $ruleName = $rule.find(".ruleName");
        var $msg = $rule.find(".msg");
        var $userType = $rule.find(".userType");
        //	恢复成备份的值
        $ruleName.val($rule.data("ruleName"));
        $msg.val($rule.data("msg"));
        $userType.val($rule.data("userType"));
        if (ruleType === '0') {
            var $pattern = $rule.find(".pattern");
            $pattern.val($rule.data("pattern"));
            validator0.form();


        } else if (ruleType === '1') {
            var $pluginClassName = $rule.find(".pluginClassName");
            var $pluginMethodName = $rule.find(".pluginMethodName");
            $pluginClassName.val($rule.data("pluginClassName"));
            $pluginMethodName.val($rule.data("pluginMethodName"));
            validator1.form();

        } else if (ruleType === '2') {
            var $defaultValue = $rule.find(".defaultValue");
            $defaultValue.val($rule.data("defaultValue"));
            validator2.form();
        } else if (ruleType === '3') {
            validator3.form();
        } else if(ruleType === '4'){
            validator4.form();
        } else if(ruleType === '5'){
            validator5.form();
        }

        afterSaveRule($rule, ruleType);


    }

    //		保存规则
    function saveRule($rule, ruleType) {
        if (checkRule($rule, ruleType)) {
            loading();
            $.post(ctx + "/rule/saveRule.action", {
                "id": $rule.find(".id").val(),
                "type": $rule.find(".type").val(),
                "msg": encodeURIComponent($rule.find(".msg").val()),
                "ruleName": encodeURIComponent($rule.find(".ruleName").val()),
                "pattern": encodeURIComponent($rule.find(".pattern").val()) !== 'undefined' ? encodeURIComponent($rule.find(".pattern").val()) : '',
                "ruleType": $rule.find(".ruleType").val(),
                "userType": /*$rule.find(".userType").val(),*/ '0',
                "pluginClassName": encodeURIComponent($rule.find(".pluginClassName").val()) !== 'undefined' ? encodeURIComponent($rule.find(".pluginClassName").val()) : '',
                "pluginMethodName": encodeURIComponent($rule.find(".pluginMethodName").val()) !== 'undefined' ? encodeURIComponent($rule.find(".pluginMethodName").val()) : '',
                "defaultValue": encodeURIComponent($rule.find(".defaultValue").val()) !== 'undefined' ? encodeURIComponent($rule.find(".defaultValue").val()) : ''
            }, function (data) {
                loadClose();
                if (data.result) {
                    $.alert('保存成功！', 1);
                    $rule.find(".type").val(1);
                    $rule.find(".id").val(data.message);
                    afterSaveRule($rule, ruleType);
                } else {
                    $.alert(data.message || '', 2);
                }
            }, "json");
        }
    }

    //		保存前的校验
    function checkRule($rule, ruleType) {
        var $ruleName = $rule.find(".ruleName");
        var ruleName = $.trim($ruleName.val());
        $ruleName.val(ruleName);

        var $msg = $rule.find(".msg");
        var msg = $.trim($msg.val());
        $msg.val(msg);

        if (ruleType === '0') {

            var $pattern = $rule.find(".pattern");
            var pattern = $.trim($pattern.val());
            $pattern.val(pattern);

            validator0.form();

            var ruleNameValid0 = validator0.element($ruleName);
            if (!ruleNameValid0) {
                $ruleName.trigger("focus");
                return false;
            }

            var ruleNameValid0 = validator0.element($pattern);
            if (!ruleNameValid0) {
                $pattern.trigger("focus");
                return false;
            }

            var ruleNameValid0 = validator0.element($msg);
            if (!ruleNameValid0) {
                $msg.trigger("focus");
                return false;
            }
        } else if (ruleType === '1') {

            var $pluginClassName = $rule.find(".pluginClassName");
            var pluginClassName = $.trim($pluginClassName.val());
            $pluginClassName.val(pluginClassName);

            var $pluginMethodName = $rule.find(".pluginMethodName");
            var pluginMethodName = $.trim($pluginMethodName.val());
            $pluginMethodName.val(pluginMethodName);

            validator1.form();

            var ruleNameValid1 = validator1.element($ruleName);
            if (!ruleNameValid1) {
                $ruleName.trigger("focus");
                return false;
            }

            var ruleNameValid1 = validator1.element($msg);
            if (!ruleNameValid1) {
                $msg.trigger("focus");
                return false;
            }

            var ruleNameValid1 = validator1.element($pluginClassName);
            if (!ruleNameValid1) {
                $pluginClassName.trigger("focus");
                return false;
            }

            var ruleNameValid1 = validator1.element($pluginMethodName);
            if (!ruleNameValid1) {
                $pluginMethodName.trigger("focus");
                return false;
            }

        } else if (ruleType === '2') {

            var $defaultValue = $rule.find(".defaultValue");
            var defaultValue = $.trim($defaultValue.val());
            $defaultValue.val(defaultValue);

            validator2.form();

            var ruleNameValid2 = validator2.element($ruleName);
            if (!ruleNameValid2) {
                $ruleName.trigger("focus");
                return false;
            }

            var ruleNameValid2 = validator2.element($msg);
            if (!ruleNameValid2) {
                $msg.trigger("focus");
                return false;
            }

            var ruleNameValid2 = validator2.element($defaultValue);
            if (!ruleNameValid2) {
                $defaultValue.trigger("focus");
                return false;
            }
        } else if(ruleType === '3'){
            validator3.form();

            var ruleNameValid3 = validator3.element($ruleName);
            if (!ruleNameValid3) {
                $ruleName.trigger("focus");
                return false;
            }

            var ruleNameValid3 = validator3.element($msg);
            if (!ruleNameValid3) {
                $msg.trigger("focus");
                return false;
            }
        } else if(ruleType === '4'){
            validator4.form();

            var ruleNameValid4 = validator4.element($ruleName);
            if (!ruleNameValid4) {
                $ruleName.trigger("focus");
                return false;
            }

            var ruleNameValid4 = validator4.element($msg);
            if (!ruleNameValid4) {
                $msg.trigger("focus");
                return false;
            }
        } else if(ruleType === '5'){
            validator5.form();
            var ruleNameValid5 = validator5.element($ruleName);
            if (!ruleNameValid5) {
                $ruleName.trigger("focus");
                return false;
            }

            var ruleNameValid5 = validator5.element($msg);
            if (!ruleNameValid5) {
                $msg.trigger("focus");
                return false;
            }
        }

        return true;
    }

    //		保存成功后，打开测试框，并应用校验规则
    function afterSaveRule($rule, ruleType) {
        var $ruleName = $rule.find(".ruleName");
        var $msg = $rule.find(".msg");
        var $userType = $rule.find(".userType");
        $ruleName.attr("readonly", "readonly");
        $msg.attr("readonly", "readonly");
        $userType.attr("disabled", "disabled");
        $rule.find(".edit-rule").show();
        $rule.find(".cancel-rule").hide();
        $rule.find(".save-rule").hide();

        if (ruleType === '0') {
            var $pattern = $rule.find(".pattern");
            $pattern.attr("readonly", "readonly");


        } else if (ruleType === '1') {
            var $pluginClassName = $rule.find(".pluginClassName");
            var $pluginMethodName = $rule.find(".pluginMethodName");

            $pluginClassName.attr("readonly", "readonly");
            $pluginMethodName.attr("readonly", "readonly");
        } else if (ruleType === '2') {
            var $defaultValue = $rule.find(".defaultValue");
            $defaultValue.attr("readonly", "readonly");
        }
    }

    //		删除规则
    function deleteRule($rule, ruleType) {
        layer.confirm("确定删除吗？", {
            icon: 3,
        }, function (index) {
            layer.close(index);
            var type = $rule.find(".type").val();
            if (type == 1) {
                loading();
                $.post(ctx + "/rule/deleteRule.action", {
                    "id": $rule.find(".id").val()
                }, function (data) {
                    loadClose();
                    if (data.result) {
                        $rule.remove();
                        $.alert('删除成功！', 1);
                    } else {
                        $.alert(data.message, 2);
                    }
                }, "json");
            } else {
                $rule.remove();
            }
        });
    }

})();














