var gl = (function () {

    $("#status").select2({
        placeholder : '全部状态',
        minimumResultsForSearch : -1
    });

    resizeSelect2($("#status"));

    $.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
        // 初始下拉框
        $("#deptId").select2({
            placeholder : '全部部门',
            language : 'zh-CN',
            data : result
        });

        resizeSelect2($("#deptId"));
        $('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
    });

    //创建一个Datatable
    var table = $('#dataTable').DataTable({
        ajax: {
            url: ctx + "/achievements/getCenterAchievementsList.action",
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
            {"data" : "dept.departmentName"},
            {"data" : "deptScore"},
            {"data" : "centerScore", "render": function(data, type, full) {
                if (full.centerGraded) {
                    return data;
                }
                return "";
            }},
            {"data" : "status", "render": function(data, type, full) {
                if (data == "1") {
                    return "未提交";
                } else if (data == "2") {
                    return "待评分";
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

    function refreshTable(year, deptId, status) {
        if (table) {
            var data = table.settings()[0].ajax.data;
            if (!data) {
                data = {};
                table.settings()[0].ajax["data"] = data;
            }
            data["year"] = year || "";
            data["dept.id"] = deptId || "";
            data["status"] = status || "";
            table.ajax.reload();
        }
    }

    $("#editBtn").click(function () {
        var nodes = table.rows('.active').data();
        if (nodes.length == 1) {
            var node = nodes[0];
            if (node.status != "2") {
                $.alert('绩效考核已提交，不能评分!');
            } else {
                toCenterAchievementsHandle(node.id);
            }
        } else {
            $.alert('请在列表中选择要评分的绩效!');
        }
    });

    function toCenterAchievementsHandle(id) {
        var url = ctx + "/achievements/toCenterAchievementsHandle.action?id=" + (id || "");
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
            var url = ctx + "/achievements/toCenterAchievementsDetail.action?id=" + (node.id || "");
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
        var deptId = $.trim($('#deptId').val());
        var status = $.trim($('#status').val());
        refreshTable(year, deptId, status);
    }

    //		重置
    function conditionReset() {
        resetSearchConditions('#year,#deptId,#status');
    }
    
    //
    $("#exportBtn").click(function(){
    	layer.confirm("确认导出数据吗？", {
			icon : 3
		}, function(index) {
	         layer.msg('正在导出结果，请稍候...', {icon: 1, time: 5000});
	         document.location = CONTEXT_PATH + "/achievements/exportAchievementsResult.action";
		});
    });
    	

    return {
        conditionSearch : conditionSearch,
        conditionReset : conditionReset,
        table : table
    };

})();