(function() {

    $("#uploadFile").cclUpload({
        "supportTypes" : ["doc", "docx", "pdf"],
        "type" : "file",
        "showList" : true,
        "multiple" : false
    });

    var rules = {
        bz : {
            maxlength : 120
        }
    };
    var validator = $('#submit_form').validateForm(rules);
    validator.form();

    $("#submitBtn").click(function() {
        if (!$("input[name='uploadFilePath']").val()) {
            $.alert("请上传附件！");
            return;
        }
        if (!validator.form()) {
            $.alert("审查意见最多120个字！");
            return;
        }
        loading();
        $.post(ctx + "/center/pCreditCheck/submitCheckReport.action", {
            "id" : $("#id").val(),
            "bz" : $("#bz").val(),
            "uploadFileName" : $("input[name='uploadFileName']").val(),
            "uploadFilePath" : $("input[name='uploadFilePath']").val()
        }, function(data) {
            loadClose();
            if (data.result) {
                $.alert("提交成功！", 1, function() {
                    var url = CONTEXT_PATH + "/center/pCreditCheck/creditCheckUpload.action";
                    AccordionMenu.openUrl(null, url);
                });
            } else {
                $.alert(data.message || "提交失败！", 2);
            }
        }, "json");
    });

})();