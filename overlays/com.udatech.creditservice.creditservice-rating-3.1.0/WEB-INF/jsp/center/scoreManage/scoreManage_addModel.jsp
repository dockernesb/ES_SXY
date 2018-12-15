<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建模型</title>
<style type="text/css">
th {
	text-align: center;
	vertical-align: middle !important;
	background-color: #F5F5F5;
}

td {
	vertical-align: middle !important;
}

.divCenter {
    height: 37px;
	line-height: 37px; 
	padding-left: 10px !important;
	padding-right: 10px !important; 
	float: left;
}

.nav>li>a:focus, .nav>li>a:hover {
    text-decoration: none;
    background-color: transparent;
    border-color: transparent;
    color: #5B9BD1;
}
</style>
</head>
<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/common/commonInit.js"></script>
<body>
	<div class="row">
		<div class="col-md-12">
			<!--  添加用tr  -->
			<div style="display: none;">
				<table class="table table-bordered">
					<tbody id="trForAdd">
						<!-- 企业概况 经营时间-->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qyxx_jysjqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_jysjqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">年</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_jysjqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 企业概况 公司规模 -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qyxx_gsgmqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gsgmqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">个</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gsgmqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 企业概况 固定资产额 -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qyxx_gdzceqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gdzceqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gdzceqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 企业概况 注册资金 -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qyxx_zczjqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_zczjqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_zczjqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 企业概况 社保缴纳额 -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qyxx_sbjneqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_sbjneqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_sbjneqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 企业概况 企业纳税额 -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qyxx_qynseqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_qynseqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_qynseqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 表彰荣誉 -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="bzryqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="bzryqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">条</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="bzryqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 欠税欠费 欠费信息  -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qsqf_qfxxqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qfxxqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qfxxqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 欠税欠费 欠税信息  -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qsqf_qsxxqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qsxxqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qsxxqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
						<!-- 欠税欠费 社保欠缴额  -->
						<tr>
							<td class="control-label col-md-12" >
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="digits" maxlength="10" required name="qsqf_sbqjeqjF" class="form-control input-md col-md-2" /></div>
								</div>
								<div style="width: 80px;text-align: center;" class="divCenter">~</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_sbqjeqjE" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">万元</div>
								<div class="col-md-2 divCenter">
									<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_sbqjeqjfs" class="form-control input-md" /></div>
								</div>
								<div style="width: 80px;" class="divCenter">分</div> 
								<button class="btn btn-sm red" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.delRow(this);"> 删除</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="portlet box red-intense">
				<div class="portlet-title">
					<div class="caption">
						<i class="fa fa-file-text-o"></i>
						新建模型
					</div>
					<div class="tools">
						<a href="javascript:;" class="collapse"> </a>
					</div>
					<div class="actions">
						<button type="button" class="btn btn-default" onclick="addModel.goBackList();">返回</button>
					</div>
				</div>
				<div class="portlet-body tabbable-line">
					<ul id="myTab" class="nav nav-tabs ">
						<li class="active">
							<a href="javascript:void(0);"> 1 创建评分模型 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 2 分数配置 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 3 企业概况 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 4 失信信息 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 5 表彰荣誉 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 6 知识产权 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 7 企业资质 </a>
						</li>
						<li>
							<a href="javascript:void(0);"> 8 欠税欠费 </a>
						</li> 
					</ul>
					<form id="addModelForm"  method="post">
						<div class="tab-content">
							<div class="tab-pane fade active in" id="tab_1">
								<h3 align="center" class="block">评分模型总分：1000&nbsp;&nbsp;（基础分：600&nbsp;分&nbsp;&nbsp;配置分：400&nbsp;分）</h3>
								<p>&nbsp;&nbsp;基础分为基础信用分，配置分为信用中心自行设置，由企业概况、失信信息、表彰荣誉、知识产权、企业资质和欠税欠费6个指标构成。</p>
								<table class="table table-bordered">
									<tr>
										<th class="control-label col-md-3"><span class="required"> * </span> 模型名称</th>
										<td align="left" class="control-label col-md-9">
											<div class="input-icon right">
												<i class="fa"></i>
												<input class="form-control" id="cjpfmx_mxmc" name="cjpfmx_mxmc" />
											</div></td>
									</tr>
									<tr>
										<th class="control-label col-md-3"><span class="required"> * </span> 模型描述</th>
										<td align="left" class="control-label col-md-9">
											<div class="input-icon right">
												<i class="fa"></i>
												<textarea id="cjpfmx_mxms" name="cjpfmx_mxms" style="resize: none;" class="form-control" maxlength="250" rows="5"></textarea>
											</div></td>
									</tr>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('cjpfmx');">
										下一步
										<i class="m-icon-swapright m-icon-white"></i>
									</a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_2">
								<h3 align="center" class="block">可配置总分：400&nbsp;分</h3>
								<p style="color: red;">&nbsp;&nbsp;提示：分数必须是整数，总分等于400分。</p>
								<table class="table table-striped table-bordered">
									<tr>
										<td class="control-label col-md-2 bold"> 企业概况</td>
										<td class="control-label col-md-3">
											
											<div class="input-icon right">
												<i class="fa"></i>
												<input type="greaterThanZero" maxlength="10" required id="fspz_qygk" name="fspz_qygk" class="form-control" />
												</div>
										</td>
										<td class="control-label" width="1%">分</td>
										<td class="control-label">企业经营时间、经营规模、固定资产额、注册资金、社保缴纳额、纳税额等相关信息。</td>
									</tr>
									<tr>
										<td class="bold"> 失信信息</td>
										<td>
											<div class="input-icon right">
												<i class="fa"></i>
												<input type="greaterThanZero" maxlength="10" required id="fspz_sxxx" name="fspz_sxxx" class="form-control"/>
											</div></td>
										<td>分</td>
										<td>企业费用解缴、行政处罚、法人代表失信、履行约定相关失信信息。</td>
									</tr>
									<tr>
										<td class="bold"> 表彰荣誉</td>
										<td>
											<div class="input-icon right">
												<i class="fa"></i>
												<input type="greaterThanZero" maxlength="10" required id="fspz_bzry" name="fspz_bzry" class="form-control"/></div></td>
										<td>分</td>
										<td>企业获得的相关表彰和荣誉信息。</td>
									</tr>
									<tr>
										<td class="bold"> 知识产权</td>
										<td>
											<div class="input-icon right">
												<i class="fa"></i>
												<input type="greaterThanZero" maxlength="10" required id="fspz_zscq" name="fspz_zscq" class="form-control"/></div></td>
										<td>分</td>
										<td>企业获得的商标、实用新型、发明、著作权、软件著作权等。</td>
									</tr>
									<tr>
										<td class="bold"> 企业资质</td>
										<td>
											<div class="input-icon right">
												<i class="fa"></i>
												<input type="greaterThanZero" maxlength="10" required id="fspz_qyzz" name="fspz_qyzz" class="form-control"/></div></td>
										<td>分</td>
										<td>企业获得相关部门、行业、协会的资质认定。</td>
									</tr>
									<tr>
										<td class="bold"> 欠税欠费</td>
										<td>
											<div class="input-icon right">
												<i class="fa"></i>
												<input type="greaterThanZero" maxlength="10" required id="fspz_qsqf" name="fspz_qsqf" class="form-control"/></div></td>
										<td>分</td>
										<td>企业总体欠费信息、欠税信息、社保欠缴额三类欠缴信息。</td>
									</tr>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('fspz');">下一步 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_3">
								<h3 align="center" class="block">企业概况总分: &nbsp;<span id="qygk_zf">0</span>&nbsp;&nbsp;分</h3>
								<p>&nbsp;&nbsp;企业概况包含企业经营时间、经营规模、固定资产额、注册资金、社保缴纳额、纳税额等相关信息。</p>
								<table class="table table-bordered">
									<!-- 经营时间  -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>经营时间</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qyxx_jysjzf" name="qyxx_jysjzf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green;">经营时间指企业存在的存续有效时间。</span>
														</div>
													</th>
												</tr>
												<tbody id="jysj">
													<tr>
														<td class="control-label col-md-12" >
															<div class="col-md-2 divCenter">
																<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_jysjqjM" class="form-control input-md col-md-2" /></div>
															</div>
															<div style="width: 80px;" class="divCenter">年以上</div>
															<div class="col-md-2 divCenter">
															</div>
															<div style="width: 80px;" class="divCenter"></div>
															<div class="col-md-2 divCenter">
																<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_jysjqjfs" class="form-control input-md" /></div>
															</div>
															<div style="width: 80px;" class="divCenter">分</div> 
															<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('jysj', '0');"> 添加</button>
														</td>
													</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 公司规模  -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>公司规模</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qyxx_gsgmzf" name="qyxx_gsgmzf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green;">本模块的公司规模是指该企业的子公司/分公司/机构数量。</span>
														</div>
													</th>
												</tr>
												<tbody id="gsgm">
												<tr>
													<td class="control-label col-md-12" >
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gsgmqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">个以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gsgmqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('gsgm', '1');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 固定资产额  -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>固定资产额</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qyxx_gdzcezf" name="qyxx_gdzcezf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green;">固定资产总额是指固定资产在整个预计使用年限内总共应计提和折旧总额，是固定资产原值。</span>
														</div>
													</th>
												</tr>
												<tbody id="gdzce">
													<tr>
														<td class="control-label col-md-12" >
															<div class="col-md-2 divCenter">
																<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gdzceqjM" class="form-control input-md col-md-2" /></div>
															</div>
															<div style="width: 80px;" class="divCenter">万元以上</div>
															<div class="col-md-2 divCenter">
															</div>
															<div style="width: 80px;" class="divCenter"></div>
															<div class="col-md-2 divCenter">
																<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_gdzceqjfs" class="form-control input-md" /></div>
															</div>
															<div style="width: 80px;" class="divCenter">分</div> 
															<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('gdzce', '2');"> 添加</button>
														</td>
													</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 注册资金 -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>注册资金</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qyxx_zczjzf" name="qyxx_zczjzf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green;">注册资金是企业实有资产的总和，以营业执照为标准。</span>
														</div>
													</th>
												</tr>
												<tbody id="zczj">
												<tr>
													<td class="control-label col-md-12" >
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_zczjqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">万元以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_zczjqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('zczj', '3');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 社保缴纳额 -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>社保缴纳额</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qyxx_sbjnezf" name="qyxx_sbjnezf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green;">社保缴纳额是指企业社保缴纳总额。</span>
														</div>
													</th>
												</tr>
												<tbody id="sbjne">
												<tr>
													<td class="control-label col-md-12" >
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_sbjneqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">万元以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_sbjneqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('sbjne', '4');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 企业纳税额 -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>企业纳税额</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qyxx_qynsezf" name="qyxx_qynsezf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: green;">企业纳税额是指企业纳税总额。</span>
														</div>
													</th>
												</tr>
												<tbody id="qynse">
												<tr>
													<td class="control-label col-md-12" >
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_qynseqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">万元以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qyxx_qynseqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('qynse', '5');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('qygk');">下一步 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_4">
								<h3 align="center" class="block">失信信息总分： &nbsp; <span class="blue font24" id="sxxx_zf">0</span> &nbsp;&nbsp;分</h3>
								<p>&nbsp;&nbsp;失信信息包含企业费用解缴、行政处罚、法人代表失信、履行约定相关失信信息，该组信息以扣分展示，按条及失信程度计分。</p>
								<table class="table table-striped table-bordered" style="max-width: 1000px;">
									<tr>
										<td class="control-label col-md-4 bold"> 一般失信</td>
										<td class="control-label col-md-3"> 每条扣除</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="sxxx_ybsxfs" name="sxxx_ybsxfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
									<tr>
										<td class="control-label col-md-4 bold"> 较重失信</td>
										<td class="control-label col-md-3"> 每条扣除</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="sxxx_jzsxfs" name="sxxx_jzsxfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
									<tr>
										<td class="control-label col-md-4 bold"> 严重失信</td>
										<td class="control-label col-md-3"> 每条扣除</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="sxxx_yzsxfs" name="sxxx_yzsxfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('sxxx');">下一步 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_5">
								<h3 align="center" class="block">表彰荣誉总分: &nbsp;<span id="bzry_zf">0</span>&nbsp;&nbsp;分</h3>
								<p>&nbsp;&nbsp;表彰荣誉是指企业获得的相关表彰和荣誉信息，按条计分。</p>
								<table class="table table-bordered">
									<!-- 表彰荣誉  -->
									<tbody id="bzry">
										<tr>
											<td>
												<table class="table table-bordered">
													<tr>
														<td class="control-label col-md-12">
															<div class="col-md-2 divCenter">
																<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="bzryqjM" class="form-control input-md col-md-2" /></div>
															</div>
															<div style="width: 80px;" class="divCenter">条以上</div>
															<div class="col-md-2 divCenter">
															</div>
															<div style="width: 80px;" class="divCenter"></div>
															<div class="col-md-2 divCenter">
																<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="bzryqjfs" class="form-control input-md" /></div>
															</div>
															<div style="width: 80px;" class="divCenter">分</div> 
															<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('bzry', '6');"> 添加</button>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('bzry');">下一步 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_6">
								<h3 align="center" class="block">知识产权总分: &nbsp;<span id="zscq_zf">0</span>&nbsp;&nbsp;分</h3>
								<p>&nbsp;&nbsp;知识产权指标是指企业获得的商标、实用新型、发明、著作权、软件著作权等，该模块按条计分。</p>
								<table class="table table-striped table-bordered" style="max-width: 1000px;">
									<tr>
										<td class="control-label col-md-4 bold"> 外观专利</td>
										<td class="control-label col-md-3"> 每条</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="zscq_wgzlfs" name="zscq_wgzlfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
									<tr>
										<td class="control-label col-md-4 bold"> 实用新型</td>
										<td class="control-label col-md-3"> 每条</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="zscq_syxxfs" name="zscq_syxxfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
									<tr>
										<td class="control-label col-md-4 bold"> 发明专利</td>
										<td class="control-label col-md-3"> 每条</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="zscq_fmzlfs" name="zscq_fmzlfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
									<tr>
										<td class="control-label col-md-4 bold"> 著作权</td>
										<td class="control-label col-md-3"> 每条</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="zscq_zzqfs" name="zscq_zzqfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
									<tr>
										<td class="control-label col-md-4 bold"> 软件著作权</td>
										<td class="control-label col-md-3"> 每条</td>
										<td class="control-label col-md-3">
											<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="zscq_rjzzqfs" name="zscq_rjzzqfs" class="form-control" /></div>
										</td>
										<td class="control-label col-md-2" >分</td>
									</tr>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('bzry');">下一步 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_7">
								<h3 align="center" class="block">企业资质总分: &nbsp;<span id="qyzz_zf">0</span>&nbsp;&nbsp;分</h3>
								<p>&nbsp;&nbsp;企业资质是指企业获得相关部门、行业、协会的资质认定，该模块为信用中心自行配置详细指标项，按证书含金量计分。</p>
								<div class="row">
									<div class="control-label col-md-7">
										<table class="table table-striped table-bordered" id="appGrid">
											<thead>
												<tr class="heading">
													<th width="50%">资质名称</th>
													<th width="40%">颁发部门</th>
													<th width="10%">操作</th>
												</tr>
											</thead>
										</table>
									</div>
									<div class="control-label col-md-5">
										<table class="table table-striped table-bordered" id="qyzz_qj" style="margin-top: 40px;">
											<tr class="heading">
												<th width="60%">资质名称</th>
												<th width="25%">分数</th>
												<th width="15%">操作</th>
											</tr>
										</table>
									</div>
								</div>
								<div align="center" style="padding-top: 30px;">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn blue button-next" onclick="addModel.goNext('qyzz');">下一步 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
							<div class="tab-pane fade" id="tab_8">
								<h3 align="center" class="block">欠税欠费总分: &nbsp;<span id="qsqf_zf">0</span>&nbsp;&nbsp;分</h3>
								<p>&nbsp;&nbsp;欠税欠费是根据企业总的欠费信息、欠税信息、社保欠缴额的具体情况来制定。</p>
								<table class="table table-bordered">
									<!-- 欠费信息  -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>欠费信息</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qsqf_qfxxzf" name="qsqf_qfxxzf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分
														</div>
													</th>
												</tr>
												<tbody id="qfxx">
												<tr>
													<td class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qfxxqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">万元以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qfxxqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('qfxx', '7');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 欠税信息  -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>欠税信息</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qsqf_qsxxzf" name="qsqf_qsxxzf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分
														</div>
													</th>
												</tr>
												<tbody id="qsxx">
												<tr>
													<td class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qsxxqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">万元以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_qsxxqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('qsxx', '8');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
									<!-- 社保欠缴额  -->
									<tr>
										<td>
											<table class="table table-bordered">
												<tr>
													<th class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<h4>社保欠缴额</h4> 
														</div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required id="qsqf_sbqjezf" name="qsqf_sbqjezf" class="form-control input-md "/></div>
														</div>
														<div class="divCenter">
															分
														</div>
													</th>
												</tr>
												<tbody id="sbqje">
												<tr>
													<td class="control-label col-md-12">
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_sbqjeqjM" class="form-control input-md col-md-2" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">万元以上</div>
														<div class="col-md-2 divCenter">
														</div>
														<div style="width: 80px;" class="divCenter"></div>
														<div class="col-md-2 divCenter">
															<div class="input-icon right"><i class="fa"></i><input type="greaterThanZero" maxlength="10" required name="qsqf_sbqjeqjfs" class="form-control input-md" /></div>
														</div>
														<div style="width: 80px;" class="divCenter">分</div> 
														<button class="btn btn-sm yellow" style="margin-top: 3px;margin-right: 10px;float: right;" onclick="addModel.addRow('sbqje', '9');"> 添加</button>
													</td>
												</tr>
												</tbody>
											</table>
										</td>
									</tr>
								</table>
								<div align="center">
									<a href="javascript:;" class="btn default button-previous" onclick="addModel.goBack();"><i class="m-icon-swapleft"></i> 上一步</a> 
									<a href="javascript:;" class="btn green button-submit" onclick="addModel.saveModel();"> 提交 <i class="m-icon-swapright m-icon-white"></i></a>
								</div>
							</div>
						</div>
						<div class="clearfix margin-bottom-20"></div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="${pageContext.request.contextPath}/app/js/center/scoreManage/scoreManage_addModel.js"></script>
</html>