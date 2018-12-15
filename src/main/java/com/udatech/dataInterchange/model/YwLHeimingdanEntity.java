package com.udatech.dataInterchange.model;

import com.udatech.dataInterchange.util.JaxbDateAdapter;

import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import java.util.Date;

public class YwLHeimingdanEntity {
    private String id;
    private String status;
    private String source;
    private Date createTime;
    private String createUser;
    private String bmbm;
    private String bmmc;
    private Date tgrq;
    private String rwbh;
    private String zzjgdm;
    private String jgqcyw;
    private String jgqc;
    private String gszch;
    private String tyshxydm;
    private String bz;
    private String rddw;
    private String rdwh;
    private String zcdz;
    private String fddbr;
    private String fzrxm;
    private String zysxss;
    private String scfzynr;
    private Date qryzsxrq;
    private Date gsjzq;
    private String jhdwqc;
    private String jgdjId;
    private String dqzt;

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

    public String getBmbm() {
        return bmbm;
    }

    public void setBmbm(String bmbm) {
        this.bmbm = bmbm;
    }

    public String getBmmc() {
        return bmmc;
    }

    public void setBmmc(String bmmc) {
        this.bmmc = bmmc;
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

    public String getZzjgdm() {
        return zzjgdm;
    }

    public void setZzjgdm(String zzjgdm) {
        this.zzjgdm = zzjgdm;
    }

    public String getJgqcyw() {
        return jgqcyw;
    }

    public void setJgqcyw(String jgqcyw) {
        this.jgqcyw = jgqcyw;
    }

    public String getJgqc() {
        return jgqc;
    }

    public void setJgqc(String jgqc) {
        this.jgqc = jgqc;
    }

    public String getGszch() {
        return gszch;
    }

    public void setGszch(String gszch) {
        this.gszch = gszch;
    }

    public String getTyshxydm() {
        return tyshxydm;
    }

    public void setTyshxydm(String tyshxydm) {
        this.tyshxydm = tyshxydm;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public String getRddw() {
        return rddw;
    }

    public void setRddw(String rddw) {
        this.rddw = rddw;
    }

    public String getRdwh() {
        return rdwh;
    }

    public void setRdwh(String rdwh) {
        this.rdwh = rdwh;
    }

    public String getZcdz() {
        return zcdz;
    }

    public void setZcdz(String zcdz) {
        this.zcdz = zcdz;
    }

    public String getFddbr() {
        return fddbr;
    }

    public void setFddbr(String fddbr) {
        this.fddbr = fddbr;
    }

    public String getFzrxm() {
        return fzrxm;
    }

    public void setFzrxm(String fzrxm) {
        this.fzrxm = fzrxm;
    }

    public String getZysxss() {
        return zysxss;
    }

    public void setZysxss(String zysxss) {
        this.zysxss = zysxss;
    }

    public String getScfzynr() {
        return scfzynr;
    }

    public void setScfzynr(String scfzynr) {
        this.scfzynr = scfzynr;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getQryzsxrq() {
        return qryzsxrq;
    }

    public void setQryzsxrq(Date qryzsxrq) {
        this.qryzsxrq = qryzsxrq;
    }

    @XmlJavaTypeAdapter(JaxbDateAdapter.class)
    public Date getGsjzq() {
        return gsjzq;
    }

    public void setGsjzq(Date gsjzq) {
        this.gsjzq = gsjzq;
    }

    public String getJhdwqc() {
        return jhdwqc;
    }

    public void setJhdwqc(String jhdwqc) {
        this.jhdwqc = jhdwqc;
    }

    public String getJgdjId() {
        return jgdjId;
    }

    public void setJgdjId(String jgdjId) {
        this.jgdjId = jgdjId;
    }

    public String getDqzt() {
        return dqzt;
    }

    public void setDqzt(String dqzt) {
        this.dqzt = dqzt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        YwLHeimingdanEntity that = (YwLHeimingdanEntity) o;

        if (id != null ? !id.equals(that.id) : that.id != null) return false;
        if (status != null ? !status.equals(that.status) : that.status != null) return false;
        if (source != null ? !source.equals(that.source) : that.source != null) return false;
        if (createTime != null ? !createTime.equals(that.createTime) : that.createTime != null) return false;
        if (createUser != null ? !createUser.equals(that.createUser) : that.createUser != null) return false;
        if (bmbm != null ? !bmbm.equals(that.bmbm) : that.bmbm != null) return false;
        if (bmmc != null ? !bmmc.equals(that.bmmc) : that.bmmc != null) return false;
        if (tgrq != null ? !tgrq.equals(that.tgrq) : that.tgrq != null) return false;
        if (rwbh != null ? !rwbh.equals(that.rwbh) : that.rwbh != null) return false;
        if (zzjgdm != null ? !zzjgdm.equals(that.zzjgdm) : that.zzjgdm != null) return false;
        if (jgqcyw != null ? !jgqcyw.equals(that.jgqcyw) : that.jgqcyw != null) return false;
        if (jgqc != null ? !jgqc.equals(that.jgqc) : that.jgqc != null) return false;
        if (gszch != null ? !gszch.equals(that.gszch) : that.gszch != null) return false;
        if (tyshxydm != null ? !tyshxydm.equals(that.tyshxydm) : that.tyshxydm != null) return false;
        if (bz != null ? !bz.equals(that.bz) : that.bz != null) return false;
        if (rddw != null ? !rddw.equals(that.rddw) : that.rddw != null) return false;
        if (rdwh != null ? !rdwh.equals(that.rdwh) : that.rdwh != null) return false;
        if (zcdz != null ? !zcdz.equals(that.zcdz) : that.zcdz != null) return false;
        if (fddbr != null ? !fddbr.equals(that.fddbr) : that.fddbr != null) return false;
        if (fzrxm != null ? !fzrxm.equals(that.fzrxm) : that.fzrxm != null) return false;
        if (zysxss != null ? !zysxss.equals(that.zysxss) : that.zysxss != null) return false;
        if (scfzynr != null ? !scfzynr.equals(that.scfzynr) : that.scfzynr != null) return false;
        if (qryzsxrq != null ? !qryzsxrq.equals(that.qryzsxrq) : that.qryzsxrq != null) return false;
        if (gsjzq != null ? !gsjzq.equals(that.gsjzq) : that.gsjzq != null) return false;
        if (jhdwqc != null ? !jhdwqc.equals(that.jhdwqc) : that.jhdwqc != null) return false;
        if (jgdjId != null ? !jgdjId.equals(that.jgdjId) : that.jgdjId != null) return false;
        if (dqzt != null ? !dqzt.equals(that.dqzt) : that.dqzt != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (status != null ? status.hashCode() : 0);
        result = 31 * result + (source != null ? source.hashCode() : 0);
        result = 31 * result + (createTime != null ? createTime.hashCode() : 0);
        result = 31 * result + (createUser != null ? createUser.hashCode() : 0);
        result = 31 * result + (bmbm != null ? bmbm.hashCode() : 0);
        result = 31 * result + (bmmc != null ? bmmc.hashCode() : 0);
        result = 31 * result + (tgrq != null ? tgrq.hashCode() : 0);
        result = 31 * result + (rwbh != null ? rwbh.hashCode() : 0);
        result = 31 * result + (zzjgdm != null ? zzjgdm.hashCode() : 0);
        result = 31 * result + (jgqcyw != null ? jgqcyw.hashCode() : 0);
        result = 31 * result + (jgqc != null ? jgqc.hashCode() : 0);
        result = 31 * result + (gszch != null ? gszch.hashCode() : 0);
        result = 31 * result + (tyshxydm != null ? tyshxydm.hashCode() : 0);
        result = 31 * result + (bz != null ? bz.hashCode() : 0);
        result = 31 * result + (rddw != null ? rddw.hashCode() : 0);
        result = 31 * result + (rdwh != null ? rdwh.hashCode() : 0);
        result = 31 * result + (zcdz != null ? zcdz.hashCode() : 0);
        result = 31 * result + (fddbr != null ? fddbr.hashCode() : 0);
        result = 31 * result + (fzrxm != null ? fzrxm.hashCode() : 0);
        result = 31 * result + (zysxss != null ? zysxss.hashCode() : 0);
        result = 31 * result + (scfzynr != null ? scfzynr.hashCode() : 0);
        result = 31 * result + (qryzsxrq != null ? qryzsxrq.hashCode() : 0);
        result = 31 * result + (gsjzq != null ? gsjzq.hashCode() : 0);
        result = 31 * result + (jhdwqc != null ? jhdwqc.hashCode() : 0);
        result = 31 * result + (jgdjId != null ? jgdjId.hashCode() : 0);
        result = 31 * result + (dqzt != null ? dqzt.hashCode() : 0);
        return result;
    }
}
