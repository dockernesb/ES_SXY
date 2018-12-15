var personDetail = (function() {
	var sfzh = $("#sfzh").val();

	// 个人行政处罚
	var xzcfTable = $('#xzcfTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getCreditInfoByTabName.action",
			type : "post",
			data : function(d) {
				d.tableName = "YW_P_GRXZCF";
				d.sfzh = sfzh;
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		paging : false,
		columns : [ {
			"data" : "CFWH"
		}, {
			"data" : "CFMC"
		}, {
			"data" : "CFSY"
		}, {
			"data" : "CFDJ"
		}, {
			"data" : "CFJG"
		}, {
			"data" : "CFZL"
		}, {
			"data" : "CFYJ"
		}, {
			"data" : "CFRQ"
		} ],
		initComplete : function(settings, json) {
			$('#xzcfTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					xzcfTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});

	// 黑名单信息
	var heimingdanxxTable = $('#heimingdanxxTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getCreditInfoByTabName.action",
			type : "post",
			data : function(d) {
				d.tableName = "YW_P_GRHEIMINGDAN";
				d.sfzh = sfzh;
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		paging : false,
		columns : [ {
			"data" : "ZYSXSS"
		}, {
			"data" : "XZCLJDNR"
		}, {
			"data" : "RDWH"
		}, {
			"data" : "RDDW"
		}, {
			"data" : "RDRQ"
		} ],
		initComplete : function(settings, json) {
			$('#heimingdanxxTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					heimingdanxxTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});

	// 交通失信信息
	var jtxxxxTable = $('#jtxxxxTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getCreditInfoByTabName.action",
			type : "post",
			data : function(d) {
				d.tableName = "YW_P_GRJTSX";
				d.sfzh = sfzh;
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		paging : false,
		columns : [ {
			"data" : "JTSXXW"
		}, {
			"data" : "SXYZCD"
		}, {
			"data" : "RDJG"
		}, {
			"data" : "RDRQ"
		} ],
		initComplete : function(settings, json) {
			$('#jtxxxxTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					xzxkTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});

	// 红名单信息
	var hongmingdanTable = $('#hongmingdanTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getCreditInfoByTabName.action",
			type : "post",
			data : function(d) {
				d.tableName = "YW_P_GRHONGMINGDAN";
				d.sfzh = sfzh;
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		paging : false,
		columns : [ {
			"data" : "RYMC"
		}, {
			"data" : "RYSX"
		}, {
			"data" : "RDWH"
		}, {
			"data" : "RDDW"
		}, {
			"data" : "RDRQ"
		} ],
		initComplete : function(settings, json) {
			$('#hongmingdanTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					hongmingdanTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});

	// 许可资质
	var xkzzTable = $('#xkzzTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getCreditInfoByTabName.action",
			type : "post",
			data : function(d) {
				d.tableName = "YW_P_GRXZXK";
				d.sfzh = sfzh;
			}
		},
		ordering : false,
		searching : false,
		autoWidth : false,
		lengthChange : true,
		pageLength : 10,
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		paging : false,
		columns : [ {
			"data" : "XKJDSWH"
		}, {
			"data" : "XKZBH"
		}, {
			"data" : "XKZMC"
		}, {
			"data" : "XKZFW"
		}, {
			"data" : "ZL"
		}, {
			"data" : "XKSXQ"
		}, {
			"data" : "XKJZQ"
		}, {
			"data" : "PZJGQC"
		}, {
			"data" : "PZRQ"
		}, {
			"data" : "BGHZRQ"
		} ],
		initComplete : function(settings, json) {
			$('#xkzzTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					xkzzTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});
})();