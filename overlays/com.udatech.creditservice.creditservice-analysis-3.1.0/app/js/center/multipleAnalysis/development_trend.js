var developmentTrend = (function() {
	$("#xzq").select2();
	$("#hyhf").select2();
	$("#qylx").select2();
	$("#zcgm").select2();
	$("#qynl").select2();
/**** 发展趋势轨迹图 ****/

var endYear = new Date();
endYear.setMonth(0);
endYear.setDate(1);
endYear = endYear.format("yyyy");
var startDate;
// x轴最大值范围
var xscaleMax = 1000;
// y轴最大值范围
var yscaleMax = 1000;
// 半径最大值范围
var radiusscaleMax = 50000;
// 动画总时长
var animateTime = 8000;

function initDevTrendChart(data){
	$("#developmentTrend").html("");
	// Various accessors that specify the four dimensions of data to visualize.
	function x(d) { return d.qiye; }
	function y(d) { return d.jilu; }
	function radius(d) { return d.total; }
	function color(d) { return d.name; }
	function key(d) { return d.name; }

	// 图表尺寸
	var margin = {top: 19.5, right: 19.5, bottom: 19.5, left: 30},
	    width = $("#developmentTrend").width() - margin.right,
	    height = 500 - margin.top - margin.bottom;
	
	// 各个维度的值预估范围，即每个轴的刻度范围
	var xScale = d3.scale.linear().domain([0, xscaleMax]).range([0, width - 50]),
	    yScale = d3.scale.linear().domain([0, yscaleMax]).range([height, 0]),
	    radiusScale = d3.scale.sqrt().domain([0, radiusscaleMax]).range([0, 40]),
	    colorScale = d3.scale.category10();

	// x和y轴
	var xAxis = d3.svg.axis().orient("bottom").scale(xScale).ticks(12, d3.format(",d")),
	    yAxis = d3.svg.axis().scale(yScale).orient("left");

	// 创建svg并且初始值
	var svg = d3.select("#developmentTrend").append("svg")
	    .attr("width", width + margin.left + margin.right)
	    .attr("height", height + margin.top + margin.bottom)
	    .append("g")
	    .attr("transform", "translate(" + 70 + "," + margin.top + ")").attr("class",
		"gRoot");
	// svg添加x轴
	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis);

	// 添加y轴
	svg.append("g")
	    .attr("class", "y axis")
	    .call(yAxis);

	// 添加x轴的标签
	svg.append("text")
	    .attr("class", "x label")
	    .attr("text-anchor", "end")
	    .attr("x", width - 80)
	    .attr("y", height - 6)
	    .text("主体数量");

	// 添加y轴标签
	svg.append("text")
	    .attr("class", "y label")
	    .attr("text-anchor", "end")
	    .attr("y", 6)
	    .attr("dy", ".75em")
	    .attr("transform", "rotate(-90)")
	    .text("记录数量");

	// 添加年份标签，并将该值设置为可转换
	var label = svg.append("text")
	    .attr("class", "year label")
	    .attr("text-anchor", "end")
	    .attr("y", height - 24)
	    .attr("x", width - 50)
	    .text(startDate);

	var countrylabel = svg.append("text")
	.attr("class", "country label")
	.attr("text-anchor", "start")
	.attr("y", 80)
	.attr("x", 20)
	.text(" ");

	var nations = data;
	// A bisector since many nation's data is sparsely-defined.
	var bisect = d3.bisector(function(d) {return d[0]; });

	// 为每个对象添加一个点，初始化年份，并赋予颜色
    var dot = svg.append("g")
        .attr("class", "dots")
        .selectAll(".dot")
        .data(interpolateData(startDate))
        .enter().append("circle")
        .attr("class", "dot")
        .style("fill", function(d) { return colorScale(color(d)); })
        .call(position)
        .on("mouseover", function(d, i,event) {
        	
             /** -----------鼠标悬浮，显示内容----------------------begin------------------------*/
	  		  var tjlb = $("input[name='tjlb']:checked").val();
	  		  var lableName="";
	  		  if(tjlb == 1){
	  			  lableName = "行业门类";
	  		  }else if(tjlb == 2){
	  			  lableName = "行政区划";
	  		  }else{
	  			  lableName = "企业年龄";
	  		  }
	  		  
        	 var popValue =lableName+"："+d.name + "<br>期末累计在营主体：" + Math.round((d.total),2) + "<br>信用主体数量(X轴)：" + Math.round((d.qiye),2) + "<br>信用记录数量(Y轴)：" + Math.round((d.jilu),2);
             
             //鼠标移入的时候显示提示框。  
             $("#titleTips").show();  
             
             var title_show = document.getElementById("titleTips");
             //设置文本框的样式以及坐标  
             $("#titleTips").css({"position":"absolute",  
	             	                 "width":"auto",
	                                  "height":"auto",  
	                                  "border":"none",
	                                  "background":"inherit",
	                                  "background":"#FBEADC",  
	                                  "line-height":"20px",  
	                                  "text-align":"left",  
	                                  "border-radius":"5px",  
	                                  "font-family":"Arial",  
	                                  "font-size":"12px",  
	                                  "font-weight":"normal",  
	                                  "z-index":"100",  
	                                  "color":"black" ,
	                                  "padding":"5px",
	                                  "border-radius": "0px",
	                                  "-moz-box-shadow": "5px 5px 5px rgba(0, 0, 0, 0.2)",
	                                  "-webkit-box-shadow": "5px 5px 5px rgba(0, 0, 0, 0.2)",
	                                  "box-shadow": "5px 5px 5px rgba(0, 0, 0, 0.2)"
	                                 }); 
             
              //根据鼠标位置设定悬停效果DIV位置
              //event = window.event||event;
             var e = window.event || arguments.callee.caller.arguments[0]; 
              var top_down = 30;                                        
              //最左值为当前鼠标位置 与 body宽度减去悬停效果DIV宽度的最小值，否则将右端导致遮盖
              var left = Math.min(e.clientX,document.body.clientWidth-title_show.clientWidth);
              title_show.style.left = left+10+"px";            
              title_show.style.top = (e.clientY + top_down+20)+"px";    
              $("#titleTips").html(popValue);
              /** -----------鼠标悬浮，显示内容----------------------end------------------------*/
              
    	     // clear_demo();
    	     if(dragit.statemachine.current_state == "idle") {
    	       dragit.trajectory.display(d, i)
    	       dragit.utils.animateTrajectory(dragit.trajectory.display(d, i), dragit.time.current, 1000)
    	       dot.style("opacity", .4)
    	       d3.select(this).style("opacity", 1)
    	       d3.selectAll(".selected").style("opacity", 1)
    	     }
    	   }).on("mouseleave", function(d, i) {
				if (dragit.statemachine.current_state == "idle") {
					countrylabel.text("");
					dot.style("opacity", 1);
				}
				$("#titleTips").hide();  
				dragit.trajectory.remove(d, i);
			}).call(dragit.object.activate);

	  // 给年标签添加一个遮盖层
	  var box = label.node().getBBox();
	  var overlay = svg.append("rect")
	      .attr("class", "overlay")
	      .attr("x", box.x)
	      .attr("y", box.y)
	      .attr("width", box.width)
	      .attr("height", box.height)
	      .on("mouseover", enableInteraction);

	  
	  // 开始动画
	 function startTransition() {
		  svg.transition()
	      .duration(animateTime)
	      .ease("linear")
	      .tween("year", tweenYear)
	      .each("end", enableInteraction);
	  }

	  // 基于数据的点位置
	  function position(dot) {
		  $(".dots circle").empty();
		  // 添加一个提示框
		  var tjlb = $("input[name='tjlb']:checked").val();
		  var lableName="";
		  if(tjlb == 1){
			  lableName = "行业门类";
		  }else if(tjlb == 2){
			  lableName = "行政区划";
		  }else{
			  lableName = "企业年龄";
		  }
		 /* dot.append("title").html(function(d){
			  var tip =lableName+"："+d.name + "<br>期末累计在营主体：" + Math.round((d.total),2) + "<br>信用主体数量(X轴)：" + Math.round((d.qiye),2) + "<br>信用记录数量(Y轴)：" + Math.round((d.jilu),2);
			  return tip
		  });
		  */
	      dot.attr("cx", function(d) {  return  xScale(x(d)); })
	          .attr("cy", function(d) { return yScale(y(d)); })
	          .attr("r", function(d) { return radiusScale(radius(d)); });
	  }

	  // Defines a sort order so that the smallest dots are drawn on top.
	  function order(a, b) {
	      return radius(b) - radius(a);
	  }

	  // 通过鼠标事件改变年份
	  function enableInteraction() {
	      var yearScale = d3.scale.linear()
	          .domain([startDate, endYear])
	          .range([box.x + 10, box.x + box.width - 10])
	          .clamp(true);

	      // Cancel the current transition, if any.
	      svg.transition().duration(0);

	      overlay
	          .on("mouseover", mouseover)
	          .on("mouseout", mouseout)
	          .on("mousemove", mousemove)
	          .on("touchmove", mousemove)
	          .on("click", itemClick);

	      function mouseover() {
	    	  $("rect.overlay").css("cssText","fill: none;pointer-events: all;cursor: ew-resize;")
	    	  overlay.on("mousemove", mousemove);
	          label.classed("active", true);
	      }

	      function mouseout() {
	          label.classed("active", false);
	      }
	      
	      var isFirst = true;
	      function itemClick(){
	    	  overlay.on("mousemove", "");//鼠标点击，解除绑定
	    	  label.classed("active", false);
	    	  if(isFirst){
	    		  $("rect.overlay").css("cssText","fill: none;pointer-events: stroke;cursor: ew-resize;")
	    	  }else{
	    		  $("rect.overlay").css("cssText","fill: none;pointer-events: all;cursor: ew-resize;");
	    		  flag = true;
	    	  }
	    	  displayYear(yearScale.invert(d3.mouse(this)[0]));  
	      }

	      function mousemove() {
	          displayYear(yearScale.invert(d3.mouse(this)[0]));
	      }
	  }
	  
	  init();
	  
	  function update(v, duration) {
		  dragit.time.current = v || dragit.time.current;
		  displayYear(dragit.time.current)
		  d3.select("#slider-time").property("value", dragit.time.current);
	  }
	  
	  function init() {
		  dragit.init(".gRoot");
		  dragit.time = {min:startDate, max:endYear, step:1, current:startDate}
		  dragit.data = d3.range(nations.length).map(function() { return Array(); })
		  for(var yy = startDate; yy<endYear; yy++) {
		    interpolateData(yy).filter(function(d, i) { 
		      dragit.data[i][yy-dragit.time.min] = [xScale(x(d)), yScale(y(d))];
		    })
		  }
		  //dragit.evt.register("update", update);
		  //d3.select("#slider-time").property("value", dragit.time.current);
		  d3.select("#slider-time")
		    .on("mousemove", function() { 
		      update(parseInt(this.value), 500);
		      clear_demo();
		    })
		  var end_effect = function() {
		    countrylabel.text("");
		    dot.style("opacity", 1)
		  }
		  //dragit.evt.register("dragend", end_effect)
	  }
	  
	  // Tweens the entire chart by first tweening the year, and then the data.
	  // For the interpolated data, the dots and label are redrawn.
	  function tweenYear() {
	    var year = d3.interpolateNumber(startDate, endYear);
	    return function(t) { displayYear(year(t)); };
	  }

	  // Updates the display to show the specified year.
	  function displayYear(year) {
	    dot.data(interpolateData(year), key).call(position).sort(order);
	    label.text(Math.round(year));
	  }

	  // Interpolates the dataset for the given (fractional) year.
	  function interpolateData(year) {
	      return nations.map(function(d) {
	    	  return {
	        	  name: d.name,
	        	  qiye: interpolateValues(d.qiye, year),
	        	  total: interpolateValues(d.total, year),
	        	  jilu: interpolateValues(d.jilu, year)
	          };
	      });
	  }

	  // Finds (and possibly interpolates) the value for the specified year.
	  function interpolateValues(values, year) {
		  if (values.length > 0) {
		      var i = bisect.left(values, year, 0, values.length - 1),
		      a = values[i];
		      if (i > 0) {
		          var b = values[i - 1],
		          t = (year - a[0]) / (b[0] - a[0]);
		          return a[1] * (1 - t) + b[1] * t;
		      }
		      return a[1];
		  } else {
			  return 0;
		  }
	  }
	  
	  function clear_demo() {
		  if(first_time) {
		      svg.transition().duration(0);
		      first_time = false;
		      window.clearInterval(demo_interval);
		      countrylabel.text("");
		      dragit.trajectory.removeAll();
		      d3.selectAll(".dot").style("opacity", 1)
		  }
	   }
	  
	  // 自动播放
	  startTransition();
    };	  
	  
	$(function(){
		  
	    // 行政区划赋值
		    multiCommon.getRegionalDic();
			
	    // 行业划分赋值
		    multiCommon.getIndustryList();
		    
		    conditionSearch();
		    //initDevTrendChart();
	 });
	
	function conditionSearch(){
		  var params = getConditions();
		  getDevTrendData(params);
	}
	
	// 获取
	function getDevTrendData(params){
		document.getElementById("over").style.display = "block";
        document.getElementById("layout").style.display = "block";
		params.chartTheme = 3;
		$.post(ctx + '/center/developmentTrend/queryDevelopmentTrend.action', params,
			function(data) {
				if (data) {
					startDate = data.startDate.substring(0, 4);
					
				    xscaleMax = data.xscaleMax;
					
				    yscaleMax = data.yscaleMax;
					
					radiusscaleMax = data.radiusscaleMax;
					
					animateTime = data.animateTime;
					
					initDevTrendChart(data.developList);	
					document.getElementById("over").style.display = "none";
		            document.getElementById("layout").style.display = "none";
					
				}
		}, "json");
	}
	
	// 获取查询条件的值
	function getConditions(){
		// 信用主题
		var xyzt = $("input[name='xyzt']:checked").val();
		
		// 类别选择
		var tjlb = $("input[name='tjlb']:checked").val();
		
		// 统计指标1 累计 新增
		var zhibiao1 = $("input[name='zhibiao1']:checked").val();
		
		// 行政区
		var xzq = $.trim($("#xzq").select2('val'));
		var xzqArr = xzq.split(",");
		var isxzqAll = false;
		for (var i = 0;i < xzqArr.length;i++){
			if (xzqArr[i] == 0) {
				isxzqAll = true;
				break;
			}
		}
		if (isxzqAll) {
			xzq = null;
		}
		
		// 企业类型
		var qylx = $.trim($("#qylx").select2('val'));
		var qylxArr = qylx.split(",");
		var isqylxAll = false;
		for (var i = 0;i < qylxArr.length;i++){
			if (qylxArr[i] == 0) {
				isqylxAll = true;
				break;
			}
		}
		if (isqylxAll) {
			qylx = null;
		}
		
		// 行业划分
		var hyhf = $.trim($("#hyhf").select2('val'));
		var hyhfArr = hyhf.split(",");
		var ishyhfAll = false;
		for (var i = 0;i < hyhfArr.length;i++){
			if (hyhfArr[i] == 0) {
				ishyhfAll = true;
				break;
			}
		}
		if (ishyhfAll) {
			hyhf = null;
		}
		
		// 企业年龄
		var qynl = $.trim($("#qynl").select2('val'));
		var qynlArr = qynl.split(",");
		var isQynlAll = false;
		for (var i = 0;i < qynlArr.length;i++){
			if (qynlArr[i] == 0) {
				isQynlAll = true;
				break;
			}
		}
		if (isQynlAll) {
			qynl = null;
		}
		
		// 注册规模
		var zcgm = $.trim($("#zcgm").select2('val'));
		var zcgmArr = zcgm.split(",");
		var iszcgmAll = false;
		for (var i = 0;i < zcgmArr.length;i++){
			if (zcgmArr[i] == 0) {
				iszcgmAll = true;
				break;
			}
		}
		if (iszcgmAll) {
			zcgm = null;
		}
		
		var params = {creditTheme : xyzt, region : xzq, industryType : hyhf, type : qylx, age : qynl, registeredScale : zcgm, trendType: zhibiao1, category : tjlb};
		
		return params;
	}
	
	// 选择不同的类别时对应的下拉条不显示
	function showorhideCondition(type){
		$(".conBox").show();
		// 行业门类
		if (type == 1) {
			$("#hyhfBox").hide();
		} else if (type == 2) {// 行政区划
			$("#xzqBox").hide();
		} else {// 企业年龄
			$("#qynlBox").hide();
		}
	}
	
	// 重置
	function conditionReset(){
		$("#cxjl").attr("checked", true);
		$("#lbhyml").attr("checked", true);
		$("#xinz").attr("checked", true);
		$("#xzq").val(['0']).trigger('change');
		$("#qylx").val(['0']).trigger('change');
		$("#zcgm").val(['0']).trigger('change');
		$("#hyhf").val(['0']).trigger('change');
		$("#qynl").val(['0']).trigger('change');
	}
	  
	return {
		conditionReset : conditionReset,
		conditionSearch : conditionSearch,
		showorhideCondition : showorhideCondition
	} 
})();
