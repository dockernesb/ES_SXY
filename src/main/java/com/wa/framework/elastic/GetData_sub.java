package com.wa.framework.elastic;

import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class GetData_sub {

    // 记录信息
    private long totlaHits;// 总记录数
    private List<Map<String, Object>> value = new ArrayList<Map<String, Object>>();

    public GetData_sub() {

    }

    public GetData_sub(long totlaHits) {
        this.totlaHits = totlaHits;
    }

    public long getTotlaHits() {
        return totlaHits;
    }

    public void setTotlaHits(long totlaHits) {
        this.totlaHits = totlaHits;
    }

    public List<Map<String, Object>> getValue() {
        return value;
    }

    public void setValue(List<Map<String, Object>> value) {
        this.value = value;
    }

    public void addData(Map<String, Object> data) {
        value.add(data);
    }

    public void addData(SearchHits hitsValues) {
        SearchHit[] hitsValue = hitsValues.getHits();

        for (SearchHit hits : hitsValue) {
            value.add(hits.getSource());
        }
    }

}
