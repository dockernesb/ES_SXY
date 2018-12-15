$(function() {
	$("textarea,input[type='text']").change(function() {
		var isfe = false;
		var url = window.location.href;
		if (url.indexOf("/ChartManage/view.action") <= 0 && url.indexOf("/ChartManage/add.action") <= 0 
		        && url.indexOf("/system/role/role.action") <= 0 && url.indexOf("/system/dictionary/dictionary.action") <= 0
		        && url.indexOf("/system/datapermission") <= 0){
			if (this.value.indexOf("<") != -1) {
				isfe = true;
				this.value = this.value.replace(/</g, "");
			}
			if (this.value.indexOf(">") != -1) {
				this.value = this.value.replace(/>/g, "");
				isfe = true;
			}
			
			if (url.indexOf("/workflow/formdef/editForm.action") <= 0 
					&& url.indexOf("/system/menu/menu.action") <= 0){
				if (this.value.indexOf("&") != -1) {
					this.value = this.value.replace(/&/g, "");
					isfe = true;
				}
			}
			if (url.indexOf("/workflow/form/showlayoutfield.action") <= 0){
				if (this.value.indexOf("\"") != -1) {
					this.value = this.value.replace(/"/g, "");
					isfe = true;
				}
			}
			if (this.value.indexOf("'") != -1) {
				this.value = this.value.replace(/'/g, "");
				isfe = true;
			}
			if (this.value.indexOf("·") != -1) {
				this.value = this.value.replace(/·/g, "");
				isfe = true;
			}
			if (this.value.indexOf("……") != -1) {
				this.value = this.value.replace(/……/g, "");
				isfe = true;
			}
			if (this.value.indexOf("——") != -1) {
				this.value = this.value.replace(/——/g, "");
				isfe = true;
			}
			if (this.value.indexOf("‘") != -1) {
				this.value = this.value.replace(/‘/g, "");
				isfe = true;
			}
			if (this.value.indexOf("’") != -1) {
				this.value = this.value.replace(/’/g, "");
				isfe = true;
			}
			if (this.value.indexOf("“") != -1) {
				this.value = this.value.replace(/“/g, "");
				isfe = true;
			}
			if (this.value.indexOf("”") != -1) {
				this.value = this.value.replace(/”/g, "");
				isfe = true;
			}
			if (this.value.indexOf("×") != -1) {
				this.value = this.value.replace(/×/g, "");
				isfe = true;
			}
			if (isfe) {
				$.messager.alert('提示', "非法字符<,>,&,\",',·,……,——,‘,’,“,”,×被过滤!", 'info');
			}
		}
	})
});