refreshPhoto();

var personalCenter = (function() {
	var rules = {
		realName : {
			required : true,
			illegalChar : [],
			maxlength : 20
		},
		idCard : {
			idCard : []
		},
		address : {
			maxlength : 100
		},
		email : {
			email : [],
			maxlength : 30
		},
		phoneNumber : {
			phone : [],
			maxlength : 30
		}
	};
	var editValidator = $('#editUserForm').validateForm(rules);
	
	// 打开修改页面
	function onEditUser() {
		$('#editUserForm')[0].reset();
		var oldGender = 0;
		if ($('#oldGender').val() == "true") {
			oldGender = 1;
		}
		$("#editGender").select2({
			language : 'zh-CN',
			minimumResultsForSearch: -1
		}).val(oldGender).trigger("change");
		
		resizeSelect2($("#editGender"));
		$.openWin({
			title : '编辑资料',
			content : $("#winEdit"),
			btnAlign : 'c',
			area : [ '600px', '450px' ],
			yes : function(index, layero) {
				editUser(index);
			}
		});
		editValidator.form();
	}
	// 修改用户
	function editUser(index) {
		if (!editValidator.form()) {
			$.alert("请检查所填信息！");
			return;
		}

		loading();
		var editUserForm = $("#editUserForm").serialize();
		var url = ctx + "/system/user/userEdit.action";
		$.post(url, editUserForm, function(data) {
			loadClose();
			if (!data.result) {
				$.alert("编辑资料失败！", "2");
			} else {
				$.alert("编辑资料成功！", "1");
			}
			layer.close(index);
			AccordionMenu.openUrl('个人中心', ctx + "/system/user/toCenter.action");
		}, "json");
	}

	$(".upload-img").uploadFile({
		showList : false,
		supportTypes : [ "jpg", "jpeg", "gif", "png", "bmp" ],
		beforeUpload : function() {
			loading();
		},
		multiple : false,
		callback : function(data) {
			if (data.success && data.success.length > 0) {
				var file = data.success[0];
				var filePath = file.path;
				saveUserPhoto(filePath);
			}
			if (data.fail && data.fail.length > 0) {
				var msg = "";
				for (var i = 0, len = data.fail.length; i < len; i++) {
					var fail = data.fail[i];
					msg += fail.name + "\t" + fail.msg + "\n";
				}
				$.alert(msg);
			}
		}
	});
	
	function saveUserPhoto(tempFilePath){
		var url = ctx + "/system/user/saveUserPhoto.action?userPhotoPath=" + tempFilePath;
		$.post(url, function(data) {
			loadClose();
			if (!data.result) {
				$.alert("修改头像失败！", "2");
			} else {
				$.alert("修改头像成功！", "1");
				$("#userPhotoPath").val(data.filePath);
				userPhotoPath = data.filePath;
				$("img.userPhoto").attr("src", ctx + "/common/viewImg.action?path=" + data.filePath);
			}
		}, "json");
	}
	return {
		editUser : editUser,
		onEditUser : onEditUser
	}
})();