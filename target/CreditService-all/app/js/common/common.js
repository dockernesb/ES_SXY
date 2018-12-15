var COMMON = function(){};
COMMON.getDicGroupSl2 = function (key,sel) {
	if(key != ""){
		var str= new Array();
		str=key.split(","); 
		  $.post(ctx+"/system/dictionary/dictionaryGroup.action?key="+str[0], function(data){
	          var _xdata = new Array();
	          var obj = jQuery.parseJSON(data);
	          $.each(obj, function(i, item) {
	              var d = new Object();
	              d.id = item.dictKey;
	              d.text = item.dictValue;
	              _xdata.push(d);
	          });
	          $("#"+sel).select2({
	              data : _xdata,
	              placeholder : '请选择',
	              width:'100%',
	              allowClear:true
	          }).on("change", function() {
	        	  if($("#"+sel+"_TEXT").length > 0) {
	        		  if(typeof($('#'+sel).select2('data')[0]) !="undefined"){
	        			  $("#"+sel+"_TEXT").val($('#'+sel).select2('data')[0].text);
	        		  }
	        	  }
	          }).trigger("change");
	          
	          if ($("#"+sel).val() == "" && str.length > 1){
	        	  $("#"+sel).val(str[1]).trigger("change");
	        	  $("#"+sel+"_TEXT").val($('#'+sel).select2('data')[0].text);
	          }
	    	 });
	}
}

COMMON.getDicValue = function (key) {
	  $.post(ctx+"/system/dictionary/dictionaryValue.action?key="+key, function(data){
		  var obj = jQuery.parseJSON(data);
      return obj.dictValue;
  	 });
}
//datagrid client page
COMMON.pagerFilter=	function (data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}

COMMON.getRadio = function (dickey,id,name,showstyle) {
	 var html = '<div class="radio-list"><div class="input-icon right"><i class="fa"></i><div class="input-group"><div class="icheck-inline">';
	  $.post(ctx+"/system/dictionary/dictionaryGroup.action?key="+dickey, function(data){
        var _xdata = new Array();
        var disable = "";
        if(showstyle == "1") {
     	   disable = 'disabled';
        }
        var obj = jQuery.parseJSON(data);
        $.each(obj, function(i, item) {
        	if(item.dictKey==dataobj[id] || (($.type(dataobj[id])=="undefined" && i==0))) {
        		if($.type(dataobj[id])=="undefined") {
        			  $("#"+id+"_TEXT").val(item.dictValue);
        		}
        		if(showstyle == "1") {
        			
        		 	html +='<label><input type="radio" '+disable+'   class="icheck" checked radiotext="'+item.dictValue+'" id="'+id+item.dictKey+'" radioid="'+id+'" value="'+item.dictKey+'"/>'+item.dictValue+'</label>';
        		 	html +='<input type="hidden"  value="'+item.dictKey+'" name="'+name+'" />';
        		} else {
        		 	html +='<label><input type="radio" '+disable+' onclick="COMMON.clickit(this)" checked radiotext="'+item.dictValue+'" id="'+id+item.dictKey+'" radioid="'+id+'" value="'+item.dictKey+'" name="'+name+'" />'+item.dictValue+'</label>';
        		}
        	} else {
        		if(showstyle == "1") {
        		 	html +='<label><input type="radio" '+disable+'  class="icheck" onclick="COMMON.clickit(this)" id="'+id+item.dictKey+'" radiotext="'+item.dictValue+'" radioid="'+id+'" value="'+item.dictKey+'"/>'+item.dictValue+'</label>';
        		} else {
        		 	html +='<label><input type="radio" '+disable+'  class="icheck"  onclick="COMMON.clickit(this)" id="'+id+item.dictKey+'" radiotext="'+item.dictValue+'" radioid="'+id+'" value="'+item.dictKey+'" name="'+name+'" />'+item.dictValue+'</label>';
        		}
        	}
        });
        html += "</div></div></div></div>";
        $("#"+id).after(html);
        $("#"+id).remove();
    	// 初始化单选框
    	$('input[name="'+name+'"]').iCheck({
    		checkboxClass : 'icheckbox_square-blue',
    		radioClass : 'iradio_square-blue',
    		increaseArea : '20%'
    	});
  	 });
}

COMMON.clickit = function(obj) {
	 if($("#"+$(obj).attr("radioid")+"_TEXT").length > 0) {
		  $("#"+$(obj).attr("radioid")+"_TEXT").val($(obj).attr("radiotext"));
	  }
	 try{
		 radioclick(obj);
	 }catch(e) {
		 
	 }
}

COMMON.getCheckbox = function (dickey,id,name,showstyle) {
	 var html = '';
	 var editval ={};
	 var editkey ={};
		if($.type(dataobj[id+"_TEXT"]) != "undefined") {
			editval = dataobj[id+"_TEXT"].split(",");
		}
		if($.type(dataobj[id]) != "undefined") {
			editkey = dataobj[id].split(",");
		}
		
	
	  $.post(ctx+"/system/dictionary/dictionaryGroup.action?key="+dickey, function(data){
       var _xdata = new Array();
       var obj = jQuery.parseJSON(data);
       var disable = "";
       if(showstyle == "1") {
    	   disable = 'disabled';
       }
       $.each(obj, function(i, item) {
    	   var chkeck = "";
    	   if(jQuery.inArray(item.dictKey, editkey)!="-1") {
    		   chkeck = "checked";
    	   }
       	 	html +='<label><input type="checkbox" name="checkbox'+name+'"  class="icheck" '+disable+' onclick="COMMON.clickbox(this)" '+chkeck+'  id="'+item.dictKey+'" radioid="'+id+'" value="'+item.dictValue+'" />'+item.dictValue+'</label>';

       });
       $("#"+id).after(html);
       $("#"+id).hide();
       $('input[name="checkbox'+name+'"]').iCheck({
    	   labelHover : false,
			checkboxClass : 'icheckbox_square-blue',
			radioClass : 'iradio_square-blue',
			increaseArea : '20%'
   	   });
 	 });
}
COMMON.clickbox = function(obj) {
	
}

COMMON.getUmEdit = function(key,styleTyle){
	 $("#"+key).attr("style","height: 100px;") ;
	//实例化编辑器，设置显示的工具栏
	if(styleTyle !="1"){
		var um = UM.getEditor(key);
		
	}else{
		$opt={toolbar:[
	        ], readonly: true
		};
       var um = UM.getEditor(key,$opt);
	}
}