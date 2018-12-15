package com.udatech.common.enmu;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

public enum UploadFileEnmu {
	企业信用申请查询个人身份证("1"),
	企业信用审查申请附件("2"),
	企业信用审查审核附件("3"),
	企业信用审查审核上传附件("4"),
	//	联合监管
	监管专题标识("777"),
	监管措施附件("888"),
	执行监管附件("999"),
	//	信用承诺
	信用承诺附件("111"),
	// 异议申诉
	企业异议申诉申请申请表("4"),
	企业异议申诉申请经办人身份证("5"),
	企业异议申诉申请企业工商营业执照("6"),
	企业异议申诉申请企业授权书("7"),
	企业异议申诉申请组织机构代码证("8"),
	企业异议申诉申请证明材料("9"),
	// 异议修复
	企业信用修复申请申请表("20"),
	企业信用修复申请经办人身份证("21"),
	企业信用修复申请企业工商营业执照("22"),
	企业信用修复申请企业授权书("23"),
	企业信用修复申请组织机构代码证("24"),
	企业信用修复申请证明材料("25"),
	// 信用承诺、自主申报
	信用承诺("200"),
	信用承诺资料("201"),
	企业注册材料("300"),
	自主申报行政许可信息("pub_1"),
	自主申报许可资质年检结果信息("pub_2"),
	自主申报表彰荣誉("pub_3"),
	// 法人信用报告申请
	企业信用报告申请_工商营业执照("1"),
	企业信用报告申请_组织机构代码证("2"),
	企业信用报告申请_自查身份证图片("3"),
	企业信用报告申请_自查企业授权书("4"),
	企业信用报告申请_委托身份证图片("5"),
	企业信用报告申请_委托企业授权书("6"),
	企业信用报告申请_委托授权法人证明文件("7"),
	企业信用报告申请_省报告PDF文件("30"),// 设置为30是为了跟信用中心的旧数据值同步
	// 自然人信用报告申请
	自然人信用报告申请_本人身份证("1"),
	自然人信用报告申请_委托人身份证("2"),
	自然人信用报告申请_委托授权书("3"),
	//绩效考核
	部门绩效考核_附件("1"),
	中心绩效考核_附件("2");

	private static final Map<String, UploadFileEnmu> lookup = new HashMap<String, UploadFileEnmu>();

	static {
		for (UploadFileEnmu s : EnumSet.allOf(UploadFileEnmu.class))
			lookup.put(s.getKey(), s);
	}

	private UploadFileEnmu(String key) {
		this.key = key;
	}

	private String key;

	public String getKey() {
		return key;
	}

	public static UploadFileEnmu getByKey(String value) {
		return lookup.get(value);
	}

	public String key() {
		return key;
	}

}
