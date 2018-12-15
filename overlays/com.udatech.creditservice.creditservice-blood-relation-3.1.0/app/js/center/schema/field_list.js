var fl = (function() {

	var tableId = $("#tableId").val();	//	表ID
	var dataCount = parseInt($("#dataCount").val(), 10);	//	表中数据数量
	var addList = [];	//	添加的字段列表(只保存数据库中不存在的记录)
	var delList = [];	//	删除的字段列表(只保存数据库中已存在的记录)
	var modList = [];	//	修改名称、编码、核心、必填、去重、更新、查询、状态的列表(只保存数据库中已存在的记录)
	var nameList = [];	//	修改名称的列表(只保存数据库中已存在的记录)
	var codeList = [];	//	修改编码的列表(只保存数据库中已存在的记录)
	top.sortNum = 0;	//	排序序号
	top.sortList = [];	//	排序列表
	
	//	校验器
	var validator = $("#fieldForm").validateForm({
		name : {
			required:true,
			rangelength:[2,30],
			tableComment:[]
		},
		code : {
			required:true,
			rangelength:[2,30],
			tableName:[],
			keyword:[]
		},
		requiredGroup : {
			digits:true,
			min:1,
			max:99
		}
	}, ".innerSelect,.innerCheckbox");
	
	//创建一个Datatable
	var table = $('#dataTable').DataTable({
        ordering: true,
        order: [[ 0, 'asc' ]],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
        columns: [
            {"data" : "fieldSort", "visible" : false},
            {"data" : "fieldSort", "render": fmtSort},
            {"data" : "name", "render": fmtName},
            {"data" : "code", "render": fmtCode}, 
            {"data" : "type", "render": fmtType}, 
            {"data" : "len", "render": fmtLength},
            {"data" : "isNullable", "render": fmtNullable}, 
            {"data" : "requiredGroup", "render": fmtGroup}, 
            {"data" : "status", "render": fmtStatus}, 
            {"data" : "postil", "render": fmtPostil}, 
            {"data" : "id", "render": fmtOp}
        ],
        drawCallback: function(settings) {
        	//	隐藏排序图标、解绑表头排序功能
        	var $th = $("#fieldForm").find("th.sorting_desc,th.sorting,th.sorting_asc");
        	$th.removeClass("sorting_desc sorting sorting_asc");
        	$th.unbind("click");
        	$th.css("outline", "none");
        	$th.css("cursor", "auto");
        	
        	//	重置按钮状态
        	var $tr = $("#dataTable tbody tr[role='row']");
        	$tr.find("div.sort-top").css("background-position", "7px -14px");
        	$tr.find("div.sort-up").css("background-position", "-37px -14px");
        	$tr.find("div.sort-down").css("background-position", "-60px -14px");
        	$tr.find("div.sort-bottom").css("background-position", "-17px -14px");
        	$tr.find("div.field-sort").css("cursor", "pointer");
        	
        	//	第一行置顶、上移置灰
        	$tr.filter(":first").find("div.sort-top").css("background-position", "7px 9px");
        	$tr.filter(":first").find("div.sort-up").css("background-position", "-37px 9px");
        	$tr.filter(":first").find("div.sort-top").css("cursor", "auto");
        	$tr.filter(":first").find("div.sort-up").css("cursor", "auto");
        	
        	//	最后一行置底、下移置灰
        	$tr.filter(":last").find("div.sort-down").css("background-position", "-60px 9px");
        	$tr.filter(":last").find("div.sort-bottom").css("background-position", "-17px 9px");
        	$tr.filter(":last").find("div.sort-down").css("cursor", "auto");
        	$tr.filter(":last").find("div.sort-bottom").css("cursor", "auto");
	    }
    });
	
	//	初始化checkbox
	function initCheckbox($obj) {
		if (!$obj) {
			$obj = $("#dataTable input.innerCheckbox");
		}
		$obj.iCheck({
			labelHover : false,
			checkboxClass : 'icheckbox_square-blue',
			radioClass : 'iradio_square-blue',
			increaseArea : '20%'
		});
		$(".icheckbox_square-blue").css("margin-right", "0px");
		$obj.on('ifChanged', function(event){
			changeGroup($(this).val());
		}); 
	}
	
	//	查询字段列表
	$.post(ctx + "/schema/getFieldList.action", {
		id : tableId
	}, function(json) {
		if (json && json.list) {
			sortNum = json.list.length || 0;
			table.rows.add(json.list);
			for (var i=0; i<sortNum; i++) {
				sortList.push(i);
				table.cell(i, 0).data(i);
			}
			table.draw();
			$(".innerType").trigger("change");
			validator.form();
			initCheckbox();
		}
	}, "json");
	
	//	弹窗上全选择字典中配置的字段
	$(".selectedAll").click(function() {
		var checked = $(this).is(":checked");
		if (checked) {
			$(".field").prop("checked", true);
		} else {
			$(".field").removeAttr("checked");
		}
	});
	
	//	弹窗上选择字典中配置的字段
	$(".field").click(function() {
		var checked = $(this).is(":checked");
		var notCheckedCount = $(".field:not(:checked)").length;
		if (checked && notCheckedCount == 0) {
			$(".selectedAll").prop("checked", true);
		} else if (!checked) {
			$(".selectedAll").removeAttr("checked");
		}
	});
	
	//	格式化字段名称
	function fmtName(data, type, full) {
		data = data || "";
		return "<div class='input-icon right'><i class='fa'></i>"
				+ "<input type='text' class='innerInput innerInputName form-control' value='" 
				+ data + "' id='" + full.id + "_name' name='name' /></div>";
	}
	
	//	格式化字段编码
	function fmtCode(data, type, full) {
		data = data || "";
		var dis = full.add == 1 ? "" : ( dataCount > 0 ? "disabled='true'" : "" );
		return "<div class='input-icon right'><i class='fa'></i>"
				+ "<input type='text' class='innerInput innerInputCode form-control' value='" 
				+ data + "' id='" + full.id + "_code' name='code' " + dis + " /></div>";
	}
	
	//	格式化字段类型
	function fmtType(data, type, full) {
		var value = full.type;
		var cls = full.add == 1 ? "add" : "";
		var eve = full.add == 1 ? "onchange='fl.typeChangeLen(\"" + full.id + "\")'" : "";
		var dis = full.add == 1 ? "" : "disabled='true'";
		var op = "<select class='form-control innerSelect innerType " + cls + "' id='" + full.id + "_type' " + eve + " " + dis + ">"
			   + "<option value='VARCHAR2' " + (value == "VARCHAR2" ? "selected='selected'" : "") + ">VARCHAR2</option>"
			/*   + "<option value='CLOB' " + (value == "CLOB" ? "selected='selected'" : "") + ">CLOB</option>"*/
			   + "</select>";
		return op;
	}
	
	//	格式化字段长度
	function fmtLength(data, type, full) {
		data = data || "";
		var cls = full.add == 1 ? "add" : "";
		var dis = full.add == 1 ? "" : "disabled='true'";
		return "<div class='input-icon right'><i class='fa'></i>"
				+ "<input type='text' class='form-control innerInput innerInputLen " 
				+ cls + "' value='" + data + "' name='len" + full.id + "' id='" 
				+ full.id + "_len' " + dis + " /></div>";
	}
	
	//	格式化字段是否必填
	function fmtNullable(data, type, full) {
		data = data || 0;
		return "<label class='innerLabel'><input type='checkbox' class='innerCheckbox' "
				+ "value='" + full.id + "'"
				+ (data == 0 ? "checked='checked'" : "") + " id='" + full.id + "_nullable' /></label>";
	}
	
	//	格式化分组
	function fmtGroup(data, type, full) {
		var isNullable = full.isNullable || 0;
		var dis = isNullable == 0 ? "" : "disabled='true'";
		data = data || "";
		return "<div class='input-icon right'><i class='fa'></i>" 
				+ "<input type='text' class='innerInput innerInputCode form-control' value='" 
				+ data + "' id='" + full.id + "_requiredGroup' name='requiredGroup' " + dis + " /></div>";
	}
	
	//	格式化批注
	function fmtPostil(data, type, full) {
		data = data || "";
		var icon = data ? "fa-file-text-o" : "fa-file-o";
		return "<div style='text-align:center;'><i class='fa " + icon + "' id='" 
				+ full.id + "_postil' style='cursor:pointer;' title='" + data + "' "
				+ "onclick='fl.openPostilWin(this, \"" + full.id + "\")'></i></div>";
	}
	
	//	格式化排序
	function fmtSort(data, type, full) {
		return "<div class='field-sort sort-top' title='置顶' onclick='fl.sortTop(this);' onmouseover='fl.sortOver(this);' onmouseout='fl.sortOut(this);'></div>"
				+ "<div class='field-sort sort-up' title='上移一位' onclick='fl.sortUp(this);' onmouseover='fl.sortOver(this);' onmouseout='fl.sortOut(this);'></div>"
				+ "<div class='field-sort sort-down' title='下移一位' onclick='fl.sortDown(this);' onmouseover='fl.sortOver(this);' onmouseout='fl.sortOut(this);'></div>"
				+ "<div class='field-sort sort-bottom' title='置底' onclick='fl.sortBottom(this);' onmouseover='fl.sortOver(this);' onmouseout='fl.sortOut(this);'></div>";
	}
	
	//	格式化字段状态
	function fmtStatus(data, type, full) {
		var value = full.status || 0;
		var op = "<select class='form-control innerSelect' id='" + full.id + "_status'>"
			   + "    <option value='1' " + (value == 1 ? "selected='selected'" : "") + ">有效</option>"
			   + "    <option value='0' " + (value == 0 ? "selected='selected'" : "") + ">无效</option>"
			   + "</select>";
		return op;
	}
	
	//	格式化操作列
	function fmtOp(data, type, full) {
		var add = full.add || "0";
		var op = "<a href='javascript:;' onclick='fl.openRuleWin(\"" + full.id + "\", " + add + ")'>规则</a>&nbsp;&nbsp;";
		op += "<a href='javascript:;' onclick='fl.copyRow(\"" + full.id + "\")'>复制</a>&nbsp;&nbsp;";
	
		if (full.add == 1 || dataCount <= 0) {
			op += "<a href='javascript:;' onclick='fl.deleteRow(\"" + full.id + "\", " + add + ")'>删除</a>";
		}
		return op;
	}
	
	//	根据下标移动表格行
	//	type==1，置顶
	//	type==2，上移
	//	type==3，下移
	//	type==4，置底
	function sortMove(index, type) {
		if (index >=0 && index < sortList.length) {
			var curIndex = sortList[index];
			switch (type) {
            case 1: //  第一个
            	for (var i=0; i<index; i++) {
            		sortList[index - i] = sortList[index - i - 1];
            		table.cell(sortList[index - i], 0).data(index - i);
            	}
            	sortList[0] = curIndex;
            	table.cell(curIndex, 0).data(0);
                break;
            case 2: //  上一个
            	var anoIndex = sortList[index - 1];
            	sortList[index - 1] = curIndex;
            	sortList[index] = anoIndex;
            	table.cell(curIndex, 0).data(index - 1);
            	table.cell(anoIndex, 0).data(index);
                break;
            case 3: //  下一个
            	var anoIndex = sortList[index + 1];
            	sortList[index + 1] = curIndex;
            	sortList[index] = anoIndex;
            	table.cell(curIndex, 0).data(index + 1);
            	table.cell(anoIndex, 0).data(index);
                break;
            case 4: //  最后一个
            	for (var i=index; i<sortList.length - 1; i++) {
            		sortList[i] = sortList[i + 1];
            		table.cell(sortList[i], 0).data(i);
            	}
            	sortList[sortList.length - 1] = curIndex;
            	table.cell(curIndex, 0).data(sortList.length - 1);
                break;
            }
			table.draw();
		}
	}
	
	top.table = table;
	
	//	置项
	function sortTop(obj) {
		$tr = $(obj).parent("td").parent("tr");
		var index = $tr.prevAll().length;
		if (index > 0) {
			sortMove(index, 1);
		}
	}
	
	//	上移
	function sortUp(obj) {
		$tr = $(obj).parent("td").parent("tr");
		var index = $tr.prevAll().length;
		if (index > 0) {
			sortMove(index, 2);
		}
	}
	
	//	下移
	function sortDown(obj) {
		$tr = $(obj).parent("td").parent("tr");
		var index = $tr.prevAll().length;
		if (index < sortList.length - 1) {
			sortMove(index, 3);
		}
	}
	
	//	置底
	function sortBottom(obj) {
		$tr = $(obj).parent("td").parent("tr");
		var index = $tr.prevAll().length;
		if (index < sortList.length - 1) {
			sortMove(index, 4);
		}
	}
	
	//	鼠标移上排序按钮
	function sortOver(obj) {
		$tr = $(obj).parent("td").parent("tr");
		var index = $tr.prevAll().length;
		if ($(obj).hasClass("sort-top")) {
			if (index != 0) {
				$(obj).css("background-position", "7px -40px");
			}
		} else if ($(obj).hasClass("sort-up")) {
			if (index != 0) {
				$(obj).css("background-position", "-37px -40px");
			}
		} else if ($(obj).hasClass("sort-down")) {
			if (index != sortList.length - 1) {
				$(obj).css("background-position", "-60px -40px");
			}
		} else if ($(obj).hasClass("sort-bottom")) {
			if (index != sortList.length - 1) {
				$(obj).css("background-position", "-17px -40px");
			}
		}
	}
	
	//	鼠标移出排序按钮
	function sortOut(obj) {
		$tr = $(obj).parent("td").parent("tr");
		var index = $tr.prevAll().length;
		if ($(obj).hasClass("sort-top")) {
			if (index != 0) {
				$(obj).css("background-position", "7px -14px");
			}
		} else if ($(obj).hasClass("sort-up")) {
			if (index != 0) {
				$(obj).css("background-position", "-37px -14px");
			}
		} else if ($(obj).hasClass("sort-down")) {
			if (index != sortList.length - 1) {
				$(obj).css("background-position", "-60px -14px");
			}
		} else if ($(obj).hasClass("sort-bottom")) {
			if (index != sortList.length - 1) {
				$(obj).css("background-position", "-17px -14px");
			}
		}
	}
	
	//	勾选必填时，启用禁用分组输入框
	function changeGroup(id) {
		var bool = $("#" + id + "_nullable").is(":checked");
		if (bool) {
			$("#" + id + "_requiredGroup").removeAttr("disabled");
		} else {
			$("#" + id + "_requiredGroup").val("");
			$("#" + id + "_requiredGroup").attr("disabled", "disabled");
		}
	}
	
	//	删除一行
	function deleteRow(id, add) {
		var rows = table.data();
		if (rows.length > 1) {
			var $tr = $("#" + id + "_name").parent("div").parent("td").parent("tr");
			var index = $tr.prevAll().length;
			var row = table.row($tr);
			if (add != 1) {
				delList.push(row.data());
			}
			row.remove().draw();
			deleteArray(index);
		} else if (rows.length == 1) {
			$.alert('至少需要一个字段！');
		}
	}
	
	//	从列表中删除指定元素
	function deleteArray(index) {
		if (index >=0 && index < sortList.length) {
			sortNum--;
			var oldVal = sortList[index];
			sortList.splice(index, 1);
			for (var i=0; i<sortList.length; i++) {
				if (sortList[i] > oldVal) {
					sortList[i] = sortList[i] - 1;
				}
				table.cell(sortList[i], 0).data(i);
			}
			table.draw();
		}
	}
	
	//	添加一行
	function addRow(name, code) {
		var rows = table.data();
		if (rows.length < 50) {
			var newRow = {"id" : new Date().getTime()};
			newRow["logicTableId"] = tableId;
			newRow["name"] = name || "";
			newRow["code"] = code || "";
			newRow["type"] = "VARCHAR2";
			newRow["len"] = 200;
			newRow["status"] = 1;
			newRow["isNullable"] = 1;
			newRow["requiredGroup"] = 0;
			newRow["fieldSort"] = sortNum++;
			newRow["add"] = 1;	//	新增的标识
			table.row.add(newRow).draw();
			addSomeRule(newRow.id);
			sortList.push(sortList.length);
			return true;
		} else {
			$.alert('最多添加50个字段！');
		}
		return false;
	}
	
	$("#addBtn").click(function() {
		addRow();
	});
	
	//	复制一行
	function copyRow(id) {
		var rows = table.data();
		if (rows.length < 50) {
			for (var i=0; i<rows.length; i++) {
				var row = rows[i];
				if (row.id == id) {
					var newRow = {"id" : new Date().getTime()};
					newRow["logicTableId"] = tableId;
					newRow["name"] = $.trim($("#" + id + "_name").val());
					newRow["code"] = $.trim($("#" + id + "_code").val());
					newRow["type"] = $.trim($("#" + id + "_type").val()) || "VARCHAR2";
					newRow["len"] = $.trim($("#" + id + "_len").val()) || "";
					newRow["status"] = $.trim($("#" + id + "_status").val()) || 1;
					newRow["isNullable"] = $("#" + id + "_nullable").is(":checked") ? 0 : 1;
					newRow["requiredGroup"] = $.trim($("#" + id + "_requiredGroup").val());
					newRow["fieldSort"] = sortNum++;
					newRow["add"] = 1;	//	新增的标识
					newRow["ruleIdList"] = json.clone(row.ruleIdList || []);
					table.row.add(newRow).draw();
					addSomeRule(newRow.id);
					sortList.push(sortList.length);
					return;
				}
			}
		} else {
			$.alert('最多添加50个字段！');
		}
	}
	
	//	返回
	$("#backBtn").click(function() {
		$("div#childBox").hide();
		$("div#parentBox").show();
		var selectArr = recordSelectNullEle();
		$("div#parentBox").prependTo("#topBox");
		callbackSelectNull(selectArr);
		resetIEPlaceholder();
	});
	
	//	新增或复制时name、code、len等增加校验规则
	function addSomeRule(id) {
		initCheckbox($("#" + id + "_nullable"));
		changeLenRule(id);
		validator.form();
	}
	
	//	类型改变时修改长度默认值
	function typeChangeLen(id) {
		changeLenRule(id);
		var type = $("#" + id + "_type").val();
		if (type == "VARCHAR2") {
			$("#" + id + "_len").val(200);
			validator.element($("#" + id + "_len"));
		} else if (type == "CLOB") {
			$("#" + id + "_len").val("");
		}
	}
	
	//	修改长度校验规则
	function changeLenRule(id) {
		var type = $("#" + id + "_type").val();
		$("#" + id + "_len").removeAttr("disabled");
		$("#" + id + "_len").rules("remove", "required,digits,min,max");
		if (type == "VARCHAR2") {
			$("#" + id + "_len").rules("add", {
				required:true,
				digits:true,
				max:4000,
				min:1
			});
		} else if (type == "CLOB") {
			$("#" + id + "_len").attr("disabled", "disabled");
			$("#" + id + "_len").prev("i").removeClass("fa-warning fa-check");
		}
	}
	
	//	校验是否存在相同的编码
	function checkSameCode() {
		var map = {};
		var list = table.data();
		for (var i=0, len=list.length; i<len; i++) {
			var row = list[i];
			var code = $("#" + row.id + "_code").val();
			code = code.toUpperCase();
			if (!map[code]) {
				map[code] = true;
			} else {
				$("#" + row.id + "_code").trigger("click");
				$.alert("字段编码[" + code + "]重复！", 0, function() {
					$("#" + row.id + "_code").focus();
				});
				return false;
			}
		}
		return true;
	}
	
	$("#saveBtn").click(function() {
		addList = [];
		modList = [];
		nameList = [];
		codeList = [];
		saveFieldList();
	});
	
	//	整数要提交的数据
	function disposalData() {
		var rows = table.data();
		for (var i=0; i<sortList.length; i++) {
			var row = rows[sortList[i]] || {};
			var id = row.id;
			var add = row.add;	//	1:新增
			var copy = {"add" : add || 0};
			copy["logicTableId"] = tableId;
			copy["name"] = $.trim($("#" + id + "_name").val());
			copy["code"] = $.trim($("#" + id + "_code").val()).toUpperCase();
			copy["type"] = $.trim($("#" + id + "_type").val());
			copy["len"] = $.trim($("#" + id + "_len").val()) || "0";
			copy["status"] = $.trim($("#" + id + "_status").val());
			copy["isNullable"] = $("#" + id + "_nullable").is(":checked") ? 0 : 1;
			copy["requiredGroup"] = $.trim($("#" + id + "_requiredGroup").val());
			copy["postil"] = encodeURI(row.postil || "");
			copy["fieldSort"] = i;
			
			var str = json.jsonToString(row.ruleIdList || []);
			str = str.replace(/\"/g, "\\\"");
			copy["ruleIdListJson"] = str || "";
			
			if (add == 1) {	//	新增的字段
				addList.push(copy);
			} else {
				copy["id"] = id;
				modList.push(copy);
				if (row.name != copy.name) {	//	字段名称被修改的字段(修改表注释)
					nameList.push(copy);
				}
				if (row.code != copy.code) {	//	字段编码被修改的字段(修改表名)
					copy["oldCode"] = row.code;
					codeList.push(copy);
				}
			}
		}
	}
	
	//	保存数据
	function saveFieldList() {
		if (validator.form()) {
			if (!checkSameCode()) {
				return;
			}
			loading();
			disposalData();
			//	提交数据
			$.post(ctx + "/schema/saveFieldList.action", {
				"id" : tableId,
				"addList" : json.jsonToString(addList),
				"modList" : json.jsonToString(modList),
				"delList" : json.jsonToString(delList),
				"nameList" : json.jsonToString(nameList),
				"codeList" : json.jsonToString(codeList)
			}, function(data) {
				loadClose();
				if (data.result) {
					$.alert('保存成功！', 1, function() {
						$("#backBtn").trigger("click");
					});
				} else {
					$.alert(data.message || "保存失败！", 2);
				}
			}, "json");
		} else {
			$.alert('表单验证不通过！');
		}
	}
	
	//	打开公共字段弹出框
	$("#commonBtn").click(function() {
		$(".selectedAll").removeAttr("checked");
		$(".field").removeAttr("checked");
		$.openWin({
			title: "公共字段选择",
			content: $("#commonDiv"),
			yes: function(index) {
				addCommonField(index);
			}
		});
	});
	
	//	选中字段
	function selectField(obj) {
		var event = window.event || arguments.callee.caller.arguments[0];
		if (!$(event.target).is(".field")) {
			var $checkbox = $(obj).find("input.field");
			$checkbox.trigger("click");
		}
	}
	
	//	添加选中的公共字段
	function addCommonField(index) {
		var $fields = $(".field:checked");
		if ($fields.length == 0) {
			$.alert('请选择要添加的字段！');
		} else {
			layer.close(index);
			$.each($fields, function(i, obj) {
				var name = $(this).parent().next("td").attr("title");
				var code = $(this).parent().next("td").next("td").attr("title");
				var success = addRow(name, code);
				if (!success) {
					return false;
				}
			});
			//	删除空行
			var rows = table.data();
			if (rows.length > 0) {
				for (var i=0; i<rows.length > 0; i++) {
					var row = rows[i];
					if (rows[i].add == 1) {
						var id = rows[i].id;
						var name = $.trim($("#" + id + "_name").val());
						var code = $.trim($("#" + id + "_code").val());
						if (name == "" && code == "") {
							var $tr = $("#" + id + "_name").parent("div").parent("td").parent("tr");
							var index = $tr.prevAll().length;
							var row = table.row($tr);
							row.remove().draw();
							deleteArray(index);
						}
					}
				}
			}
		}
	}
	
	//	根据ID获取一行数据
	function getRowById(id) {
		var rows = table.data();
		if (rows.length < 50) {
			for (var i=0; i<rows.length; i++) {
				var row = rows[i];
				if (row.id == id) {
					return row;
				}
			}
		}
	}
	
	//	批注管理
	function openPostilWin(obj, id) {
		$("#postilDiv").data("id", id);
		$("#postilDiv").data("obj", obj);
		var row = getRowById(id);
		$("#postil").val(row.postil || "");
		setTimeout(function(){document.getElementById("postil").focus();}, 200);
		$.openWin({
			title: "批注管理",
			content: $("#postilDiv"),
			yes: function(index) {
				var text = $.trim($("#postil").val());
				if (text && text.length > 200) {
					$.alert("批注不能超过200个字符！");
					return;
				}
				layer.close(index);
				changePostil();
			}
		});
	}
	
	//	修改批注
	function changePostil() {
		var id = $("#postilDiv").data("id");
		var obj = $("#postilDiv").data("obj");
		var row = getRowById(id);
		if (row && obj) {
			var text = $.trim($("#postil").val());
			row.postil = text || "";
			if (text) {
				$(obj).removeClass("fa-file-o").addClass("fa-file-text-o");
				$(obj).attr("title", text);
			} else {
				$(obj).removeClass("fa-file-text-o").addClass("fa-file-o");
				$(obj).attr("title", text);
			}
		}
	}
	
	//	规则管理
	function openRuleWin(id, add) {
		$("#rowId").val(id);
		$("#ruleDiv input.rule").removeAttr("checked");
		var row = getRowById(id);
		var ruleIdList = row.ruleIdList || [];
		for (var i=0; i<ruleIdList.length; i++) {
			var ruleId = ruleIdList[i];
			$("#" + ruleId).prop("checked", "checked");
		}
		$.openWin({
			title: "规则管理",
			content: $("#ruleDiv"),
			yes: function(index) {
				layer.close(index);
				changeRule();
			}
		});
	}
	
	
	//	改变字段规则
	function changeRule() {
		var $rules = $("#ruleDiv input.rule");
		var rowId = $("#rowId").val();
		var row = getRowById(rowId);
		if (row) {
			var ruleIdList = row.ruleIdList || [];
			var newRuleIdList = [];
			$.each($rules, function(i, obj) {
				var ruleId = $(obj).attr("id");
				if ($(obj).is(":checked")) {	//	选中的
					newRuleIdList.push(ruleId);
				}
			});
			row.ruleIdList = newRuleIdList;
		}
	}
	
	//	选中规则
	function selectRule(obj) {
		var event = window.event || arguments.callee.caller.arguments[0];
		if (!$(event.target).is(".rule")) {
			var $checkbox = $(obj).find("input.rule");
			$checkbox.trigger("click");
		}
	}
	
	return {
		sortTop : sortTop,
		sortUp : sortUp,
		sortDown : sortDown,
		sortBottom : sortBottom,
		sortOver : sortOver,
		sortOut : sortOut,
		deleteRow : deleteRow,
		copyRow : copyRow,
		openRuleWin : openRuleWin,
		openPostilWin : openPostilWin,
		typeChangeLen : typeChangeLen,
		selectField : selectField,
		selectRule : selectRule
	};

})();
