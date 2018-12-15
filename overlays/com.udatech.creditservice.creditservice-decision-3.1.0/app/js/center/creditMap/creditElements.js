// 信用要素
var creditElements = (function(){
	
	//+++++++++根据需求填写对应名称代码,若三个参数均为空则默认加载当前ip所在城市++++++++++//
	// 地级市名称
	var newCityName = $("#centerCity").val();
	
	// 地级市代码
	var newCityCode = $("#cityCode").val();//查询地址 http://www.sdgxjy.com/companyReg/query.jsp
	
	// 县级市名称
	var subCityName = $("#countyCity").val();
	
	//+++++++++++++++++++//
	
    var map, toolBar, district, polygons = [], citycode, cityName;
	
    var zoomLevel; // 缩放等级
    
    var viewArea; // 当前可视区域
    
    var adcode; // 区域代码
    
    var isload;
    
    // 默认加载当前市
    map = new AMap.Map('mapContainer', {
        resizeEnable: true,
        zoom : 9,
        keyboardEnable : false, // 禁止使用键盘方向键
        features : ['bg', 'point'] // 地图没有线路网
    });
    
    var trafficLayer = new AMap.TileLayer.Traffic({zIndex:10}); //实时路况图层
    trafficLayer.setMap(map);   //添加实时路况图层
    trafficLayer.hide();
    
    var roadNetLayer = new AMap.TileLayer.RoadNet({zIndex:10}); //实例化路网图层
    roadNetLayer.setMap(map);
    roadNetLayer.hide();
    
    if (newCityName) {
    	map.setCity(newCityName);
    }
    
    
    function zoomChange(e){
    	zoomLevel = map.getZoom();
    	var areaBounds = map.getBounds();
    	viewArea = areaBounds.southwest.lng + "," +areaBounds.southwest.lat + ";" +   
    	           areaBounds.northeast.lng + "," +areaBounds.northeast.lat;
    	isKeywordSearch(2);
    }
    
   // map.on("zoomchange",zoomChange);
    map.on("zoomchange",zoomChange); // 绑定zoom级别发生改变事件
    map.on("dragend",zoomChange); // 绑定鼠标拖动事件
    
    //map.setMapStyle("fresh");
    
    // 行政区划查询
    var opts = {
        subdistrict: 1,   // 返回下一级行政区
        level: 'city', // 查询行政级别为 市
        showbiz:false,
        extensions:"all" // 是否返回行政区边界坐标点，可选值：base、all，all表示返回
    };
    
    $('#keyword').keypress(function(e) {
		if (e.which == 13) {
			keywordSearch();
		}
	});
    
    $(function(){
    	
    	if (isIE()) {
   		 $("input[type=checkbox]").css({"vertical-align":"middle","margin-top":"0"});
    	}
    	
   	    // 加载地图工具
    	map.plugin(["AMap.ToolBar"], function() {
    		map.addControl(new AMap.ToolBar());
    	});
    	
    	if(location.href.indexOf('&guide=1')!==-1){
    		map.setStatus({scrollWheel:false})
    	}
    	
    	// 加载区域搜索插件
    	AMap.plugin(['AMap.DistrictSearch'],function(){//回调函数
            district = new AMap.DistrictSearch(opts) ;//注意：需要使用插件同步下发功能才能这样直接使用
            getCity();
        });
    	// 加载热力图插件
        map.plugin(["AMap.Heatmap"], function() {
        	    // 初始化heatmap对象
    	        heatmap = new AMap.Heatmap(map, {
    	            radius: 25, //给定半径
    	            opacity: [0, 0.8]
    	            /*,gradient:{
    	             0.5: 'blue',
    	             0.65: 'rgb(117,211,248)',
    	             0.7: 'rgb(0, 255, 0)',
    	             0.9: '#ffea00',
    	             1.0: 'red'
    	             }*/
    	        });
    	 });
         
         // 右侧边栏属性设置
         $('.sliderbar-container').sliderBar({
     		 open : true,           // 默认是否打开，true打开，false关闭
             top : 20,              // 距离顶部多高
             width : 220,           // body内容宽度   230
             height : 500,          // body内容高度
             theme : 'green',       // 主题颜色
             position : 'right'     // 显示位置，有left和right两种
     	 });
         
         document.addEventListener("fullscreenchange", function(e) {
        	 var isFullscreen = document.fullscreenEnabled;
        	 if (isFullscreen) {
        		 windowMax(1);
       	     } else {
       	    	 windowMax(2);
       	     }
         });
         document.addEventListener("mozfullscreenchange", function(e) {
        	 var isFullscreen = window.fullScreen;
        	 if (isFullscreen) {
        		 windowMax(1);
       	     } else {
       	    	 windowMax(2);
       	     }
         });
         document.addEventListener("webkitfullscreenchange", function(e) {
        	 var isFullscreen = document.webkitIsFullScreen;
        	 if (isFullscreen) {
        		 windowMax(1);
       	     } else {
       	    	 windowMax(2);
       	     }
         });
         
         //getDataProvider();
    }); 

    // 模拟窗口最大化
    function windowMax(type){
    	if (type == 1){
    		var height = 768;
    		if ( isIE() && (navigator.userAgent.indexOf('Opera') < 0)) {
    			height = document.documentElement.clientHeight;//88top+28foot
    		} else if ((navigator.userAgent.indexOf('Firefox') >= 0) ||(navigator.userAgent.indexOf('Opera') >= 0) || (navigator.userAgent.indexOf('Chrome') >= 0) || (navigator.userAgent.indexOf('Safari') >= 0)) {
    			height = window.innerHeight;
    	    }	
    		$("#mapContainer").height(height + "px");
    		$(".page-content-wrapper .page-content ").addClass("page-content-max");
    		$(".page-title").hide();
    		$(".page-container").css({"z-index":1000,"margin-top":"0px"});
    		$(".page-footer").hide();
    		$(".portlet").css("margin-bottom","0px");
    		
    		$("#toBig").attr({"src":ctx + "/app/images/creditMap/btnToSmall.png","alt":"缩小"});
            $("#toBig").parent().attr("title","缩小");
    	} else{
    		$("#mapContainer").height(630+"px");
    		$(".page-content-wrapper .page-content ").removeClass("page-content-max");
    		$(".page-title").show();
    		$(".page-container").css({"z-index":"0","margin-top":"46px"});
    		$(".page-footer").show();
    		$(".portlet").css("margin-bottom","25px");
    		
    		$("#toBig").attr({"src":ctx + "/app/images/creditMap/btnToBig.png","alt":"放大"});
        	$("#toBig").parent().attr("title","放大");
    	}
    }
    
    // 判断浏览器是否是ie
    function isIE() { //ie?  
        if (window.ActiveXObject || "ActiveXObject" in window)  
            return true;  
        else  {
     	   return false;  
        }
    }
    
    // 获取当前选中区域
    function getCheckedDistincts(){
    	var treeObj = $.fn.zTree.getZTreeObj("dropdowncksTree");
		var selectedQy = treeObj.getCheckedNodes(true);
		var allNodes = treeObj.transformToArray(treeObj.getNodes());
		if (allNodes.length == selectedQy.length) {
			//search(selectedQy[0]);
			adcode = selectedQy[0].adcode;
		} else{
			adcode = "";
			    for (var i = 0;i < selectedQy.length;i++) {
				    if (selectedQy[i].level != 0) {
				    	if (i == selectedQy.length - 1) {
				    		adcode += selectedQy[i].adcode;
				    	} else {
				    		adcode += selectedQy[i].adcode + ",";
				    	}
					}
				} 
		}
    }
    
    // 获取当前所在城市名称
    function getCity() {
        map.getCity(function(data) {
            if (data['province'] && typeof data['province'] === 'string') {
            	cityName = data['city'] || data['province'];
            	if (newCityName) {
            	    cityName= newCityName;
            	    drawCity(cityName,newCityCode);
            	}
            	else {
            		drawCity(cityName,data.citycode);
            	}
            	
            }
        });
    }
    
    // 使用district对象调用行政区查询的功能
    function drawCity(name,citycode){
   	    district.search(name, function(status, result) {
   	        if(status=='complete'){
   	            getData(result.districtList[0], citycode);
   	            adcode = citycode;
   	            if (subCityName) {
   	            	qychanged = true;
   	            }
   	            conditionSearch("load");
   	            isload = 0;
   	        }
        });
    }
  
    function getData(data, citycode) {
    	
    	// 获得当前城市下的区县
        var subList = data.districtList;
        var level = data.level;
        
        if (level === 'city' && subList) {
       	 
            var setting = {
        		check: {
        			enable: true
        		},
        		data: {
        	        simpleData: {
        	            enable: true
        	        }
        	    },
        		view: {
        			showIcon: false,
        			showLine: false
        		}
        	};
       
       	    var childrenArr = [];
            for (var i = 0, l = subList.length; i < l; i++) {
                var name = subList[i].name;
                var levelSub = subList[i].level;
                var adcode = subList[i].adcode;
                if (subCityName && name == subCityName) {
                	childrenArr.push({name: name,value: levelSub, adcode:adcode,checked : true});
                } else {
                	childrenArr.push({name: name,value: levelSub, adcode:adcode});
                }
                
            }
            
            if (subCityName){
            	var zNodes = [{name:cityName, open:true, value:"city", adcode : citycode, checked : true,children:childrenArr}];
            	var zTreecks = $.fn.zTree.init($("#dropdowncksTree"), setting, zNodes);
            } else {
            	var zNodes = [{name:cityName, open:true, value:"city", adcode : citycode,children:childrenArr}];
            	var zTreecks = $.fn.zTree.init($("#dropdowncksTree"), setting, zNodes);
                zTreecks.checkAllNodes(true);// 默认全选
            }
        }
    }
    
    // 画行政区边界
    function drawPolygon(type, data){
    	
    	/*for (var i = 0, l = polygons.length; i < l; i++) {
            polygons[i].setMap(null);
        }*/
    	
    	// 清除地图上所有覆盖物
    	
        var bounds = data.boundaries;
        if (bounds) {
            for (var i = 0, l = bounds.length; i < l; i++) {
                var polygon = new AMap.Polygon({
                    map: map,
                    strokeWeight: 3,
                    strokeColor: '#bbb',
                    fillColor: 'red',
                    fillOpacity: 0,
                    zIndex:1,//将多边形层置于最底部，否则点击不了图标
                    path: bounds[i]
                });
                polygons.push(polygon);
               // judgePoints(polygon);
            }
            if (type != 2) {
            	map.setFitView();//地图自适应
            }
        }
    }
    
    var qychanged = false;
    function search(type, obj) {
    	
    	 var keyword = obj.name; // 关键字
         var adcode = obj.adcode;
         if (obj.value == 'city') {
         	district.search(keyword, function(status, result) {
         	   if(status=='complete'){
         		   drawPolygon(type, result.districtList[0]);
         	   }
             });
         } else {
         	 district.setLevel(obj.value); // 行政区级别
             district.setExtensions('all');
             // 按照adcode进行查询可以保证数据返回的唯一性
             district.search(adcode, function(status, result) {
                 if(status === 'complete'){ 
                       drawPolygon(type, result.districtList[0]);
                 }
             });
         }
    }
    
    var selectedElementIndex = 0;
    // 要素选择和取消选择
    function toggleElements(obj, index){
    	var eleClass = $(obj).find($(".elementsOpa")).attr("class");
    	if (eleClass.indexOf("elementsActive") != -1) {
    		selectedElementIndex = 0;
    		$(obj).find($(".elementsOpa")).removeClass("elementsActive");
    	} else {
    		selectedElementIndex = index;
    		$(obj).find($(".elementsOpa")).addClass("elementsActive");
    	}
    	$(".elementsOpa").not($(obj).find($(".elementsOpa"))).removeClass("elementsActive");
    	
    	if (selectedElementIndex != 0) {
    		$(".legendImg").hide();
    	} else {
    		$(".legendImg").show();
    	}
    	
		switch(selectedElementIndex){
		    // 行政许可
		    case 1:
		    	getDataProvider(0);
		    	break;
		    // 行政处罚
		    case 2:
		    	getDataProvider(0);
		    	break;
		    // 资质荣誉
		    case 3:
		    	getDataProvider(0);
		    	break;
		    // 欠税信息
		    case 4:
		    	getDataProvider(1, 'qianshuiType');
		    	break;
		    // 欠费信息
		    case 5:
		    	getDataProvider(1, 'qianjiaoType');
		    	break;
		    // 参保欠缴
		    case 6:
		    	getDataProvider(1, 'canbaoType');
		    	break;
		}
		
    	qychanged = false;
    	isload = 1;
    	$("#keyword").val("");
    	$('.phTips').show();
    	
    	if ($("#startDate").val() != "") {
    		$("#startDate + .phTips").hide();
		}
		
		if ($("#endDate").val() != "") {
			$("#endDate + .phTips").hide();
		}
    	conditionSearch();
    }
	
	// 行业树
	var setting = {
		treeId : "id",
		async : {
			enable : true,
			url : ctx + "/creditCommon/getIndustryTree.action",
			type : "post"
		},
		data : {
			key : {
				name : "text",
			}
		},
		check : {
			enable : true,
			chkDisabledInherit : true,
			nocheckInherit : true
		},
		callback : {
			onAsyncSuccess : function() {	//	展开一级二级节点
				var treeObj = $.fn.zTree.getZTreeObj("industryTree");
				allNodes = treeObj.transformToArray(treeObj.getNodes());
				expandTreeNode();
			},
			onClick : function(event, treeId, treeNode) {	//	单击节点刷新列表
				refreshTable(treeNode.id);
			},
			beforeClick: function(treeId, treeNode, clickFlag) {
				return !treeNode.isParent;	//当是父节点 返回false 不让选取
			}
		}
	};
	
	function getDataProvider(type, key){
		 var setting = {
				    treeId : "id",
	        		check: {
	        			enable: true,
     				chkDisabledInherit : true,
     				nocheckInherit : true
	        		},
	        		data: {
	        	        simpleData: {
	        	            enable: true
	        	        },
	        	        key : {
	        				name : "text"
	        			}
	        	    }
	    };
		if (type == 0) {
			$.post(ctx + "/system/department/getDeptList.action", {},
				function(data) {
				    var childrenArr = data;
					var zNodes = [{text: '全部', open:true, id:"", children : childrenArr}];
					var zTreecks = $.fn.zTree.init($("#dataProviderTree"), setting, zNodes);
					//zTreecks.checkAllNodes(true);// 默认全选
			}, "json");
		} else {
			$.getJSON(ctx + "/system/dictionary/listValues.action", {
				groupKey : key
			}, function(result) {
				var data = result.items;
				var childrenArr = data;
				var zNodes = [{text: '全部', open:true, id:"", children : childrenArr}];
				var zTreecks = $.fn.zTree.init($("#dataProviderTree"), setting, zNodes);
				//zTreecks.checkAllNodes(true);// 默认全选
			}, "json");
		}
	}
	
	function expandTreeNode() {
		var treeObj = $.fn.zTree.getZTreeObj("industryTree");
		var root = treeObj.getNodes()[0];
		treeObj.expandNode(root, true);
		var children = root.children;
		if (children) {
			for (var i=0, len = children.length; i<len; i++) {
				var child = children[i];
				treeObj.expandNode(child, true);
			}
		}
	}
	
	var zTreeObj = $.fn.zTree.init($("#industryTree"), setting);
	var allNodes = [];
		
	function refreshTable(id) {
		if (table) {
			var data = table.settings()[0].ajax.data;
			if (!data) {
				data = {};
				table.settings()[0].ajax["data"] = data;
			}
			data["parentId"] = id;
			table.ajax.reload();
		}
	}
	
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
				end.start = datas; // 将结束日的初始值设定为开始日
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
		
	// 条件搜索企业点位
	function conditionSearch(type){
		
		if (type == 1) {
			isload = 1;
		}
		// 企业类型
		var enterTypeVal = [];
		$("input[name='type']:checked").each(function(){
			enterTypeVal.push($(this).val()); 
		});
		
		// 注册规模
		var scaleVal = [];
		$("input[name='scale']:checked").each(function(){
			scaleVal.push($(this).val()); 
		});
		
		// 主体年份
		var yearVal = [];
		$("input[name='year']:checked").each(function(){
			yearVal.push($(this).val()); 
		});
		
		// 国标产业
		var domainVal = [];
		if ($("input[name='GUOBIAO']:checked").val() == "GBCY") {
		    $("input[name='domainType']:checked").each(function(){
		    	domainVal.push($(this).val()); 
			});
		}
		
		// 开始时间
		var startDate = $("#startDate").val();
		
		// 结束时间
		var endDate = $("#endDate").val();
		
		if (type == 1 || type == 2) {
			$("#keyword").val("");
			$('.phTips').show();
			qychanged = false;
			if ($("#startDate").val() != "") {
				$("#startDate + .phTips").hide();
			}
			
			if ($("#endDate").val() != "") {
				$("#endDate + .phTips").hide();
			}
		}
		// 国标行业
		var industryTypeVal = "";
		
		if ($("input[name='GUOBIAO']:checked").val() == "GBHY") {
	        var treeObj = $.fn.zTree.getZTreeObj("industryTree");
			var selectedHys = treeObj.getCheckedNodes(true);
			if (selectedHys != null) {
				for (var i = 0; i < selectedHys.length; i++) {
					if (selectedHys[i].level != 0) {
						industryTypeVal = industryTypeVal + selectedHys[i].id;
						if (i < selectedHys.length - 1) {
							industryTypeVal = industryTypeVal + ",";
						}
					}
				}
			}
		}
		
		getCheckedDistincts();
		
		// 自定义维度
		var customDimensionVal = "";
		
		var treeObj1 = $.fn.zTree.getZTreeObj("dataProviderTree");
		if (treeObj1 != null) {
			var selectedOptions = treeObj1.getCheckedNodes(true);
			if (selectedOptions != null) {
				for (var i = 0; i < selectedOptions.length; i++) {
					if (selectedOptions[i].level != 0) {
						customDimensionVal = customDimensionVal + selectedOptions[i].id;
						if (i < selectedOptions.length - 1) {
							customDimensionVal = customDimensionVal + ",";
						}
					}
				}
			}
		}
		var searchParams = {};
		if (type != "load") {
			searchParams = {
					"adcode" : adcode,
					"level" : zoomLevel,
					"mapBoundary" : viewArea,
			        "type" : enterTypeVal.join(","),
			        "registeredScale" : scaleVal.join(","),
			        "topicYear" : yearVal.join(","),
			        "domainType" : domainVal.join(","),
			        "industryType" : industryTypeVal,
			        "startDate" : startDate,
			        "endDate" : endDate,
			        "customDimension" : customDimensionVal
			};
		} else {
			searchParams = {
					"adcode" : adcode
			}
		}
		
		if (isload == 0) {
			searchParams = {
					"adcode" : adcode,
					"level" : zoomLevel,
					"mapBoundary" : viewArea
			}
		}
		var url = ctx + "/center/creditMap/queryElementList.action";
		$("#decideDateDL").show();
		$("#dataProvider").show();
		switch(selectedElementIndex){
		    // 行政许可
		    case 1:
		    	$("#decideDateDL dt").html("许可决定日期");
		    	$("#dataProvider dt").html("数据提供部门");
		    	searchParams.elementType = 'xzxk';
		    	break;
		    // 行政处罚
		    case 2:
		    	$("#decideDateDL dt").html("处罚决定日期");
		    	$("#dataProvider dt").html("数据提供部门");
		    	searchParams.elementType = 'xzcfxx';
		    	break;
		    // 资质荣誉
		    case 3:
		    	$("#decideDateDL dt").html("认定日期");
		    	$("#dataProvider dt").html("数据提供部门");
		    	searchParams.elementType = 'bzry';
		    	break;
		    // 欠税信息
		    case 4:
		    	$("#decideDateDL dt").html("欠税日期");
		    	$("#dataProvider dt").html("欠税税种");
		    	searchParams.elementType = 'qsxx';
		    	break;
		    // 欠费信息
		    case 5:
		    	$("#decideDateDL dt").html("认定日期");
		    	$("#dataProvider dt").html("欠缴类型");
		    	searchParams.elementType = 'qjfxx';
		    	break;
		    // 参保欠缴
		    case 6:
		    	$("#decideDateDL dt").html("认定日期");
		    	$("#dataProvider dt").html("参保类别");
		    	searchParams.elementType = 'cbqjxx';
		    	break;
		    default:
		    	$("#decideDateDL").hide();
		    	$("#dataProvider").hide();
		    	url = ctx + "/center/creditMap/queryEnterpriseList.action";
		        break;
		}
	   /* $.ajaxSetup({
		    async: false // 线程同步，会阻塞主线程导致页面无法加载其他元素
		});*/
		$.post(url, searchParams,
			function(data) {
			if (selectedElementIndex == 0) {
				if (mapType == "heatMap") {
					dealHeatMap(type, data.thermodynamic);
				} else {
					dealMass(type, '',data.firstIndustry, data.secondIndustry, data.thirdIndustry);
				}
			} else {
				if (mapType == "heatMap") {
					dealHeatMap(type, data.thermodynamic);
				} else {
					dealMass(type, data.scatter);
				}
			}
		}, "json");
	}
	
	function keywordSearch(type){
		var keyword = $.trim($("#keyword").val());
		if (keyword != "" && keyword != null) {
			selectedElementIndex = 0;
			$(".elementsOpa").removeClass("elementsActive");
			$(".legendImg").show();
			$("#decideDateDL").hide();
	    	$("#dataProvider").hide();
			$.post(ctx + "/center/creditMap/queryEnterpriseList.action", {keyWord : keyword, "adcode" : adcode},
					function(data) {
				        if (type != 2) {
				        	type = 1;
				        }
						if (mapType == "heatMap") {
							dealHeatMap(type, data.thermodynamic);
						} else {
							dealMass(type, '',data.firstIndustry, data.secondIndustry, data.thirdIndustry);
						}
					}, "json");
		}
	}
	
	// 条件重置
	function conditionReset(){
		$("#keyword").val("");
		$('.phTips').show();
		$("input[name='type']").attr("checked",false); 
		$("input[name='scale']").attr("checked",false); 
		$("input[name='year']").attr("checked",false);
		$("input[name='selectAll']").attr("checked",false);
		
		//重置日期
		resetSearchConditions('#startDate,#endDate');
		
		
		setDomainIndustry(1);
		$("#GBCY").attr("checked",true); 
		$("input[name='domainType']").attr("checked",false); 
		var treeObj = $.fn.zTree.getZTreeObj("industryTree");
		// 取消行业树选中
		treeObj.checkAllNodes(false);
		var treeObj1 = $.fn.zTree.getZTreeObj("dataProviderTree");
		if (treeObj1 != null) {
			treeObj1.checkAllNodes(false);
		}
		resetDate(start,end);
	}
	
    // 产业行业单选按钮切换触发事件
	function setDomainIndustry(type){
		// 产业
        if (type == 1) {
        	$("#industryTree").hide();
        	$("#domainTree").show();
        } else {
        	$("#domainTree").hide();
        	$("#industryTree").show();
        }
	}
    
	// 区域选择下拉展开收缩
	function toggleDropcks(type){
		$("#dropdowncks").slideToggle();
		if (type == 1) {
			qychanged = true;
			conditionSearch();
		}
	}
	
	// 窗口最大化状态
	var screenState = 0;
	// 窗口最大化
    function toggleFullScreen() {
    	//F11key();
    	// ie9,ie10暂时不支持
        if (!document.fullscreenElement && // alternative standard method  
            !document.mozFullScreenElement && !document.webkitFullscreenElement) {// current working methods  
            if (document.documentElement.requestFullscreen) {  
                document.documentElement.requestFullscreen();  
            } else if (document.documentElement.mozRequestFullScreen) {  
                document.documentElement.mozRequestFullScreen();  
            } else if (document.documentElement.webkitRequestFullscreen) {  
                document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);  
            } else if (isIE() && screenState == 0){
            	screenState = 1;
            	windowMax(1);
            } else if (isIE() && screenState == 1){
            	screenState = 0;
            	windowMax(2);
            }
        }  else {  
            if (document.cancelFullScreen) {  
                document.cancelFullScreen();  
            } else if (document.mozCancelFullScreen) {  
                document.mozCancelFullScreen();  
            } else if (document.webkitCancelFullScreen) {  
                document.webkitCancelFullScreen();  
            }
        }  
    } 
    
  //模拟F11
    function F11key(){ 
    	var WsShell = new ActiveXObject('WScript.Shell') 
        WsShell.SendKeys('{F11}'); 
    } 
    
    function resizeWindow(){ 
    	if (window.screen) {
    	//判断浏览器是否支持window.screen判断浏览器是否支持
    	 var myw = screen.availWidth;
    	
    	//定义一个myw，
    	 var myh = screen.availHeight; 
    	 
    	//定义一个myw，接受到当前全屏的高 
    	window.moveTo(0, 0); 
    	//把window放在左上脚 
    	//window.resizeTo(myw, myh);
    	$("#mapContainer").height(myh + "px").width(myw + "px");
    	//把当前窗体的长宽跳转为myw和myh 
    	} 
    }
/***** 散点图相关 *****/
    var mass = null;
    var masses = [];
    function loadMess(elementList, QB1, QB2, QB3){
    	
        // 散点图标
    	var massIcon;
		switch(selectedElementIndex){
			// 行政许可
		    case 1:
		    	massIcon = ctx + "/app/images/creditMap/yellow.png";
		    	break;
		    // 行政处罚
		    case 2:
		    	massIcon = ctx + "/app/images/creditMap/green.png";
		    	break;
		    // 资质荣誉
		    case 3:
		    	massIcon = ctx + "/app/images/creditMap/red.png";
		    	break;
		    // 欠税信息
		    case 4:
		    	massIcon = ctx + "/app/images/creditMap/purple.png";
		    	break;
		    // 欠费信息
		    case 5:
		    	massIcon = ctx + "/app/images/creditMap/pink.png";
		    	break;
		    // 参保欠缴
		    case 6:
		    	massIcon = ctx + "/app/images/creditMap/blue.png";
		    	break;
		    default:
		    	massIcon = "http://webapi.amap.com/theme/v1.3/markers/n/mark_b.png";
		        break;
		}
		
	   // 默认情况下按三大产业图标分类
       if (selectedElementIndex == 0) {
        	drawMess(QB1, ctx + "/app/images/creditMap/yi.png", 1);
        	drawMess(QB2, ctx + "/app/images/creditMap/er.png", 1);
        	drawMess(QB3, ctx + "/app/images/creditMap/san.png", 1);
        } else {
        	drawMess(elementList, massIcon);
        }
    }
    
    // 画散点图
    function drawMess(enterList, massIcon, type){
    	var w = 16,h = 20;
    	if (type == 1) {
    		w = 20;
    		h = 24;
    	}
    	mass = new AMap.MassMarks(enterList, {
    	    url: massIcon,
    	    anchor: new AMap.Pixel(3, 7),
    	    size: new AMap.Size(w, h),
    	    opacity:1,
    	    cursor:'pointer',
    	    zIndex: 1000
    	});
    	    
    	mass.on('click',function(e){
    	    marker.setPosition(e.data.lnglat);
    	    openInfo(e.data);
    	});
    	      
    	var marker = new AMap.Marker({
    	    content:' ',
    	    map:map
    	});
    	masses.push(mass);
        mass.setMap(map);
    }
    
    var mapType = "mass";
    
    // 切换成散点图
    function toMassMap(obj){
    	mapType = "mass";
    	$(".btnmap").removeClass("btnDarkActive");
    	if ($(obj).attr("class").indexOf("btnDarkActive") == -1) {
    		$(obj).addClass("btnDarkActive");
    	}
    	
    	isKeywordSearch();
    }
    
    // 处理散点数据,QB1,QB2,QB3对应三大产业数据
    function dealMass(type, elementList, QB1, QB2, QB3){
    	
    	if (qychanged) {
	    	for (var i = 0, l = polygons.length; i < l; i++) {
	            polygons[i].setMap(null);
	        }
    	}
    	
    	//if (zoomLevel < 15) {
	    	for (var i = 0, l = masses.length; i < l; i++) {
	    		masses[i].setMap(null);
	        }
    	//}
    	if (heatmap != null && heatmap != undefined) {
    		heatmap.setDataSet({data: []});
    	}
    	
    	var treeObj = $.fn.zTree.getZTreeObj("dropdowncksTree");
		var selectedQy = treeObj.getCheckedNodes(true);
		var allNodes = treeObj.transformToArray(treeObj.getNodes());
		if (allNodes.length == selectedQy.length) {
			search(type, selectedQy[0]);
		} else{
			if (qychanged) {
			    for (var i = 0;i < selectedQy.length;i++) {
				    if (selectedQy[i].level != 0) {
						search(type, selectedQy[i]);
					}
				} 
			}
		}
		loadMess(elementList, QB1, QB2, QB3);
    }
    
    // 打开信息窗口
    function openInfo(data) {
        // 构建信息窗体中显示的内容
        var info = [];
        var title = "<span style='font-size:14px'>" + data.jgqc + "</span><div>" + data.zl + "</div>";
        info.push("<span class='infoWinItem'>法定代表人：" + data.fddbrxm + "</span>");
        info.push("<span class='infoWinItem'>注册资本：" + data.zczj + "万</span>");
        info.push("<span class='infoWinItem'>成立时间：" + data.fzrq + "</span>");
        info.push("<span class='infoWinItem'>行业类型：" + data.sshymc + "</span>");
        info.push("<span class='infoWinItem'>通讯地址：" + data.jgdz + "</span><br/>");
        info.push("<div class='infoWinBtn'><button class='btn btn-info btn-md' onclick='creditElements.openWin(\"" + data.id + "\", 1)'>社会法人</button>  <button  class='btn btn-info btn-md' onclick='creditElements.openWin(\"" + data.id + "\", 2)'>信用图谱</button></div>");
        var infoWindow = new AMap.InfoWindow({
            isCustom: true,  // 使用自定义窗体
            content: createInfoWindow(title, info.join("")),//content: info.join("<br/>")  // 使用默认信息窗体框样式，显示信息内容
            offset: new AMap.Pixel(16, -28) // 加上偏移
        });
        infoWindow.open(map,data.lnglat);
    }
   
    function openWin(id, type){
    	if (type == 1) {
    		window.open(ctx + "/center/socialLegalPerson/toView.action?isOpen=1&id=" + id);
    	} else {
    		window.open(ctx + "/center/creditCubic/toCreditAtlas.action?isOpen=1&qyid=" + id);
    	}
    }
    
    // 构建自定义信息窗体
    function createInfoWindow(title, content) {
        var info = document.createElement("div");
        info.className = "infoWindow";

        // 定义顶部标题
        var top = document.createElement("div");
        var titleD = document.createElement("div");
        var closeX = document.createElement("img");
        top.className = "info-top";
        titleD.innerHTML = title;
        closeX.src = "http://webapi.amap.com/images/close2.gif";
        closeX.onclick = closeInfoWindow;

        top.appendChild(titleD);
        top.appendChild(closeX);
        info.appendChild(top);

        // 定义中部内容
        var middle = document.createElement("div");
        middle.className = "info-middle";
        middle.innerHTML = content;
        info.appendChild(middle);

        // 定义底部内容
        var bottom = document.createElement("div");
        bottom.className = "info-bottom";
        bottom.style.position = 'relative';
        bottom.style.top = '0px';
        bottom.style.margin = '0 auto';
        var sharp = document.createElement("img");
        sharp.src = "http://webapi.amap.com/images/sharp.png";
        bottom.appendChild(sharp);
        info.appendChild(bottom);
        return info;
    }
    
    // 关闭信息窗体
    function closeInfoWindow() {
        map.clearInfoWindow();
    }
    
/***** 热力图相关 *****/
    var heatmap; 
    
    // 切换热力图
    function toHeatMap(obj){
    	
    	mapType = "heatMap";
    	
    	// 改变按钮样式
    	$(".btnmap").removeClass("btnDarkActive");
    	if ($(obj).attr("class").indexOf("btnDarkActive") == -1) {
    		$(obj).addClass("btnDarkActive");
    	}
    	
    	isKeywordSearch();
    }

    // 处理热力图数据
    function dealHeatMap(type, enterList){
    	// 清除行政区
    	if (qychanged) {
	    	for (var i = 0, l = polygons.length; i < l; i++) {
	            polygons[i].setMap(null);
	        }
	    	//polygons = [];
    	}
    	
    	// 清除地图上的点位
    	for (var i = 0, l = masses.length; i < l; i++) {
    		masses[i].setMap(null);
        }
    	
    	if (heatmap != null && heatmap != undefined) {
    		heatmap.setDataSet({data: []});
    	}

    	var treeObj = $.fn.zTree.getZTreeObj("dropdowncksTree");
		var selectedQy = treeObj.getCheckedNodes(true);
		var allNodes = treeObj.transformToArray(treeObj.getNodes());
		if (allNodes.length == selectedQy.length) {
			search(type, selectedQy[0]);
		} else{
			if (qychanged) {
			    for (var i = 0;i < selectedQy.length;i++) {
				    if (selectedQy[i].level != 0) {
						search(type, selectedQy[i]);
					}
				} 
			}
		}
		drawHeatMap(enterList);
		
    }
    
    // 画热力图
    function drawHeatMap(list){
    	 heatmap.setDataSet({
             data: list,
             max: 100
         });
    }
    
    function isKeywordSearch(type) {
    	var keyword = $.trim($("#keyword").val());
    	if (keyword != "" && keyword != null) {
    		keywordSearch(type);
    	} else {
    		conditionSearch(2);
    	}
    }
    
    // 全选
    function selectAll(obj, name){  
        if ($(obj).attr("checked")) {  
        	$("input[name='" + name + "']").attr("checked", true);  
        } else {  
        	$("input[name='" + name + "']").attr("checked", false);  
        }  
    } 
    
    function selectAllCon() {
		$("input[name='type']").attr("checked",true); 
		$("input[name='scale']").attr("checked",true); 
		$("input[name='year']").attr("checked",true);
		$("input[name='selectAll']").attr("checked",true);
		$("input[name='domainType']").attr("checked",true); 
		var treeObj = $.fn.zTree.getZTreeObj("industryTree");
		// 取消行业树选中
		treeObj.checkAllNodes(true);
		var treeObj1 = $.fn.zTree.getZTreeObj("dataProviderTree");
		if (treeObj1 != null) {
			treeObj1.checkAllNodes(true);
		}
    }
    
    return {
    	toggleElements : toggleElements,
    	toggleFullScreen : toggleFullScreen,
    	toHeatMap : toHeatMap,
    	search : search,
    	conditionSearch : conditionSearch,
    	toMassMap : toMassMap,
    	conditionReset : conditionReset,
    	setDomainIndustry : setDomainIndustry,
    	toggleDropcks : toggleDropcks,
    	openWin : openWin,
    	keywordSearch : keywordSearch,
    	selectAll : selectAll,
    	selectAllCon : selectAllCon
	}; 
	
})();
   