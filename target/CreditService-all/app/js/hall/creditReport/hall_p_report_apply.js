(function() {
	var currentStep = 1;// 当前步骤，默认第一步

	var handleTitle = function(tab, navigation, index) {
		if (currentStep == 1) {
			var cxrxm = $.trim($("#cxrxm").val());
			var cxrsfzh = $.trim($("#cxrsfzh").val());
			if (!cxrxm) {
				$.alert("姓名不能为空！");
				return false;
			}
			if (!cxrsfzh) {
				$.alert("身份证号不能为空！");
				return false;
			}
			if (!checkIdCard(cxrsfzh)) {
				$.alert("身份证号格式不正确！");
				return false;
			}
			var cxrsfzPath = $("input[name='cxrsfzPath']").length;
			if (cxrsfzPath <= 0) {
				$.alert("请上传本人身份证！");
				return false;
			}
		}

		if (currentStep == 2) {
			// 委托查询
			var wtrxm = $.trim($("#wtrxm").val());
			var wtrsfzh = $.trim($("#wtrsfzh").val());
			var wtrlxdh = $.trim($("#wtrlxdh").val());
			if (!wtrxm) {
				$.alert("委托人姓名不能为空！");
				return false;
			}
			if (!wtrsfzh) {
				$.alert("委托人身份证号不能为空！");
				return false;
			}
			if (!checkIdCard(wtrsfzh)) {
				$.alert("委托人身份证号格式不正确！");
				return false;
			}

			if (!wtrlxdh) {
				$.alert("委托人联系电话不能为空！");
				return false;
			}

			if (!validator.element('#wtrlxdh')) {
				$.alert("委托人联系电话格式不正确，请填写正确的手机号码！");
				return false;
			}

			var cxrxm = $.trim($("#cxrxm").val());
			var cxrsfzh = $.trim($("#cxrsfzh").val());
			if ((cxrxm == wtrxm && cxrxm != '') || (cxrsfzh == wtrsfzh && cxrsfzh != '')) {
				$.alert("本人信息和委托人信息不能相同！");
				return false;
			}

			var wtrsfzPath = $("input[name='wtrsfzPath']").length;
			if (wtrsfzPath <= 0) {
				$.alert("请上传委托人身份证！");
				return false;
			}
			var wtsqsPath = $("input[name='wtsqsPath']").length;
			if (wtsqsPath <= 0) {
				$.alert("请上传委托授权书！");
				return false;
			}
		}

		if (currentStep == 3) {
			var purpose = validator.element("#purpose");
			var sqbgqssj = $("#sqbgqssj").val();
			var sqbgjzsj = $("#sqbgjzsj").val();
			if (!purpose) {
				$.alert("报告用途不能为空！");
				return false;
			}
			if (isNull(sqbgqssj) || isNull(sqbgjzsj)) {
				$.alert("报告起止时间不能为空！");
				return false;
			}
			if (sqbgqssj > sqbgjzsj) {
				$.alert("报告起始时间不能大于截止时间！");
				return false;
			}
			if (!validator.element("#bz")) {
				$.alert("备注超长，请修改！");
				return false;
			}
		}

		$('li').removeClass("done");
		var li_list = navigation.find('li');
		for (var i = 0; i < index; i++) {
			$(li_list[i]).addClass("done");
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
			var passFlag = handleTitle(tab, navigation, index);
			if (passFlag) {
				if (currentStep == 1 && navigation.find('li:eq(1)').hasClass('disabled')) {
					currentStep += 2;
				} else {
					currentStep++;
				}
				if (currentStep > 4) {
					currentStep = 4;
				}
				if (currentStep == 2) {
					searchInfo('#wtsearchInput', '#wtfasearch', '#wtrxx', '#wtrxm', '#wtrsfzh', '#wtrlxdh');
				}
			}
			resetBtn();
			return passFlag;
		},
		onPrevious : function(tab, navigation, index) {
			if (currentStep == 3 && navigation.find('li:eq(1)').hasClass('disabled')) {
				currentStep -= 2;
			} else {
				currentStep--;
			}
			if (currentStep < 1) {
				currentStep = 1;
			}
			resetBtn();
			return true;
		},
		onTabShow : function(tab, navigation, index) {
			var total = navigation.find('li').length;
			var current = index + 1;
			var $percent = (current / total) * 100;
			$('div.progress-bar').css({
				width : $percent + '%'
			});
			if (current == 4) {
				initView();
			}
		}
	});

	// 重置操作步骤按钮
	function resetBtn() {
		if (currentStep == 1) {
			$(".button_reset").show();
			$('.button-previous').hide();
			$('.button-next').show();
			$('.button-submit').hide();
		}
		if (currentStep == 2 || currentStep == 3) {
			$(".button_reset").show();
			$('.button-previous').show();
			$('.button-next').show();
			$('.button-submit').hide();
		}
		if (currentStep == 4) {
			$(".button_reset").hide();
			$('.button-previous').show();
			$('.button-next').hide();
			$('.button-submit').show();
		}
	}

	// 初始化预览
	function initView() {
		$("#cxrxmView").val($("#cxrxm").val());
		$("#cxrsfzhView").val($("#cxrsfzh").val());
		var type = $('input[name="type"]:checked').val();
		if (type == 1) {
			// 委托查询
			$("#wtrxmView").val($("#wtrxm").val());
			$("#wtrsfzhView").val($("#wtrsfzh").val());
			$("#wtrlxdhView").val($("#wtrlxdh").val());
			$('#wtdivtab4').removeClass('hide');
			$('#wtrsfzView').closest('.form-group').removeClass('hide');
			$('#wtsqsView').closest('.form-group').removeClass('hide');
		} else {
			$("#wtrxmView").val('');
			$("#wtrsfzhView").val('');
			$("#wtrlxdhView").val('');
			$('#wtdivtab4').addClass('hide');
			$('#wtrsfzView').closest('.form-group').addClass('hide');
			$('#wtsqsView').closest('.form-group').addClass('hide');
		}

		$("#purposeView").val($("#purpose").select2('data')[0].text);
		$("#sqbgqssjView").val($("#sqbgqssj").val());
		$("#sqbgjzsjView").val($("#sqbgjzsj").val());
		$("#bzView").val($("#bz").val());
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

	// 初始化单选框
	$('input[name="type"]').on('ifChecked', function(event) {
		if ($(event.target).val() == 0) {// 自查
			// 本人查询，跳过第二步委托人信息的填写
			$('#submit_form').bootstrapWizard('disable', 1);
			// 切换至本人查询时，重置委托人信息
			$("#wtsearchInput,#wtrxm,#wtrsfzh,#wtrlxdh").val("").change();
			$("#wtrsfz,#wtsqs").cclResetUpload();
		} else if ($(event.target).val() == 1) {// 委托查询
			$('#submit_form').bootstrapWizard('enable', 1);
		}
	});
	$('input[name="type"]:eq(0)').iCheck('check');

	$('.button-previous').hide();
	$('.button-submit').hide();

	// 示例如下，所有参数均可选，都有默认值
	$("#wtsqs").cclUpload({
		type : "img", // 文件类型（img | file），默认为file
		multiple : false, // 是否多选（默认单选替换）
		showList : true
	});
	$("#cxrsfz,#wtrsfz").cclUpload({
		"type" : "img",
		"showList" : true,
		"multiple" : true,
		"max" : 2
	});

	$(".button_reset").click(function() {
		if (currentStep == 1) {
			$("#searchInput,#cxrxm,#cxrsfzh").val("").change();
			$("#cxrsfz").cclResetUpload();
		} else if (currentStep == 2) {
			$("#wtsearchInput,#wtrxm,#wtrsfzh,#wtrlxdh").val("").change();
			$("#wtrsfz,#wtsqs").cclResetUpload();
		} else if (currentStep == 3) {
			$('#purpose').val(null).trigger('change');
			$("#bz").val("");
			$('#sqbgqssj').val(threeYearsAgo); // 设置开始时间为三年前
			$('#sqbgjzsj').val(today); // 结束时间为当日
		}
		validator.form();
	});

	// 搜索自然人信息
	function searchInfo(searchInputId, searchBtnId, grxxDivId, xmId, sfzhId, lxdhId) {
		$(searchInputId).combobox({
			url : ctx + "/creditCommon/getPersonInfo.action",
			key : "ID",
			value : "NAME",
			searchBtn : searchBtnId,
			callback : function(i, row) {
				$(xmId).val(row.XM);
				$(sfzhId).val(row.SFZH);
				if (!isNull(lxdhId)) {
					$(lxdhId).val(row.LXDH || '');
				}
				$(grxxDivId).removeClass('hide');
			}
		});
	}

	// 本人查询搜索
	searchInfo('#searchInput', '#fasearch', '#brxx', '#cxrxm', '#cxrsfzh');

	var validator = $('#submit_form').validateForm({
		wtrlxdh : {
			required : true,
			mobile : [],
			maxlength : 11
		},
		bz : {
			maxlength : 500
		},
		purpose : {
			required : true
		}
	});

	validator.form();

	$.getJSON(ctx + "/system/dictionary/listValues.action?groupKey=applyPReportPurpose", function(result) {
		// 初始下拉框
		$("#purpose").select2({
			language : 'zh-CN',
			data : result.items,
			minimumResultsForSearch : -1,// 去掉搜索框
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
			var month = jzsj.substring(5, 7);
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
        return (new Date(new_date.getTime()-1000*60*60*24)).getDate();//获取当月最后一天日期
    }

	$(".button-submit").click(function() {
		loading();
        fillDate();
		$("#submit_form").ajaxSubmit({
			url : ctx + "/hallPReport/addReport.action",
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

							var url = ctx + "/hallPReport/toReportApply.action";
							$("div#mainContent").load(url);
						}, function() {
							var url = ctx + "/hallPReport/toReportApply.action";
							$("div#mainContent").load(url);
						});
					} else {
						layer.confirm(result.message, {
							icon : 1,
							btn : [ '立即打印反馈单', '暂不打印' ]
						}, function(index) {
							layer.close(index);
							var url = ctx + "/hallPReport/printReportApply.action?id=" + result.id;
							window.open(url, "信用报告申请反馈单");
							url = ctx + "/hallPReport/toReportApply.action";
							$("div#mainContent").load(url);
						}, function() {
							var url = ctx + "/hallPReport/toReportApply.action";
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

    $("#dsfz").click(function() {
        var CVR_IDCard = document.getElementById("CVR_IDCard");
        var strReadResult = CVR_IDCard.ReadCard();
        if(strReadResult == "0")
        {
            $("#searchInput").val(CVR_IDCard.CardNo);
            $("#fasearch").click();
            $("#searchInput").focus();
        }else{
            $.alert("读卡失败，无卡或卡片已读过！", 2);
        }
    });

    $("#dwtrsfz").click(function() {
        var CVR_IDCard = document.getElementById("CVR_IDCard");
        var strReadResult = CVR_IDCard.ReadCard();
        if(strReadResult == "0")
        {
            $("#wtsearchInput").val(CVR_IDCard.CardNo);
            $("#wtfasearch").click();
            $("#wtsearchInput").focus();
        }else{
            $.alert("读卡失败，无卡或卡片已读过！", 2);
        }
    });

})();