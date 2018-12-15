<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<!-- BEGIN CORE PLUGINS -->
<!--[if lt IE 9]>
<script type="text/javascript" src="${rsa}/global/plugins/respond.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/excanvas.min.js"></script> 
<![endif]-->
<!-- 高德地图必须在jquery之前引用，否则会有问题 -->
<script type="text/javascript" src="https://webapi.amap.com/maps?v=1.3&key=314916f9156b2e8ab43de3e004348ba0"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery-migrate.min.js"></script>
<!-- IMPORTANT! Load jquery-ui.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
<script type="text/javascript" src="${rsa}/global/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.blockui.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.cokie.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/uniform/jquery.uniform.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/bootstrap-wizard/jquery.bootstrap.wizard.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/icheck/icheck.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/dateFormat.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.form.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/others/jquery.json-2.4.js"></script>
<!-- END CORE PLUGINS -->

<!-- BEGIN PLUGINS SCRIPTS -->
<!-- 此处必须引入select2.full.min.js,否则自定义表单的新增页面里下拉框无法显示 -->
<script type="text/javascript" src="${rsa}/global/plugins/select2/js/select2.full.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/select2/js/i18n/zh-CN.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/dataTables-1.10.12/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/dataTables-1.10.12/media/js/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/dataTables-1.10.12/media/js/chinese-string.js"></script>

<script type="text/javascript"
	src="${rsa}/global/plugins/dataTables-1.10.12/extensions/ColReorder/js/dataTables.colReorder.min.js"></script>
<script type="text/javascript"
	src="${rsa}/global/plugins/dataTables-1.10.12/extensions/Scroller/js/dataTables.scroller.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/zTree_v3/js/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/zTree_v3/js/jquery.ztree.exhide.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/layer-v3.0.1/layer/layer.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/laydate-v1.1/laydate/laydate.js"></script>

<script type="text/javascript" src="${rsa}/global/plugins/jquery-validation/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/jquery-validation/js/additional-methods.min.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/jquery-validation/js/localization/messages_zh.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/validate.rule.js"></script>
<!-- END PLUGINS SCRIPTS -->

<!-- BEGIN THETE SCRIPTS -->
<script type="text/javascript" src="${rsa}/global/scripts/metronic.js"></script>
<script type="text/javascript" src="${rsa}/admin/layout/scripts/layout.js"></script>
<script type="text/javascript" src="${rsa}/admin/layout/scripts/demo.js"></script>
<!-- END THETE SCRIPTS -->

<!-- 自定义公用JS写这里 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/base.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/cclUpload/cclUpload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/cclSelect/cclSelect.js"></script>

<!-- 自定义表单datagrid -->
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/window.js"></script>

<%--表格客户端中文按首字母排序需要用到，勿删除--%>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/util/pinyin.js"></script>

<script type="text/javascript" src="${rsa}/global/plugins/export/jquery.dataTable.export.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/echarts-3.2.2/echarts.min.js"></script>
<script src="${rsa}/global/plugins/others/jquery.sliderBar.js"></script>
<script type="text/javascript" src="${rsa}/global/plugins/echarts-3.2.2/china.js"></script>
<script>
	var CONTEXT_PATH = '${pageContext.request.contextPath}';
	var RESOURCE_PATH = '${rsa}';

	var ctx = CONTEXT_PATH;
	var rsa = RESOURCE_PATH;

	// 设置dataTable默认语言(中文)
	$.extend($.fn.dataTable.defaults, {
		dom : '<"ttop"i<"columnToggler">><"tdiv"t>r<"tfoot"lp<"push">>',
		lengthMenu : [ [ 5, 10, 20, 30, 50, 100], [ 5, 10, 20, 30, 50, 100 ] ],// change per page values here
		language : {
			url : CONTEXT_PATH + '/app/js/common/dataTables/dataTables.chinese.json'
		}
	});
	$.fn.dataTable.ext.errMode = function(s, h, m) {
		log(m);
		$.alert('数据列表加载出错！');
	}
	// 设置layer使用的皮肤
	layer.config({
		skin : 'layer-ext-moon',
		extend : 'moon/style.css'
	});
	$.fn.select2.defaults.set("theme", "bootstrap");
</script>