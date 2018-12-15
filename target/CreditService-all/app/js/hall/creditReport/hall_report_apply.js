(function() {

	var tabIndex = 0; // tab下标

	var handleTitle = function(tab, navigation, index) {
		var total = navigation.find('li').length;
		var current = index + 1;

		if (current == 2) {
			var qymc = $.trim($("#qymc").val());
			var gszch = $.trim($("#gszch").val());
			var zzjgdm = $.trim($("#zzjgdm").val());
			if (!qymc) {
				$.alert("企业名称不能为空！");
				return false;
			}
			var yyzzLen = $("input[name='yyzzPath']").length;
			var zzjgdmzLen = $("input[name='zzjgdmzPath']").length;
			if (yyzzLen <= 0) {
				$.alert("营业执照必须上传！");
				return false;
			}
		}

		if (current == 3) {
			var type = $('input[name="type"]:checked').val();
			// 企业自查
			var jbrxm = validator.element("#jbrxm");
			var jbrsfzhm = validator.element("#jbrsfzhm");
			var jbrlxdh = validator.element("#jbrlxdh");
			if (!jbrxm || !jbrsfzhm || !jbrlxdh) {
				$.alert("表单验证不通过！");
				return false;
			}
			if (type == 0) {
				var sfzLen = $("input[name='sfzPath']").length;
				if (sfzLen <= 0) {
					$.alert("请上传身份证！");
					return false;
				}
				// 清空切换为委托查询时填写的内容，如果有的话
				// 委托内容
				$("#sqsearchInput").val('').change();
				$("#sqqymc").val('');
				$("#sqgszch").val('');
				$("#sqzzjgdm").val('');
				$("#sqtyshxydm").val('');
				$("#sqsfz,#sqqysqs,#sqfrzmwj").cclResetUpload();
			} else {
				// 委托查询
				var sqqymc = $.trim($("#sqqymc").val());
				var sqgszch = $.trim($("#sqgszch").val());
				var sqzzjgdm = $.trim($("#sqzzjgdm").val());
				var sqtyshxydm = $.trim($("#sqtyshxydm").val());
				if (!sqqymc) {
					$.alert("授权法人名称不能为空！");
					return false;
				}

				var qymc = $.trim($("#qymc").val());
				var gszch = $.trim($("#gszch").val());
				var zzjgdm = $.trim($("#zzjgdm").val());
				var tyshxydm = $.trim($("#tyshxydm").val());
				if ((qymc == sqqymc && qymc != '') || (gszch == sqgszch && gszch != '') || (zzjgdm == sqzzjgdm && zzjgdm != '') || (tyshxydm == sqtyshxydm && tyshxydm != '')) {
					$.alert("第一步申请报告的企业信息和授权法人信息相同！请选择企业自查模式。");
					return false;
				}

				var sfzLen = $("input[name='sqsfzPath']").length;
				if (sfzLen <= 0) {
					$.alert("请上传身份证！");
					return false;
				}
				// 清空切换为企业自查时填写的内容，如果有的话
				// 自查内容
				$("#sfz,#qysqs").cclResetUpload();
			}

		}

		if (current == 4) {
			/*var bz = validator.element("#bz");*/
			var areaDepts = validator.element("#areaDepts");
			var projectName = validator.element("#projectName");
			var projectXL = validator.element("#projectXL");
			var purpose = validator.element("#purpose");
			var sqbgqssj = $("#sqbgqssj").val();
			var sqbgjzsj = $("#sqbgjzsj").val();
			if (!purpose) {
				$.alert("申请报告用途不能为空！");
				return false;
			}

			/*if (!$.trim($("#bz").val())) {
                $.alert("备注不能为空！");
                return false;
            }*/
			
			if (!$.trim($("#areaDepts").val())) {
                $.alert("区域部门不能为空！");
                return false;
            }
			
			if (!$.trim($("#projectName").val())) {
                $.alert("项目名称不能为空！");
                return false;
            }
			if (!$.trim($("#projectXL").val())) {
                $.alert("项目细类不能为空！");
                return false;
            }
			
			if(!areaDepts || !projectName ||!projectXL){
				$.alert("填入字符过长，请修改！");
				return false;
			}
			/*if (!bz) {
				$.alert("备注超长，请修改！");
				return false;
			}*/

			if (isNull(sqbgqssj) || isNull(sqbgjzsj)) {
				$.alert("报告起止时间不能为空！");
				return false;
			}
			if (sqbgqssj > sqbgjzsj) {
				$.alert("报告起始时间不能大于截止时间！");
				return false;
			}
		}

		$('li').removeClass("done");
		var li_list = navigation.find('li');
		for (var i = 0; i < index; i++) {
			$(li_list[i]).addClass("done");
		}

		if (current == 1) {
			$('.button-previous').hide();
		} else {
			$('.button-previous').show();
		}

		if (current >= total) {
			$('.button-next').hide();
			$('.button-submit').show();
		} else {
			$('.button-next').show();
			$('.button-submit').hide();
		}

		if (current == 4) {
			$(".button_reset").hide();
		} else {
			$(".button_reset").show();
		}

		return true;
	};

	$('#submit_form').bootstrapWizard({
		'nextSelector' : '.button-next',
		'previousSelector' : '.button-previous',
		onTabClick : function(tab, navigation, index, clickedIndex) {
			return false;
		},
		onNext : function(tab, navigation, index) {
			return handleTitle(tab, navigation, index);
		},
		onPrevious : function(tab, navigation, index) {
			handleTitle(tab, navigation, index);
		},
		onTabShow : function(tab, navigation, index) {
			var total = navigation.find('li').length;
			var current = index + 1;
			tabIndex = current;
			var $percent = (current / total) * 100;
			$('div.progress-bar').css({
				width : $percent + '%'
			});
			if (current == 4) {
				initView();
			}
		}
	});

	// 初始化预览
	function initView() {
		$("#qymcView").val($("#qymc").val());
		$("#gszchView").val($("#gszch").val());
		$("#zzjgdmView").val($("#zzjgdm").val());
		$("#tyshxydmView").val($("#tyshxydm").val());
		var type = $('input[name="type"]:checked').val();
		$("#jbrxmView").val($("#jbrxm").val());
		$("#jbrsfzhmView").val($("#jbrsfzhm").val());
		$("#jbrlxdhView").val($("#jbrlxdh").val());
		if (type == 0) {
			// 企业自查
			$('#sqdivtab4').addClass('hide');
			$('#sqfrzmwjView').closest('.form-group').addClass('hide');
			$('#qysqsView').closest('.form-group').removeClass('hide');
			$('#sqqysqsView').closest('.form-group').addClass('hide');
		} else {
			// 委托查询
			$("#sqqymcView").val($("#sqqymc").val());
			$("#sqgszchView").val($("#sqgszch").val());
			$("#sqzzjgdmView").val($("#sqzzjgdm").val());
			$("#sqtyshxydmView").val($("#sqtyshxydm").val());
			$('#sqdivtab4').removeClass('hide');
			$('#qysqsView').closest('.form-group').addClass('hide');
			$('#sqqysqsView').closest('.form-group').removeClass('hide');
			$('#sqfrzmwjView').closest('.form-group').removeClass('hide');
		}

		$("#purposeView").val($("#purpose").select2('data')[0].text);
		$("#sqbgqssjView").val($("#sqbgqssj").val());
		$("#sqbgjzsjView").val($("#sqbgjzsj").val());
		$("#bzView").val($("#bz").val());
		$("#areaDeptsView").val($("#areaDepts").val());
		$("#projectNameView").val($("#projectName").val());
		$("#projectXLView").val($("#projectXL").val());
		setTimeout(function() {
			copyImg();
		}, 0);
	}

	// 复制图片
	function copyImg() {
		$.each($(".upload-img:not(label)"), function(i, obj) {
			var id = $(obj).attr("id");
			var $target = $(obj).data("target");
			if ($target && $target.length == 1) {
				var viewId = id + "View";
				var $clone = $target.clone();
				$clone.find("input").remove();
				$clone.find("div.delete").remove();
				$("#" + viewId).children().remove();
				$("#" + viewId).append($clone);

				$clone.find("img").click(function() {
					openPhoto($(this).attr("src"));
				});
			}
		});

	}

	// 初始化单选框
	$('input[name="type"]').iCheck({
		checkboxClass : 'icheckbox_square-blue',
		radioClass : 'iradio_square-blue',
		increaseArea : '20%'
	});

	$('input[name="type"]').on('ifChecked', function(event) {
		if ($(event.target).val() == 0) {
			$('#zcdiv').removeClass('hide');
			$('#sqdiv').addClass('hide');
		} else {
			$('#zcdiv').addClass('hide');
			$('#sqdiv').removeClass('hide');
			// 企业委托查询搜索
			searchInfo('#sqsearchInput', '#sqfasearch', '#sqqymc', '#sqgszch', '#sqzzjgdm', '#sqtyshxydm', '#sqqyxx');
		}
	});

	$('.button-previous').hide();
	$('.button-submit').hide();

	// 初始化上传图片按钮
	// $(".upload-img").uploadImg();

	// 示例如下，所有参数均可选，都有默认值
	$(".upload-img:not(#sfz,#sqsfz)").cclUpload({
		type : "img", // 文件类型（img | file），默认为file
		multiple : false, // 是否多选（默认单选替换）
		showList : true
	});
	$("#sfz,#sqsfz").cclUpload({
		"type" : "img",
		"showList" : true,
		"multiple" : true,
		"max" : 2
	});

	function resetStep2() {
		$("#jbrxm").val("");
		$("#jbrsfzhm").val("");
		$("#jbrlxdh").val("");
		$("#sfz,#qysqs").cclResetUpload();
		// 委托信息
		$("#sqsearchInput").val('').change();
		$("#sqqymc").val('');
		$("#sqgszch").val('');
		$("#sqzzjgdm").val('');
		$("#sqtyshxydm").val('');
		$("#sqsfz,#sqqysqs,#sqfrzmwj").cclResetUpload();
		validator.form();
	}

	$(".button_reset").click(function() {
		if (tabIndex == 1) {
			$("#searchInput").val("").change();
			$("#qymc").val("");
			$("#gszch").val("");
			$("#zzjgdm").val("");
			$("#tyshxydm").val("");
			$("#yyzz,#zzjgdmz").cclResetUpload();
		} else if (tabIndex == 2) {
			resetStep2();
		} else if (tabIndex == 3) {
			$('#purpose').val(null).trigger('change');
			$("#bz").val("");
			
			$('#sqbgqssj').val(threeYearsAgo); // 设置开始时间为三年前
			$('#sqbgjzsj').val(today); // 结束时间为当日
		}
		validator.form();
	});

	// 搜索企业信息
	function searchInfo(searchInputId, searchBtnId, qymcId, gszchId, zzjgdmId, tyshxydmId, qyxxDivId) {
		$(searchInputId).combobox({
			url : ctx + "/creditCommon/getEnterpriseList.action",
			key : "ID",
			value : "NAME",
			searchBtn : searchBtnId,
			callback : function(i, row) {
				$(qymcId).val(row.JGQC);
				$(gszchId).val(row.GSZCH);
				$(zzjgdmId).val(row.ZZJGDM);
				$(tyshxydmId).val(row.TYSHXYDM);
			}
		});
	}

	// 企业自查搜索
	searchInfo('#searchInput', '#fasearch', '#qymc', '#gszch', '#zzjgdm', '#tyshxydm', '#qyxx');

	var validator = $('#submit_form').validateForm({
		jbrxm : {
			required : true,
			maxlength : 50
		},
		jbrsfzhm : {
			required : true,
			idCard : [],
			maxlength : 18
		},
		jbrlxdh : {
			required : true,
			phone : [],
			maxlength : 15
		},
		sqqymc : {
			required : true
		},
		/*bz : {
            required : true,
			maxlength : 500
		},*/
		purpose : {
			required : true
		},
		areaDepts :{
			required : true,
			maxlength : 50
		},
		projectName :{
			required : true,
			maxlength : 50
		},
		projectXL :{
			required : true,
			maxlength : 50
		}
	});

	validator.form();

	$.getJSON(ctx + "/hallReport/listValues.action?groupKey=applyReportPurpose", function(result) {
		// 初始下拉框
		$("#purpose").select2({
			language : 'zh-CN',
			data : result.items,
			// minimumResultsForSearch : -1,// 去掉搜索框
			// 选中项回调
			templateSelection : function(selection) {
				validator.form();
				return selection.text;
			}
		});
	});

	// 设置初始时间 开始时间为三年前，结束时间为当日
	var today = new Date().format("yyyy-MM");
	var threeYearsAgo = new Date();
	threeYearsAgo.setFullYear(threeYearsAgo.getFullYear() - 3);
	threeYearsAgo = threeYearsAgo.format("yyyy-MM");
	$('#sqbgqssj').val(threeYearsAgo); // 设置开始时间为三年前
	$('#sqbgjzsj').val(today); // 结束时间为当日

    $("#sqbgqssj").datepicker({
        language: "zh-CN",
        todayHighlight: true,
        format: 'yyyy-mm',
        autoclose: true,
        startView: 'months',
        maxViewMode:'year',
        minViewMode:'months',
        defaultDate:'-3y',   //默认日期
        endDate: today,
    }).on("changeDate", function(e) {
        $( "#sqbgjzsj" ).datepicker( "setStartDate", $(this).val() );
    });

    $("#sqbgjzsj").datepicker({
        language: "zh-CN",
        todayHighlight: true,
        format: 'yyyy-mm',
        autoclose: true,
        startView: 'months',
        maxViewMode:'year',
        minViewMode:'months',
        startDate: "-3y",
    }).on("changeDate", function(e) {
        $( "#sqbgqssj" ).datepicker( "setEndDate", $(this).val() );
    });

    function fillDate() {
        var qssj = $('#sqbgqssj').val();
        if (qssj) {
            qssj = qssj + "-01";
            $('#sqbgqssj').val(qssj);
        }
        var jzsj = $('#sqbgjzsj').val();
        if (jzsj) {
            var year = jzsj.substring(0, 4);
            var month = parseInt(jzsj.substring(5, 7) || 0, 10) - 1;
            var lastDay = getLastDay(year, month);
            $('#sqbgjzsj').val(jzsj + "-" + lastDay);
        }
    }

    function getLastDay(year,month) {
        var new_year = year;  //取当前的年份
        var new_month = ++month;//取下一个月的第一天，方便计算（最后一天不固定）
        if(month>11) {     //如果当前大于12月，则年份转到下一年
            new_month -=12;    //月份减
            new_year++;      //年份增
        }
        var new_date = new Date(new_year,new_month,1);        //取当年当月中的第一天
        return (new Date(new_date.getTime()-1000*60*60*24)).getDate();    //获取当月最后一天日期
    }

	$(".button-submit").click(function() {
		loading();
        fillDate();
		$("#submit_form").ajaxSubmit({
			url : ctx + "/hallReport/addReport.action",
			success : function(result) {
				loadClose();
				if (result.result) {
					if ($('#audit').val() == 0 && !isNull(result.xybgbh)) {
						layer.confirm(result.message, {
							icon : 1,
							btn : [ '立即打印', '暂不打印' ]
						}, function(index) {
							layer.close(index);
							// 报告生成成功，新窗口直接打开生成过的报告页面
							if (isAcrobatPluginInstall()) {
								var url = ctx + '/reportQuery/viewReport.action?xybgbh=' + result.xybgbh;
								var newwin = window.open(url);
								newwin.focus();
								// 添加信用报告预览日志
								addPreViewLog(result.id);
							} else {
								$.alert("未安装Adobe Reader，无法预览！");
							}
							
							var url = ctx + "/hallReport/toReportApply.action";
							$("div#mainContent").load(url);
						}, function() {
							var url = ctx + "/hallReport/toReportApply.action";
							$("div#mainContent").load(url);
						});
					} else {
						layer.confirm(result.message, {
							icon : 1,
							btn : [ '立即打印反馈单', '暂不打印' ]
						}, function(index) {
							layer.close(index);
							var url = ctx + "/hallReport/printReportApply.action?id=" + result.id;
							window.open(url, "信用报告申请反馈单");
							url = ctx + "/hallReport/toReportApply.action";
							$("div#mainContent").load(url);
						}, function() {
							var url = ctx + "/hallReport/toReportApply.action";
							$("div#mainContent").load(url);
						});
					}
				} else {
					$.alert(result.message, 2);
				}
			},
			dataType : "json"
		});
	});

    $("#djbrsfz").click(function() {
        var CVR_IDCard = document.getElementById("CVR_IDCard");
        var strReadResult = CVR_IDCard.ReadCard();
        if (strReadResult == "0") {
            $("#jbrxm").val(CVR_IDCard.Name);
            $("#jbrsfzhm").val(CVR_IDCard.CardNo);
        } else {
            $.alert("读卡失败，无卡或卡片已读过！", 2);
        }
    });

})();