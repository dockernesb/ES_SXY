package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwLJgslbgdjEntity;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "DATAS")
public class YwLJgslbgdjDatas {
    private List<YwLJgslbgdjEntity> data;

    @XmlElement(name = "DATA")
    public List<YwLJgslbgdjEntity> getData() {
        return data;
    }

    public void setData(List<YwLJgslbgdjEntity> data) {
        this.data = data;
    }

}