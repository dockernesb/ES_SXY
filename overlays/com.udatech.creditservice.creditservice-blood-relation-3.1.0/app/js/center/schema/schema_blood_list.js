var collectionBlood = function() {
	
	// 数据血缘
    function showCetl() {
        var selectRows = collection.table.rows('.active').data();
        if (selectRows.length == 1) {
            var row = selectRows[0];
            $.openWin({
                title: '数据血缘 — ' + row.NAME,
                type: 2,
                content: ctx + '/dp/cetlInfo/showCetl.action?tableCode=' + row.CODE + '&showLog=' + true,
                area: ['860px', '600px']
            });
        } else {
            $.alert('请先选择目录！');
        }
    }
    
	return {
		showCetl:showCetl
	}
}();