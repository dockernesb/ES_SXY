// 审查审核
var cCreditCheckExamine = (function() {var rules = {
		shyj : {
			maxlength : 120
		}
	};
	var exValidator = $('#cCreditCheckExamineForm').validateForm(rules);
	exValidator.form();
	
	var applyId = $('#applyId').val();
	var table = $('#enterGrid').DataTable({
		// "scrollY": 385,
		"deferRender" : true,
		"ordering" : false,
		"searching" : false,
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		pageLength : 10,
		"autoWidth" : false,
		"columnDefs" : [ {
			"orderable" : false,
			"targets" : 0
		} ],
		"pageLength" : 10, // 显示5项结果
		ajax : { // 通过ajax访问后台获取数据
			url : CONTEXT_PATH + '/center/creditCheck/getEnterList.action?id=' + applyId, // 后台地址
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
		} ],
		columnDefs : [ {
			"targets" : 0,
			render : function(data, type, row, meta) {
				// 显示行号
				var startIndex = meta.settings._iDisplayStart;
				return startIndex + meta.row + 1;
			}
		} ]
	});

	function goBack() {
        $("div#cCreditCheckExamineList").show();
        $("div#cCreditCheckExamineDetail").hide();
        var selectArr = recordSelectNullEle();
        $("div#cCreditCheckExamineList").prependTo("#topBox");
        callbackSelectNull(selectArr);
        cCreditCheckList.table.ajax.reload(null, false);// 刷新列表还保留分页信息
        resetIEPlaceholder();
	}

	function examine(type) {
		var shyj = $.trim($('#shyj').val());
		var res = exValidator.form();

		if (res) {
			if (!type && isNull(shyj)) {
				$.alert("请填写审核意见!");
			} else {

                if (type && $("input[name='uploadFilePath']").length <= 0) {
                    $.alert("请上传附件！");
                    return;
                }

				var url = CONTEXT_PATH + '/center/creditCheck/examine.action';
				loading();
				$.post(url, {
					type : type,
					id : applyId,
					shyj : shyj,
                    uploadFileName : $("input[name='uploadFileName']").val(),
                    uploadFilePath : $("input[name='uploadFilePath']").val()
				}, function(data) {
                    loadClose();
					if (data) {
                        $.alert("审核成功!", 1);
					} else {
						$.alert("审核失败!请与管理员联系", 2);
					}
                    goBack();
				});
			}
		}
	}

	function createExamineReport() {
		var bjbh = $("#bjbh").val();
		var scxxl = $('#scxxl').val();
		var url = CONTEXT_PATH + '/center/creditCheck/createExamineReport.action';
		$.post(url, {
			bjbh : bjbh,
			id : applyId,
			scxxl : scxxl
		}, function(data) {

		},"json");
	}

    function downLoadReport(filePath, fileName) {
        document.location = CONTEXT_PATH + "/creditCommon/ajaxDownload.action?filePath=" + filePath + "&fileName=" + fileName;
    }

    $("#uploadFile").cclUpload({
        "supportTypes" : ["doc", "docx", "pdf"],
        "type" : "file",
        "showList" : true,
        "multiple" : false,
        "isExamine" : true
    });

	return {
//		"createExamineReport" : createExamineReport,
        "downLoadReport" : downLoadReport,
		"examine" : examine,
		"goBack" : goBack
	};

})();