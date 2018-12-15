  var arrWin = new Array();
        
        function closeWin() {
            for (var index in arrWin) {
                arrWin[index].close();
            }
        }
    
        function reloadtree(tableid) {
        	$('#'+tableid).datagrid('reload');
        }
        
         function openPostWindow(url, name, dataobj, width ,height)  
              {  
        	 $("#tempForm").remove();
        	 openWindow(name, width ,height);
                  var tempForm = $("<form id='tempForm' method='post' target='"+name+"' action='"+url+"'></form>");  
                  for(var a in dataobj) {
                	   var hideInput = $("<input type='hidden' name='"+a+"'></input>");  
                       tempForm.append(hideInput);   
                       hideInput.val(dataobj[a]);
                  }
                  $("body").append(tempForm)
                  $("#tempForm").submit();
            }
        
         function openWindow(name, width ,height){ 
             //转向网页的地址
             //网页名称，可为空
             //弹出窗口的宽度
         	 var iWidth=748;
         	 var iHeight=563;
         	if (window.screen)
 		      {
 		          //获取屏幕的分辨率
 		           iHeight = screen.availHeight-30;
 		            iWidth = screen.availWidth-10;
 		      }
            
             //弹出窗口的高度
           
             if(typeof(width)!="undefined"&& $.trim(width)!=""){
             	iWidth = width;
             }
             if(typeof(height)!="undefined" && $.trim(height)!=""){
             	iHeight = height;
             }
             //获得窗口的垂直位置 
             var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
             //获得窗口的水平位置 
             var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
             arrWin[name] = window.open('about:blank', name, 'height=' + iHeight + ',innerHeight=' + iHeight + ',width=' + iWidth + ',innerWidth=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',status=no,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=1,titlebar=no');
         }
         
        
        function openWin(url, name, width ,height){
        	if(url == '_blank'){
        		url = 'about:blank';
        	} else {
        		var arr = url.split("?");
                if(arr.length>1) {
                	 url =url+"&tableid="+name;
                } else {
                	 url =url+"?tableid="+name;
                }
        	}
            //转向网页的地址
            //网页名称，可为空
            //弹出窗口的宽度
        	 var iWidth=748;
        	 var iHeight=563;
        	if (window.screen)
		      {
		          //获取屏幕的分辨率
		           iHeight = screen.availHeight-30;
		            iWidth = screen.availWidth-10;
		      }
           
            //弹出窗口的高度
          
            if(typeof(width)!="undefined"&& $.trim(width)!=""){
            	iWidth = width;
            }
            if(typeof(height)!="undefined" && $.trim(height)!=""){
            	iHeight = height;
            }
            //获得窗口的垂直位置 
            var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
            //获得窗口的水平位置 
            var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
            arrWin[name] = window.open(url, name, 'height=' + iHeight + ',innerHeight=' + iHeight + ',width=' + iWidth + ',innerWidth=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',status=no,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=1,titlebar=no');
        }
        
        $.fn.smartFloat = function() {
        	var position = function(element) {
        		var top = element.position().top, pos = element.css("position");
        		$(window).scroll(function() {
        			var scrolls = $(this).scrollTop();
        			if (scrolls > top) {
        				if (window.XMLHttpRequest) {
        					element.css({
        						position: "fixed",
        						top: 0
        					});	
        				} else {
        					element.css({
        						top: scrolls
        					});	
        				}
        			}else {
        				element.css({
        					position: pos,
        					top: top
        				});	
        			}
        		});
        };
        	return $(this).each(function() {
        		position($(this));						 
        	});
        };