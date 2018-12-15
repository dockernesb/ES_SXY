var trigger = function() {
	var table = $('#triggersGrid').DataTable(// 创建一个Datatable
	{
		ajax : {
			url : CONTEXT_PATH + "/system/trigger/list.action",
			type : 'post',
			data : {
				jobName : $.trim($('#jobName').val()),
				triggerName : $.trim($('#triggerName').val())
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
			"data" : "id.triggerName"
		}, {
			"data" : "triggerState"
		}, {
			"data" : "qrtzJobDetails.id.jobName"
		}, {
			"data" : "qrtzJobDetails.description"
		}, {
			"data" : "nextFireTime"
		}, {
			"data" : "prevFireTime"
		}, {
			"data" : "startTime"
		} ],
		columnDefs : [ {
			targets : [ -1, -2, -3 ],
			render : function(value, type, row) {
				if (value > 1) {
					return (new Date(value)).Format("yyyy-MM-dd hh:mm:ss");
				} else {
					return "-";
				}
			}
		}, {
			targets : 1,
			render : function(value, type, row) {
				if (value == 'WAITING') {
					return '等待';
				} else if (value == 'PAUSED') {
					return '暂停';
				}
				return "执行中";
			}
		} ]
	});

	$('#triggersGrid tbody').on('click', 'tr', function() {
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			table.$('tr.active').removeClass('active');
			$(this).addClass('active');
		}
	});

	$.getJSON(ctx + "/system/trigger/jobNames.action", function(result) {
		// 初始下拉框
		$('#jobId').select2({
			language : 'zh-CN',
			data : result.items
		});

		$("#jobId").change(function() {
			addValidator.form();
		});
	});

	// 按条件查询
	function conditionSearch(type) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["jobName"] = $.trim($('#jobName').val());
			data["triggerName"] = $.trim($('#triggerName').val());
			table.ajax.reload(null, type==1?true:false);// 刷新列表还保留分页信息
		}
	}
	// 重置查询条件
	function conditionReset() {
		resetSearchConditions('#jobName,#triggerName');
	}

	function addTrigger() {
		$('#addTriggerForm')[0].reset();
		$("#jobId").val(['demoJob-DEFAULT']).trigger('change');
		$.openWin({
			title : '新增任务',
			content : $("#winAdd"),
			area : [ '540px', '330px' ],
			yes : function(index, layero) {
				addTriggerSubmit(index);
			}
		});
		addValidator.form();
	}
	// 保存新加的触发器
	function addTriggerSubmit(index) {
		if (!addValidator.form()) {
			$.alert("表单验证不通过，无法提交！");
			return;
		}
		loading();
		var addTriggerForm = $("#addTriggerForm").serialize();
		$.post(ctx + "/system/trigger/create.action", addTriggerForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert(data.message, 2);
			} else {
				layer.close(index);
				$.alert(data.message, 1);
				conditionSearch();
			}
		}, "json");
	}

	// 删除
	function deleteConfirm() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			layer.confirm('确认要删除吗？', {
				icon : 3
			}, function(index) {
				loading();
				$.post(ctx + "/system/trigger/delete.action?", {
					triggerName : node.id.triggerName,
					group : node.id.triggerGroup
				}, function(data) {
					loadClose();
					if (!data.result) {
						$.alert(data.message, 2);
					} else {
						layer.close(index);
						$.alert(data.message, 1);
						conditionSearch();
					}
				}, "json");
			});
		} else {
			$.alert('请先选择要删除的任务!');
		}
	}

	// 暂停
	function pause() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			layer.confirm('确认要暂停吗？', {
				icon : 3
			}, function(index) {
				loading();
				$.post(ctx + "/system/trigger/pause.action?", {
					triggerName : node.id.triggerName,
					group : node.id.triggerGroup
				}, function(data) {
					loadClose();
					if (!data.result) {
						$.alert(data.message, 2);
					} else {
						layer.close(index);
						$.alert(data.message, 1);
						conditionSearch();
					}
				}, "json");
			});
		} else {
			$.alert('请先选择要暂停的任务!');
		}
	}
	// 恢复
	function resume() {
		var gridNodes = table.rows('.active').data();
		if (gridNodes.length > 0) {
			var node = gridNodes[0];
			layer.confirm('确认要恢复吗？', {
				icon : 3
			}, function(index) {
				loading();
				$.post(ctx + "/system/trigger/resume.action?", {
					triggerName : node.id.triggerName,
					group : node.id.triggerGroup
				}, function(data) {
					loadClose();
					if (!data.result) {
						$.alert(data.message, 2);
					} else {
						layer.close(index);
						$.alert(data.message, 1);
						conditionSearch();
					}
				}, "json");
			});
		} else {
			$.alert('请先选择要恢复的任务!');
		}
	}

	var rules = {
		triggerName : {
			required : true,
			unblank : [],
			illegalChar : [],
			maxlength : 50
		},
		jobId : {
			required : true,
			unblank : []
		},
		cronExpression : {
			required : true,
			maxlength : 30
		}
	};
	var addValidator = $('#addTriggerForm').validateForm(rules);

	return {
		conditionSearch : conditionSearch,
		conditionReset : conditionReset,
		addTrigger : addTrigger,
		deleteConfirm : deleteConfirm,
		pause : pause,
		resume : resume
	}
}();