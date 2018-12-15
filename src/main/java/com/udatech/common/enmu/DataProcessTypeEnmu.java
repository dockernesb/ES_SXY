package com.udatech.common.enmu;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

/**
 * 数据处理过程 处理类别
 */
public enum DataProcessTypeEnmu {
    数据上报("1"), 规则校验("2"),关联入库("3");

    private static final Map<String, DataProcessTypeEnmu> lookup = new HashMap<String, DataProcessTypeEnmu>();

    static {
        for (DataProcessTypeEnmu s : EnumSet.allOf(DataProcessTypeEnmu.class))
            lookup.put(s.getKey(), s);
    }

    private DataProcessTypeEnmu(String key) {
        this.key = key;
    }

    private String key;

    public String getKey() {
        return key;
    }

    public static DataProcessTypeEnmu getByKey(String value) {
        return lookup.get(value);
    }

    public String key() {
        return key;
    }
}
