// 审查申请Js
var cCreditCheckUpload = (function() {
	var rules = {
		scmc : {
			required : true,
			unblank : [],
			illegalChar : []
		},
		scxxl : {
			required : true,
			unblank : []
		},
		departentId : {
			required : true,
			unblank : []
		}
	};
	var applyValidator = $('#cCreditCheckUploadForm').validateForm(rules);
	
	$.getJSON(ctx + "/system/department/getDeptList.action", function(result) {
		// 初始下拉框
		$("#departentId").select2({
			placeholder : '点击选择审查部门',
			allowClear : true,
			language : 'zh-CN',
			data : result,
			// 选中项回调
			templateSelection : function(selection) {
				applyValidator.form();
				return selection.text;
			}
		});

		$('#departentId').val(null).trigger("change");
	});

	
	$('#departentId').val("").trigger("change");
    $.getJSON(ctx + "/creditTemplate/listValues.action?category=0&zyyt=7", function (result) {
        $('#scxxl').select2({
            placeholder : "点击选择审查类别",
            language : "zh-CN",
            allowClear : false,
			data : result,
            // 选中项回调
            templateSelection : function(selection) {
				applyValidator.form();
				return selection.text;
        	}
        });

        resizeSelect2('#scxxl');
        $('#scxxl').on("select2:unselect", function(e) {
            applyValidator.form();
        });

	});

	$(".upload-img").cclUpload({
		type : "img", // 文件类型（img | file），默认为file
		showList : true // 是否显示预览列表（默认不显示列表）
	});
	$(".upload-file").cclUpload({
		supportTypes : [ "xls", "xlsx" ], // 支持的文件类型(文件类型为img时，默认支持"jpg","jpeg","gif","bmp","png")
		callback : function(data) {
			var filePathStr = "";
			var fileNameStr = "";
			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					filePathStr += data[i].path + ",";
					fileNameStr += data[i].name + ",";
				}
	
				batchAdd(filePathStr, fileNameStr);
			}
		}
	});

    var start = {
        elem : '#scsjs',
        format : 'YYYY-MM-DD',
        max : '2099-12-30', // 最大日期
        min : '1900-01-01', // 最小日期
        istime : false,
        istoday : false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose : function(datas) {
            laydatePH('#scsjs', datas);
            end.min = datas; // 开始日选好后，重置结束日的最小日期
            end.start = datas // 将结束日的初始值设定为开始日
        }
    };
    var end = {
        elem : '#scsjz',
        format : 'YYYY-MM-DD',
        max : '2099-12-30', // 最大日期
        min : '1900-01-01', // 最小日期
        istime : false,
        istoday : false,
        isclear : false, // 是否显示清空
        issure : false, // 是否显示确认
        choose : function(datas) {
            laydatePH('#scsjz', datas);
            start.max = datas; // 结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);

    // 设置初始时间 开始时间为三年前，结束时间为当日
    var today = new Date().format("yyyy-MM-dd");
    var threeYearsAgo = new Date();
    threeYearsAgo.setFullYear(threeYearsAgo.getFullYear() - 3);
    threeYearsAgo = threeYearsAgo.format("yyyy-MM-dd");
    $('#scsjs').val(threeYearsAgo); // 设置开始时间为三年前
    $('#scsjz').val(today); // 结束时间为当日
    end.min = threeYearsAgo; //开始日选好后，重置结束日的最小日期
    end.start = threeYearsAgo //将结束日的初始值设定为开始日
    start.max = today; //结束日选好后，重置开始日的最大日期

	var table = $('#enterGrid').DataTable({
		// "scrollY": 385,
		"deferRender" : true,
		"ordering" : false,
		"searching" : false,
		"lengthChange" : true,
		"autoWidth" : false,
		"columnDefs" : [ {
			"orderable" : false,
			"targets" : 0
		} ],
		"pageLength" : 10, // 显示5项结果
		ajax : { // 通过ajax访问后台获取数据
			url : CONTEXT_PATH + '/center/creditCheck/queryList.action', // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : null
		}, {
			"data" : "qymc"
		}, {
			"data" : "gszch"
		}, {
			"data" : "zzjgdm"
		}, {
			"data" : "shxydm"
		}, {
			"data" : "id"
		} ],
		columnDefs : [ {
			targets : 5, // 操作
			render : function(data, type, row) {
				var str = '<button type="button" class="btn red btn-xs" title="删除" onclick="cCreditCheckUpload.removeEnt(\'' + data + '\');"><i class="fa fa-trash-o"></i>  删除</button>';
				return str;
			}
		}, {
			"targets" : 0,
			render : function(data, type, row, meta) {
				// 显示行号
				var startIndex = meta.settings._iDisplayStart;
				return startIndex + meta.row + 1;
			}
		} ]
	});
	applyValidator.form();

	// 手工录入
	function manualAdd() {
		$('#addEnterForm')[0].reset();
		$.openWin({
			title : '手动录入企业',
			content : $("#winAdd"),
			btnAlign : 'c',
			area : [ '600px', '410px' ],
			yes : function(index, layero) {
				manualAddSub(index);
			}
		});
	}

	// 手工录入 提交
	function manualAddSub(index) {
		var zzjgdm = $.trim($('#zzjgdm').val());
		var qymc = $.trim($('#qymc').val());
		var gszch = $.trim($('#gszch').val());
		var shxydm = $.trim($('#shxydm').val());
		if (isNull(qymc)) {
			$.alert("请填写企业名称!");
			return;
		}
		if (isNull(shxydm + gszch + zzjgdm)) {
			$.alert("工商注册号、组织机构代码和统一社会信用代码至少填写一个!");
			return;
		}

		loading();
		$.post(CONTEXT_PATH + '/center/creditCheck/manualAdd.action', {
			zzjgdm : zzjgdm,
			qymc : qymc,
			shxydm : shxydm,
			gszch : gszch
		}, function(data) {
			loadClose();
			var data = eval('(' + data + ')');
			table.ajax.reload(null, false);
            if (data.result) {
                layer.close(index);
                layer.confirm(data.message + '是否继续添加？', {
					icon : 3
				}, function(index) {
					layer.close(index);
					manualAdd();
				});
			} else {
				$.alert(data.message, 2);
			}
		});
	}

	// 批量上传
	function batchAdd(filePathStr, fileNameStr) {
		loading();
		var bjbh = $("#bjbh").val();
		$.post(CONTEXT_PATH + '/center/creditCheck/batchAdd.action', {
			bjbh : bjbh,
			filePathStr : filePathStr,
			fileNameStr : fileNameStr
		}, function(data) {
			var data = eval('(' + data + ')');
			table.ajax.reload(null, false);
			layer.open({
				type : 1, // Page层类型
				area : [ '600px', '400px' ],
				title : '批量导入解析结果',
				shade : 0.6, // 遮罩透明度
				anim : 1, // 0-6的动画形式，-1不开启
				content : '<div style="padding:10px 20px;">' + data.message + '</div>'
			});
			loadClose();
		});
	}

	// 下载模板
	function templateDownload() {
		loading();
		window.location.href = CONTEXT_PATH + "/center/creditCheck/templateDownload.action";
		loadClose();
	}

	// 删除企业
	function removeEnt(id) {
		layer.confirm('确认要删除此企业吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(CONTEXT_PATH + "/center/creditCheck/reomveEnter.action?id=" + id, {}, function(data) {
				loadClose();
				if (data.result) {
					$.alert('删除成功!', 1);
					table.ajax.reload();
				} else {
					$.alert('删除失败!', 2);
				}
			}, 'json');
		});
	}

	// 申请
	function conditionAdd() {
		if (!applyValidator.form()) {
			$.alert("请检查所填信息！", 2);
			return;
		}

		var table = $('#enterGrid').DataTable();
		var cnt = table.rows().data().length;
		if (cnt == 0) {
			$.alert("请添加企业信息!", 2);
			return;
		}
		loading();
		var bjbh = $("#bjbh").val();
		// var arr = $('#scxxl').val();
		// var scxxl = "";
		// for (var i = 0; i < arr.length; i++) {
		// 	scxxl += arr[i];
		// 	if (i != arr.length -1) {
		// 		scxxl += ",";
		// 	}
		// }
		$('#cCreditCheckUploadForm').ajaxSubmit({
			url : CONTEXT_PATH + '/center/creditCheck/addApplication.action',
			dataType : "json",
			success : function(data) {
                loadClose();
				if (data.result) {
					$.alert("提交成功！后台正在生成报告,请稍后查看 ", 1);
					conditionReset();
					var fileUrl = CONTEXT_PATH + '/center/creditCheck/createExamineReport.action';
					$.post(fileUrl, {
						id : data.applyId,
						bjbh : bjbh,
						// scxxl : scxxl
						scxxl : $('#scxxl').val()
					}, function(data) {
//						if (data.result) {
//							window.location.href = CONTEXT_PATH + "/creditCommon/ajaxDownload.action?filePath=" + data.message;
//						} else {
//							loadClose();
//							$.alert("信用审查报告生成异常，请稍后再试...", 2);
//						}
					}, "json");
				} else {
					$.alert(data.message, 2);
				}
			}
		});
	}

	// 重置
	function conditionReset() {
		// $("#cCreditCheckUploadForm")[0].reset();
		// $("#uploadImg").cleanImg();
		// scxxlSel.val("").trigger("change");
		// $('#departentId').val(null).trigger("change");
		$.post(CONTEXT_PATH + "/center/creditCheck/clearList.action", {}, function(data) {
			table.ajax.reload();
		});
        // applyValidator.form();
        //
        // $('#scsjs').val(threeYearsAgo); // 设置开始时间为三年前
        // $('#scsjz').val(today); // 结束时间为当日
        // end.min = threeYearsAgo; //开始日选好后，重置结束日的最小日期
        // end.start = threeYearsAgo //将结束日的初始值设定为开始日
        // start.max = today; //结束日选好后，重置开始日的最大日期

        var url = CONTEXT_PATH + '/center/creditCheck/creditCheckUpload.action';
        $("div#mainContent").load(url);
	}

	return {
		"manualAdd" : manualAdd,
		"removeEnt" : removeEnt,
		"templateDownload" : templateDownload,
		"conditionAdd" : conditionAdd,
		"conditionReset" : conditionReset
	};

})();