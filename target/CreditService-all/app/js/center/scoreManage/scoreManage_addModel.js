/**
 * 新建评分模型模板用JS
 */
var addModel = (function() {
	var rules = {
		cjpfmx_mxmc : {
			required : true,
			unblank : [],
			illegalCharacter : [ '.-（）()' ],
			maxlength : 20
		},
		cjpfmx_mxms : {
			required : true,
			unblank : [],
			illegalCharacter : [ '.-（）()' ],
			maxlength : 250
		}
	};
	var addModelForm = $('#addModelForm').validateForm(rules);

	// 禁用所有的选项卡
	var tab = (function() {
		var index = 0;
		function changeTab() {
			$("#myTab li.active").removeClass("active");
			$("#myTab li:eq(" + index + ")").addClass("active");
			$("div.tab-content div.tab-pane.active.in")
					.removeClass("active in");
			$("div.tab-content div.tab-pane:eq(" + index + ")").addClass(
					"in active");
			addModelForm.form();
		}
		return {
			prev : function() {
				if (index > 0) {
					index--;
					changeTab();
				}
			},
			next : function() {
				if (index < 7) {
					var validateRes = validateByTabIndex(index);
					if (validateRes) {
						index++;
						changeTab();
					}
				}
			}
		};
	})();

	// 删除行
	function delRow(k) {
		$(k).parent().parent().remove();
	}

	// table添加行
	function addRow(table, id) {
		var rowNum = $("#" + table + " tr").length - 1; // 总行数
		var newRow = $("#trForAdd tr:eq(" + id + ")").clone(true); // 获取tr
		$.each($(newRow).find("input"), function(i, item) {
			$(item).val('');
		});
		$("#" + table + " tr:eq(" + rowNum + ")").before(newRow); // 在table的最后一行前面添加一行
	}

	// 进入页面时添加一行
	addRow('jysj', '0');
	addRow('gsgm', '1');
	addRow('gdzce', '2');
	addRow('zczj', '3');
	addRow('sbjne', '4');
	addRow('qynse', '5');
	addRow('bzry', '6');
	addRow('qfxx', '7');
	addRow('qsxx', '8');
	addRow('sbqje', '9');
	
	// 企业资质列表
	var table = $('#appGrid').DataTable({
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
			url : CONTEXT_PATH + '/center/scoreManage/queryQYZZZS.action', // 后台地址
			type : 'post'
		},
		serverSide : true, // 设置服务器方式
		processing : true, // 表格加载时的提示
		columns : [ {
			"data" : "ZZMC"
		}, {
			"data" : "RDJGQC"
		}, {
			"data" : "ZZMC", // 操作
			render : function(data) {
				var str = '<button type="button" class="btn btn-xs yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addQyzz(\'' + data + '\');"> 选择</button>';
				return str;
			}
		} ]
	});
	
	// 添加企业资质
	function addQyzz(zzmc) {
		var allInputs = $(":input[name='qyzz_zzmc']");
		var flg = 0;
		$.each(allInputs, function(i, obj) {
			var hasVal = $(obj).val();
			if (zzmc == hasVal) {
				flg = 1;
			}
		});
		if (flg == 1) {
			$.alert('请勿重复添加！');
		} else {
			var str = "";
			str += "<tr>";
			str += "	<td align='left' nowrap >" + zzmc;
			str += "	<input name='qyzz_zzmc' type='hidden' class='form-control' value='" + zzmc + "'/>";
			str += "	</td>";
			str += "	<td align='center' nowrap >";
			str += '        <div class="input-icon right"><i class="fa"></i>';
			str += '		    <input name="qyzz_fs" type="greaterThanZero" required class="form-control"/>';
			str += '        </div>';
			str += "	</td>";
			str += "	<td align='center' nowrap>";
			str += "        <button type='button' class='btn btn-xs red' style='margin-top: 3px;margin-right: 10px;float: right;' onclick='addModel.delRow(this);'> 删除</button>";
			str += "	</td>";
			str += "</tr>";
			var $str = $(str);
			$("#qyzz_qj tbody").append($str); // 在table的最后一行前面添加一行
			$("input").blur(function() {
				addModelForm.element($(this));
			});
		}
	}

	function goNext() {
		tab.next();
	}

	// 上一步
	function goBack() {
		tab.prev();
	}

	// 根据DivId验证
	function validateByTabIndex(tabIndex) {
		var validateRes = false;
		switch (tabIndex) {
		case 0:
			validateRes = validTab1();
			break;
		case 1:
			validateRes = validTab2();
			break;
		case 2:
			validateRes = validTab3();
			break;
		case 3:
			validateRes = validTab4();
			break;
		case 4:
			validateRes = validTab5();
			break;
		case 5:
			validateRes = validTab6();
			break;
		case 6:
			validateRes = validTab7();
			break;
		}

		return validateRes;
	}

	// 校验tab_1
	function validTab1() {
		var res_mc = $("#addModelForm").validate().element($("#cjpfmx_mxmc"));
		var res_ms = $("#addModelForm").validate().element($("#cjpfmx_mxms"));
		if (res_mc && res_ms) {
			return true;
		} else {
			return false;
		}
	}

	// 校验tab_2
	function validTab2() {
		var res = true;
		$('#tab_2 input[type=greaterThanZero]').each(function() {
			var tab2 = $("#addModelForm").validate().element(this);
			if (!tab2) {
				res = false;
			}
		});
		if (res) {
			var allCnt = 0;
			$('#tab_2 input[type=greaterThanZero]').each(function() {
				allCnt += parseInt(this.value);
			});
			if (allCnt != 400) {
				$.alert('分数设置总分必须等于400分，当前总分：' + allCnt);
				res = false;
			} else {
				$("#qygk_zf").html($("#fspz_qygk").val());// 企业概况
				$("#sxxx_zf").html($("#fspz_sxxx").val());// 失信信息
				$("#bzry_zf").html($("#fspz_bzry").val());// 荣誉表彰
				$("#zscq_zf").html($("#fspz_zscq").val());// 知识产权
				$("#qyzz_zf").html($("#fspz_qyzz").val());// 企业资质
				$("#qsqf_zf").html($("#fspz_qsqf").val());// 欠税欠费
			}
		}
		return res;
	}

	// 校验tab_3
	function validTab3() {
		var res = true;
		$('#tab_3 input[type=greaterThanZero]').each(function() {
			var tab = $("#addModelForm").validate().element(this);
			if (!tab) {
				res = false;
			}
		});

		if (res) {
			var jysjZf = parseInt($("#qyxx_jysjzf").val(), 10); // 经营时间总分
			var gsgmZf = parseInt($("#qyxx_gsgmzf").val(), 10); // 公司规模总分
			var gdzceZf = parseInt($("#qyxx_gdzcezf").val(), 10); // 固定资产额总分
			var zczjZf = parseInt($("#qyxx_zczjzf").val(), 10); // 注册资金总分
			var sbjneZf = parseInt($("#qyxx_sbjnezf").val(), 10); // 社保缴纳额总分
			var qynseZf = parseInt($("#qyxx_qynsezf").val(), 10); // 企业纳税额总分
			var allZf = jysjZf + gsgmZf + gdzceZf + zczjZf + sbjneZf + qynseZf; // 当前页面总分
			var zf = parseInt($("#qygk_zf").html(), 10); // 总分
			if (allZf != zf) {
				$.alert('分数设置必须等于企业概况总分，当前总分：' + allZf);
				res = false;
			}
			// （1）经营时间区间验证
			else if (!validateQjf("qyxx_jysj", '经营时间', jysjZf)) {
				res = false;
			}
			// （2）公司规模区间验证
			else if (!validateQjf("qyxx_gsgm", '公司规模', gsgmZf)) {
				res = false;
			}
			// （3）固定资产额区间验证
			else if (!validateQjf("qyxx_gdzce", '固定资产额', gdzceZf)) {
				res = false;
			}
			// （4）注册资金区间验证
			else if (!validateQjf("qyxx_zczj", '注册资金', zczjZf)) {
				res = false;
			}
			// （5）社保缴纳额区间验证
			else if (!validateQjf("qyxx_sbjne", '社保缴纳额', sbjneZf)) {
				res = false;
			}
			// （6）企业纳税额区间验证
			else if (!validateQjf("qyxx_qynse", '企业纳税额', qynseZf)) {
				res = false;
			}
		} 
		return res;
	}

	// 校验tab_4
	function validTab4() {
		var res = true;
		$('#tab_4 input[type=greaterThanZero]').each(function() {
			var tab = $("#addModelForm").validate().element(this);
			if (!tab) {
				res = false;
			}
		});

		if (res) {
			var sxxx_ZF = parseInt($("#sxxx_zf").html(), 10);
			var sxxx_ybsxFS = parseInt($("#sxxx_ybsxfs").val(), 10);
			var sxxx_jzsxFS = parseInt($("#sxxx_jzsxfs").val(), 10);
			var sxxx_yzsxFS = parseInt($("#sxxx_yzsxfs").val(), 10);
			if (sxxx_ybsxFS > sxxx_ZF) {
				$.alert('一般失信分数不可超过可配置总分。');
				res = false;
			} else if (sxxx_jzsxFS > sxxx_ZF) {
				$.alert('较重失信分数不可超过可配置总分。');
				res = false;
			} else if (sxxx_yzsxFS > sxxx_ZF) {
				$.alert('严重失信分数不可超过可配置总分。');
				res = false;
			}
		}
		return res;
	}

	// 校验tab_5
	function validTab5() {
		var res = true;
		$('#tab_5 input[type=greaterThanZero]').each(function() {
			var tab = $("#addModelForm").validate().element(this);
			if (!tab) {
				res = false;
			}
		});

		if (res) {
			var bzryZf = parseInt($("#bzry_zf").html(), 10);
			// 表彰荣誉区间验证
			if (!validateQjf("bzry", '表彰荣誉', bzryZf)) {
				res = false;
			}
		} 
		return res;
	}

	// 校验tab_6
	function validTab6() {
		var res = true;
		$('#tab_6 input[type=greaterThanZero]').each(function() {
			var tab = $("#addModelForm").validate().element(this);
			if (!tab) {
				res = false;
			}
		});

		if (res) {
			var zscq_zf = parseInt($("#zscq_zf").html(), 10);
			if (parseInt($("#zscq_wgzlfs").val(), 10) > zscq_zf) {
				$.alert('外观专利分数必须小于或等于知识产权总分');
				res = false;
			} else if (parseInt($("#zscq_syxxfs").val(), 10) > zscq_zf) {
				$.alert('实用新型分数必须小于或等于知识产权总分');
				res = false;
			} else if (parseInt($("#zscq_fmzlfs").val(), 10) > zscq_zf) {
				$.alert('发明专利分数必须小于或等于知识产权总分');
				res = false;
			} else if (parseInt($("#zscq_zzqfs").val(), 10) > zscq_zf) {
				$.alert('著作权分数必须小于或等于知识产权总分');
				res = false;
			} else if (parseInt($("#zscq_rjzzqfs").val(), 10) > zscq_zf) {
				$.alert('软件著作权分数必须小于或等于知识产权总分');
				res = false;
			}
		}
		return res;
	}

	// 校验tab_7
	function validTab7() {
		var res = true;
		$('#tab_7 input[type=greaterThanZero]').each(function() {
			var tab = $("#addModelForm").validate().element(this);
			if (!tab) {
				res = false;
			}
		});

		if (res) {
			var qyzz_zf = parseInt($("#qyzz_zf").html(), 10);
			var qyzzFs = 0;
			var qyzzFsZf = 0;
			$("input[name='qyzz_fs']").each(function() {
				qyzzFs = parseInt($(this).val(), 10);
				qyzzFsZf += qyzzFs;
			});
			if (qyzzFsZf == 0) {
				$.alert('企业资质指标向分数设置不能为空');
				res = false;
			} else if (qyzzFs > qyzz_zf) {
				$.alert('企业资质分数必须小于或等于企业资质总分');
				res = false;
			}
		}
		return res;
	}
	
	// 校验tab_8
	function validTab8() {
		var res = true;
		$('#tab_8 input[type=greaterThanZero]').each(function() {
			var tab = $("#addModelForm").validate().element(this);
			if (!tab) {
				res = false;
			}
		});

		if (res) {
			var qsqf_qfxxzf = parseInt($("#qsqf_qfxxzf").val(), 10); // 欠费信息总分
			var qsqf_qsxxzf = parseInt($("#qsqf_qsxxzf").val(), 10); // 欠税信息总分
			var qsqf_sbqjezf = parseInt($("#qsqf_sbqjezf").val(), 10); // 社保欠缴额总分
			var allZf = qsqf_qfxxzf + qsqf_qsxxzf + qsqf_sbqjezf; // 当前页面总分
			var zf = parseInt($("#qsqf_zf").html(), 10); // 总分
			if (allZf != zf) {
				$.alert('分数设置必须等于欠税欠费总分，当前总分：' + allZf);
				res = false;
			} 
			// （1）欠费信息区间验证
			else if(!validateQjf("qsqf_qfxx", '欠费信息', qsqf_qfxxzf)){
				res = false;
			}
			// （2）欠税信息区间验证
			else if(!validateQjf("qsqf_qsxx", '欠税信息', qsqf_qsxxzf)){
				res = false;
			}
			// （3）社保欠缴额区间验证
			else if(!validateQjf("qsqf_sbqje", '社保欠缴额', qsqf_sbqjezf)){
				res = false;
			}
		}
		return res;
	}

	// 验证区间
	function validateQjf(id, name, maxFs) {
		var res = true;
		var qjf_fs = 0;
		$("div.tab-content input[name='" + id + "qjfs']").each(
				function(i, item) {
					qjf_fs = parseInt($(item).val(), 10);
					if (qjf_fs > maxFs) {
						$.alert(name + '分数设置必须小于或等于总分');
						res = false;
						return false;
					}
				})
		if (!res) {
			return false;
		}
		var qjF_arr = new Array();
		$("div.tab-content input[name='" + id + "qjF']").each(
				function(i, item) {
					qjF_arr[i] = parseInt($(item).val(), 10);
				})
		qjF_arr.push(parseInt($("div.tab-content input[name='" + id + "qjM")
				.val(), 10));
		var qjE_arr = new Array();
		$("div.tab-content input[name='" + id + "qjE']").each(
				function(i, item) {
					qjE_arr[i] = parseInt($(item).val(), 10);
				})
		for (var i = 0; i < qjE_arr.length; i++) {
			if (qjE_arr[i] < qjF_arr[i]) {
				$.alert(name + '区间结束段设置必须大于起始区间段');
				res = false;
				return false;
			}
			if (qjE_arr[i] != qjF_arr[i + 1]) {
				$.alert(name + '区间起始段设置必须等于上一项的结束段');
				res = false;
				return false;
			}
		}
		return res;
	}
	
	// 保存按钮
	function saveModel() {
		// 验证输入正确性
		if (!validTab8()) {
			return;
		}
		loading();
		$('#addModelForm').ajaxSubmit({
			url : CONTEXT_PATH + '/center/scoreManage/addModel.action',
			dataType : "json",
			success : function(data) {
				loadClose();
				if (data.result) {
					$.alert("创建成功", 1, goBackList());
				} else {
					var msg = "";
					if (data.message) {
						msg = "(" + (data.message || "") + ")";
					}
					$.alert("创建失败" + msg, 2);
				}
			}
		});
		
	}

	// 新建模型
	function goBackList() {
		var selectArr = recordSelectNullEle();
        $("div#fatherDiv").prependTo("#topBox");
        callbackSelectNull(selectArr);
        $("div#fatherDiv").show();
        $("div#childDiv").hide();
        var activeIndex = recordDtActiveIndex(smml.table);// 父页面的table
        smml.table.ajax.reload(function(){
        	callbackDtRowActive(smml.table, activeIndex);
        }, false);// 刷新列表还保留分页信息
        resetIEPlaceholder();
	}

	addModelForm.form();
	$("input").blur(function() {
		addModelForm.element($(this));
	});

	return {
		addQyzz : addQyzz,
		addRow : addRow,
		delRow : delRow,
		goNext : goNext,
		goBack : goBack,
		goBackList : goBackList,
		saveModel : saveModel
	};

})();