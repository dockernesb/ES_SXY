package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwLHeimingdanEntity;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "DATAS")
public class YwLHeimingdanDatas {
    private List<YwLHeimingdanEntity> data;

    @XmlElement(name = "DATA")
    public List<YwLHeimingdanEntity> getData() {
        return data;
    }

    public void setData(List<YwLHeimingdanEntity> data) {
        this.data = data;
    }

}