<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务端首页</title>
</head>
<body>
	<div class="row">
		<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat green-jungle">
				<div class="visual">
					<!-- <i class="fa  fa-align-justify"></i> -->
					
					<i class="fa  fa-globe"></i>
				</div>
				<div class="details">
					<div class="number">${yearCnt}</div>
					<div class="desc">年办理</div>
				</div>
				<i class="more"> </i>
			</div>
		</div>
		<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat green-haze">
				<div class="visual">
					<!-- <i class="fa fa-indent"></i> -->
					<i class="fa fa-moon-o"></i>
				</div>
				<div class="details">
					<div class="number">${monthCnt}</div>
					<div class="desc">月办理</div>
				</div>
				<i class="more"> </i>
			</div>
		</div>
		<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat blue-madison">
				<div class="visual">
					<!-- <i class="fa fa-outdent"></i> -->
					<i class="fa fa-sun-o"></i>
				</div>
				<div class="details">
					<div class="number">${dayCnt}</div>
					<div class="desc">日办理</div>
				</div>
				<i class="more"> </i>
			</div>
		</div>
		<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat red-intense">
				<div class="visual">
					<i class="fa fa-tag"></i>
				</div>
				<div class="details">
					<div class="number">${undoCnt}</div>
					<div class="desc">待办理</div>
				</div>
				<i class="more"> </i>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-6 col-sm-6">
			<div class="portlet light bordered" style="height: 380px;">
				<div id="applyCountPie" style="width: 100%; height: 100%;"></div>
			</div>
		</div>
		<div class="col-md-6 col-sm-6">
			<div class="portlet light bordered" style="height: 380px;">
				<h4 class="block">信用报告</h4>
				<ul class="feeds">
					<li>
						<div class="col1">
							<div class="cont">
								<div class="cont-col1">
									<div class="label label-sm label-success">
										<i class="fa fa-bar-chart-o"></i>
									</div>
								</div>
								<div class="cont-col2">
									<div class="desc">申请量</div>
								</div>
							</div>
						</div>
						<div class="col2">
							<div class="date">${bgCnt }</div>
						</div>
					</li>
					<li>
						<div class="col1">
							<div class="cont">
								<div class="cont-col1">
									<div class="label label-sm label-success">
										<i class="fa fa-database"></i>
									</div>
								</div>
								<div class="cont-col2">
									<div class="desc">业务占比</div>
								</div>
							</div>
						</div>
						<div class="col2">
							<div class="date">${bgPer }</div>
						</div>
					</li>
				</ul>
				<h4 class="block">异议申诉</h4>
				<ul class="feeds">
					<li>
						<div class="col1">
							<div class="cont">
								<div class="cont-col1">
									<div class="label label-sm label-success">
										<i class="fa fa-bar-chart-o"></i>
									</div>
								</div>
								<div class="cont-col2">
									<div class="desc">申请量</div>
								</div>
							</div>
						</div>
						<div class="col2">
							<div class="date">${yyCnt }</div>
						</div>
					</li>
					<li>
						<div class="col1">
							<div class="cont">
								<div class="cont-col1">
									<div class="label label-sm label-success">
										<i class="fa fa-database"></i>
									</div>
								</div>
								<div class="cont-col2">
									<div class="desc">业务占比</div>
								</div>
							</div>
						</div>
						<div class="col2">
							<div class="date">${yyPer }</div>
						</div>
					</li>
				</ul>
				<h4 class="block">信用修复</h4>
				<ul class="feeds">
					<li>
						<div class="col1">
							<div class="cont">
								<div class="cont-col1">
									<div class="label label-sm label-success">
										<i class="fa fa-bar-chart-o"></i>
									</div>
								</div>
								<div class="cont-col2">
									<div class="desc">申请量</div>
								</div>
							</div>
						</div>
						<div class="col2">
							<div class="date">${xfCnt }</div>
						</div>
					</li>
					<li>
						<div class="col1">
							<div class="cont">
								<div class="cont-col1">
									<div class="label label-sm label-success">
										<i class="fa fa-database"></i>
									</div>
								</div>
								<div class="cont-col2">
									<div class="desc">业务占比</div>
								</div>
							</div>
						</div>
						<div class="col2">
							<div class="date">${xfPer }</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<input id="yyCnt" value="${yyCnt }" type="hidden"/>
	<input id="bgCnt" value="${bgCnt }" type="hidden"/>
	<input id="xfCnt" value="${xfCnt }" type="hidden"/>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
	<script type="text/javascript" src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
<script type="text/javascript">
	var pieChart = echarts.init(document.getElementById("applyCountPie"));
	var pieDataKinds = [ '信用报告', '异议申诉', '信用修复' ];
	var seriesData = [ {
		value : $('#bgCnt').val(),
		name : '信用报告'
	}, {
		value : $('#yyCnt').val(),
		name : '异议申诉'
	}, {
		value : $('#xfCnt').val(),
		name : '信用修复'
	} ];
	initPie();
	
	function initPie() {
		var option = {
			title : {
				text : '业务办理量分布图',
				x : 'center'
			},
			toolbox : {
				show : true,
				left : '20',
				top : '50',
				feature : {
					restore : {
						show : true
					},
					saveAsImage : {
						show : true
					}
				}
			},
			tooltip : {
				trigger : 'item',
				formatter : "{a} <br/>{b} : {c} ({d}%)"
			},
			legend : {
				orient : 'vertical',
				left : 'right',
				data : pieDataKinds
			},
			series : [ {
				name : '业务办理量分布图',
				type : 'pie',
				radius : '75%',
				center : [ '50%', '55%' ],
				data : seriesData,
				label : {
					normal : {
						show : true,
						formatter : '{b}：{c}'
					}
				},
				color : [ '#00A65A', '#30BBBB', '#F39C12' ],
				itemStyle : {
					emphasis : {
						shadowBlur : 10,
						shadowOffsetX : 0,
						shadowColor : 'rgba(0, 0, 0, 0.5)'
					}
				}
			} ]

		};
		pieChart.setOption(option);
		pieChart.hideLoading();
	}
	$(window).resize(function() {
		pieChart.resize();
	});
</script>
</html>