
// ccl上传封装
$.fn.extend({
	//	初始化图片上传组件
	uploadImg : function(opts) {
		opts = opts || {};
		return this.each(function(i, obj) {
			var $self = $(this);
			var alreadyInit = $self.data("alreadyInit");
			
			if (alreadyInit) {
				return;
			} else {
				$self.data("alreadyInit", true);
			}
			
			var name = $self.attr("id") || "img";
			var cls = $self.attr("class");
			var text = $self.html();
			var supportTypes = opts["supportTypes"] || ["jpg", "jpeg", "gif", "bmp", "png"];
			var callback = opts["callback"] || null;
			var multiple = opts["multiple"];
			var beforeUpload = opts["beforeUpload"] || null;
			if (typeof(multiple) == "undefined") {
				multiple = true;
			}
			
			var url = ctx + "/common/ajaxFileUpload.action";
			var $form = $("#uploadImgForm");
			var $file = $form.children("input");
			
			var $div = $('<div class="preview-img-panel"></div>');
			$self.after($div);
			$self.data("$div", $div);
			
			var $label = $('<label for="uploadImgInput" class="' + cls + '">' + text + '</label>');
			$self.before($label);
			$self.hide();
			
			if ($form.length == 0) {
				$form = $('<form id="uploadImgForm" method="post" action="' + url + '" enctype="multipart/form-data" style="display:none;"></form>');
				$file = $('<input id="uploadImgInput" type="file" name="files" accept="*" multiple />');
				$time = $('<input id="timeInput" type="hidden" />');
				$form.append($file).append($time);
				$("body").append($form);
				
				$file.change(function() {
					// 文件格式校验
					var temp = $(this).val();
					if (temp != null && temp != '') {
						var index = temp.lastIndexOf("\\");
						if (index > 0) {
							temp = temp.substring(index + 1);
						}
						index = temp.lastIndexOf(".");
						var suffix = temp.substring(index + 1).toLowerCase();
						if ($.inArray(suffix, supportTypes) == '-1') {
							$.alert('请选择正确的图片格式!<br/>支持格式：[ ' + supportTypes.join(", ") + ' ]');
							return;
						}
					} else {
						return;
					}
					
					if ($form.data("beforeUpload") instanceof Function) {
						$form.data("beforeUpload")();
					}
					
					$time.val(new Date().getTime());
					loading();
					$form.ajaxSubmit({
						success : function(result) {
							loadClose();
							$form[0].reset();
							if (result.success && result.success.length > 0) {
								showImg(result.success);
							}
							if (result.fail && result.fail.length > 0) {
								var msg = "";
								for (var i=0, len=result.fail.length; i<len; i++) {
									var fail = result.fail[i];
									msg += "\"" + fail.name + "\"" + fail.msg + "\n";
								}
								$.alert(msg);
							}
						},
						dataType : "json"
					});
					
					function showImg(list) {
						var html = '';
						for (var i=0, len=list.length; i<len; i++) {
							var img = list[i];
							html += '<div class="preview-img">';
							html += '<img src="' + ctx + '/common/viewImg.action?path=' + img.path + '" />';
							html += '<div class="fa fa-trash-o delete"></div>';
							html += '<input type="hidden" name="' + $form.data("name") + 'Name" value="' + img.name + '" />';
							html += '<input type="hidden" name="' + $form.data("name") + 'Path" value="' + img.path + '" />';
							html += '</div>';
						}
						$form.data("$div").append(html);
						openPhotoListener();
						delImgListener();
					}
					
					function delImgListener() {
						$form.data("$div").find("div.delete").unbind("click").click(function() {
							$(this).parent().remove();
						});
					}
					
					function openPhotoListener() {
						$form.data("$div").find("img").unbind("click").click(function() {
							var url = $(this).attr("src");
							openPhoto(url);
						});
					}
				});
			}
			
			$label.click(function() {
				$form.data("$div", $div);
				$form.data("name", name);
				$form.data("beforeUpload", beforeUpload);
				if (multiple) {
					$("#uploadImgInput").attr("multiple", "multiple");
				} else {
					$("#uploadImgInput").removeAttr("multiple");
				}
			});
		});
	},
	
	//	清除图片预览
	cleanImg : function() {
		return this.each(function() {
			var $self = $(this);
			var $div = $self.data("$div");
			if ($div) {
				$div.children().remove();
			}
		});
	},
	
	// ccl上传封装
	uploadFile : function(opts) {
		opts = opts || {};
		return this.each(function(i, obj) {
			var $self = $(this);
			var alreadyInit = $self.data("alreadyInit");
			
			if (alreadyInit) {
				return;
			} else {
				$self.data("alreadyInit", true);
			}
			
			var name = $self.attr("id") || "file";
			var cls = $self.attr("class");
			var text = $self.html();
			var supportTypes = opts["supportTypes"] || [];
			var beforeUpload = opts["beforeUpload"] || null;
			var callback = opts["callback"] || null;
			var showList = opts["showList"];
			var multiple = opts["multiple"];
			if (typeof(showList) == "undefined") {
				showList = true;
			}
			if (typeof(multiple) == "undefined") {
				multiple = true;
			}
			var url = ctx + "/common/ajaxFileUpload.action";
			var $form = $("#uploadFileForm");
			var $file = $form.children("input");
			
			var $div = $('<div class="preview-img-panel"></div>');
			if (showList) {
				$self.after($div);
				$self.data("$div", $div);
			}
			
			var $label = $('<label for="uploadFileInput" class="' + cls + '">' + text + '</label>');
			$self.before($label);
			$self.hide();
			
			if ($form.length == 0) {
				$form = $('<form id="uploadFileForm" method="post" action="' + url + '" enctype="multipart/form-data" style="display:none;"></form>');
				$file = $('<input id="uploadFileInput" type="file" name="files" accept="*" multiple />');
				$time = $('<input id="timeInput" type="hidden" />');
				$form.append($file).append($time);
				$("body").append($form);
				
				$file.change(function() {
					// 文件格式校验
					var temp = $(this).val();
					if (temp != null && temp != '') {
						var index = temp.lastIndexOf("\\");
						if (index > 0) {
							temp = temp.substring(index + 1);
						}
						index = temp.lastIndexOf(".");
						var suffix = temp.substring(index + 1).toLowerCase();
						var types = $form.data("supportTypes");
						if (types.length > 0 && $.inArray(suffix, types) == '-1') {
							$.alert('请选择正确的文件格式!<br/>支持格式：[ ' + types.join(", ") + ' ]');
							return;
						}
					} else {
						return;
					}
					
					if ($form.data("beforeUpload") instanceof Function) {
						$form.data("beforeUpload")();
					}
					
					$time.val(new Date().getTime());
					loading();
					$form.ajaxSubmit({
						success : function(result) {
							loadClose();
							$form[0].reset();
							if ($form.data("callback") instanceof Function) {
								$form.data("callback")(result, $form.data("$self"));
							}
							if (result.success && result.success.length > 0) {
								if ($form.data("showList")) {
									showImg(result.success);
								}
							}
							if (result.fail && result.fail.length > 0) {
								var msg = "";
								for (var i=0, len=result.fail.length; i<len; i++) {
									var fail = result.fail[i];
									msg += "\"" + fail.name + "\"" + fail.msg + "\n";
								}
								$.alert(msg);
							}
						},
						dataType : "json"
					});
					
					function showImg(list) {
						var html = '';
						for (var i=0, len=list.length; i<len; i++) {
							var file = list[i];
							html += '<div class="preview-file">';
							html += '<div class="preview-icon"><img src="' + ctx + '/app/images/icon/' + file.icon + '" /></div>';
							html += '<div class="preview-name">' + file.name + '</div>';
							html += '<div class="fa fa-trash-o delete"></div>';
							html += '<input type="hidden" name="' + $form.data("name") + 'Name" value="' + file.name + '" />';
							html += '<input type="hidden" name="' + $form.data("name") + 'Path" value="' + file.path + '" />';
							html += '</div>';
						}
						$form.data("$div").append(html);
						delImgListener();
					}
					
					function delImgListener() {
						$form.data("$div").find("div.delete").unbind("click").click(function() {
							$(this).parent().remove();
						});
					}
					
				});
			}
			
			$label.click(function() {
				$form.data("$self", $self);
				$form.data("$div", $div);
				$form.data("name", name);
				$form.data("showList", showList);
				$form.data("supportTypes", supportTypes);
				$form.data("beforeUpload", beforeUpload);
				$form.data("callback", callback);
				if (multiple) {
					$("#uploadFileInput").attr("multiple", "multiple");
				} else {
					$("#uploadFileInput").removeAttr("multiple");
				}
			});
		});
	},
	
	//	清除上传文件
	cleanFile : function() {
		return this.each(function() {
			var $self = $(this);
			var $div = $self.data("$div");
			if ($div) {
				$div.children().remove();
			}
		});
	},
	
	// 下载封装
	download : function(opts) {
		opts = opts || {};
		var label = opts["label"] || "下载";
		return this.each(function() {
			var uploadFileId = $(this).val();
			var $previewBtn = $('<a href="javascript:void(0)" class="upload-img preview">' + label + '</a>');
			$(this).after($previewBtn);

			// 打开图片预览框
			$previewBtn.click(function() {
				if (uploadFileId != null && uploadFileId != "") {
					document.location = getRootPath() + "/gov/common/ajaxDownload.action?uploadFileId=" + uploadFileId;
				}
			});
		});
	}
});
