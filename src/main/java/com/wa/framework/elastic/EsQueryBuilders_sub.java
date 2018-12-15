package com.wa.framework.elastic;

import com.alibaba.fastjson.JSON;
import org.apache.commons.lang.StringUtils;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.Client;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.RangeQueryBuilder;
import org.elasticsearch.search.SearchHit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * @author Administrator
 *
 */
public class EsQueryBuilders_sub {
	   private Logger logger = LoggerFactory.getLogger(getClass());
	/** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * match query 单个匹配 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder matchQuery(String filed,String value) {  
        return QueryBuilders.matchQuery(filed, value);  
    }
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * multimatch  query 
     * 创建一个匹配查询的布尔型提供字段名称和文本。(相当于OR查询 要么存在filed1中，要么存在filed2中...) 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder multiMatchQuery(String value,String... fileds) {  
        
        return QueryBuilders.multiMatchQuery(  
        		value,     // Text you are looking for  
        		fileds      // Fields you query on  
        );  
    }
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * boolean query and 条件组合查询 (定制化使用)
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder booleanQuerys(Map<String,String> map) {  
    	  BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery();
    	  for (String filed : map.keySet()) {
    		   String value = map.get(filed);
    		  queryBuilder.must(QueryBuilders.termQuery(filed, value));
    	  }
    	  
        return queryBuilder;                   
    } 
    
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * 模糊查询 boolean query and 条件组合查询 (定制化使用)
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder wildCardQuerys(Map<String,String> map, Map<String,String> map2) {  
    	 BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery();
    	 // 精确查询
    	 for (String filed : map.keySet()) {
  		     String value = map.get(filed);
  		     queryBuilder.must(QueryBuilders.termQuery(filed, value));
    	 }
    	 // 模糊查询
	   	 for (String filed : map2.keySet()) {
   		     String value = map2.get(filed);
   		     StringBuffer newvalue = new StringBuffer();
   		     newvalue.append("*").append(value).append("*");
   		     queryBuilder.must(QueryBuilders.wildcardQuery(filed, newvalue.toString()));
	   	 }
	   	
       return queryBuilder;                      
    } 
    
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * boolean query and 条件组合查询 (定制化使用)
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    public static RangeQueryBuilder rangeQuery(String rangeFilter, String startTime, String endTime) {
        RangeQueryBuilder queryBuilder = QueryBuilders.rangeQuery(rangeFilter);
        if (StringUtils.isNotEmpty(startTime)){
            queryBuilder.from(startTime);
        }
        if (StringUtils.isNotEmpty(endTime)){
            queryBuilder.to(endTime);
        }
          
        return queryBuilder;                   
    } 
    
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * ids query 
     * 构造一个只会匹配的特定数据 id 的查询。 (通过多个id查询)
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder idsQuery(String... ids) {  
        return QueryBuilders.idsQuery().ids(ids);  
    } 
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * fuzzy query 
     * 使用模糊查询匹配文档查询。 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder fuzzyQuery(String filed,String value) {  
        return QueryBuilders.fuzzyQuery(filed, value);  
    }
    /** 
     *  NotSolved
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * disjunction max query 
     * 一个生成的子查询文件产生的联合查询， 
     * 而且每个分数的文件具有最高得分文件的任何子查询产生的， 
     * 再加上打破平手的增加任何额外的匹配的子查询。 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder disMaxQuery() {  
        return QueryBuilders.disMaxQuery()  
                .add(QueryBuilders.termQuery("DESIDE_ORG", "连云港市"))          // Your queries  
                .add(QueryBuilders.termQuery("DESIDE_ORG", "赣榆区市场监督管理局"))   // Your queries  
                .boost(1.2f)  
                .tieBreaker(0.7f);  
    }
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * matchall query 
     * 查询匹配所有文件。 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder matchAllQuery() {  
        return QueryBuilders.matchAllQuery();  
    } 
    /** 
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     * prefix query 
     * 包含与查询相匹配的文档指定的前缀。 分词后的前缀
     * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
     */  
    protected static QueryBuilder prefixQuery() {  
        return QueryBuilders.prefixQuery("DESIDE_ORG", "连云港市");  
    } 
    
    protected static QueryBuilder booleanQuery(Map<String, String> mustFiledValueMap) {

        BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery();

        for (String filed : mustFiledValueMap.keySet()) {

            String value = mustFiledValueMap.get(filed);
            queryBuilder.must(QueryBuilders.termQuery(filed, value));
        }

        return queryBuilder;
    }
    
    /*
	 * Get index 获取文档相当于读取数据库的一行数据
	 */
	public String get(String index, String type, String id) {
		// 获取客户端连接
		Client client = getClient();
		if (client == null) {
			throw new RuntimeException("dis connect from elastic server!");
		}
		String json = "";
		SearchResponse response = client.prepareSearch(index)
				.setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
				//.setQuery(QueryBuilders.termQuery("DESIDE_ORG", id)) // Query
				//.setQuery(EsQueryBuilders_sub.matchQuery("DESIDE_ORG", id))
			  //.setQuery(EsQueryBuilders_sub.multiMatchQuery(id,"TITLE","DESIDE_ORG" ))
				//.setQuery(EsQueryBuilders_sub.idsQuery("9a4aadebb7568d81c2c534e80f385734",id))
				.setQuery(EsQueryBuilders_sub.matchAllQuery())
				//.setQuery(EsQueryBuilders_sub.fuzzyQuery("name", id))
				//.setQuery(EsQueryBuilders_sub.prefixQuery())
				//.setSize(2500).addHighlightedField("DESIDE_ORG")
				// .setHighlighterPreTags("<span style=\"color:red\">")
		       // .setHighlighterPostTags("</span>")
				.execute().actionGet();
		System.out.println("count::"+response.getHits().getHits().length);
		if (response.getHits().getHits().length >= 1) {
			for (SearchHit hit : response.getHits().getHits()) {
				try {
					System.out.println(hit.highlightFields());
					json = JSON.toJSONString((hit.getSource()));
					logger.info(json);
				} catch (Exception e) {
					logger.error("elasticsearch get index failed "
							+ e.getMessage());
					return null;
				}
			}
		} else {
			logger.info("elasticsearch not found data");
			return null;
		}
		logger.info(json);
		return json;
		// System.out.println(JSON.toJSON(response.getHits()));
	}
	private static Client getClient() {
		ElaticsearchUtils_sub util = ElaticsearchUtils_sub.getInstance();
		if (util == null) {
			return null;
		}
		return util.getClient();
	}
	public static void main(String[] args) {
		EsQueryBuilders_sub client=new EsQueryBuilders_sub();
		client.get("crawler_urls","crawler_urls","江苏经营异常列入公告");
	}
}
