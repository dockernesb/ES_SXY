package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwPGrhydjEntity;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "DATAS")
public class YwPGrhydjDatas {
    private List<YwPGrhydjEntity> data;

    @XmlElement(name = "DATA")
    public List<YwPGrhydjEntity> getData() {
        return data;
    }

    public void setData(List<YwPGrhydjEntity> data) {
        this.data = data;
    }

}