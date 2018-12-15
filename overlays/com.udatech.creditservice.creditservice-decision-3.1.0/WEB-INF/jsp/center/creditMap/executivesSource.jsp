<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditMap/creditMap.css" />
  
<title>高管来源分析</title>
<style>
.over {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	background-color: #f5f5f5;
	opacity: 0.5;
	z-index: 1000;
}

.layout {
	display: none;
	position: absolute;
	top: 40%;
	left: 40%;
	width: 20%;
	height: 20%;
	z-index: 1001;
	text-align: center;
}

.page-content-max {
    margin-left: 0px !important;
    margin-top: 0px;
    min-height: 600px;
    padding: 0px !important;
}
.sldMod {
    height: 450px;
    overflow-y: auto;
}
.legendTile{left:5px;
top: 20px;
bottom: 600px;
width:350px;
border-radius:4px; 
position: absolute;
background:rgb(64,74,89);
box-sizing:border-box;
padding:5px 10px;
font-weight:bold;
font-size:18px;
z-index:10;
color: rgb(255,255,255);
margin-left:20px;
opacity:1;}
.dowebokBG{opacity:1;}
.sldMod dl dd label{ display:inline; margin-right:7px;}
.sldMod dl.db dd label{ display:block;}
.ztree {
    padding: 0px;
}

</style>

</head>
<body>

<div id="over" class="over"></div>
<div id="layout" class="layout"><img src="${pageContext.request.contextPath}/app/images/loading-0.gif" alt="" /></div>
	<div class="portlet box" style="position:relative;overflow:hidden">
	    <div id="mapContainer" style="height:640px"></div>
	    
	    <div class="sliderbar-container" id="dowebok">
	        <div class="title arrR"></div>
	        <div class="body">
                <div class="sldMod" height="450">
                	<dl>
                		<dt>高管类型</dt>
                		<dd>
                			<label for="GGFR"><input type="radio" name="GGLX" id="GGFR" value="0" checked onclick="executivesSource.setPosDiv(1)"/>法定代表人</label>
                			<label for="GGDS"><input type="radio" name="GGLX" id="GGDS" value="1" onclick="executivesSource.setPosDiv(2)"/>董事监事高管</label>
                		</dd>
                	</dl>
                	<dl id="postDiv" style="display:none">
                		<dt>职务</dt>
                		<dd>
                		    <label for="POSTAll"><input type="checkbox" id="POSTAll"  name="selectAll" value="0" onclick="executivesSource.selectAll(this,'post')"/>全选</label>
                			<label for="DONGSHI"><input type="checkbox" name="post" id="DONGSHI" value="0" />董事</label>
                			<label for="JIANSHI"><input type="checkbox" name="post" id="JIANSHI" value="1" />监事</label>
                		</dd>
                	</dl>
                	<dl>
                		<dt>性别</dt>
                		
                		<dd>
                		    <label for="SEXAll"><input type="checkbox" id="SEXAll"  name="selectAll" value="0" onclick="executivesSource.selectAll(this,'sex')"/>全选</label>
                			<label for="MAN"><input type="checkbox" name="sex" id="MAN" value="0"/>男</label>
                			<label for="WOMEN"><input type="checkbox" name="sex" id="WOMEN" value="1" />女</label>
                		</dd>
                	</dl>
                	<dl>
                		<dt>年龄分布</dt>
                		<dd>
                		    <label for="NLFBAll"><input type="checkbox" id="NLFBAll"  name="selectAll" value="0" onclick="executivesSource.selectAll(this,'age')"/>全选</label>
                			<label for="NLFBA"><input type="checkbox" name="age" id="NLFBA" value="5" />50后</label>
                			<label for="NLFBB"><input type="checkbox" name="age" id="NLFBB" value="6" />60后</label>
                			<label for="NLFBC"><input type="checkbox" name="age" id="NLFBC" value="7" />70后</label>
                			<label for="NLFBD"><input type="checkbox" name="age" id="NLFBD" value="8" />80后</label>
                			<label for="NLFBE"><input type="checkbox" name="age" id="NLFBE" value="9" />90后</label>
                			<label for="NLFBF"><input type="checkbox" name="age" id="NLFBF" value="99" />其他</label>
                		</dd>
                	</dl>
                	<dl>
                		<dt>行业类型</dt>
                		<dd>
                			<div id="industryTree" class="ztree" >
                			</div>
                		</dd>
                	</dl>
                	<dl class="db">
                		<dt>注册规模</dt>
                		<dd>
                			<label for="ZHUCEAll"><input type="checkbox" id="ZHUCEAll"  name="selectAll" value="0" onclick="executivesSource.selectAll(this,'scale')"/>全选</label>
                			<label for="ZHUCEA"><input type="checkbox" name="scale" id="ZHUCEA" value="ZHUCEA" />10万以下</label>
                			<label for="ZHUCEB"><input type="checkbox" name="scale" id="ZHUCEB" value="ZHUCEB" />10万-100万</label>
                			<label for="ZHUCEC"><input type="checkbox" name="scale" id="ZHUCEC" value="ZHUCEC" />100万-500万</label>
                			<label for="ZHUCED"><input type="checkbox" name="scale" id="ZHUCED" value="ZHUCED" />500万-1000万</label>
                			<label for="ZHUCEE"><input type="checkbox" name="scale" id="ZHUCEE" value="ZHUCEE" />1000万-5000万</label>
                			<label for="ZHUCEF"><input type="checkbox" name="scale" id="ZHUCEF" value="ZHUCEF" />5000万以上</label>
                		</dd>
                	</dl>
                	<dl class="db">
                		<dt>主体年份</dt>
                		<dd>
                		    <label for="NFAll"><input type="checkbox" id="NFAll"   name="selectAll"  value="0" onclick="executivesSource.selectAll(this,'year')"/>全选</label>
                			<label for="NFA"><input type="checkbox" name="year" id="NFA" value="NFA" />不足1年</label>
                			<label for="NFB"><input type="checkbox" name="year" id="NFB" value="NFB" />1-5年</label>
                			<label for="NFC"><input type="checkbox" name="year" id="NFC" value="NFC" />5-10年</label>
                			<label for="NFD"><input type="checkbox" name="year" id="NFD" value="NFD" />10年以上</label>
                		</dd>
                	</dl>
                	

                </div>    
                
	        </div>
	        <div class="searchBtn">
	        	<button type="button" class="btn btn-xs gray-meadow" onclick="executivesSource.selectAllCon();" style="float:left">全选
			    </button>
                <button type="button" class="btn btn-xs green-meadow" onclick="executivesSource.conditionSearch(1);">确认
			    </button>
			    <button type="button" class="btn btn-xs blue-dark" onclick="executivesSource.conditionReset();">重置
			    </button>     
            </div>
	    </div>
	    <div class="dowebokBG" id="dowebokBG">
	    
    </div>
<div id="legendTile" style="display:none" class="legendTile"> </div>
				
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditMap/executivesSource.js"></script>
</body>
</html>

	