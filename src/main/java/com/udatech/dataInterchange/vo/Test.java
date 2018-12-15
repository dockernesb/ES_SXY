package com.udatech.dataInterchange.vo;

import com.udatech.dataInterchange.model.YwLSgsxzcfEntity;
import com.udatech.dataInterchange.util.JaxbUtil;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Test {

    /**
     * @param args
     */
    public static void main(String[] args) throws IOException {

        //创建java对象

        YwLSgsxzcfDatas ywLSgsxzcfDatas = new YwLSgsxzcfDatas();

        YwLSgsxzcfEntity t1 = new YwLSgsxzcfEntity();
        t1.setId("121");
        t1.setCreateTime(new Date());

        YwLSgsxzcfEntity t2 = new YwLSgsxzcfEntity();
        t2.setId("");

        List<YwLSgsxzcfEntity> data = new ArrayList<>();
        data.add(t1);
        data.add(t2);
        ywLSgsxzcfDatas.setData(data);

        //将java对象转换为XML字符串
        JaxbUtil requestBinder = new JaxbUtil(YwLSgsxzcfDatas.class, JaxbUtil.CollectionWrapper.class);
        String retXml = requestBinder.toXml(ywLSgsxzcfDatas, new FileWriter("/ftp2.xml"));
        System.out.println("xml:" + retXml);

//        XStream xStream = new XStream();
//        xStream.alias("DATAS", List.class);
//        xStream.alias("DATA", YwLSgsxzcfEntity.class);
//
//        System.out.println(xStream.toXML(data));

        //将xml字符串转换为java对象
//        JaxbUtil resultBinder = new JaxbUtil(YwLSgsxzcfDatas.class,
//                JaxbUtil.CollectionWrapper.class);
//        YwLSgsxzcfDatas ywLSgsxzcfDatasObj = resultBinder.fromXml(retXml);
//
//        System.out.println("hotelid:" + ywLSgsxzcfDatasObj);

    }

}