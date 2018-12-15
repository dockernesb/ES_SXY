package com.udatech.dataInterchange.model;

import com.udatech.dataInterchange.util.JaxbDateAdapter;

import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import java.util.Date;

public class YwPGrheimingdanEntity {
    private String id;
    private String status;
    private String source;
    private Date createTime;
    private String createUser;
    private String bmmc;
    private String bmbm;
    private Date tgrq;
    private String xm;
    private String sfzh;
    private String zjlx;
    private String rwbh;
    private String bz;
    private String zysxss;
    private String xzcljdnr;
    private String rdwh;
    private String rddw;
    private Date rdrq;
    private Date gsjzq;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getBmmc() {
        return bmmc;
    }

    public void setBmmc(String bmmc) {
        this.bmmc = bmmc;
    }

    public String getBmbm() {
        return bmbm;
    }

    public void setBmbm(String bmbm) {
        this.bmbm = bmbm;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getTgrq() {
        return tgrq;
    }

    public void setTgrq(Date tgrq) {
        this.tgrq = tgrq;
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

    public String getZjlx() {
        return zjlx;
    }

    public void setZjlx(String zjlx) {
        this.zjlx = zjlx;
    }

    public String getRwbh() {
        return rwbh;
    }

    public void setRwbh(String rwbh) {
        this.rwbh = rwbh;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public String getZysxss() {
        return zysxss;
    }

    public void setZysxss(String zysxss) {
        this.zysxss = zysxss;
    }

    public String getXzcljdnr() {
        return xzcljdnr;
    }

    public void setXzcljdnr(String xzcljdnr) {
        this.xzcljdnr = xzcljdnr;
    }

    public String getRdwh() {
        return rdwh;
    }

    public void setRdwh(String rdwh) {
        this.rdwh = rdwh;
    }

    public String getRddw() {
        return rddw;
    }

    public void setRddw(String rddw) {
        this.rddw = rddw;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getRdrq() {
        return rdrq;
    }

    public void setRdrq(Date rdrq) {
        this.rdrq = rdrq;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getGsjzq() {
        return gsjzq;
    }

    public void setGsjzq(Date gsjzq) {
        this.gsjzq = gsjzq;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        YwPGrheimingdanEntity that = (YwPGrheimingdanEntity) o;

        if (id != null ? !id.equals(that.id) : that.id != null) return false;
        if (status != null ? !status.equals(that.status) : that.status != null) return false;
        if (source != null ? !source.equals(that.source) : that.source != null) return false;
        if (createTime != null ? !createTime.equals(that.createTime) : that.createTime != null) return false;
        if (createUser != null ? !createUser.equals(that.createUser) : that.createUser != null) return false;
        if (bmmc != null ? !bmmc.equals(that.bmmc) : that.bmmc != null) return false;
        if (bmbm != null ? !bmbm.equals(that.bmbm) : that.bmbm != null) return false;
        if (tgrq != null ? !tgrq.equals(that.tgrq) : that.tgrq != null) return false;
        if (xm != null ? !xm.equals(that.xm) : that.xm != null) return false;
        if (sfzh != null ? !sfzh.equals(that.sfzh) : that.sfzh != null) return false;
        if (zjlx != null ? !zjlx.equals(that.zjlx) : that.zjlx != null) return false;
        if (rwbh != null ? !rwbh.equals(that.rwbh) : that.rwbh != null) return false;
        if (bz != null ? !bz.equals(that.bz) : that.bz != null) return false;
        if (zysxss != null ? !zysxss.equals(that.zysxss) : that.zysxss != null) return false;
        if (xzcljdnr != null ? !xzcljdnr.equals(that.xzcljdnr) : that.xzcljdnr != null) return false;
        if (rdwh != null ? !rdwh.equals(that.rdwh) : that.rdwh != null) return false;
        if (rddw != null ? !rddw.equals(that.rddw) : that.rddw != null) return false;
        if (rdrq != null ? !rdrq.equals(that.rdrq) : that.rdrq != null) return false;
        if (gsjzq != null ? !gsjzq.equals(that.gsjzq) : that.gsjzq != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (status != null ? status.hashCode() : 0);
        result = 31 * result + (source != null ? source.hashCode() : 0);
        result = 31 * result + (createTime != null ? createTime.hashCode() : 0);
        result = 31 * result + (createUser != null ? createUser.hashCode() : 0);
        result = 31 * result + (bmmc != null ? bmmc.hashCode() : 0);
        result = 31 * result + (bmbm != null ? bmbm.hashCode() : 0);
        result = 31 * result + (tgrq != null ? tgrq.hashCode() : 0);
        result = 31 * result + (xm != null ? xm.hashCode() : 0);
        result = 31 * result + (sfzh != null ? sfzh.hashCode() : 0);
        result = 31 * result + (zjlx != null ? zjlx.hashCode() : 0);
        result = 31 * result + (rwbh != null ? rwbh.hashCode() : 0);
        result = 31 * result + (bz != null ? bz.hashCode() : 0);
        result = 31 * result + (zysxss != null ? zysxss.hashCode() : 0);
        result = 31 * result + (xzcljdnr != null ? xzcljdnr.hashCode() : 0);
        result = 31 * result + (rdwh != null ? rdwh.hashCode() : 0);
        result = 31 * result + (rddw != null ? rddw.hashCode() : 0);
        result = 31 * result + (rdrq != null ? rdrq.hashCode() : 0);
        result = 31 * result + (gsjzq != null ? gsjzq.hashCode() : 0);
        return result;
    }
}
