<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title>字典管理</title>
</head>
<body>
	<div class="row">
		<div class="col-md-12">
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-globe"></i>字典列表
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
					<div class="actions">
					    <shiro:hasPermission name="system.dictionary.add">
						<a href="javascript:void(0);" onclick="dict.addDictionary();" class="btn btn-default btn-sm">
							<i class="fa fa-plus"></i> 新增字典
						</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.dictionary.edit">
						<a href="javascript:void(0);" onclick="dict.editDictionary();" class="btn btn-default btn-sm">
							<i class="fa fa-edit"></i> 修改字典
						</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="system.dictionary.delete">
						<a href="javascript:void(0);" onclick="dict.deleteConfirm();" class="btn btn-default btn-sm">
							<i class="fa fa-minus"></i> 删除字典
						</a>
						</shiro:hasPermission>
					</div>
				</div>
				<div class="portlet-body">
					<div class="row">
						<div class="col-md-12">
							<form class="form-inline">
								<input id="condition" class="form-control input-md" style="width: 25%;" placeholder="字典组编码、字典组名称、描述" />
								&nbsp;
								<button type="button" class="btn btn-info btn-md" onclick="dict.conditionSearch(1);">
									<i class="fa fa-search"></i>查询
								</button>
								<button type="button" class="btn btn-default btn-md" onclick="dict.conditionReset();">
									<i class="fa fa-rotate-left"></i>重置
								</button>
							</form>
						</div>
					</div>
					<table class="table table-striped table-hover table-bordered" id="dictGrid">
						<thead>
							<tr class="heading">
								<th style="width: 30px"></th>
								<th width="20%">字典组编码</th>
								<th>字典组名称</th>
								<th width="50%">描述</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="winAdd" style="display: none; margin: 30px 40px">
		<form id="addDictionaryForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 字典组编码</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="groupKey" name="groupKey" />
							<input type="hidden" id="dictVal" name="dictVal">
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 字典组名称</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="groupName" name="groupName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">描述</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="description" name="description" rows="5"></textarea>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label" style="padding-top: 30px;"><span class="required">*</span> 字典键值对</label>
					<div class="col-sm-8">
						<table id="dic" style="max-width: 100%">
							<tr align="center">
								<td width="140px">字典编码</td>
								<td width="140px">字典值</td>
								<td width="30px"></td>
								<td width="30px"></td>
							</tr>
							<tr class="dicTd">
								<td style="padding: 5px 5px 0px 0px;"><div class="input-icon right">
										<i class="fa"></i>
										<input class="form-control key" name="key" style="width: 250px;" />
									</div></td>
								<td style="padding: 5px 5px 0px 0px;"><div class="input-icon right">
										<i class="fa"></i>
										<input class="form-control value" name="value" style="width: 250px;" />
									</div></td>
								<td style="padding: 5px 5px 0px 0px;"><input type="button" value="+" style="width: 30px;" onclick="dict.createTR();" /></td>
								<td style="padding: 5px 5px 0px 0px;"><input type="button" value="-" style="width: 30px;" class="delDic" /></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="winEdit" style="display: none; margin: 30px 40px;">
		<form id="editDictionaryForm" method="post" class="form-horizontal">
			<div class="form-body">
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 字典组编码</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="groupKey_edit" name="groupKey" />
							<input type="hidden" id="dictVal_edit" name="dictValEdit">
							<input type="hidden" id="id" name="id">
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label"><span class="required">*</span> 字典组名称</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<input class="form-control" id="groupName_edit" name="groupName" />
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label">描述</label>
					<div class="col-sm-8">
						<div class="input-icon right">
							<i class="fa"></i>
							<textarea class="form-control" id="description_edit" name="description" rows="5"></textarea>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label" style="padding-top: 30px;">字典键值对</label>
					<div class="col-sm-8">
						<table border="0px" cellspacing="5" id="dic_edit">
							<tr align="center">
								<td width="140px">字典编码</td>
								<td width="140px">字典值</td>
								<td width="30px"></td>
								<td width="30px"></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</form>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/sys/dictionary/dictionary_list.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
</body>
</html>