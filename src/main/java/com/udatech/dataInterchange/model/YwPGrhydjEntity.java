package com.udatech.dataInterchange.model;

import com.udatech.dataInterchange.util.JaxbDateAdapter;

import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import java.util.Date;

public class YwPGrhydjEntity {
    private String id;
    private String status;
    private String source;
    private Date createTime;
    private String createUser;
    private String bmmc;
    private String bmbm;
    private Date tgrq;
    private String rwbh;
    private String bz;
    private String djjg;
    private Date djrq;
    private String nanfxm;
    private String nanfsfzh;
    private String nvfxm;
    private String nvfsfzh;
    private String ywlx;
    private String hyzknv;
    private String hyzknan;

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

    public String getDjjg() {
        return djjg;
    }

    public void setDjjg(String djjg) {
        this.djjg = djjg;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getDjrq() {
        return djrq;
    }

    public void setDjrq(Date djrq) {
        this.djrq = djrq;
    }

    public String getNanfxm() {
        return nanfxm;
    }

    public void setNanfxm(String nanfxm) {
        this.nanfxm = nanfxm;
    }

    public String getNanfsfzh() {
        return nanfsfzh;
    }

    public void setNanfsfzh(String nanfsfzh) {
        this.nanfsfzh = nanfsfzh;
    }

    public String getNvfxm() {
        return nvfxm;
    }

    public void setNvfxm(String nvfxm) {
        this.nvfxm = nvfxm;
    }

    public String getNvfsfzh() {
        return nvfsfzh;
    }

    public void setNvfsfzh(String nvfsfzh) {
        this.nvfsfzh = nvfsfzh;
    }

    public String getYwlx() {
        return ywlx;
    }

    public void setYwlx(String ywlx) {
        this.ywlx = ywlx;
    }

    public String getHyzknv() {
        return hyzknv;
    }

    public void setHyzknv(String hyzknv) {
        this.hyzknv = hyzknv;
    }

    public String getHyzknan() {
        return hyzknan;
    }

    public void setHyzknan(String hyzknan) {
        this.hyzknan = hyzknan;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        YwPGrhydjEntity that = (YwPGrhydjEntity) o;

        if (id != null ? !id.equals(that.id) : that.id != null) return false;
        if (status != null ? !status.equals(that.status) : that.status != null) return false;
        if (source != null ? !source.equals(that.source) : that.source != null) return false;
        if (createTime != null ? !createTime.equals(that.createTime) : that.createTime != null) return false;
        if (createUser != null ? !createUser.equals(that.createUser) : that.createUser != null) return false;
        if (bmmc != null ? !bmmc.equals(that.bmmc) : that.bmmc != null) return false;
        if (bmbm != null ? !bmbm.equals(that.bmbm) : that.bmbm != null) return false;
        if (tgrq != null ? !tgrq.equals(that.tgrq) : that.tgrq != null) return false;
        if (rwbh != null ? !rwbh.equals(that.rwbh) : that.rwbh != null) return false;
        if (bz != null ? !bz.equals(that.bz) : that.bz != null) return false;
        if (djjg != null ? !djjg.equals(that.djjg) : that.djjg != null) return false;
        if (djrq != null ? !djrq.equals(that.djrq) : that.djrq != null) return false;
        if (nanfxm != null ? !nanfxm.equals(that.nanfxm) : that.nanfxm != null) return false;
        if (nanfsfzh != null ? !nanfsfzh.equals(that.nanfsfzh) : that.nanfsfzh != null) return false;
        if (nvfxm != null ? !nvfxm.equals(that.nvfxm) : that.nvfxm != null) return false;
        if (nvfsfzh != null ? !nvfsfzh.equals(that.nvfsfzh) : that.nvfsfzh != null) return false;
        if (ywlx != null ? !ywlx.equals(that.ywlx) : that.ywlx != null) return false;
        if (hyzknv != null ? !hyzknv.equals(that.hyzknv) : that.hyzknv != null) return false;
        if (hyzknan != null ? !hyzknan.equals(that.hyzknan) : that.hyzknan != null) return false;

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
        result = 31 * result + (rwbh != null ? rwbh.hashCode() : 0);
        result = 31 * result + (bz != null ? bz.hashCode() : 0);
        result = 31 * result + (djjg != null ? djjg.hashCode() : 0);
        result = 31 * result + (djrq != null ? djrq.hashCode() : 0);
        result = 31 * result + (nanfxm != null ? nanfxm.hashCode() : 0);
        result = 31 * result + (nanfsfzh != null ? nanfsfzh.hashCode() : 0);
        result = 31 * result + (nvfxm != null ? nvfxm.hashCode() : 0);
        result = 31 * result + (nvfsfzh != null ? nvfsfzh.hashCode() : 0);
        result = 31 * result + (ywlx != null ? ywlx.hashCode() : 0);
        result = 31 * result + (hyzknv != null ? hyzknv.hashCode() : 0);
        result = 31 * result + (hyzknan != null ? hyzknan.hashCode() : 0);
        return result;
    }
}
