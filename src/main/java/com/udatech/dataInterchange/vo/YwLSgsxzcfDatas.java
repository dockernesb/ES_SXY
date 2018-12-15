package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwLSgsxzcfEntity;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "DATAS")
public class YwLSgsxzcfDatas {
    private List<YwLSgsxzcfEntity> data;

    @XmlElement(name = "DATA")
    public List<YwLSgsxzcfEntity> getData() {
        return data;
    }

    public void setData(List<YwLSgsxzcfEntity> data) {
        this.data = data;
    }

}