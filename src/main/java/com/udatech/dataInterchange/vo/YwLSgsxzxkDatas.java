package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwLSgsxzxkEntity;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "DATAS")
public class YwLSgsxzxkDatas {
    private List<YwLSgsxzxkEntity> data;

    @XmlElement(name = "DATA")
    public List<YwLSgsxzxkEntity> getData() {
        return data;
    }

    public void setData(List<YwLSgsxzxkEntity> data) {
        this.data = data;
    }

}