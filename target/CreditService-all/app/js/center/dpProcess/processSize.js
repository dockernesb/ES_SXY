var dataSize = (function() {
	
	/******************************* 初始化**********************************************************/
	
	var start = {
			elem : '#startDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30', // 最大日期
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#startDate', datas);
				end.min = datas; // 开始日选好后，重置结束日的最小日期
				end.start = datas // 将结束日的初始值设定为开始日
			}
		};
		var end = {
			elem : '#endDate',
			format : 'YYYY-MM-DD',
			max : '2099-12-30',
			istime : false,
			istoday : false,// 是否显示今天
			isclear : false, // 是否显示清空
			issure : false, // 是否显示确认
			choose : function(datas) {
				laydatePH('#endDate', datas);
				start.max = datas; // 结束日选好后，重置开始日的最大日期
			}
		};
	laydate(start);
	laydate(end);
	
	// 开始时间
	var startDate = $("#startDate").val();
	// 结束时间
	var endDate = $("#endDate").val();
	
	//创建一个Datatable
	var table;
	
	var myChart1;
	var myChart2;
	var myChart3;
	$(function(){
		myChart1 = echarts.init(document.getElementById("processSizePie"), "macarons");
		myChart2 = echarts.init(document.getElementById("frSizePie"), "macarons");
		myChart3 = echarts.init(document.getElementById("zrrSizePie"), "macarons");
		conditionSearch();
		
		$('input:radio[name="dataOrigin"]').change(function(){  
	         if($(this).is(":checked")){  
	        	 conditionSearch();
	          } 
	      }); 
		
		
	});
	
	/******************************* 初始化 end*****************************************************/
	
	
	/************************************查询 begin************************************************/
	
	function getConditions(){
		var params = {};
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var type = $("input[name='dataOrigin']:checked").val();
		params.startDate = startDate;
		params.endDate = endDate;
		params.type = type;
		return params
	}
	
	//查询入库量
	function conditionSearch() {
		//获取查询条件
		var params = getConditions();
		if (startDate && endDate && startDate > endDate) {
			$.alert('开始日期不能大于结束日期！');
			return;
		}
		//加载图表
		loadChart(params);
		
	}
	
	
	function loadChart(params){
		myChart1.showLoading();
		myChart2.showLoading();
		myChart3.showLoading();
		getSchemaPieData(params,function() {
			initSchemaPie();//上报量饼图
		});
		getFrPieData(params,function() {
			initFrPie();//法人饼图
		});
		getZrrPieData(params,function() {
			initZrrPie();//自然人量饼图
		});
		
        //部门表格
        getDeptDataTable(function(){
            initDeptTable();
        })

        goBack();
    }
	
	
	// 重置
	function conditionReset() {
		resetSearchConditions('#startDate,#endDate');
		$("input[name='dataOrigin']:eq(0)").attr("checked",'checked'); 
		resetDate(start,end);
	}
	
	/************************************查询 end*********************************************************/
	
	
	/*****************************************加载饼图  begin************************************************/
	
	var seriesData1 = [];
	var legendData1 = [];
	var selected1 = {};
	//获取部门总入库量饼图数据
	function getSchemaPieData(params,callback) {
		params = getConditions();
		params.chartsType = "1";
		$.post(ctx + "/dpProcess/queryStorageQuantity.action", 
			params, function(result) {
			seriesData1 = [];
			if(result){
				$.each(result,function(n,value){
					seriesData1.push({value:value.ALLSIZE==null?0:value.ALLSIZE, name:value.DEPT_NAME});
						legendData1.push(value.DEPT_NAME);
						selected1[value.DEPT_NAME] = n < 6;
				});
			}
			if (seriesData1.length == 0) {
				seriesData1 = [{value:0, name:"暂无数据"}];
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}

	
	var seriesData2 = [];
	var legendData2 = [];
	var selected2 = {};
	//获取部门总入库量饼图数据
	function getFrPieData(params,callback) {
		params = getConditions();
		params.personType = 0 ;
		$.post(ctx + "/dpProcess/queryDataCategoryQuantity.action", 
			params, function(result) {
			seriesData2 = [];
			if(result){
				$.each(result,function(n,value){
					seriesData2.push({value:value.ALLSIZE==null?0:value.ALLSIZE, name:value.DICT_VALUE});
						legendData2.push(value.DICT_VALUE);
						selected2[value.DICT_VALUE] = n < 6;
				});
			}
			if (seriesData2.length == 0) {
				seriesData2 = [{value:0, name:"暂无数据"}];
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}
	
	
	
	var seriesData3 = [];
	var legendData3 = [];
	var selected3 = {};
	//获取部门总入库量饼图数据
	function getZrrPieData(params,callback) {
		params = getConditions();
		params.personType = 1;
		$.post(ctx + "/dpProcess/queryDataCategoryQuantity.action", 
			params, function(result) {
			seriesData3 = [];
			if(result){
				$.each(result,function(n,value){
					seriesData3.push({value:value.ALLSIZE==null?0:value.ALLSIZE, name:value.DICT_VALUE});
					legendData3.push(value.DICT_VALUE);
					selected3[value.DICT_VALUE] = n < 6;
				});
			}
			if (seriesData3.length == 0) {
				seriesData3 = [{value:0, name:"暂无数据"}];
			}
			if (callback instanceof Function) {
				callback();
			}
		}, "json");
	}
	
	
	
	
	
	  //	初始化部门入库量占比饼图
	function initSchemaPie() {
		myChart1.setOption({
			title : {
		        text: '入库占比',
		        subtext: '统计部门上报数据的入库量',
		        x:'center'
		    },
		    tooltip: {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    toolbox: {
		        show: true,
		        x: 30,
		        feature: {
		        	restore : {
						show : true
					},
		            saveAsImage: {show: true}
		        }
		    },
		    legend: {
		        type: 'scroll',
		        orient: 'vertical',
		        right: 10,
		        top: 50,
		        bottom: 20,
		        data: legendData1,
		        selected: selected1
		    },
		    series : [
		              {
		                  name: '征集数据统计',
		                  type: 'pie',
		                  radius : '50%',
				          bottom:'30%',
		                  center: ['45%', '55%'],
		                  avoidLabelOverlap: true,
		                  data: seriesData1,
		                  itemStyle: {
		                      emphasis: {
		                          shadowBlur: 10,
		                          shadowOffsetX: 0,
		                          shadowColor: 'rgba(0, 0, 0, 0.5)'
		                      }
		                  }
		              }
		          ]
		},true);
		myChart1.hideLoading();
		myChart1.resize();
	}
	
	
	  //	初始化部门入库量占比饼图
	function initFrPie() {
		myChart2.setOption({
			title : {
		        text: '法人入库数据结构',
		        subtext: '',
		        x:'center'
		    },
		    tooltip: {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    toolbox: {
		        show: true,
		        x: 30,
		        feature: {
		        	restore : {
						show : true
					},
		            saveAsImage: {show: true}
		        }
		    },
		    legend: {
		        type: 'scroll',
		        orient: 'vertical',
		        right: 10,
		        top: 50,
		        bottom: 20,
		        data: legendData2,
		        selected: selected2
		    },
		    series : [
		              {
		                  name: '征集数据统计',
		                  type: 'pie',
		                  radius : '70%',
				          bottom:'30%',
		                  center: ['30%', '60%'],
		                  avoidLabelOverlap: true,
		                  data: seriesData2,
		                  itemStyle: {
		                      emphasis: {
		                          shadowBlur: 10,
		                          shadowOffsetX: 0,
		                          shadowColor: 'rgba(0, 0, 0, 0.5)'
		                      }
		                  }
		              }
		          ]
		},true);
		myChart2.hideLoading();
		myChart2.resize();
	}
	
	
	  //	初始化部门入库量占比饼图
	function initZrrPie() {
		myChart3.setOption({
			title : {
		        text: '自然人入库数据结构',
		        subtext: '',
		        x:'center'
		    },
		    tooltip: {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    toolbox: {
		        show: true,
		        x: 30,
		        feature: {
		        	restore : {
						show : true
					},
		            saveAsImage: {show: true}
		        }
		    },
		    legend: {
		        type: 'scroll',
		        orient: 'vertical',
		        right: 10,
		        top: 50,
		        bottom: 20,
		        data: legendData3,
		        selected: selected3
		    },
		    series : [
		              {
		                  name: '征集数据统计',
		                  type: 'pie',
		                  radius : '70%',
				          bottom:'30%',
		                  center: ['30%', '60%'],
		                  avoidLabelOverlap: true,
		                  data: seriesData3,
		                  itemStyle: {
		                      emphasis: {
		                          shadowBlur: 10,
		                          shadowOffsetX: 0,
		                          shadowColor: 'rgba(0, 0, 0, 0.5)'
		                      }
		                  }
		              }
		          ]
		},true);
		myChart3.hideLoading();
		myChart3.resize();
	}
	
	
	
	/*****************************************加载饼图  end****************************************************/
	
	
	/****************************************加载表格  begin *************************************************/
	var tableData = [];
	function getDataTable(callback) {
		var startDate = $("#startDate").val();
		var  endDate =$("#endDate").val();
		var tableName = $("#tableName").val();
		var deptId = $("#deptId").val();
		var param = getConditions();
		var url = ctx + "/dpProcess/queryTableDetails.action";
		 $.getJSON(url,param, function (data) {
	         tableData = [];
	         tableData = data;
	         if (callback instanceof Function) {
	             callback();
	         }
	     });
		}
	 

	/************************************加载表格  end ********************************************************/

	
	/****************************************加载部门表格  begin *************************************************/
	var tableDeptData = [];
	function getDeptDataTable(callback) {
		var param = getConditions();
		var url = ctx + "/dpProcess/queryDeptQuantity.action";
		 $.getJSON(url,param
	     , function (data) {
	    	 tableDeptData = [];
	    	 tableDeptData = data;
	         if (callback instanceof Function) {
	             callback();
	         }
	     });
		}
	 
	//创建一个Datatable
	var deptTable = $('#deptDataTable').DataTable({
        ordering: true,
        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
        columns: [
          	{"data": null,
              render: function (data, type, row, meta) {
                  // 显示行号
                  var startIndex = meta.settings._iDisplayStart;
                  return startIndex + meta.row + 1;
              } ,
                "orderable" : false
			}, {
				"data" : "DEPT_NAME" , //部门名称
				type:'chinese-string',
				render : function (data, type, row) {
					if(data=='合计')
						return data;
					var str = '<a href="javascript:;" onclick="dataSize.showDetail(\'' + row.DEPT_ID + '\')">' + data + '</a>';
					return str;
                }
			}, {
				"data" : "ALLSIZE" //合计入库
			}, {
				"data" : "FRSIZE" //法人入库
			}, {
				"data" : "ZRRSIZE" //自然人入库
			}],
	         initComplete: function (settings, data) {
	            var columnTogglerContent = $('#export_dept_btn').clone();
	            $(columnTogglerContent).removeClass('hide');
	            var columnTogglerDiv = $(deptTable.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
	            $(columnTogglerDiv).html(columnTogglerContent);
	        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });

    //创建一个Datatable
    var deptTable_detail = $('#deptDataTable_detail').DataTable({
        ordering: true,
        order: [],
        searching: false,
        autoWidth: false,
        lengthChange: true,
        pageLength: 10,
        serverSide: false,//如果是服务器方式，必须要设置为true
        processing: true,//设置为true,就会有表格加载时的提示
        paging: false,
        columns: [
            {"data": null,
                render: function (data, type, row, meta) {
                    // 显示行号
                    var startIndex = meta.settings._iDisplayStart;
                    return startIndex + meta.row + 1;                } ,
                "orderable" : false
            }, {
                "data" : "TABLE_NAME" , // 目录名称
                type:'chinese-string'
            }, {
                "data" : "ALLSIZE" // 入库量
            }],
        initComplete: function (settings, data) {
            var columnTogglerContent = $('#detail_dept_btn').clone();
            $(columnTogglerContent).removeClass('hide');
            var columnTogglerDiv = $(deptTable_detail.table().node()).parent().prev('div.ttop').find('.columnToggler').eq(0);
            $(columnTogglerDiv).html(columnTogglerContent);
        },
        drawCallback: function (settings, data) {
            var api = this.api();
            var startIndex = api.context[0]._iDisplayStart;//获取到本页开始的条数
            api.column(0).nodes().each(function (cell, i) {
                cell.innerHTML = startIndex + i + 1;
            });
        }
    });

  //	初始化表格数据
	function initDeptTable() {
		deptTable.clear().draw();
		deptTable.rows.add(tableDeptData).draw();
	}

	// 导出
	function exportDeptData() {
        loading();
        var params = getConditions();
        var titles = "单位名称,合计入库,法人入库,自然人入库";
        var columns = "DEPT_NAME,ALLSIZE,FRSIZE,ZRRSIZE";

        var url = ctx + '/dpProcess/exportDeptData.action';

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': params.startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': params.endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'type', 'value': params.type}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'excelName', 'value': '数据量统计-部门统计'}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
	}

    // 导出部门详细
    function exportDeptDetailData() {
        loading();
        var deptId = $('#detail_deptId').val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var titles = "目录名称,入库量";
        var columns = "TABLE_NAME,ALLSIZE";

        var url = ctx + '/dpProcess/exportDeptDetailData.action' ;

        var _form = $("<form></form>", {
            'id': 'importExcel',
            'method': 'post',
            'action': url,
            'target': "_self",
            'style': 'display:none'
        }).appendTo($('body'));

        //将隐藏域加入表单
        _form.append($("<input>", {'type': 'hidden', 'name': 'deptId', 'value': deptId}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'startDate', 'value': startDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'endDate', 'value': endDate}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'titles', 'value': titles}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'columns', 'value': columns}));
        _form.append($("<input>", {'type': 'hidden', 'name': 'excelName', 'value': '数据量统计-部门目录统计'}));
        //触发提交事件
        _form.trigger('submit');
        //表单删除
        _form.remove();
        loadClose();
    }


	/************************************加载表格部门  end ********************************************************/

    function showDetail(deptId) {
		$('#detail_deptId').val(deptId);
        deptTable_detail.clear().draw();

        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var url = ctx + "/dpProcess/queryTableQuantityByDeptId.action";
        $.getJSON(url, {
            startDate: startDate,
            endDate: endDate,
            deptId: deptId,
        }, function (data) {
            deptTable_detail.rows.add(data).draw();
        });

        $('#dept_fatherDiv').hide();
        $('#dept_sonDiv').show();
    }

    function goBack() {
		$('#dept_sonDiv').hide();
		$('#dept_fatherDiv').show();
    }

	return {
        conditionSearch: conditionSearch,
        exportDeptDetailData: exportDeptDetailData,
        showDetail: showDetail,
        goBack: goBack,
        exportDeptData: exportDeptData,
        conditionReset: conditionReset
	}
})();





