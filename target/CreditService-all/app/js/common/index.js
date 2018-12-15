var userPhotoPath = "";

$(function() {
	// 获取未读系统消息
	getMsgCount();
	
	$.getJSON(ctx + '/system/user/getUserPhoto.action', function(result) {
		userPhotoPath = result.userPhotoPath;
		$("#userPhotoImg").attr("src", ctx + "/common/viewImg.action?path=" + userPhotoPath);
		// 刷新用户头像
		refreshPhoto();
	});
});
// 主页
function gotoHome() {
	window.top.location.href = ctx + '/index.action';
}

// userType帐号类型：管理员(0), 中心端(1), 业务端(2), 政务端(3);
// 根据用户类型打开对应主界面
function openIndex(userType) {
	if (userType == 2) {// 业务端(2)
		var url = ctx + "/hall/index/toHallIndex.action";
	}else if (userType == 3) {// 政务端(3)
		var url = ctx + "/gov/dataAnalysis/toDataAnalysis.action";
	} else {//管理员,中心端
		var url=  ctx + "/center/index/toCenterIndex.action";
	}
    AccordionMenu.openUrl("&nbsp;", url);
}

function refreshPhoto() {
	if (isNull(userPhotoPath)) {
		$('img.userPhoto').attr('src', rsa + '/admin/layout/img/photo3.jpg');
	}
}

// 根据用户类型打开对应个人中心
function openSelfCenter(userType) {
	var url = ctx + "/system/user/toCenter.action";
	AccordionMenu.openUrl('个人中心', url);
}

// 获取未读系统消息
function getMsgCount() {
	$.getJSON(ctx + '/system/message/unread.action', function(unreadList) {
		if (unreadList.length && unreadList.length > 0) {
			$("#msgLabel").html(unreadList.length);
		} else {
			$("#msgLabel").html('');
		}
	});
}

function logOut() {
	layer.confirm('您确定要退出系统吗？', {
		icon : 3
	}, function(index) {
		location = 'logout.action';
	});
}

var rules = {
	oldPwd : {
		required : true,
		unblank : [],
		notchineseG : [],
		minlength : 6,
		maxlength : 50
	},
	newPwd : {
		required : true,
		unblank : [],
		notchineseG : [],
		minlength : 6,
		maxlength : 50
	},
	surePwd : {
		required : true,
		equalTo : "#newPwd"
	}
};
var addValidator = $('#editPwdForm').validateForm(rules);

// 修改密码
function editPwd() {
	$('#editPwdForm')[0].reset();
	$.openWin({
		title : '修改密码',
		content : $("#winEditPwd"),
		area : [ '540px', '330px' ],
		yes : function(index, layero) {
			editPwdSubmit(index);
		}
	});
	addValidator.form();
}
function editPwdSubmit(index) {
	if (!addValidator.form()) {
		$.alert("密码长度最少6个字,且新密码和确认密码相同！");
		return;
	}
	loading();
	var editPwdForm = $("#editPwdForm").serialize();
	$.post(ctx + "/system/user/editPwd.action", editPwdForm, function(data) {
		loadClose();
		if (!data.result) {
			$.alert(data.message, 2);
		} else {
			layer.close(index);
			$.alert('密码修改成功，请重新登录!', 1, function() {
				top.document.location = ctx + "/logout.action";
			});
		}
	}, "json");
}

/*----------------------------系统消息----------------------------------*/
// 显示系统消息弹框
function showMessage() {
	initMsgTable(true);// 创建一个Datatable
}
// 创建一个系统消息Datatable
var table;
function initMsgTable(isFirst, state) {
	if (typeof (state) == "undefined") {
		state = false;
	}
	$.getJSON(ctx + '/system/message/list.action', {
		state : state
	}, function(result) {
		table = $('#sysMessageTable').DataTable({
			dom : '<t>r<"tfoot"lp>',
			destroy : true,// 如果需要重新加载的时候请加上这个
			lengthChange : true,// 是否允许用户改变表格每页显示的记录数
			searching : false,// 是否允许Datatables开启本地搜索
			ordering : false,
			autoWidth : false,
			paging : true,
			pageLength : 5,
			data : result.rows,
			// 使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
			// data 这里是固定不变的
			columns : [ {
				"data" : null
			}, {
				"data" : "state",
				"render" : stateFormatter
			}, {
				"data" : "title",
				"render" : titleFormatter
			}, {
				"data" : "sendName"
			}, {
				"data" : "sendDate"
			} ],
			columnDefs : [ {
				targets : 0, // checkBox
				render : function(data, type, row) {
					return '<input type="checkbox" name="checkThis" class="icheck">';
				}
			} ],
			drawCallback : function(settings) {
				$('#sysMessageTable .checkall').iCheck('uncheck');
				$('#sysMessageTable .checkall, #sysMessageTable tbody .icheck').iCheck({
					labelHover : false,
					cursor : true,
					checkboxClass : 'icheckbox_square-blue',
					radioClass : 'iradio_square-blue',
					increaseArea : '20%'
				});

				// 列表复选框选中取消事件
				var checkAll = $('#sysMessageTable .checkall');
				var checkboxes = $('#sysMessageTable tbody .icheck');
				checkAll.on('ifChecked ifUnchecked', function(event) {
					if (event.type == 'ifChecked') {
						checkboxes.iCheck('check');
						$('#sysMessageTable tbody tr').addClass('active');
					} else {
						checkboxes.iCheck('uncheck');
						$('#sysMessageTable tbody tr').removeClass('active');
					}
				});
				checkboxes.on('ifChanged', function(event) {
					if (checkboxes.filter(':checked').length == checkboxes.length) {
						checkAll.prop('checked', 'checked');
					} else {
						checkAll.removeProp('checked');
					}
					checkAll.iCheck('update');

					if ($(this).is(':checked')) {
						$(this).closest('tr').addClass('active');
					} else {
						$(this).closest('tr').removeClass('active');
					}
				});

				// 添加行选中点击事件
				$('#sysMessageTable tbody tr').on('click', function() {
					$(this).toggleClass('active');
					if ($(this).hasClass('active')) {
						$(this).find('.icheck').iCheck('check');
					} else {
						$(this).find('.icheck').iCheck('uncheck');
					}
				});
			}
		});
		$('#msgDetail').hide();
		$('#msgDiv').show();
		if (isFirst) {// 第一次打开弹框时
			$.openWin({
				title : '系统消息',
				content : $("#sysMsgDiv"),
				area : [ '760px', '460px' ],
				btn : [ "关闭" ],
				btnAlign : 'r'
			});
		}
	});
}
// 返回消息列表
function msgBack() {
	initMsgTable(false);
}

