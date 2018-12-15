var dict = function() {
	var rules = {
		groupKey : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 20
		},
		groupName : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 20
		},
		key : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 20
		},
		value : {
			required : true,
			unblank : [],
			illegalCharacter : [',，、-'],
			maxlength : 20
		},
		description : {
			maxlength : 120
		}
	};
	var addValidator = $('#addDictionaryForm').validateForm(rules);
	var editValidator = $('#editDictionaryForm').validateForm(rules);

	var table = $('#dictGrid').DataTable(// 创建一个Datatable
	{
		ajax : {
			url : CONTEXT_PATH + "/system/dictionary/list.action",
			type : 'post',
			data : {
				condition : $.trim($('#condition').val())
			}
		},
		serverSide : true,// 如果是服务器方式，必须要设置为true
		processing : true,// 设置为true,就会有表格加载时的提示
		lengthChange : true,// 是否允许用户改变表格每页显示的记录数
		searching : false,// 是否允许Datatables开启本地搜索
		paging : true,
		ordering : false,
		autoWidth : false,
		columns : [ {
			"className" : 'details-control',
			"orderable" : false,
			"data" : null,
			"defaultContent" : '<div class="icon">&nbsp;</div>'
		}, {
			"data" : "groupKey"
		}, {
			"data" : "groupName"
		}, {
			"data" : "description"
		} ]
	});

	$('#dictGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	// 显示行明细
	function showDetail(rowData) {
		var _html = '';
		$.ajax({
			type : "POST",
			dataType : 'json',
			url : ctx + '/system/dictionary/listValue.action',
			data : {
				groupKey : rowData.groupKey
			},
			async : false,
			success : function(result) {
				_html = '<table class="table table-bordered"  style="width:50%"><thead><tr><th width=\"50%\">字典编码 </th><th width=\"50%\">字典值 </th></tr></thead>';
				_html += '<tbody>';
				$.each(result, function(i, item) {
					_html += '<tr>';
					_html += '<td>' + item.dictKey + '</td>';
					_html += '<td>' + item.dictValue + '</td>';
					_html += '</tr>';
				});
				_html += '</tbody></table>';
			}
		});
		return _html;
	}
	// 行明细点击事件
	$('#dictGrid tbody').on('click', 'td.details-control', function() {
		var tr = $(this).closest('tr');
		var row = table.row(tr);
		if (row.child.isShown()) { // This row is already open - close it
			row.child.hide();
			tr.removeClass('shown');
		} else { // Open this row
			row.child(showDetail(row.data())).show();
			tr.addClass('shown');
		}
	});

	// 按条件查询
	function conditionSearch(type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["condition"] = $.trim($('#condition').val());
			table.ajax.reload(null, type==1?true:false);// 刷新列表还保留分页信息
		}
	}
	// 重置查询条件
	function conditionReset() {
		resetSearchConditions('#condition');
	}

	function addDictionary() {
		$('#addDictionaryForm')[0].reset();
		$("#dic  tr:gt(1)").remove();
		$.openWin({
			title : '新增字典',
			content : $("#winAdd"),
			area : [ '855px', '550px' ],
			yes : function(index, layero) {
				addSubmit(index);
			}
		});
		addValidator.form();
	}
	// 保存新加的字典
	function addSubmit(index) {
		if (!addValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		var bol = false;
		var bolRepeat = false;
		var bolBlunk = false;
		var dicArr = new Array();
		var dicKey = new Array();
		var dicValue = new Array();
		var reg = /\s/;
		$(".dicTd").each(function() {
			var key = $(this).find(".key").val();
			var value = $(this).find(".value").val();
			if (jQuery.inArray(key + "-" + value, dicArr) == -1) {
				dicArr.push(key + "-" + value);
			} else {
				bolRepeat = true;
			}
			if (jQuery.inArray(key, dicKey) == -1) {
				dicKey.push(key);
			} else {
				bolRepeat = true;
			}
			if (jQuery.inArray(value, dicValue) == -1) {
				dicValue.push(value);
			} else {
				bolRepeat = true;
			}
			if (key == "" || value == "") {
				bol = true;
			}
			if (reg.test(key) || reg.test(value)) {
				bolBlunk = true;
			}
		});
		if (bol) {
			$.alert('请把字典编码和字典值填写完整！', 2);
			return false;
		}
		if (bolBlunk) {
			$.alert('字典编码和字典值不能输入空格，请修改！', 2);
			return false;
		}
		if (bolRepeat) {
			$.alert('字典编码或字典值有重复，请修改！', 2);
			return false;
		}
		var param = "";
		$.each(dicArr, function(i, item) {
			param += item + ";";
		});
		param = param.substr(0, param.length - 1);
		$('#dictVal').val(param);

		loading();
		var addDictionaryFormData = $('#addDictionaryForm').serialize();
		$.post(ctx + "/system/dictionary/addDict.action", addDictionaryFormData, function(data) {
			loadClose();
			if (!data.result) {
				$.alert('字典组编码或者名称已经存在!', 2);
			} else {
				layer.close(index);
				$.alert('数据字典添加成功!', 1);
				conditionSearch();
			}
		}, "json");

	}

	// 修改字典
	function editDictionary() {
		$('.dicTd_edit').remove();// 移除旧数据

		var gridNodes = table.rows('.active').data();
		if (gridNodes.length == 1) {
			var node = gridNodes[0];
			$.ajax({
				type : "POST",
				dataType : 'json',
				url : ctx + '/system/dictionary/listValue.action',
				data : {
					groupKey : node.groupKey
				},
				async : false,
				success : function(result) {
					$('#groupKey_edit').val(node.groupKey);
					$('#groupName_edit').val(node.groupName);
					$('#description_edit').val(node.description);
					$('#id').val(node.id);
					var tr_html = '';
					$.each(result, function(i, item) {
						tr_html += '<tr class="dicTd_edit">';
						tr_html += '<td style="padding: 5px 5px 0px 0px;"><div class="input-icon right"><i class="fa"></i>';
						tr_html += '<input class="form-control key_edit" name="key" value="' + item.dictKey + '" style="width: 250px;" /></div></td>';
						tr_html += '<td style="padding: 5px 5px 0px 0px;"><div class="input-icon right"><i class="fa"></i>';
						tr_html += '<input class="form-control value_edit" name="value" value="' + item.dictValue + '" style="width: 250px;" /></div></td>';
						tr_html += '<td style="padding: 5px 5px 0px 0px;"><input type="button" value="+" style="width: 30px;" onclick="dict.createTR_edit();" /></td>';
						tr_html += '<td style="padding: 5px 5px 0px 0px;"><input type="button" value="-" style="width: 30px;" class="delDic_edit" /></td>';
						tr_html += '</tr>';
					});
					$('#dic_edit').append(tr_html);

					$(".delDic_edit").click(function() {
						if ($('.dicTd_edit').length > 1) {
							$(this).parent().parent().remove();
						}
					});

					$.openWin({
						title : '修改字典',
						content : $("#winEdit"),
						area : [ '855px', '550px' ],
						yes : function(index, layero) {
							editSubmit(index);
						}
					});
					editValidator.form();
					$('.key_edit, .value_edit').focus();
				}
			});
		} else {
			$.alert('请先选择要修改的字典记录!');
		}
	}
	// 保存编辑的字典信息
	function editSubmit(index) {
		if (!editValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		var bol = false;
		var bolRepeat = false;
		var bolBlunk = false;
		var dicArr = new Array();
		var dicKey = new Array();
		var dicValue = new Array();
		var reg = /\s/;
		$(".dicTd_edit").each(function() {
			var key = $(this).find(".key_edit").val();
			var value = $(this).find(".value_edit").val();
			if (key == "" || value == "") {
				bol = true;
			}
			if (reg.test(key) || reg.test(value)) {
				bolBlunk = true;
			}
			if (jQuery.inArray(key + "-" + value, dicArr) == -1) {
				dicArr.push(key + "-" + value);
			} else {
				bolRepeat = true;
			}
			if (jQuery.inArray(key, dicKey) == -1) {
				dicKey.push(key);
			} else {
				bolRepeat = true;
			}
			if (jQuery.inArray(value, dicValue) == -1) {
				dicValue.push(value);
			} else {
				bolRepeat = true;
			}
		});
		if (bol) {
			$.alert('请把字典编码和字典值填写完整！', 2);
			return false;
		}
		if (bolBlunk) {
			$.alert('字典编码和字典值不能输入空格，请修改！', 2);
			return false;
		}
		if (bolRepeat) {
			$.alert('字典编码或字典值有重复，请修改！', 2);
			return false;
		}
		var param = "";
		$.each(dicArr, function(i, item) {
			param += item + ";";
		});
		param = param.substr(0, param.length - 1);
		$('#dictVal_edit').val(param);

		loading();
		var editDictionaryForm = $("#editDictionaryForm").serialize();
		$.post(ctx + "/system/dictionary/editDict.action", editDictionaryForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert('字典组编码或者名称已经存在!', 2);
			} else {
				layer.close(index);
				$.alert('数据字典修改成功!', 1);
				conditionSearch();
			}
		}, "json");
	}
	// 删除部门
	function deleteConfirm() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			layer.confirm('确认要删除吗？', {
				icon : 3
			}, function(index) {
				loading();
				$.post(ctx + "/system/dictionary/deleteDict.action", {
					id : node.id
				}, function(data) {
					loadClose();
					if (!data.result) {
						$.alert('删除字典失败!', 2);
					} else {
						layer.close(index);
						$.alert('删除字典成功!', 1);
						conditionSearch();
					}
				}, "json");
			});
		} else {
			$.alert('请先选择要删除的字典记录!');
		}
	}

	// 添加一行字典输入框-增加弹窗里的
	function createTR() {
		$('#dic')
				.append(
						'<tr class="dicTd"><td style="padding: 5px 5px 0px 0px;"><div class="input-icon right"><i class="fa"></i><input class="form-control key" name="key" style="width: 250px;" /></div></td><td style="padding: 5px 5px 0px 0px;"><div class="input-icon right"><i class="fa"></i><input class="form-control value" name="value" style="width: 250px;" /></div></td><td style="padding: 5px 5px 0px 0px;"><input type="button" value="+" style="width: 30px;" onclick="dict.createTR();"></td><td style="padding: 5px 5px 0px 0px;"><input type="button" value="-" style="width: 30px;" class="delDic"></td></tr>');
		$(".delDic:last").click(function() {
			if ($('.dicTd').length > 1) {
				$(this).parent().parent().remove();
			}
		});
		$('.key, .value').focus();
	}

	// 添加一行字典输入框 - 修改弹窗里的
	function createTR_edit() {
		var tr_html = '<tr class="dicTd_edit">';
		tr_html += '<td style="padding: 5px 5px 0px 0px;"><div class="input-icon right"><i class="fa"></i>';
		tr_html += '<input class="form-control key_edit" name="key" style="width: 250px;" /></div></td>';
		tr_html += '<td style="padding: 5px 5px 0px 0px;"><div class="input-icon right"><i class="fa"></i>';
		tr_html += '<input class="form-control value_edit" name="value" style="width: 250px;" /></div></td>';
		tr_html += '<td style="padding: 5px 5px 0px 0px;"><input type="button" value="+" style="width: 30px;" onclick="dict.createTR_edit();" /></td>';
		tr_html += '<td style="padding: 5px 5px 0px 0px;"><input type="button" value="-" style="width: 30px;" class="delDic_edit" /></td>';
		tr_html += '</tr>'
		$('#dic_edit').append(tr_html);
		$(".delDic_edit:last").click(function() {
			if ($('.dicTd_edit').length > 1) {
				$(this).parent().parent().remove();
			}
		});
		editValidator.form();
		$('.key_edit, .value_edit').focus();
	}

	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		addDictionary : addDictionary,
		editDictionary : editDictionary,
		deleteConfirm : deleteConfirm,
		createTR : createTR,
		createTR_edit : createTR_edit
	}
}();

$(function() {
	$(".delDic").click(function() {
		if ($('.dicTd').length > 1) {
			$(this).parent().parent().remove();
		}
	});
});