var supvEnterDetail = (function() {
	var qymc = $("#qymc").val();
	var gszch = $("#gszch").val();
	var zzjgdm = $("#zzjgdm").val();
	var tyshxydm = $("#tyshxydm").val();

	// 股东信息
	var gdxxTable = $('#gdxxTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getEnterpriseBaseInfo.action",
			type : "post",
			data : function(d) {
				d.tableKey = "gdxx";
				d.gszch = gszch;
				d.zzjgdm = zzjgdm;
				d.tyshxydm = tyshxydm;
				d.jgqc = qymc;
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
			"data" : "GDLX"
		}, {
			"data" : "GDMC"
		}, {
			"data" : "RJCZ"
		}, {
			"data" : "SJCZ"
		}, {
			"data" : "DJJGMC"
		}, {
			"data" : "DJRQ"
		}, {
			"data" : "GSGQCZZM"
		}, {
			"data" : "BGRQ"
		} ],
		initComplete : function(settings, json) {
			$('#gdxxTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					gdxxTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});

	// 董事监事高管信息
	var dsjsggxxTable = $('#dsjsggxxTable').DataTable({
		ajax : {
			url : ctx + "/creditCommon/getEnterpriseBaseInfo.action",
			type : "post",
			data : function(d) {
				d.tableKey = "dsjsggxx";
				d.gszch = gszch;
				d.zzjgdm = zzjgdm;
				d.tyshxydm = tyshxydm;
				d.jgqc = qymc;
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
			"data" : "XM"
		}, {
			"data" : "ZJLX"
		}, {
			"data" : "ZJHM"
		}, {
			"data" : "ZWLX"
		}, {
			"data" : "GJ"
		}, {
			"data" : "BGHZRQ"
		} ],
		initComplete : function(settings, json) {
			$('#dsjsggxxTable tbody').on('click', 'tr', function() {
				if ($(this).hasClass('active')) {
					$(this).removeClass('active');
				} else {
					dsjsggxxTable.$('tr.active').removeClass('active');
					$(this).addClass('active');
				}
			});
		}
	});
})();