// 高管来源分析
var executivesSource = (function(){
	
	// 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('mapContainer'));
	
	// 中心城市
	var centerCity = "";
	
	// 中心城市坐标
	var locationArr=[];
	
	// 中心城市所在省
	var province = "";
	
	//获取当前城市
	$.post(ctx + "/center/executivesSource/getCenterLocation.action",
			function(xdata) {
		
		centerCity = xdata.centerCity; // 中心城市
		
		// 中心城市坐标
		locationArr[0] = (""+xdata.location).split(",")[0];
		locationArr[1] = (""+xdata.location).split(",")[1];
		province = xdata.province;     // 中心城市所在省
		conditionSearch();
		
		//获取高管人员总计数量
		$.post(ctx + "/center/executivesSource/getTotalExecutivesNum.action",
				function(data) {
			
				$("#legendTile").empty();
				var value = addCommas(data);
				var str = xdata.center+"高管人员总计："+value+" 人次";
				$("#legendTile").append(str);
				}, "json");
		}, "json");
	
	 
    
    var geoCoordMap = {
		    '陕西': [108.940174,34.341568],
		    '云南': [102.832891,24.880095],
		    '内蒙古': [111.749180,40.842585],
		    '四川': [104.066541,30.572269],
		    '青海': [101.778228,36.617144],
		    '甘肃': [103.834303,36.061089],
		    '安徽': [117.227239,31.820586],
		    '天津': [117.200983,39.084158],
		    '北京': [116.407526,39.904030],
		    '黑龙江':[126.534967,45.803775],
		    '湖南': [112.938814,28.228209],
		    '重庆': [106.551556,29.563009],
		    '广东': [113.264434,23.129162],
		    '山东': [117.119999,36.651216],
		    '河南': [113.625368,34.746599],
		    '上海': [121.473701,31.230416],
		    '浙江': [120.155070,30.274084],
		    '西藏': [91.140856,29.645554],
		    '河北': [114.514862,38.042309],
		    '新疆': [87.616848,43.825592],
		    '江西': [115.858197,28.682892],
		    '广西': [108.366543,22.817002],
		    '山西': [112.548879,37.870590],
		    '湖北': [114.305392,30.593098],
		    '宁夏': [106.230909,38.487193],
		    '贵州': [106.630153,26.647661],
		    '江苏': [118.796877,32.060255],
		    '吉林': [125.323544,43.817071],
		    '辽宁': [123.431474,41.805698],
		    '福建': [119.296494,26.074507],
		    '海南': [110.198293,20.044001]
    	};
    var data=[];
    function initMap(){
    	//myChart.clear();
    	var splitNumber = 1;
    	if(data.length　>　0 &&　data[0].TOTAL >1){
    		splitNumber = 3; // 刻度个数
    	}
         var selectedItems = [];
             var categoryData = [];
             var barData = [];
             var newData = [];
             var j = 1;
             var barData = [];
             for(var i=0;i<data.length;i++){
             		if((j<6)){
             			var obj={};
             			obj.name= data[i].CATEGORY+","+data[i].TOTAL+","+data[i].RATING_NUM;
             			obj.value = data[i].TOTAL
             			barData.push(obj)
             			j++;
             		}
             }
             barData.sort(function(a,b){
              	return  a.value-b.value;
             })
             for(var i=0;i<barData.length;i++){
            	    var name = (""+barData[i].name).split(",")[0];
              			categoryData.push(name);
              }
          
    	  option = {
    		    backgroundColor: 'rgb(64,74,89)',//整个背景色
    		    title: [{
    		        text: '',
    		        subtext: '',
    		        left: 'center',
    		        textStyle: {
    		            color: '#fff'
    		        }
    		    }],
    		    
    		    tooltip: {
    		        trigger: 'item',
    		        padding: 5,  
    		        formatter : function (params, ticket, callback) {
    		        	if(params.seriesType !='lines'){
    		        		var value = params.data.name+"";
    		        		var arrVal = value.split(",");
    		        		if(arrVal.length != 2){
    		        			var tooltipD;
    		        			if(arrVal.length == 4){
    		        				tooltipD = arrVal[0] + "<br />任职人次："  + addCommas(arrVal[1]) + "<br />排名："+arrVal[2]+"<br />占比 : "+arrVal[3] +"%";
    		        			}else{
    		        				tooltipD = arrVal[4] + "<br />任职人次："  + addCommas(arrVal[1]) + "<br />排名："+arrVal[2]+"<br />占比 : "+arrVal[3] +"%";
    		        			}
    		        			return tooltipD;
    		        		}
    		        	}
                    }
    		        
    		    },
    		    geo: {
    		        map: 'china',
    		        label: {
    		            emphasis: {
    		                show: false
    		            }
    		        },
    		        roam: true,
    		        silent: true,
    		        center: [110.9526, 34.7617],
    		        width:'60%',
    		        itemStyle: {
    		            normal: {
    		                areaColor: 'rgb(50,60,72)',//地图背景颜色
    		                borderColor: 'rgb(27,27,27)',//地图线条颜色
    		                width:10
    		            },
    		            emphasis: {
    		                areaColor: '#2a333d'
    		            }
    		        }
    		    },
    		    toolbox: {
    		        show : true,
    		        orient : 'vertical',
    		        x: 'right',
    		        y: 'center'

    		    },
    		    grid: {
    		        left: 50,
    		        top: 80,
    		        bottom: 450,
    		        width: '20%'
    		    },
    		    xAxis: {
    		        type: 'value',
    		        scale: true,
    		        position: 'top',
    		        minInterval: 1,//最小刻度
    		        splitNumber:splitNumber ,
    	            min:0,
    	            max:'dataMax',
    		        boundaryGap: false,
    		        splitLine: {
    		            show: false
    		        },
    		        axisLine: {
    		            show: false
    		        },
    		        axisTick: {
    		            show: false
    		        },
    		        axisLabel: {
    		            margin: 2,
    		            fontWeight: 'bolder',
    		            textStyle: {
    		                color: 'rgb(250,250,250)'
    		            }
    		        },
    		    },
    		    yAxis: {
    		        type: 'category',
    		        nameGap: 5,
    		        axisLine: {
    		            show: true,
    		            lineStyle: {
    		                color: '#ddd'
    		            }
    		        },
    		        axisTick: {
    		            show: false,
    		            lineStyle: {
    		                color: '#ddd'
    		            }
    		        },
    		        axisLabel: {
    		            interval: 0,
    		            fontWeight: 'bolder',
    		            textStyle: {
    		            	 color: 'rgb(250,250,250)'
    		            }
    		        },
    		        data: categoryData
    		    },
    		    series: [

    		    {
    		        type: 'lines',
    		        zlevel: 1,//线条样式
    		       
    		        effect: {
    		            show: true,
    		            period: 8,//箭头移动速度，越小越快
    		            trailLength: 0,
    		            color: 'rgb(108,240,218)',//箭头颜色3399cf
    		            symbol: planePath,
    		            symbolSize: 12
    		        },
    		        lineStyle: {
    		            normal: {
    		            	color:'rgb(255,210,209)',//线条颜色
    		                width: 1,
    		                opacity: 0.5,//不透明度
    		                curveness: 0.2 //弧度
    		            }
    		        },
    		        data: formtGCData(geoCoordMap, data, centerCity, false)
    		    }, {

    		        type: 'effectScatter',
    		        coordinateSystem: 'geo',
    		        zlevel: 2,
    		        rippleEffect: {
    		            period: 4,
    		            scale: 2.5,
    		            brushType: 'stroke'
    		        },
    		        label: {
    		            normal: {
    		                show: true,
    		                position: 'right',
    		                formatter:  function (val) {
    		                	var value= val.name+"";
    		                	var names = value.split(",");
    			            	return names[0];
    		                }
    		            }
    		        },
    		        symbolSize: 5,
    		        itemStyle: {
    		            normal: {
    		                color: '#0D6695',
    		                borderColor: 'gold'
    		            }
    		        },

    		        data: formtVData(geoCoordMap, data, centerCity)
    		    }, {
    	            id: 'bar',
    	            zlevel: 1,
    	            type: 'bar',
    	            symbol: 'none',
    	            itemStyle: {
    	                normal: {
    	                	color: 'rgb(108,240,218)'
    	                }
    	            },
    	            tooltip: {
        		        trigger: 'item',
        		        padding: 5,  
        		        formatter : function (params, ticket, callback) {
    		        		var value = params.data.name+"";
    		        		var arrVal = value.split(",");
    		        		var tooltipD= arrVal[0] + "<br />任职人次："  + addCommas(arrVal[1]) + "<br />占比 : "+arrVal[2] +"%";
    		        		return tooltipD;
        		        		
                        }
        		        
        		    },
    	            data: barData
    		    }]
        	};
             
         $("#legendTile").attr("style","display:block");
        
    	 myChart.setOption(option);
    	
    }
    	function formtGCData(geoData, data, srcNam, dest) {
    	    var tGeoDt = [];
    	    if (dest) {
    	    	var j = 1;
    	        for (var i = 0, len = data.length; i < len; i++) {
    	        	if(geoData[province][0] ==locationArr[0] && geoData[province][1] ==locationArr[1] ){//省会城市：不显示省，只显示市
    	        		if (srcNam != data[i].CATEGORY && data[i].CATEGORY != province) {
    	        			tGeoDt.push({
    	        				coords: [locationArr,geoData[data[i].CATEGORY]],
    	        				name:[data[i].CATEGORY+","+data[i].TOTAL+","+j+","+data[i].RATING_NUM]
    	        			});
    	        		}
    	        		j++;
    	        	}else{
    	        		if (srcNam != data[i].CATEGORY) {
    	        			tGeoDt.push({
    	        				coords: [locationArr,geoData[data[i].CATEGORY]],
    	        				name:[data[i].CATEGORY+","+data[i].TOTAL+","+j+","+data[i].RATING_NUM]
    	        			});
    	        		}
    	        		j++;
    	        		
    	        	}
    	        }
    	    } else {
    	    	var j = 1;
    	        for (var i = 0, len = data.length; i < len; i++) {
    	        	if(geoData[province][0] ==locationArr[0] && geoData[province][1] ==locationArr[1] ){//省会城市：不显示省，只显示市
    	        		if (srcNam != data[i].CATEGORY && data[i].CATEGORY != province) {
    	        			tGeoDt.push({
    	        				coords: [geoData[data[i].CATEGORY], locationArr],
    	        				name:[data[i].CATEGORY+","+data[i].TOTAL+","+j+","+data[i].RATING_NUM]
    	        			});
    	        		}
    	        		j++;
    	        	}else{
    	        		if (srcNam != data[i].CATEGORY) {
    	        			tGeoDt.push({
    	        				coords: [geoData[data[i].CATEGORY], locationArr],
    	        				name:[data[i].CATEGORY+","+data[i].TOTAL+","+j+","+data[i].RATING_NUM]
    	        			});
    	        		}
    	        		j++;
    	        		
    	        	}
    	        }
    	    }
    	    return tGeoDt;
    	}

    	function formtVData(geoData, data, srcNam) {
    		var srcValue;
    	    var tGeoDt = [];
    	    var j = 1;
    	    for (var i = 0, len = data.length; i < len; i++) {
    	        var tNam = data[i].CATEGORY;
    	        var size = data[i].HANDLETOTAL+1;
    	        if(geoData[province][0] ==locationArr[0] && geoData[province][1] ==locationArr[1] ){//省会城市：不显示省，只显示市
    	        	
		        	 if (srcNam != tNam && data[i].CATEGORY != province) {
		    	            tGeoDt.push({
		    	                name: data[i].CATEGORY+","+data[i].TOTAL+","+j+","+data[i].RATING_NUM,
		    	                symbolSize: size,
		    	                value: geoData[tNam],
		    	                itemStyle: {
		    	    	            normal: {
		    	    	                color: 'rgb(238,250,1)',//字体颜色和坐标圆圈最外层颜色
		    	    	                borderColor: '#000'
		    	    	            }
		    	    	        }
		    	            });
		    	        }else{
		    	        	srcValue = data[i].TOTAL+","+j+","+data[i].RATING_NUM+","+province;
		    	        }
		              j++;
    	        }else{
    	        	if (srcNam != tNam) {
	    	            tGeoDt.push({
	    	                name: data[i].CATEGORY+","+data[i].TOTAL+","+j+","+data[i].RATING_NUM,
	    	                symbolSize: size+3,
	    	                value: geoData[tNam],
	    	                itemStyle: {
	    	    	            normal: {
	    	    	                color: 'rgb(238,250,1)',//字体颜色和坐标圆圈最外层颜色
	    	    	                borderColor: '#000'
	    	    	            }
	    	    	        }
	    	            });
	    	        }else{
	    	        	srcValue = data[i].TOTAL+","+j+","+data[i].RATING_NUM;
	    	        }
	              j++;
    	        }
    	       
    	    }
    	    
    	    tGeoDt.push({
    	        name: srcNam+","+srcValue,
    	        value: locationArr,
    	        symbolSize: 20,
    	        itemStyle: {
    	            normal: {
    	                color: 'rgb(108,240,218)',//中心字体颜色
    	                borderWidth: 2,
    	                borderColor: 'black'
    	            }
    	        }
    	    });
    	    return tGeoDt;
    	}

    	//var planePath = 'path://M1705.06,1318.313v-89.254l-319.9-221.799l0.073-208.063c0.521-84.662-26.629-121.796-63.961-121.491c-37.332-0.305-64.482,36.829-63.961,121.491l0.073,208.063l-319.9,221.799v89.254l330.343-157.288l12.238,241.308l-134.449,92.931l0.531,42.034l175.125-42.917l175.125,42.917l0.531-42.034l-134.449-92.931l12.238-241.308L1705.06,1318.313z';
    	//var planePath = 'arrow';
    	//var planePath = "path://M917.965523 917.331585c0 22.469758-17.891486 40.699957-39.913035 40.699957-22.058388 0-39.913035-18.2302-39.913035-40.699957l-0.075725-0.490164-1.087774 0c-18.945491-157.665903-148.177807-280.296871-306.821991-285.4748-3.412726 0.151449-6.751774 0.562818-10.240225 0.562818-3.450589 0-6.789637-0.410346-10.202363-0.524956-158.606321 5.139044-287.839661 127.806851-306.784128 285.436938l-1.014096 0 0.075725 0.490164c0 22.469758-17.854647 40.699957-39.913035 40.699957s-39.915082-18.2302-39.915082-40.699957l-0.373507-3.789303c0-6.751774 2.026146-12.903891 4.91494-18.531052 21.082154-140.712789 111.075795-258.241552 235.432057-312.784796C288.420387 530.831904 239.989351 444.515003 239.989351 346.604042c0-157.591201 125.33352-285.361213 279.924387-285.361213 154.62873 0 279.960203 127.770012 279.960203 285.361213 0 97.873098-48.391127 184.15316-122.103966 235.545644 124.843356 54.732555 215.099986 172.863023 235.808634 314.211285 2.437515 5.290493 4.01443 10.992355 4.01443 17.181311L917.965523 917.331585zM719.822744 346.679767c0-112.576985-89.544409-203.808826-199.983707-203.808826-110.402459 0-199.944821 91.232864-199.944821 203.808826s89.542362 203.808826 199.944821 203.808826C630.278335 550.488593 719.822744 459.256752 719.822744 346.679767z";
        //    简笔人2
        var  planePath="path://M621.855287 587.643358C708.573965 540.110571 768 442.883654 768 330.666667 768 171.608659 648.609267 42.666667 501.333333 42.666667 354.057399 42.666667 234.666667 171.608659 234.666667 330.666667 234.666667 443.22333 294.453005 540.699038 381.59961 588.07363 125.9882 652.794383 21.333333 855.35859 21.333333 1002.666667L486.175439 1002.666667 1002.666667 1002.666667C1002.666667 815.459407 839.953126 634.458526 621.855287 587.643358Z";

       
           
	     
	   

    $(function(){
    	
    	 if (isIE()) {
    		 $("input[type=checkbox]").css({"vertical-align":"middle","margin-top":"0"});
    	 }
         // 右侧边栏属性设置
         $('.sliderbar-container').sliderBar({
     		 open : true,           // 默认是否打开，true打开，false关闭
             top : 20,              // 距离顶部多高
             width : 220,           // body内容宽度   230
             height : 500,          // body内容高度
             theme : 'green',       // 主题颜色
             position : 'right'     // 显示位置，有left和right两种
     	 });
         
    }); 
    
    function addCommas(nStr)
    {
     nStr += '';
     x = nStr.split('.');
     x1 = x[0];
     x2 = x.length > 1 ? '.' + x[1] : '';
     var rgx = /(\d+)(\d{3})/;
     while (rgx.test(x1)) {
      x1 = x1.replace(rgx, '$1' + ',' + '$2');
     }
     return x1 + x2;
    }

    // 判断浏览器是否是ie
    function isIE() { //ie?  
        if (window.ActiveXObject || "ActiveXObject" in window)  
            return true;  
        else  {
     	   return false;  
        }
    }
    
    
    var selectedElementIndex = 0;
	
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
	
	// 条件搜索高管来源
	function conditionSearch(type){
		// 高管类型
		var executiveType = $("input[name='GGLX']:checked").val();
		
		//查询条件
		var searchParams = {};
		if(type == 1){
			//点击【查询】按钮查询
			
			// 职务
			var postVal = [];
			$("input[name='post']:checked").each(function(){
				postVal.push($(this).val());
			});
			
			// 性别
			var sexVal = [];
			$("input[name='sex']:checked").each(function(){
				sexVal.push($(this).val());
			});
			
			// 年龄分布
			var ageVal = [];
			$("input[name='age']:checked").each(function(){
				ageVal.push($(this).val()); 
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
			
			// 行业类型
			var industryTypeVal = "";
			
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
			
			searchParams = {
					"executiveType" : executiveType,//高管类型
			        "post" : postVal.join(","), //职务
			        "sex"  : sexVal.join(","), //性别
			        "age" : ageVal.join(","),	// 年龄分布
			        "registeredScale" : scaleVal.join(","),	// 注册规模
			        "topicYear" : yearVal.join(","),	// 主体年份
			        "industryType" : industryTypeVal // 行业类型
			};
		}else{
			
			//默认查询
			searchParams = {
					"executiveType" : executiveType	//高管类型
			};
		}
		document.getElementById("over").style.display = "block";
        document.getElementById("layout").style.display = "block";
		var url = ctx + "/center/executivesSource/queryExecutivesList.action";
		$.post(url, searchParams,
				function(xdata) {
			if(xdata){
				data = xdata.executivesList;
			
			    //初始化地图
				initMap();
				document.getElementById("over").style.display = "none";
				document.getElementById("layout").style.display = "none";
				
			}
		}, "json");
		
		
		
	}
	
	// 条件重置
	function conditionReset(){
		$("#GGDS").attr("checked",false); 
		$("#GGFR").attr("checked",true); 
		setPosDiv(1);
		$("input[name='post']").attr("checked",false); 
		$("input[name='sex']").attr("checked",false); 
		$("input[name='age']").attr("checked",false); 
		$("input[name='scale']").attr("checked",false); 
		$("input[name='year']").attr("checked",false); 
		$("input[name='selectAll']").attr("checked",false);
		var treeObj = $.fn.zTree.getZTreeObj("industryTree");
		// 取消行业树选中
		treeObj.checkAllNodes(false);
	}
	
	// 单个类型全选
    function selectAll(obj, name){  
        if ($(obj).attr("checked")) {  
        	$("input[name='" + name + "']").attr("checked", true);  
        } else {  
        	$("input[name='" + name + "']").attr("checked", false);  
        }  
    } 
    
	// 全选
   function selectAllCon() {
	   $("input[name='post']").attr("checked",true); 
	   $("input[name='sex']").attr("checked",true); 
	   $("input[name='age']").attr("checked",true); 
		$("input[name='scale']").attr("checked",true); 
		$("input[name='year']").attr("checked",true);
		$("input[name='selectAll']").attr("checked",true);
		var treeObj = $.fn.zTree.getZTreeObj("industryTree");
		
		// 行业树全选
		treeObj.checkAllNodes(true);
		var treeObj1 = $.fn.zTree.getZTreeObj("dataProviderTree");
		if (treeObj1 != null) {
			treeObj1.checkAllNodes(true);
		}
    }
    
   function setPosDiv(type){
	   if(type == 1){
		   $("#postDiv").attr("style","display:none");
		   $("#POSTAll").attr("checked",false);
		   $("input[name='post']").attr("checked",false); 
	   }else{
		   $("#postDiv").attr("style","display:block");
	   }
   
	   
   }
    return {
    	conditionSearch : conditionSearch,
    	conditionReset : conditionReset,
    	selectAll : selectAll,
    	selectAllCon : selectAllCon,
    	setPosDiv : setPosDiv
	}; 
	
})();
   