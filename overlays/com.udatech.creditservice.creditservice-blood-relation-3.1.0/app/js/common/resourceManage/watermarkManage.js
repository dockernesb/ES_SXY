var watermarkManage = function() {
	var table = $('#watermarkGrid').DataTable(// 创建一个Datatable
	{
		ajax : {
			url : ctx + "/creditTemplate/watermarkList.action",
			type : 'post'
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		ordering : false,
		autoWidth : false,
		columns : [ {
			"data" : "NAME"
		}, {
			"data" : null,
			'render' : function(data, type, row) {
				data.FILE_PATH = data.FILE_PATH.replace(/\\/g, "/");
				var pathUrl = ctx + '/common/viewImg.action?path=' + data.FILE_PATH;
				return '<a href="javascript:;" onclick="openPhoto(\'' + pathUrl + '\')">预览</a>';
			}
		}, {
			"data" : "CREATE_TIME"
		}, {
			"data" : "CREATE_USER_NAME"
		} ]
	});

	$('#watermarkGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 示例如下，所有参数均可选，都有默认值
	$("#watermarkImg").cclUpload({
		type : "img", // 文件类型（img | file），默认为file
		multiple : false, // 是否多选（默认单选替换）
		showList : true
	});

	function addWatermark() {
		$('#name').val('');
		$("#watermarkImg").cclResetUpload();
		$.openWin({
			title : '新建',
			content : $("#winAdd"),
			area : [ '560px', '415px' ],
			yes : function(index, layero) {
				add(index);
			}
		});
	}
	// 保存新加的水印
	function add(index) {
		if (isNull($('#name').val())) {
			$.alert("水印名称不能为空！", 2);
			return;
		}

		if (isNull($('input[name="watermarkImgName"]').val())) {
			$.alert("请先上传水印图片！", 2);
			return;
		}

		loading();
		var addForm = $("#addForm").serialize();
		$.post(ctx + "/creditTemplate/addWatermark.action", addForm, function(data) {
			loadClose();
			if (!data.result) {
				var msg = data.message || "保存失败！";
				$.alert(msg, 2);
			} else {
				layer.close(index);
				$.alert('保存成功!', 1);
				table.ajax.reload(null, false);
			}
		}, "json");
	}

	function editWatermark() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			$('#name').val(node.NAME);
			$("#watermarkImg").cclResetUpload();

			$("#watermarkImg").data('$div').html('');
			var html = '<div class="preview-img">';
			html += '<img onclick="openPhoto($(this).attr(\'src\'));" src="' + ctx + '/common/viewImg.action?path=' + node.FILE_PATH + '" />';
			html += '<div onclick="$(this).parent().remove();" class="fa fa-trash-o delete"></div>';
			html += '<input type="hidden" name="watermarkImgName" value="' + node.SRCFILENAME + '" />';
			html += '<input type="hidden" name="watermarkImgPath" value="' + node.FILE_PATH + '" />';
			html += '</div>';
			$("#watermarkImg").data('$div').html(html);

			$.openWin({
				title : '编辑',
				content : $("#winAdd"),
				area : [ '560px', '415px' ],
				yes : function(index, layero) {
					edit(index, node.ID, node.UPLOADFILEID);
				}
			});
		} else {
			$.alert('请选择要编辑的水印!');
		}
	}

	// 保存编辑的水印
	function edit(index, id, uploadFileId) {
		if (isNull($('#name').val())) {
			$.alert("水印名称不能为空！", 2);
			return;
		}

		if (isNull($('input[name="watermarkImgName"]').val())) {
			$.alert("请先上传水印图片！", 2);
			return;
		}

		loading();
		var addForm = $("#addForm").serialize();
		$.post(ctx + "/creditTemplate/editWatermark.action?id=" + id + '&uploadFileId=' + uploadFileId, addForm, function(data) {
			loadClose();
			if (!data.result) {
				var msg = data.message || "保存失败！";
				$.alert(msg, 2);
			} else {
				layer.close(index);
				$.alert('保存成功!', 1);
				table.ajax.reload(null, false);
			}
		}, "json");
	}

	function delWatermark() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			layer.confirm('确认要删除吗？', {
				icon : 3
			}, function(index) {
				loading();
				$.post(ctx + "/creditTemplate/delWatermark.action", {
					id : node.ID
				}, function(data) {
					loadClose();
					if (!data.result) {
						$.alert('删除失败!', 2);
					} else {
						layer.close(index);
						$.alert('删除成功!', 1);
						table.ajax.reload(null, false);
					}
				}, "json");
			});
		} else {
			$.alert('请选择要删除的水印!');
		}
	}

	$('#backBtn').click(function() {
		log($('#useType').val());
		if ($('#useType').val() == 0) {
			AccordionMenu.openUrl('信用报告模板', ctx + '/creditTemplate/creditTemplate.action');
		}
		if ($('#useType').val() == 1) {
			AccordionMenu.openUrl('信用审查模板', ctx + '/creditTemplate/creditTemplateSC.action');
		}
	});

	return {
		addWatermark : addWatermark,
		editWatermark : editWatermark,
		delWatermark : delWatermark
	}
}();