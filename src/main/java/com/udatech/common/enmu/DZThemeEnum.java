/**
 * 
 */
package com.udatech.common.enmu;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

/**
 * <描述>： 报告定制-状态常量<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月4日上午9:27:19
 */
public enum DZThemeEnum {
    顶级资源("0"), 一级资源("1"), 二级资源("2"), 未定义("-1"), 无效("0"), 有效("1"), 资源用途_报告查询("0"), 资源用途_联合奖惩("1"), 资源用途_异议申诉("2"), 资源用途_信用修复("3"), 资源用途_主体管理(
                    "4"), 资源用途_自然人管理("5"), 资源用途_数据追溯("6"), 资源用途_法人信用审查("7"), 资源用途_自然人信用审查("8"),资源用途_自然人异议申诉("9"), 配置("add"), 修改("update"), 查看("read"), 默认("0"), 非默认(
                    "1"), 法人("0"), 自然人("1"), 模板用途_报告查询("0"), 模板用途_信用审查("1");

    private static final Map<String, DZThemeEnum> lookup = new HashMap<String, DZThemeEnum>();

    static {
        for (DZThemeEnum s : EnumSet.allOf(DZThemeEnum.class))
            lookup.put(s.getKey(), s);
    }

    DZThemeEnum(String key) {
        this.key = key;
    }

    private String key;

    public String getKey() {
        return key;
    }

    public static DZThemeEnum getByKey(String value) {
        return lookup.get(value);
    }

    public String key() {
        return key;
    }
}
