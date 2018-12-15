var creditTemplete = function () {
    // 操作类型opType（add：新增，read：查看，update：修改）
    // 模板用途useType（0：报告查询，1：信用审查）
    function addTemplate() {
        var addUrl = ctx + '/creditTemplate/toConfigureTemplate.action?opType=add&templateId=&useType=1';

        $('#templateRow').hide();
        $('#templateContent').html("");
        $('#templateContent').show();
        $('#templateContent').load(addUrl);
        $('html, body').animate({
            scrollTop: 0
        }, 500);
    }

    function editTemplate() {
        if (!isNull($('.nav-tabs >.active >a').attr('href'))) {
            var ahref = $('.nav-tabs >.active >a').attr('href');
            var templateId = ahref.substring(1);
            var category = $('#category_' + templateId).val();
            var addUrl = ctx + '/creditTemplate/toConfigureTemplate.action?opType=update&templateId=' + templateId + '&useType=1&category=' + category;

            $('#templateRow').hide();
            $('#templateContent').html("");
            $('#templateContent').show();
            $('#templateContent').load(addUrl);
        }
    }

    function deleteTemplate() {
        var ahref = $('.nav-tabs >.active >a').attr('href');
        var templateId = ahref.substring(1);

        if (!isNull(templateId)) {
            layer.confirm('确认要删除吗？', {
                icon: 3
            }, function (index) {
                loading();
                $.post(ctx + "/creditTemplate/deleteTemplate.action", {
                    templateId: templateId
                }, function (data) {
                    loadClose();
                    if (!data.result) {
                        if (data.message == '0') {
                            $.alert('删除模板失败！', 2);
                        } else {
                            $.alert(data.message, 2);
                        }
                    } else {
                        layer.close(index);
                        $.alert('删除成功模板！', 1);
                        AccordionMenu.openUrl('信用审查模板', ctx + '/creditTemplate/creditTemplateSC.action');
                    }
                }, "json");
            });
        } else {
            $.alert('没有要删除的模板！');
        }
    }

    // 模板打印报告预览
    function previewReport(em) {
        if (!isNull($(em)) && !isNull($(em).attr('href'))) {
            var templateId = $(em).attr('href').substring(1);
            // 加载模板报告预览
            var previewUrl = ctx + '/creditTemplate/previewReportSC.action?templateId=' + templateId;
            var divId = '#' + templateId + '_previewDiv';
            $(divId).load(previewUrl);
        }
    }

    // 水印管理
    function watermarkManage() {
        var url = ctx + '/creditTemplate/watermark.action?useType=1';
        $('#templateRow').hide();
        $('#templateContent').html("");
        $('#templateContent').show();
        $('#templateContent').load(url);
    }

    return {
        addTemplate: addTemplate,
        editTemplate: editTemplate,
        deleteTemplate: deleteTemplate,
        previewReport: previewReport,
        watermarkManage: watermarkManage
    }
}();

$(function () {
    var a = $('.nav-tabs >.active >a');
    creditTemplete.previewReport(a);
});
