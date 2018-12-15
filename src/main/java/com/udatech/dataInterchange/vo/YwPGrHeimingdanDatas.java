package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwPGrheimingdanEntity;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "DATAS")
public class YwPGrHeimingdanDatas {
    private List<YwPGrheimingdanEntity> data;

    @XmlElement(name = "DATA")
    public List<YwPGrheimingdanEntity> getData() {
        return data;
    }

    public void setData(List<YwPGrheimingdanEntity> data) {
        this.data = data;
    }

}