// 格式化消息状态显示
function stateFormatter(data, type, full) {
	// 数据类型type -有这些值：filter、display、type、sort
	if (data) {
		return "已读";
	} else {
		return "未读";
	}
}

// 格式化标题显示
function titleFormatter(data, type, full) {
	if($.type(full.taskId) != "undefined") {
		return "<a href='javascript:void(0);' onclick=handle('"+data+"','"+full.id+"','"+full.state+"','"+full.taskId+"',this)>"+data+"</a>";
	} else if(full.recordId != undefined ){
		return "<a href='javascript:void(0);' onclick=handle1('"+data+"','"+full.id+"','"+full.recordId+"',this)>"+data+"</a>";
	} else {
		return '<a href="javascript:void(0);" onclick="showDetail(\'' + full.id + '\',\'' + full.state + '\');">' + data + '</a>';
	}
}

function handle(value, id, state, taskId, obj) {
	if (state=="false"){
		read(id);
	}
	openWin(ctx + "/workflow/processHandlePage/userTaskPage.action?taskId="+taskId+'&isMsgType=1','showDetail');
}

function handle1(value, id, recordId,obj) {
	read(id);
	openWin(ctx + "/workflow/usertask/showProcess.action?processInstanceId="+recordId+"&&modulId=MyCopyWork&isMsgType=1",'showDetail');
}

function read(id) {
	$.post(ctx + "/system/message/read.action",{id:id},function(data){
		//reloadtree();
	});
}

// 系统消息弹框按钮查询功能
function conditionSearch1(state) {
	initMsgTable(false, state);
}
// 查看消息详细
function showDetail(id, state) {
	$.getJSON(CONTEXT_PATH + "/system/message/showDetail.action", {
		id : id
	}, function(data) {
		$('#sendUser').html(data.sendName);
		$('#sendTime').html(data.sendDate);
		$('#msgContent').html(data.content);
		$('#msgDiv').hide();
		$('#msgDetail').show();
	});
}
// 消息操作：批量已读、批量删除
function operMessage(type) {
	var rows = table.rows('.active').data();
	if (rows.length == 0) {
		$.alert("请选择消息！");
		return;
	}
	var str = "";
	var pass = true;
	$.each(rows, function(index, item) {
		if (!item.state) {// 未读
			str += item.id + ",";
		} else {
			pass = false;
			return;
		}
	});
	if (!pass) {
		$.alert("请选择未读消息！");
		return;
	}
	if (1 == type) {
		$.post(ctx + "/system/message/readAll.action", {
			ids : str.substring(0, str.length - 1)
		}, function(data) {
			$.alert("操作成功！", 1, function() {
				initMsgTable(false);
			});
		});
	} else if (0 == type) {
		layer.confirm('确认要删除消息吗？', {
			icon : 3
		}, function(index) {
			loading();
			$.post(ctx + "/system/message/deleteMessage.action", {
				ids : str.substring(0, str.length - 1)
			}, function(data) {
				loadClose();
				if (!data.result) {
					$.alert('删除失败！', 2);
				} else {
					layer.close(index);
					$.alert('删除成功！', 1);
					initMsgTable(false);
				}
			}, "json");
		});
	}
}

//保存主题皮肤设置
function saveThemeSkin(){
	var panel = $('.theme-panel');
	
	var themeColors = $('li.tooltips.current', panel).attr('data-style'); // 选中的主题皮肤
	var themeStyle = $('.layout-style-option', panel).val(); // 选中的主题样式
//	var layout = $('.layout-option', panel).val(); // 布局
	var header = $('.page-header-option', panel).val(); // 顶部
	var topMenuDropdown = $('.page-header-top-dropdown-style-option', panel).val(); // 顶部下拉菜单皮肤
	var sidebarMode = $('.sidebar-option', panel).val(); // 侧边栏模式
	var sidebarMenu = $('.sidebar-menu-option', panel).val(); // 侧边栏菜单 
	var sidebarStyle = $('.sidebar-style-option', panel).val(); // 侧边栏样式 
	var sidebarPosition = $('.sidebar-pos-option', panel).val(); // 侧边栏位置 
	var footer = $('.page-footer-option', panel).val(); // 底部

	loading();
	$.post(ctx + "/system/user/saveThemeSkin.action",{
		themeColors : themeColors,
		themeStyle : themeStyle,
//		layout : layout,
		header : header,
		topMenuDropdown : topMenuDropdown,
		sidebarMode : sidebarMode,
		sidebarMenu : sidebarMenu,
		sidebarStyle : sidebarStyle,
		sidebarPosition : sidebarPosition,
		footer : footer
	}, function (data) {
		loadClose();
		if (data.result) {
			$.alert('保存设置成功！', '1');
			$('.toggler-close').click();
		} else {
			$.alert('保存设置失败！', '2');
		}
	}, "json");

}