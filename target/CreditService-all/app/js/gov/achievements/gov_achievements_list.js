var gl = (function () {

    //创建一个Datatable
    var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/achievements/getGovAchievementsList.action",
            type: "post"
        },
        ordering: false,
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: true,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        columns: [
            {"data" : "year"},
            {"data" : "deptScore"},
            /*{"data" : "centerScore", "render": function(data, type, full) {
                if (full.status == "3") {
                    return data;
                }
                return "";
            }},*/
            {"data" : "status", "render": function(data, type, full) {
                if (data == "1") {
                    return "未提交";
                } else if (data == "2") {
                    return "已提交";
                } else if (data == "3") {
                    return "已评分";
                }
                return "未知";
            }}
        ]
    });

    $('#dataTable tbody').on('click', 'tr', function() {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            table.$('tr.active').removeClass('active');
            $(this).addClass('active');
        }
    });

    function refreshTable(year) {
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["year"] = year || "";
            table.ajax.reload();
        }
    }

    $("#addBtn").click(function () {
        toGovAchievementsHandle();
    });

    $("#editBtn").click(function () {
        var nodes = table.rows('.active').data();
        if (nodes.length == 1) {
            var node = nodes[0];
            if (node.status != "1") {
                $.alert('绩效考核已提交，不能修改!');
            } else {
                toGovAchievementsHandle(node.id);
            }
        } else {
            $.alert('请在列表中选择要修改的绩效!');
        }
    });

    function toGovAchievementsHandle(id) {
        var url = ctx + "/achievements/toGovAchievementsHandle.action?id=" + (id || "");
        $("div#handleDiv").html("");
        $("div#handleDiv").load(url);
        $("div#handleDiv").prependTo("#topBox");
        $("div#mainListDiv").hide();
        $("div#handleDiv").show();
        resetIEPlaceholder();
    }

    $("#detailBtn").click(function () {
        var nodes = table.rows('.active').data();
        if (nodes.length == 1) {
            var node = nodes[0];
            var url = ctx + "/achievements/toGovAchievementsDetail.action?id=" + (node.id || "");
            $("div#handleDiv").html("");
            $("div#handleDiv").load(url);
            $("div#handleDiv").prependTo("#topBox");
            $("div#mainListDiv").hide();
            $("div#handleDiv").show();
            resetIEPlaceholder();
        } else {
            $.alert('请在列表中选择要查看的绩效!');
        }
    });

    //	搜索
    function conditionSearch() {
        var year = $.trim($('#year').val());
        refreshTable(year);
    }

    //		重置
    function conditionReset() {
        resetSearchConditions('#year');
    }

    return {
        conditionSearch : conditionSearch,
        conditionReset : conditionReset,
        table : table
    };

})();