<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/app/css/creditMap/creditMap.css" />
<title>信用要素</title>
<style>

.page-content-max {
    margin-left: 0px !important;
    margin-top: 0px;
    min-height: 600px;
    padding: 0px !important;
}

.keyworkBox span.phTips {
	margin-left: 13px !important;
	margin-top: -29px;
}

#decideDateDL span.phTips {
	margin-left: 13px !important;
	margin-top: -42px;
}

.dateBoxSpan{position:relative;display:block;}

.dateBoxSpan span.phTips {
 	position:absolute;
 	top:35px;
} 
 
.keyworkBox{position: absolute; left: 50%; height: 30px; top: 20px; width: 336px; margin-left: -15%;}
.keyworkBox label{display: inline-block; float: left;}
.keyworkBox label input[type="text"]{padding: 0px 12px; height: 28px; width: 264px;border:1px solid #aaa;}
.keyworkBox a{ display: inline-block; float: left;border-radius: 4px; color: rgb(255, 255, 255); font-size: 14px; height: 28px; line-height: 28px; margin-left: 7px; padding: 0px 10px; text-decoration: none; background: rgb(84, 130, 191) none repeat scroll 0px 0px;}
@media screen and (min-width: 1347px) {
.keyworkBox{margin-left: -10%;}
}
</style>
</head>
<body>
	<div class="portlet box" style="position:relative;overflow:hidden">
	    <input type="hidden" id="centerCity" value="${centerCity}" />
	    <input type="hidden" id="cityCode" value="${cityCode}" />
	    <input type="hidden" id="countyCity" value="${countyCity}" />
	    
	    <div id="mapContainer"></div>
	    <div class="keyworkBox">
		   <label for="keyword">
				<input id="keyword" class="form-control"  name="keyword" placeholder="请输入主体名称或经营范围" type="text">
		   </label>
		   <a href="#" onclick="creditElements.keywordSearch()">
	                                   搜索
		   </a>
		</div>    
	    
	    <div id="tip">
	         <a class="tipA" href="#" onclick="creditElements.toggleDropcks()">
	                                   区域选择
			 </a>
			<div id="dropdowncks">
				<div  class="ztree" id="dropdowncksTree">
				</div>
				<div class="btnOK">
				   <a href='#' onclick="creditElements.toggleDropcks(1)">确认</a>
			    </div>
			</div>
			
	        <!-- <select id='district' style="width:190px" onchange='creditElements.search(this);'></select>  
			 -->					
	    </div>
	    <div class="btnDarkBox">	    	
			<a class="btnDark btnmap" onclick="creditElements.toHeatMap(this);" id="heatMap">热力图</a>
			<a class="btnDark btnmap btnDarkActive" onclick="creditElements.toMassMap(this)">散点图</a>
			<a class="btnDark" onclick='creditElements.toggleFullScreen();' title="放大"><img id="toBig" src="${pageContext.request.contextPath}/app/images/creditMap/btnToBig.png" alt="放大"/></a>
	    </div>	    
	   
	    <div class="sliderbar-container" id="dowebok">
	        <div class="title arrR"></div>
	        <div class="body">
	        	<div class="sldTit">信用要素</div>
	        	<div class="elementsIconBox">
	                <a onclick="creditElements.toggleElements(this, 1);">
				        <dl class="xzxk">
				        	<dt><i class="icon-book-open"></i></dt>
		                	<dd>
				        		<span>行政许可</span>
				        		<span class="elementsOpa"></span>
				        	</dd>
		                </dl>
	                </a>
	                <a onclick="creditElements.toggleElements(this, 2);">
				        <dl class="xzcf">
				        	<dt><i class="icon-energy"></i></dt>
				        	<dd>
				        		<span>行政处罚</span>
				        		<span class="elementsOpa"></span>
				        	</dd>
		                </dl>
	                </a>
	                <a onclick="creditElements.toggleElements(this, 3);">
				        <dl class="zzry">
				        	<dt><i class="icon-trophy"></i></dt>
				        	<dd>
				        		<span>资质荣誉</span>
				        		<span class="elementsOpa"></span>
				        	</dd>
		                </dl>
	                </a>
	                <a onclick="creditElements.toggleElements(this, 4);">
				        <dl class="qsxx">
				        	<dt><i class="fa fa-credit-card"></i></dt>
				        	<dd>
				        		<span>欠税信息</span>
				        		<span class="elementsOpa"></span>
				        	</dd>
		                </dl>
	                </a>
	                 <a onclick="creditElements.toggleElements(this, 5);">
				        <dl class="qfxx">
				        	<dt><i class="fa fa-money"></i></dt>
				        	<dd>
				        		<span>欠费信息</span>
				        		<span class="elementsOpa"></span>
				        	</dd>
		                </dl>
	                </a>
	                <a onclick="creditElements.toggleElements(this, 6);">
				        <dl class="cbqj">
				        	<dt><i class="fa fa-user"></i></dt>
				        	<dd>
				        		<span>参保欠缴</span>
				        		<span class="elementsOpa"></span>
				        	</dd>
		                </dl>
	                </a>
	                <div class="push"></div>
                </div>
                <div class="sldMod">
                    <dl id="decideDateDL" style="display:none">
                		<dt>许可决定日期</dt>
                		<dd>
                			<span class="dateBoxSpan">
								<input type="text" class="form-control input-md form-search date-icon" id="startDate" readonly="readonly" placeholder="开始时间" />
                			</span> 
							&nbsp;至&nbsp;
							<span class="dateBoxSpan">
								<input type="text" class="form-control input-md form-search date-icon" id="endDate" readonly="readonly" placeholder="截止日期"/>
							</span> 
							&nbsp;
                		</dd>
                	</dl>
                	<dl id="dataProvider" style="display:none">
                		<dt>数据提供部门</dt>
                		<dd>
                			<div id="dataProviderTree" class="ztree" style="margin: 10px;">
                			</div>
                		</dd>
                	</dl>
                	<dl>
                		<dt>企业类型</dt>
                		<dd>
                			<label for="QIYEAll"><input type="checkbox" id="QIYEAll"  name="selectAll" value="0" onclick="creditElements.selectAll(this,'type')"/>全选</label>
                			<label for="QIYEA"><input type="checkbox" name="type" id="QIYEA" value="QIYEA"/>内资非私营</label>
                			<label for="QIYEB"><input type="checkbox" name="type" id="QIYEB" value="QIYEB"/>内资私营</label>
                			<label for="QIYEC"><input type="checkbox" name="type" id="QIYEC" value="QIYEC"/>外商投资</label>
                			<label for="QIYED"><input type="checkbox" name="type" id="QIYED" value="QIYED"/>其他</label>
                		</dd>
                	</dl>
                	<dl>
                		<dt>注册规模</dt>
                		<dd>
                			<label for="ZHUCEAll"><input type="checkbox" id="ZHUCEAll"  name="selectAll" value="0" onclick="creditElements.selectAll(this,'scale')"/>全选</label>
                			<label for="ZHUCEA"><input type="checkbox" name="scale" id="ZHUCEA" value="ZHUCEA"/>10万以下</label>
                			<label for="ZHUCEB"><input type="checkbox" name="scale" id="ZHUCEB" value="ZHUCEB"/>10万-100万</label>
                			<label for="ZHUCEC"><input type="checkbox" name="scale" id="ZHUCEC" value="ZHUCEC"/>100万-500万</label>
                			<label for="ZHUCED"><input type="checkbox" name="scale" id="ZHUCED" value="ZHUCED"/>500万-1000万</label>
                			<label for="ZHUCEE"><input type="checkbox" name="scale" id="ZHUCEE" value="ZHUCEE"/>1000万-5000万</label>
                			<label for="ZHUCEF"><input type="checkbox" name="scale" id="ZHUCEF" value="ZHUCEF"/>5000万以上</label>
                		</dd>
                	</dl>
                	<dl>
                		<dt>主体年份</dt>
                		<dd>
                			<label for="NFAll"><input type="checkbox" id="NFAll"   name="selectAll"  value="0" onclick="creditElements.selectAll(this,'year')"/>全选</label>
                			<label for="NFA"><input type="checkbox" name="year" id="NFA" value="NFA"/>不足1年</label>
                			<label for="NFB"><input type="checkbox" name="year" id="NFB" value="NFB"/>1-5年</label>
                			<label for="NFC"><input type="checkbox" name="year" id="NFC" value="NFC"/>5-10年</label>
                			<label for="NFD"><input type="checkbox" name="year" id="NFD" value="NFD"/>10年以上</label>
                		</dd>
                	</dl>
                	<dl>
                		<dt>行业类型</dt>
                		<dd>
                			<label for="GBCY"><input type="radio" name="GUOBIAO" id="GBCY" value="GBCY" checked onclick="creditElements.setDomainIndustry(1)"/>国标产业</label>
                			<label for="GBHY"><input type="radio" name="GUOBIAO" id="GBHY" value="GBHY" onclick="creditElements.setDomainIndustry(2)"/>国标行业</label>
                			<div id="domainTree" style="margin: 10px">
                				<label for="QBAll"><input type="checkbox" id="QBAll" name="selectAll" value="0" onclick="creditElements.selectAll(this,'domainType')"/>全选</label>
                			    <label for="QB1"><input type="checkbox" name="domainType" id="QB1" value="QB1"/>第一产业</label>
                			    <label for="QB2"><input type="checkbox" name="domainType" id="QB2" value="QB2"/>第二产业</label>
                			    <label for="QB3"><input type="checkbox" name="domainType" id="QB3" value="QB3"/>第三产业</label>
                			</div>
                			<div id="industryTree" class="ztree" style="margin: 10px;display:none">
                			</div>
                		</dd>
                	</dl>
                </div>    
                
	        </div>
	        <div class="searchBtn">
	        	<button type="button" class="btn btn-xs gray-meadow" onclick="creditElements.selectAllCon();" style="float:left">全选
			    </button>
                <button type="button" class="btn btn-xs green-meadow" onclick="creditElements.conditionSearch(1);">确认
			    </button>
			    <button type="button" class="btn btn-xs blue-dark" onclick="creditElements.conditionReset();">重置
			    </button>     
            </div>
	    </div>
	    <div class="dowebokBG" id="dowebokBG">
	    
	    </div>
	    <div class="legendImg">
		    <img src="${pageContext.request.contextPath}/app/images/creditMap/yi.png" alt="第一产业" title="第一产业" width="20" height="24"/>
		    <img src="${pageContext.request.contextPath}/app/images/creditMap/er.png" alt="第二产业" title="第二产业" width="20" height="24"/>
		    <img src="${pageContext.request.contextPath}/app/images/creditMap/san.png" alt="第三产业" title="第三产业" width="20" height="24"/>
	    </div>
    </div>

   
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/creditMap/creditElements.js"></script>
</body>
</html>

	