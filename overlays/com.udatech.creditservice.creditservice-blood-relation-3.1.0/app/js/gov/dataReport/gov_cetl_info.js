var cetlInfo = function () {
    // 数据血缘
    function showCetl() {
        var selectRows = govTask.table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            $.openWin({
                title: '数据血缘 — ' + row.NAME,
                type: 2,
                content: ctx + '/dp/cetlInfo/showCetl.action?tableCode=' + row.CODE,
                area: ['860px', '600px']
            });
        } else {
            $.alert('请先选择要操作的目录。');
        }
    }

    return {
        showCetl: showCetl
    }
}();