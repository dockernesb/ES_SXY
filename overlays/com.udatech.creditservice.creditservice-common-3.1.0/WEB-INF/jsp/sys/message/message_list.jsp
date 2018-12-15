<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%    
    String path = request.getContextPath();    
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
    pageContext.setAttribute("basePath",basePath);    
%> 
<html>
<head><link href="<%=basePath %>app/images/favicon.ico" rel="shortcut icon" type="image/x-icon" media="screen" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/WEB-INF/jsp/common/common.jsp"></jsp:include>
    <script type="text/javascript" src="<%=basePath%>app/js/common/window.js"></script>
    <title>系统消息</title>
</head>
	<body class="overflowH bodyBGgray">
<div class="container">
			<div class="containBox">
				<div class="positionBox">
					<div class="floatL"> 系统消息</div>
					<div class="floatR">&nbsp;</div>
				</div>
				<div class="menuThrBox" id="containInBox">
					<div class="whiteBox">
						<div class="whiteBoxIn">
							<div class="searchBox">
								<table width="100%" border="0" cellspacing="10" cellpadding="0">
									<tr>
										<td align="left" nowrap width="1%">
											<button class="btn btn-warning btn-mini" onclick="conditionSearch(false);">未读消息</button>
										</td>
										<td align="left" nowrap width="1%">
											<button class="btn btn-info btn-mini" onclick="conditionSearch(true);">已读消息</button>
										</td>
										<td align="left" nowrap width="*">
											<button class="btn btn-success btn-mini" onclick="operMessage(1);">批量已读</button>
										</td>
										<!-- <td align="left" nowrap width="*">
											<button class="btn btn-danger btn-mini" onclick="operMessage(0);">批量删除</button>
										</td> -->
									</tr>
								</table>
							</div>
						    <table id="sysMessageTable" title="" class="easyui-datagrid" 
						            style=" width="100%"
						          data-options="rownumbers:true, pagination:true, 
						            singleSelect:false, collapsible:true, fitColumns:true, 
						            pageSize:10, url:'list.action', queryParams:{state:false},method:'post', 
						            iconCls:'icon-user', toolbar:'#tb'">
						        <thead>
						            <tr>
						            	<th field="ck" checkbox="true"></th>
						                <th field="state" width="5" formatter="enableFormat">状态</th>
						                <th field="title" width="50"  formatter="showDetail">标题</th>
						                <th field="sendName" width="10">发送者</th>
						                <th field="sendDate" width="20" align="left">时间</th>
						            </tr>
						        </thead>
						    </table>
						
						</div>
					</div>
				</div>
			</div>
		</div>

    
    <script type="text/javascript">
    function enableFormat(value, row, index){
        if (value){
            return "已读";
        } else {
            return "未读";
        }
    }
    function showDetail(value, row, index) {
    	if($.type(row.taskId) != "undefined") {
    		return "<a href='javascript:void(0);' onclick=handle('"+value+"','"+row.id+"','"+row.state+"','"+row.taskId+"',this)><font color=blue>"+value+"</font> </a>";
    	} else if(row.recordId != undefined ){
    		return "<a href='javascript:void(0);' onclick=handle1('"+value+"','"+row.id+"','"+row.recordId+"',this)><font color=blue>"+value+"</font> </a>";
    	} else {
    		return "<a href='<%=basePath%>/system/message/showDetail.action?id="+row.id+"'><font color=blue>"+value+"</font> </a>";
    	}
    }
    
    function handle(value, id, state, taskId, obj) {
    	if (state=="false"){
    		read(id);
    	}
    	openWin(CIP_PATH+"/workflow/processHandlePage/userTaskPage.action?taskId="+taskId,'showDetail');
    }
    
    function handle1(value, id, recordId,obj) {
    	read(id);
    	openWin(CIP_PATH+"/workflow/usertask/showProcess.action?processInstanceId="+recordId+"&&modulId=MyCopyWork",'showDetail');
    }
    
    function read(id) {
    	$.post("read.action",{id:id},function(data){
    		reloadtree();
		});
    }
    
    function conditionSearch(state) {
        var queryParams = $('#sysMessageTable').datagrid('options').queryParams;
        if(typeof(state)=="undefined") {
        	state = "";
        }
        queryParams["state"] = state;
        $('#sysMessageTable').datagrid('options').queryParams = queryParams;
        $('#sysMessageTable').datagrid('options').pageNumber = 1;
        $('#sysMessageTable').datagrid('getPager').pagination({pageNumber: 1});
        $("#sysMessageTable").datagrid('reload');
    }
    
    function reloadtree() {
    	$('#sysMessageTable').datagrid('reload');
    }
    
    function operMessage(type){
    	var rows = $("#sysMessageTable").datagrid("getChecked");
    	if(rows.length == 0){
    		$.messager.alert("提示","请选择消息！","info");
    		return;
    	}
    	var str = "";
		$.each(rows, function(index, item){
			if (!item.state){
				str += item.id+",";
			}
		}); 
    	if(1 == type){
    		$.post("<%=basePath%>/system/message/readAll.action",{ids:str.substring(0,str.length-1)},function(data){
				reloadtree();
			});
    	}else if(0 == type){
	    	$.messager.confirm("确认", "是否要删除消息？", function(r){
    			$.post("<%=basePath%>/system/message/deleteMessage.action",{ids:str.substring(0,str.length-1)},function(data){
    				reloadtree();
    			});
	    	});
    	}
    }
    </script>
</body>
</html>