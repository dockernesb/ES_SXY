package com.udatech.common.model;

/**
 * 自然人审核企业表
 *
 * @author 创建人：何斐
 * @version 创建时间：2016年5月17日上午9:25:14
 * @Description
 */
public class PeopleExamine implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private String id;// 主键
    private String xm; // 姓名
    private String sfzh;// 身份证号
    private PCreditExamine pCreditExamine;// 自然人信用审查申请表
    private String bjbh;// 办件编号

    private String sywyCount;// 商业违约信息
    private String grcfCount;// 个人处罚信息
    private String grzxCount;// 个人执行信息

    public PeopleExamine() {
        super();
    }

    public PeopleExamine(String id, String xm, String sfzh, PCreditExamine PCreditExamine, String bjbh) {
        super();
        this.id = id;
        this.xm = xm;
        this.sfzh = sfzh;
        this.pCreditExamine = PCreditExamine;
        this.bjbh = bjbh;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public PCreditExamine getpCreditExamine() {
        return pCreditExamine;
    }

    public void setpCreditExamine(PCreditExamine pCreditExamine) {
        this.pCreditExamine = pCreditExamine;
    }

    public String getBjbh() {
        return bjbh;
    }

    public void setBjbh(String bjbh) {
        this.bjbh = bjbh;
    }

    public String getSywyCount() {
        return sywyCount;
    }

    public void setSywyCount(String sywyCount) {
        this.sywyCount = sywyCount;
    }

    public String getGrcfCount() {
        return grcfCount;
    }

    public void setGrcfCount(String grcfCount) {
        this.grcfCount = grcfCount;
    }

    public String getGrzxCount() {
        return grzxCount;
    }

    public void setGrzxCount(String grzxCount) {
        this.grzxCount = grzxCount;
    }

    public String getXm() {
        return xm;
    }

    public void setXm(String xm) {
        this.xm = xm;
    }

    public String getSfzh() {
        return sfzh;
    }

    public void setSfzh(String sfzh) {
        this.sfzh = sfzh;
    }
}
