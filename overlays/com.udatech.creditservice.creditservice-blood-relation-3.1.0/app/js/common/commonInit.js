$(function() {
	// 初始化IE 支持placeholder效果
	// Metronic.handleFixInputPlaceholderForIE();
	jQuery('span.phTips').remove();
	jQuery('input[placeholder]').placeholder();

	// 初始化查询条件中select2的对齐为题
	$('.select2-hidden-accessible.form-search').next('span').css('margin-bottom', '5px');
});

/*解决ie9下placeholder显示多个并且错乱问题*/
function resetIEPlaceholder(){
	jQuery('span.phTips').remove();
	jQuery('input[placeholder]').placeholder();
}