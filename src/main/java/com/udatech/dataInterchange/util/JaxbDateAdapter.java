package com.udatech.dataInterchange.util;

import javax.xml.bind.annotation.adapters.XmlAdapter;
import java.text.SimpleDateFormat;
import java.util.Date;

public class JaxbDateAdapter extends XmlAdapter<String, Date> {
    private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public Date unmarshal(String v) throws Exception {
        if (v == null) {
            return null;
        }

        return format.parse(v);
    }

    @Override
    public String marshal(Date v) {
        return format.format(v);
    }
}