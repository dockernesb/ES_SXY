package com.wa.framework.elastic;

import com.alibaba.fastjson.JSON;
import com.udatech.common.constant.Constants;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.util.DateUtils;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthRequest;
import org.elasticsearch.action.admin.indices.mapping.put.PutMappingRequest;
import org.elasticsearch.action.bulk.BulkRequestBuilder;
import org.elasticsearch.action.count.CountResponse;
import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.Requests;
import org.elasticsearch.client.transport.NoNodeAvailableException;
import org.elasticsearch.cluster.metadata.MappingMetaData;
import org.elasticsearch.common.collect.ImmutableOpenMap;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.elasticsearch.index.query.IdsQueryBuilder;
import org.elasticsearch.index.query.MoreLikeThisQueryBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.RangeQueryBuilder;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.MetricsAggregationBuilder;
import org.elasticsearch.search.aggregations.metrics.sum.Sum;
import org.elasticsearch.search.sort.SortOrder;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.elasticsearch.common.xcontent.XContentFactory.jsonBuilder;

/**
 * @author fenghj
 */
@SuppressWarnings("deprecation")
public class ESUtils_sub {
    private static final Log logger = LogFactory.getLog(ESUtils_sub.class);

    public final static String ERRORTYPE = "_ERROR";

    /*-----------------------信用数据追溯记录begin--------------------------*/
    // 上报数据，elastic 索引
    public static String CREDIT_TRACE_INDEX = "";
    public static String CREDIT_TRACE_INDEX_TYPE = "";

    // 索引数据主键
    public final static String PROP_ID = "ID";

    // 索引数据插入时间
    public final static String PROP_INSERTTIME = "inserttime";

    // 索引插入日期
    public final static String PROP_INSERTDAY = "insertday";

    // 索引数据来源，赋值如下：原始库（ESUtils_sub.STAGE_YSK），原始->有效（ESUtils_sub.STAGE_YXK），有效->业务（ESUtils_sub.STAGE_YWK），业务库（STAGE_YWK_ONLY）
    public final static String PROP_STAGE = "stage";

    // 索引数据action类型
    public final static String PROP_ACTION = "action";

    // 索引数据内容详情
    public final static String PROP_CONTENT = "content";

    // 索引数据任务编码
    public final static String PROP_TASKCODE = "taskcode";

    // 索引数据表名
    public final static String PROP_TABLE_NAME = "tablename";

    // kettle有效库到业务库时记录的业务表名
    public final static String PROP_YW_TABLE_NAME = "ywTableName";

    // 索引数据信用主体（法人或自然人）主键
    public final static String PROP_CREDIT_SUBJECT_ID = "creditsubjectid";

    // 索引数据信用业务事项，取DataTraceItemEnum枚举值中的常量
    public final static String PROP_ITEM = "item";

    // 索引数据该条记录被使用的信用业务事项大类，取取DataTraceItemTypeEnum枚举值中的常量
    public final static String PROP_ITEM_TYPE = "itemtype";

    // 该记录被使用的业务办件编号
    public final static String PROP_SERVICENO = "serviceNo";

    // 状态
    public final static String PROP_STATUS = "status";

    // 数据处理时间
    public final static String PROP_OP_TIME = "optime";

    // cetl转换名称
    public final static String PROP_CETL_TRANS_NAME = "transname";

    // 原因
    public final static String PROP_KETTLE_REASON = "kettlereason";

    // 字段错误原因
    public final static String PROP_KETTLE_ERROR_REASON = "ERROR_REASON";

    // 文件解析字段错误原因
    public final static String PROP_KETTLE_I_ERROR_REASON = "I_ERROR_REASON";

    // 错误来源字段
    public final static String PROP_ERROR_SOURCE = "errorSource";

    // 错误字段
    public final static String PROP_KETTLE_ERROR_HEAD = "ERROR_HEAD";

    // 错误代码字段
    public final static String PROP_KETTLE_ERROR_CODE = "ERR_CODE";

    // 错误代码40001,规则校验分类
    public final static String ERROR_CODE_RULE = "40001";

    // 错误原因
    public final static String PROP_KETTLE_REASON_PARSE_EROR = "格式错误";
    /*-----------------------信用数据追溯记录end--------------------------*/

    // 错误处理状态字段
    public final static String PROP_OPERATE_STATUS = "OPERATE_STATUS";

    // 错误处理时间字段
    public final static String PROP_OPERATE_TIME = "OPERATE_TIME";

    // 数据上报方式字段
    public final static String PROP_REPORT_WAY = "REPORT_WAY";

    /*-----------------------数据来源常量begin--------------------------*/
    // 原始库
    public final static String STAGE_YSK = "s";

    // 原始->有效
    public final static String STAGE_YXK = "x";

    // 有效->业务
    public final static String STAGE_YWK = "w";

    // 到有效库的疑问数据->原始
    public final static String STAGE_YXK_TO_YSK = "x2s";

    // 到业务库的疑问数据->原始
    public final static String STAGE_YWK_TO_YSK = "W2s";
    /*-----------------------数据来源常量end--------------------------*/

    /*-----------------------数据操作常量begin--------------------------*/
    // 文本上传或者手动录入入原始库的操作
    public final static String ACTION_INSERT = "i";

    // kettle处理，原始库到有效库或者有效库到业务库的操作
    public final static String ACTION_KETTLE_INSERT = "ki";

    // 页面修改原始库的操作
    public final static String ACTION_EDIT = "e";

    // 页面删除原始库的操作
    public final static String ACTION_DELETE = "d";

    // 页面修复疑问数据到原始库的操作
    public final static String ACTION_REPAIR_INSERT = "ri";
    /*-----------------------数据操作常量end--------------------------*/

    public final static String STATUS_NOT_DO = "no"; // 未处理
    public final static String STATUS_DONE = "do"; // 已处理
    public final static String STATUS_IGNORE = "ignore"; // 已忽略
    public final static String STATUS_MODIFY = "modify"; // 已修改

    /*-----------------------部门编码--------------------------*/
    public final static String DEPT_CODE = "DEPT_CODE"; // 部门编码

    static {
        System.out.println("===============elastic.properties init========================");
        CompositeConfiguration config = new CompositeConfiguration();
        try {
            config.addConfiguration(new PropertiesConfiguration("properties/elastic.properties"));
        } catch (ConfigurationException e) {
            logger.error(e.getMessage(), e);
        }
    }

    static {
        // 从配置文件中获取属性值

        CREDIT_TRACE_INDEX = PropertyConfigurer.getValue("shebao.index");
        CREDIT_TRACE_INDEX_TYPE = PropertyConfigurer.getValue("shebao.type");
    }

    /***
     * 创建索引mapping
     * @param index
     * @param type
     * @param map
     */
    public void createNotMapping(String index, String type, Map<String, Map<String, String>> map) {
        XContentBuilder builder = null;
        try {
            // createIndex(index);//创建mapping之前要创建索引
            Client client = getClient();
            if (client == null) {
                throw new RuntimeException("dis connect from elastic server!");
            }

            builder = XContentFactory.jsonBuilder().startObject()
                    // 索引库名（类似数据库中的表）
                    .startObject(type)
                    // 放开data类型必须设置为date类型的开关，即2017-04-10这样的日期不会作为date类型，为string类型
                    .field("date_detection", false).startObject("properties");
            for (String filed : map.keySet()) {// 遍历要分词的字段
                builder = builder.startObject(filed);
                for (String ff : map.get(filed).keySet()) {
                    builder = builder.field(ff, map.get(filed).get(ff));
                }
                builder = builder.endObject();
            }

            builder.endObject().endObject().endObject();
            PutMappingRequest mapping = Requests.putMappingRequest(index).type(type).source(builder);
            client.admin().indices().putMapping(mapping).actionGet();
        } catch (IOException e) {
            logger.error("elastic 索引库已经存在");
        }

    }

    /***
     * 创建索引mapping
     * @param index
     * @param type
     * @param map
     */
    public void createNotMapping1(String index, String type, Map<String, Map<String, String>> map) {
        XContentBuilder builder = null;
        try {
            // createIndex(index);//创建mapping之前要创建索引
            Client client = getClient();
            if (client == null) {
                throw new RuntimeException("dis connect from elastic server!");
            }

            builder = XContentFactory.jsonBuilder().startObject()
                    // 索引库名（类似数据库中的表）
                    .startObject(type)
                    // 放开data类型必须设置为date类型的开关，即2017-04-10这样的日期不会作为date类型，为string类型
                    .field("date_detection", false).startObject("properties");
            builder = builder.startObject(PROP_CONTENT).startObject("properties");
            for (String filed : map.keySet()) {// 遍历要分词的字段
                builder = builder.startObject(filed);
                for (String ff : map.get(filed).keySet()) {
                    builder = builder.field(ff, map.get(filed).get(ff));
                }
                builder = builder.endObject();
            }

            builder.endObject().endObject().endObject().endObject().endObject();
            PutMappingRequest mapping = Requests.putMappingRequest(index).type(type).source(builder);
            client.admin().indices().putMapping(mapping).actionGet();
        } catch (IOException e) {
            logger.error("elastic 索引库已经存在");
        }

    }

    // 创建索引
    public synchronized void createIndex(String index) {
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        try {
            client.admin().indices().prepareCreate(index).setSettings(Settings.builder().put("index.max_result_window", 2000000000)).get();

            // waitForYellow
            client.admin().cluster().health(new ClusterHealthRequest(index).waitForYellowStatus()).actionGet();
        } catch (Exception e) {
            logger.error("elastic 索引库" + index + "已经存在了");
        }
    }

    /*
     * create index trans document to json saveindex 索引type 类型json 索引数据
     */
    public boolean createIndex(String index, String type, String json, String id) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        return createIndex(client, index, type, json, id);
    }

    public boolean createIndex(Client client, String index, String type, String json, String id) {
        try {
            if (client == null) {

                client = getClient();
                if (client == null) {
                    throw new RuntimeException("dis connect from elastic server!");
                }
            }

            IndexResponse response = client.prepareIndex(index, type, id).setSource(json).execute().actionGet();

            if (logger.isInfoEnabled()) {
                logger.info("create index: " + index + ",json:" + json + ",type:" + type + ",id:" + response.getId() + "success");
            }
        } catch (Exception e) {
            logger.error("create index: " + index + ",json:" + json + ",type:" + type + ",id:" + id + "failed", e);
            logger.error(e.getMessage(), e);
            return false;

        }
        return true;
    }

    /**
     * @throws @since JDK 1.6
     * @Description: 批量建索引
     * @param: @param index
     * @param: @param type
     * @param: @param dataMap <elasticId,JsonStr>
     * @param: @return
     * @return: boolean
     */
    public boolean createIndexByMap(String index, String type, Map<String, String> dataMap) {
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        BulkRequestBuilder bulkRequest = client.prepareBulk();

        try {
            int no = 0;
            for (String elasticId : dataMap.keySet()) {
                String jsonStr = dataMap.get(elasticId);

                bulkRequest.add(client.prepareIndex(index, type, elasticId).setSource(jsonStr));

                // 每500条提交一次
                if ((no > 0 && no % 500 == 0) || no >= (dataMap.size() - 1)) {
                    bulkRequest.execute().actionGet();
                }
                no++;
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return false;
        }

        return true;
    }

    /***
     * 更新具体id更新执行字段的值
     * @param id id
     * @param filed 字段
     * @param filedvalue 字段值
     */
    public void updateIndex(String id, Map<String, String> updateFieldMap, Map<String, Object> contentFieldMap) {
        if (updateFieldMap == null || updateFieldMap.size() <= 0) {
            return;
        }
        // 获取客户端连接
        try {
            Client client = getClient();
            if (client == null) {
                throw new RuntimeException("dis connect from elastic server!");
            }
            UpdateRequest uRequest = new UpdateRequest();
            uRequest.index(CREDIT_TRACE_INDEX);
            uRequest.type(CREDIT_TRACE_INDEX_TYPE);
            uRequest.id(id);
            XContentBuilder xContentBuilder = jsonBuilder().startObject();

            for (String field : updateFieldMap.keySet()) {
                xContentBuilder.field(field, updateFieldMap.get(field));
            }

            if (contentFieldMap != null) {
                xContentBuilder.startObject(ESUtils_sub.PROP_CONTENT);
                for (String field : contentFieldMap.keySet()) {
                    xContentBuilder.field(field, contentFieldMap.get(field));
                }
                xContentBuilder.endObject();
            }

            uRequest.doc(xContentBuilder.endObject());
            client.update(uRequest).get();
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new RuntimeException("elastic update failed");
        }

    }

    /***
     * 更新具体id更新执行字段的值
     * @param index 索引
     * @param type 类型
     * @param id id
     * @param filed 字段
     * @param filedvalue 字段值
     */
    public void updateIndex(String index, String type, String id, Map<String, String> updateFieldMap) {
        if (updateFieldMap == null || updateFieldMap.size() <= 0) {
            return;
        }
        // 获取客户端连接
        try {
            Client client = getClient();
            if (client == null) {
                throw new RuntimeException("dis connect from elastic server!");
            }
            UpdateRequest uRequest = new UpdateRequest();
            uRequest.index(index);
            uRequest.type(type);
            uRequest.id(id);
            XContentBuilder xContentBuilder = jsonBuilder().startObject();

            for (String field : updateFieldMap.keySet()) {
                xContentBuilder.field(field, updateFieldMap.get(field));
            }
            uRequest.doc(xContentBuilder.endObject());
            client.update(uRequest).get();
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new RuntimeException("elastic update failed");
        }

    }

    /**
     * @throws @since JDK 1.6
     * @Description: 仅仅获取索引为credit_trace的数据
     * @param: @param type
     * @param: @param m
     * @param: @param form
     * @param: @param size
     * @param: @param result
     * @param: @return
     * @return: List<Map       <       String       ,       Object>>
     */
    @SuppressWarnings("unchecked")
    public Pageable<Map<String, Object>> getCreditRraceDataList(Map<String, String> m, Page page) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        int pageSize = page.getPageSize();
        int startIndex = (page.getCurrentPage() - 1) * pageSize;

        List<Map<String, Object>> list = new ArrayList<>();

        SearchResponse response = null;
        try {
            response = client.prepareSearch(CREDIT_TRACE_INDEX)
                    .setTypes(CREDIT_TRACE_INDEX_TYPE)
                    .setQuery(EsQueryBuilders_sub.booleanQuerys(m)).setFrom(startIndex).setSize(pageSize).execute()
                    .actionGet();
        } catch (NoNodeAvailableException e) {
            logger.error("elasticsearch get response failed : [" + MapUtils.getString(m, "tablename", "") + "] " + e.getMessage());
            return new SimplePageable<>();
        }
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return new SimplePageable<>();
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return new SimplePageable<>();
        }

        Pageable<Map<String, Object>> result = new SimplePageable<Map<String, Object>>();
        // 总记录数
        int totalRecords = (int) response.getHits().getTotalHits();
        // 总页数
        int totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
        result.setTotalRecords(totalRecords);
        result.setTotalPages(totalPages);
        result.setPageSize(pageSize);

        if (page.getCurrentPage() == null || page.getCurrentPage().intValue() <= 0) {
            result.setCurrentPage(1);
        } else {
            result.setCurrentPage(page.getCurrentPage());
        }

        List<Map<String, Object>> showTableData = new ArrayList<Map<String, Object>>();

        for (Map<String, Object> mapData : list) {
            // 表数据
            Map<String, Object> jsonMap = (Map<String, Object>) mapData.get(PROP_CONTENT);
            if (jsonMap == null) {
                continue;
            }
            // 数据状态
            String status = (String) mapData.get(PROP_STATUS);
            if (status == null || status.equals(STATUS_NOT_DO)) {// 未处理
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_DO_NOTHIING);
                jsonMap.put("OPERATE_TIME", null);
            } else {
                // 已处理/忽略
                if (status.equals(STATUS_DONE)) {
                    jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_FINISH);
                } else if (status.equals(STATUS_IGNORE)) {
                    jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_IGNORE);
                }
                String opTimeStr = (String) mapData.get(PROP_OP_TIME);
                if (opTimeStr == null) {
                    jsonMap.put("OPERATE_TIME", null);
                } else {
                    jsonMap.put("OPERATE_TIME", DateUtils.parseDate(opTimeStr, DateUtils.YYYYMMDDHHMMSS_19));
                }
            }
            //
            // 异常原因
            jsonMap.put(PROP_KETTLE_REASON, (String) mapData.get(PROP_KETTLE_REASON));
            jsonMap.put(PROP_KETTLE_ERROR_REASON, (String) mapData.get(PROP_KETTLE_ERROR_REASON));
            jsonMap.put(PROP_KETTLE_ERROR_HEAD, (String) mapData.get(PROP_KETTLE_ERROR_HEAD));

            jsonMap.put(PROP_STAGE, (String) mapData.get(PROP_STAGE));
            showTableData.add(jsonMap);
        }
        result.addData(showTableData);

        return result;

    }

    /**
     * @throws @since JDK 1.6
     * @Description: 获取索引为credit_trace的数据包含区间查询
     * @param: @param type
     * @param: @param m
     * @param: @param form
     * @param: @param size
     * @param: @param result
     * @param: @return
     * @return: List<Map       <       String       ,       Object>>
     */
    @SuppressWarnings("unchecked")
    public Pageable<Map<String, Object>> getCreditTraceDataList(Map<String, String> m, Map<String, String> m2, Page page, RangeQueryBuilder rangeFilter) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        int pageSize = page.getPageSize();
        int startIndex = (page.getCurrentPage() - 1) * pageSize;

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        // 创建查询索引
        SearchRequestBuilder builder = client.prepareSearch(CREDIT_TRACE_INDEX);
        // 设置查询索引类型
        builder.setTypes(CREDIT_TRACE_INDEX_TYPE);

        builder.setSearchType(SearchType.DEFAULT);
        //  builder
        // 设置查询条件
        //builder.setQuery(EsQueryBuilders_sub.booleanQuerys(m));
        // 模糊查询
        builder.setQuery(EsQueryBuilders_sub.wildCardQuerys(m, m2));
        // 设置分区间查询
        if (rangeFilter != null) {
            builder.setPostFilter(rangeFilter);
        }

        // 分页
        builder.setFrom(startIndex).setSize(pageSize);

        // 字段排序,排序方式 默认降序
        SortOrder sortOrder = SortOrder.DESC;

        builder.addSort(PROP_OP_TIME, sortOrder);

        SearchResponse response = builder.execute().actionGet();

        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return new SimplePageable<Map<String, Object>>();
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return new SimplePageable<Map<String, Object>>();
        }

        Pageable<Map<String, Object>> result = new SimplePageable<Map<String, Object>>();
        // 总记录数
        int totalRecords = (int) response.getHits().getTotalHits();
        // 总页数
        int totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
        result.setTotalRecords(totalRecords);
        result.setTotalPages(totalPages);
        result.setPageSize(pageSize);

        if (page.getCurrentPage() == null || page.getCurrentPage().intValue() <= 0) {
            result.setCurrentPage(1);
        } else {
            result.setCurrentPage(page.getCurrentPage());
        }

        List<Map<String, Object>> showTableData = new ArrayList<Map<String, Object>>();

        for (Map<String, Object> mapData : list) {
            // 表数据
            Map<String, Object> jsonMap = (Map<String, Object>) mapData.get(PROP_CONTENT);
            if (jsonMap == null) {
                continue;
            }
            // 数据状态
            String status = (String) mapData.get(PROP_STATUS);
            if (status == null || status.equals(STATUS_NOT_DO)) {// 未处理
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_DO_NOTHIING);
            } else if (status.equals(STATUS_DONE)) {
                // 已处理
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_FINISH);
            } else if (status.equals(STATUS_IGNORE)) {
                // 已忽略
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_IGNORE);
            } else {
                // 已修改 STATUS_MODIFY
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_MODIFY);
            }

            String opTimeStr = (String) mapData.get(PROP_OP_TIME);
            if (opTimeStr == null) {
                jsonMap.put("OPERATE_TIME", null);
            } else {
                jsonMap.put("OPERATE_TIME", DateUtils.parseDate(opTimeStr, DateUtils.YYYYMMDDHHMMSS_19));
            }

            // 上报方式
            jsonMap.put(PROP_REPORT_WAY, (String) mapData.get(PROP_REPORT_WAY));

            // 异常原因
            jsonMap.put(PROP_KETTLE_REASON, (String) mapData.get(PROP_KETTLE_REASON));
            jsonMap.put(PROP_KETTLE_ERROR_REASON, (String) mapData.get(PROP_KETTLE_ERROR_REASON));
            jsonMap.put(PROP_KETTLE_ERROR_HEAD, (String) mapData.get(PROP_KETTLE_ERROR_HEAD));

            jsonMap.put(PROP_STAGE, (String) mapData.get(PROP_STAGE));
            showTableData.add(jsonMap);
        }
        result.addData(showTableData);

        return result;

    }

    /**
     * 根据查询条件查询所有的疑问数据`
     *
     * @param m
     * @param m2
     * @param rangeFilter
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getCreditTraceDataList(Map<String, String> m, Map<String, String> m2, RangeQueryBuilder rangeFilter) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        // 创建查询索引
        SearchRequestBuilder builder = client.prepareSearch(CREDIT_TRACE_INDEX);
        // 设置查询索引类型
        builder.setTypes(CREDIT_TRACE_INDEX_TYPE);

        builder.setSearchType(SearchType.DEFAULT);
        //  builder
        // 设置查询条件
        //builder.setQuery(EsQueryBuilders_sub.booleanQuerys(m));
        // 模糊查询
        builder.setQuery(EsQueryBuilders_sub.wildCardQuerys(m, m2));
        // 设置分区间查询
        if (rangeFilter != null) {
            builder.setPostFilter(rangeFilter);
        }

        // 查询范围
        builder.setFrom(0).setSize(1000000000);

        // 字段排序,排序方式 默认降序
        SortOrder sortOrder = SortOrder.DESC;

        builder.addSort(PROP_OP_TIME, sortOrder);

        SearchResponse response = builder.execute().actionGet();

        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return new ArrayList<Map<String, Object>>();
                }
            }
        } else {
            logger.debug("elasticsearch not found data");
            return new ArrayList<Map<String, Object>>();
        }

        List<Map<String, Object>> showTableData = new ArrayList<Map<String, Object>>();

        for (Map<String, Object> mapData : list) {
            // 表数据
            Map<String, Object> jsonMap = (Map<String, Object>) mapData.get(PROP_CONTENT);
            if (jsonMap == null) {
                continue;
            }
            jsonMap.put("elasticId", (String) mapData.get("_id"));
            // 数据状态
            String status = (String) mapData.get(PROP_STATUS);
            if (status == null || status.equals(STATUS_NOT_DO)) {// 未处理
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_DO_NOTHIING);
            } else if (status.equals(STATUS_DONE)) {
                // 已处理
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_FINISH);
            } else if (status.equals(STATUS_IGNORE)) {
                // 已忽略
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_IGNORE);
            } else {
                // 已修改 STATUS_MODIFY
                jsonMap.put("OPERATE_STATUS", Constants.UPLOAD_ERROR_MODIFY);
            }

            String opTimeStr = (String) mapData.get(PROP_OP_TIME);
            jsonMap.put("optime", opTimeStr);
            if (opTimeStr == null) {
                jsonMap.put("OPERATE_TIME", null);
            } else {
                jsonMap.put("OPERATE_TIME", DateUtils.parseDate(opTimeStr, DateUtils.YYYYMMDDHHMMSS_19));
            }

            // 上报方式
            jsonMap.put(PROP_REPORT_WAY, (String) mapData.get(PROP_REPORT_WAY));

            // 异常原因
            jsonMap.put(PROP_KETTLE_REASON, (String) mapData.get(PROP_KETTLE_REASON));
            jsonMap.put(PROP_KETTLE_ERROR_REASON, (String) mapData.get(PROP_KETTLE_ERROR_REASON));
            jsonMap.put(PROP_KETTLE_ERROR_HEAD, (String) mapData.get(PROP_KETTLE_ERROR_HEAD));

            jsonMap.put(PROP_STAGE, (String) mapData.get(PROP_STAGE));
            showTableData.add(jsonMap);
        }

        return showTableData;

    }

    /**
     * @throws @since JDK 1.6
     * @Description: 获取索引为credit_trace中的记录
     * @param: @param type
     * @param: @param id
     * @param: @return
     * @return: Map<String       ,       Object>
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getCreditRraceData(Map<String, String> m) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        SearchResponse response = client.prepareSearch(CREDIT_TRACE_INDEX)
                .setTypes(CREDIT_TRACE_INDEX_TYPE)
                .setQuery(EsQueryBuilders_sub.booleanQuerys(m)).setFrom(0).setSize(1000000000).execute().actionGet();// 注：此处的setSize10亿需要在elastic页面上是为设置，参照升级指南
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return new ArrayList<Map<String, Object>>();
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return new ArrayList<Map<String, Object>>();
        }

        if (list.size() <= 0) {
            return new ArrayList<Map<String, Object>>();
        }

        for (Map<String, Object> mapData : list) {
            // 表数据
            Map<String, Object> jsonMap = (Map<String, Object>) mapData.get(PROP_CONTENT);
            if (jsonMap == null) {
                continue;
            }
            jsonMap.put("_id", mapData.get("_id"));
        }
        return list;

    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的分页数据，不包括排序和区间查询
     * @param: @param m
     * @param: @param page
     * @param: @return
     * @return: Pageable<Map       <       String       ,       Object>>
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> getPageList(Map<String, String> m, Page page) {
        return getPageList(m, page, null, null, null);
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的分页数据，包括排序
     * @param: @param m 查询条件
     * @param: @param page 分页数据
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @return
     * @return: Pageable<Map       <       String       ,       Object>>
     * @since JDK 1.7
     */
    public Pageable<Map<String, Object>> getPageListOrder(Map<String, String> m, Page page, String sort, String order) {
        return getPageList(m, page, sort, order, null);
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的分页数据，包括排序和区间查询
     * @param: @param m 查询条件
     * @param: @param page 分页数据
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @param rangeFilter 区间查询
     * @param: @return
     * @return: Pageable<Map       <       String       ,       Object>>
     * @since JDK 1.7
     */
    public Pageable<Map<String, Object>> getPageListOrderAndRange(Map<String, String> m, Page page, String sort,
                                                                  String order, RangeQueryBuilder rangeFilter) {
        return getPageList(m, page, sort, order, rangeFilter);
    }

    /**
     * @throws
     * @Description: 分页查询索引库credit_trace_data
     * @param: @param m 查询条件
     * @param: @param page 分页数据
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @param rangeFilter 区间查询
     * @param: @return
     * @return: Pageable<Map       <       String       ,       Object>>
     * @since JDK 1.7
     */
    private Pageable<Map<String, Object>> getPageList(Map<String, String> m, Page page, String sort, String order, RangeQueryBuilder rangeFilter) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        int pageSize = page.getPageSize();
        int startIndex = (page.getCurrentPage() - 1) * pageSize;

        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        // 创建查询索引
        SearchRequestBuilder builder = client.prepareSearch(CREDIT_TRACE_INDEX);

        // 设置查询索引类型
        builder.setTypes(CREDIT_TRACE_INDEX_TYPE);

        // 设置查询条件
        builder.setQuery(EsQueryBuilders_sub.booleanQuerys(m));

        // 设置分区间查询
        if (rangeFilter != null) {
            builder.setPostFilter(rangeFilter);
        }

        // 分页
        builder.setFrom(startIndex).setSize(pageSize);

        // 排序字段
        if (StringUtils.isNotEmpty(sort)) {
            // 字段排序,排序方式 默认降序
            SortOrder sortOrder = SortOrder.ASC;
            if (StringUtils.isNotEmpty(order) && Constants.ORDER_DESC.equals(order)) {
                sortOrder = SortOrder.DESC;
            }
            builder.addSort(sort, sortOrder);
        }

        // 设置是否按查询匹配度排序
        builder.setExplain(true);

        // 最后就是返回搜索响应信息
        SearchResponse response = builder.execute().actionGet();

        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return new SimplePageable<Map<String, Object>>();
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return new SimplePageable<Map<String, Object>>();
        }

        // 总记录数
        int totalRecords = (int) response.getHits().getTotalHits();

        // 总页数
        int totalPages = (int) Math.ceil(totalRecords / (double) pageSize);

        Pageable<Map<String, Object>> result = new SimplePageable<Map<String, Object>>();
        result.setTotalRecords(totalRecords);
        result.setTotalPages(totalPages);
        result.setPageSize(pageSize);

        if (page.getCurrentPage() == null || page.getCurrentPage().intValue() <= 0) {
            result.setCurrentPage(1);
        } else {
            result.setCurrentPage(page.getCurrentPage());
        }

        result.addData(list);

        return result;

    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的所有数据，不包括排序和区间查询
     * @param: @param m
     * @param: @return
     * @return: GetData_sub
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getAllList(Map<String, String> m) {
        return getAllList(m, null, null, null, false);
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的所有数据，包括排序
     * @param: @param m 查询条件
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @return
     * @return: GetData_sub
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getAllListOrder(Map<String, String> m, String sort, String order) {
        return getAllList(m, sort, order, null, false);
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的所有数据，包括排序和区间查询
     * @param: @param m 查询条件
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @param rangeFilter 区间查询
     * @param: @return
     * @return: GetData_sub
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getAllListOrderAndRange(Map<String, String> m, String sort,
                                                             String order, RangeQueryBuilder rangeFilter, boolean isContent) {
        return getAllList(m, sort, order, rangeFilter, isContent);
    }

    /**
     * @throws @since JDK 1.6
     * @Description: 获取所有记录
     * @param: @param index
     * @param: @param type
     * @param: @param value
     * @param: @param field
     * @param: @return
     * @return: GetData_sub
     */
    private List<Map<String, Object>> getAllList(Map<String, String> map, String sort, String order, RangeQueryBuilder rangeFilter, boolean
            isContent) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        // 创建查询索引
        SearchRequestBuilder builder = client.prepareSearch(CREDIT_TRACE_INDEX);

        // 设置查询索引类型
        builder.setTypes(CREDIT_TRACE_INDEX_TYPE);

        // 设置查询条件
        builder.setQuery(EsQueryBuilders_sub.booleanQuerys(map));

        // 设置分区间查询
        if (rangeFilter != null) {
            builder.setPostFilter(rangeFilter);
        }

        // 排序字段
        if (StringUtils.isNotEmpty(sort)) {
            // 字段排序,排序方式 默认降序
            SortOrder sortOrder = SortOrder.ASC;
            if (StringUtils.isNotEmpty(order) && Constants.ORDER_DESC.equals(order)) {
                sortOrder = SortOrder.DESC;
            }
            if (isContent) {
                builder.addSort(ESUtils_sub.PROP_CONTENT + "." + sort, sortOrder);
            } else {
                builder.addSort(sort, sortOrder);
            }
        }

        // 设置是否按查询匹配度排序
        builder.setExplain(true);

        // 最后就是返回搜索响应信息
        SearchResponse response = builder.setFrom(0).setSize(1000000000).execute().actionGet();
        SearchHits hitsValues = response.getHits();

        // 返回结果
        List<Map<String, Object>> value = new ArrayList<Map<String, Object>>();
        SearchHit[] hitsValue = hitsValues.getHits();
        for (SearchHit hits : hitsValue) {
            value.add(hits.getSource());
        }

        return value;
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的所有数据，不包括排序和区间查询
     * @param: @param m
     * @param: @return
     * @return: GetData_sub
     * @since JDK 1.6
     */
    public GetData_sub getAllListData(Map<String, String> m) {
        return getAllListData(m, null, null, null);
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的所有数据，包括排序
     * @param: @param m 查询条件
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @return
     * @return: GetData_sub
     * @since JDK 1.6
     */
    public GetData_sub getAllListOrderData(Map<String, String> m, String sort, String order) {
        return getAllListData(m, sort, order, null);
    }

    /**
     * @throws
     * @Description: 根据查询条件获取索引库credit_trace_data的所有数据，包括排序和区间查询
     * @param: @param m 查询条件
     * @param: @param sort 排序字段
     * @param: @param order 升序or降序
     * @param: @param rangeFilter 区间查询
     * @param: @return
     * @return: GetData_sub
     * @since JDK 1.6
     */
    public GetData_sub getAllListOrderAndRangeData(Map<String, String> m, String sort,
                                                   String order, RangeQueryBuilder rangeFilter) {
        return getAllListData(m, sort, order, rangeFilter);
    }

    /**
     * @throws @since JDK 1.6
     * @Description: 获取所有记录
     * @param: @param index
     * @param: @param type
     * @param: @param value
     * @param: @param field
     * @param: @return
     * @return: GetData_sub
     */
    private GetData_sub getAllListData(Map<String, String> map, String sort, String order, RangeQueryBuilder rangeFilter) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        // 创建查询索引
        SearchRequestBuilder builder = client.prepareSearch(CREDIT_TRACE_INDEX);

        // 设置查询索引类型
        builder.setTypes(CREDIT_TRACE_INDEX_TYPE);

        // 设置查询条件
        builder.setQuery(EsQueryBuilders_sub.booleanQuerys(map));

        // 设置分区间查询
        if (rangeFilter != null) {
            builder.setPostFilter(rangeFilter);
        }

        // 排序字段
        if (StringUtils.isNotEmpty(sort)) {
            // 字段排序,排序方式 默认降序
            SortOrder sortOrder = SortOrder.ASC;
            if (StringUtils.isNotEmpty(order) && Constants.ORDER_DESC.equals(order)) {
                sortOrder = SortOrder.DESC;
            }
            builder.addSort(sort, sortOrder);
        }

        // 设置是否按查询匹配度排序
        builder.setExplain(true);

        // 最后就是返回搜索响应信息
        SearchResponse response = builder.setFrom(0).setSize(1000000000).execute().actionGet();
        SearchHits hitsValues = response.getHits();

        // 总记录数
        long totlaHits = hitsValues.getTotalHits();
        if (totlaHits <= 0) {
            return null;
        }

        // 返回结果
        GetData_sub getDataSub = new GetData_sub(totlaHits);
        getDataSub.addData(hitsValues);

        return getDataSub;
    }

    private static Client getClient() {
        ElaticsearchUtils_sub util = ElaticsearchUtils_sub.getInstance();
        if (util == null) {
            return null;
        }
        return util.getClient();
    }

    public void close() {
        // on shutdown 断开集群
        ElaticsearchUtils_sub.getInstance().colseClient();
    }

    /**
     * @throws @since JDK 1.6
     * @Description: 获取所有记录
     * @param: @param index
     * @param: @param type
     * @param: @param value
     * @param: @param field
     * @param: @return
     * @return: GetData_sub
     */
    public GetData_sub getAllListByField(String index, String type, Map<String, String> mustFiledValueMap, boolean all) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        int pageSize = 10000;
        int pageIndex = 0;

        SearchRequestBuilder sbuilder = client.prepareSearch(index).setTypes(type)
                .setQuery(EsQueryBuilders_sub.booleanQuery(mustFiledValueMap));
        sbuilder.setFrom(pageIndex).setSize(pageSize);

        SearchResponse response = sbuilder.execute().actionGet();
        SearchHits hitsValues = response.getHits();
        // 总数
        long totlaHits = hitsValues.getTotalHits();

        if (totlaHits <= 0) {
            return null;
        }

        // 返回结果
        GetData_sub getDataSub = new GetData_sub(totlaHits);
        getDataSub.addData(hitsValues);

        if (all) {// 获取所有
            // 总页数
            long totalPage = (totlaHits / pageSize) + (totlaHits % pageSize == 0 ? 0 : 1);

            for (int page = 1; page < totalPage; page++) {
                pageIndex = page * pageSize;

                sbuilder.setFrom(pageIndex);
                if (pageIndex + pageSize > totlaHits) {
                    sbuilder.setSize((int) (totlaHits - pageIndex));
                } else {
                    sbuilder.setSize(pageSize);
                }

                response = sbuilder.execute().actionGet();
                hitsValues = response.getHits();

                // 总数
                totlaHits = hitsValues.getTotalHits();
                if (totlaHits <= 0) {
                    break;
                }
                getDataSub.addData(hitsValues);
            }
        }

        return getDataSub;
    }

    /**
     * 根据_id模糊查询
     *
     * @param index
     * @param type
     * @param id
     * @param fields
     * @return
     */
    public List<Map<String, Object>> getList(String _id) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        IdsQueryBuilder ids = new IdsQueryBuilder();
        ids.addIds(_id);
        SearchResponse response = client.prepareSearch(CREDIT_TRACE_INDEX).setTypes(CREDIT_TRACE_INDEX_TYPE)
                .setSearchType(SearchType.DFS_QUERY_THEN_FETCH).setQuery(ids) // Query
                // .setQuery(QueryBuilders.matchAllQuery()) // Query
                .setFrom(0).setSize(1000000000).execute().actionGet();
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return null;
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return null;
        }
        logger.debug("size:" + list.size() + "=======" + JSON.toJSON(list));
        return list;
    }

    /**
     * 根据_id模糊查询
     *
     * @param index
     * @param type
     * @param id
     * @param fields
     * @return
     */
    public List<Map<String, Object>> getList(String index, String type, String _id) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        SearchResponse response = client.prepareSearch(index).setTypes(type)
                .setSearchType(SearchType.DFS_QUERY_THEN_FETCH).setQuery(QueryBuilders.fuzzyQuery("_id", _id)) // Query
                // .setQuery(QueryBuilders.matchAllQuery()) // Query
                .setFrom(0).setSize(1000000000).execute().actionGet();
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return null;
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return null;
        }
        logger.debug("size:" + list.size() + "=======" + JSON.toJSON(list));
        return list;

    }

    /**
     * 根据多字段模糊查询
     *
     * @param index
     * @param type
     * @param id
     * @param fields
     * @return
     */
    public List<Map<String, Object>> getListbyFields(String index, String type, String value, String... fields) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        MoreLikeThisQueryBuilder more = new MoreLikeThisQueryBuilder(fields);
        more.likeText(value).analyzer("ik").minTermFreq(1).maxQueryTerms(25);// q为查询字段
        SearchResponse response = client.prepareSearch(index).setTypes(type).setQuery(more)

                .setFrom(0).setSize(1000000000).execute().actionGet();
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return null;
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return null;
        }
        logger.debug("size:" + list.size() + "=======" + JSON.toJSON(list));
        return list;
    }

    /**
     * @param index
     * @param type
     * @param m     需要查询的字段和字段值
     * @return
     */
    public List<Map<String, Object>> getList(String index, String type, Map<String, String> m, int form, int size) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        SearchResponse response = client.prepareSearch(index).setTypes(type).setQuery(EsQueryBuilders_sub.booleanQuerys(m))
                .setFrom(form).setSize(size).execute().actionGet();
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return null;
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return null;
        }
        // logger.debug("size:" + list.size() + "=======" + JSON.toJSON(list));
        return list;

    }

    /**
     * @param index
     * @param m     需要查询的字段和字段值
     * @return 查询index所有类型的数据
     */
    public List<Map<String, Object>> getAllList(String index, Map<String, String> m, int form, int size,
                                                String... types) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        SearchResponse response = client.prepareSearch(index).setTypes(types).setQuery(EsQueryBuilders_sub.booleanQuerys(m))
                .setFrom(form).setSize(size).execute().actionGet();
        if (response.getHits().getHits().length > 0) {
            for (SearchHit hit : response.getHits().getHits()) {
                Map<String, Object> map = new HashMap<String, Object>();
                try {
                    map.put("_id", hit.getId());
                    map.put("_type", hit.getType());
                    BeanUtils.populate(map, hit.getSource());
                    list.add(map);

                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return null;
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return null;
        }
        logger.debug("size:" + list.size() + "=======" + JSON.toJSON(list));
        return list;

    }

    /**
     * 查询分词
     *
     * @param index
     * @param type
     */
    public void queryData(String index, String type) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }

        QueryBuilder queryBuilder = QueryBuilders.termQuery("info.CORP_NAME", "苏州");

        SearchResponse searchResponse = client.prepareSearch(index).setTypes(type).setQuery(queryBuilder).execute()
                .actionGet();
        SearchHits hits = searchResponse.getHits();
        System.out.println("查询到记录数:" + hits.getTotalHits());
        SearchHit[] searchHists = hits.getHits();
        for (SearchHit sh : searchHists) {
            System.out.println("content:" + sh.getSource().get("contents"));
        }
    }

    /***
     * 创建索引mapping
     * @param index
     * @param type
     * @param map
     */
    public void createMapping(String index, String type, Map<String, String> map) {
        XContentBuilder builder = null;
        try {
            // createIndex(index);//创建mapping之前要创建索引
            Client client = getClient();
            if (client == null) {
                throw new RuntimeException("dis connect from elastic server!");
            }

            builder = XContentFactory.jsonBuilder().startObject()
                    // 索引库名（类似数据库中的表）
                    .startObject(type).startObject("properties");
            for (String filed : map.keySet()) {// 遍历要分词的字段
                builder.startObject(filed).field("type", map.get(filed)).field("analyzer", "ik")
                        .field("search_analyzer", "ik_max_word").endObject();
            }

            builder.endObject().endObject().endObject();
            PutMappingRequest mapping = Requests.putMappingRequest(index).type(type).source(builder);
            client.admin().indices().putMapping(mapping).actionGet();
        } catch (IOException e) {
            logger.error("elastic 索引库已经存在");
        }

    }

    public boolean checkMapping(String index, String type) {
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        // 创建一个itest索引，索引类型为news。
        try {
            ImmutableOpenMap<String, MappingMetaData> mappings = client.admin().cluster().prepareState().execute()
                    .actionGet().getState().getMetaData().getIndices().get(index).getMappings();
            if (mappings.get(type).source() == null) {
                return false;
            } else {
                return true;
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return false;
        }

    }

    /*
     * Count result;
     */
    public void count(String index, String type) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        CountResponse countresponse = null;
        try {
            countresponse = client.prepareCount(index).setQuery(QueryBuilders.termQuery("_type", type)).execute()
                    .actionGet();
            logger.info(countresponse.getCount());
        } catch (Exception e) {
            logger.error("elasticsearch count failed." + e.getMessage());
            logger.error(e.getMessage(), e);
        }

    }

    /**
     * @param index
     * @param m     需要查询的字段和字段值
     * @return 查询index所有类型的数据
     */
    @SuppressWarnings("rawtypes")
    public double aggre(String index, Map<String, String> m, String... types) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        // 聚合数据
        MetricsAggregationBuilder aggregation = AggregationBuilders.sum("agg").field("port");
        SearchResponse response = client.prepareSearch(index).setTypes(types).addAggregation(aggregation)
                .setQuery(EsQueryBuilders_sub.booleanQuerys(m)).execute().actionGet();
        Sum agg = response.getAggregations().get("agg");
        double value = agg.getValue();
        return value;
    }

    @SuppressWarnings("rawtypes")
    public void groupby(String index, Map<String, String> m, String... types) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        AggregationBuilder aggregation = AggregationBuilders.terms("agg").field("port");
        SearchResponse response = client.prepareSearch(index).setTypes(types).addAggregation(aggregation)
                .setQuery(EsQueryBuilders_sub.booleanQuerys(m)).execute().actionGet();

        Terms genders = response.getAggregations().get("agg");

        // For each entry
        for (Terms.Bucket entry : genders.getBuckets()) {
            if (logger.isInfoEnabled()) {
                logger.info(entry.getKey() + "------------" + entry.getDocCount());
            }
        }
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
        SearchResponse response = client.prepareSearch(index).setTypes(type)
                .setSearchType(SearchType.DFS_QUERY_THEN_FETCH).setQuery(QueryBuilders.termQuery("_id", id)) // Query
                .execute().actionGet();
        if (response.getHits().getHits().length == 1) {
            for (SearchHit hit : response.getHits().getHits()) {
                try {
                    json = JSON.toJSONString((hit.getSource()));
                } catch (Exception e) {
                    logger.error("elasticsearch get index failed " + e.getMessage());
                    logger.error(e.getMessage(), e);
                    return null;
                }
            }
        } else {
            logger.info("elasticsearch not found data");
            return null;
        }
        logger.debug(json);
        return json;
        // System.out.println(JSON.toJSON(response.getHits()));
    }

    /**
     * 根据索引类型删除
     *
     * @param index
     * @param type
     * @param map
     */
    public static void delIndex(String index, String type, Map<String, String> map) {
        ESUtils_sub es = new ESUtils_sub();
        List<Map<String, Object>> ipl = es.getList(index, type, map, 0, 10000);
        if (ipl != null && ipl.size() > 0) {
            for (Map<String, Object> m : ipl) {
                es.delete(index, type, m.get("_id").toString());
            }
            delIndex(index, type, map);
        }
    }

    /*
     * Delete index 删除文档，相当于删除一行数据 id:_id
     */
    private void delete(String index, String type, String id) {
        // 获取客户端连接
        Client client = getClient();
        if (client == null) {
            throw new RuntimeException("dis connect from elastic server!");
        }
        DeleteResponse deleteresponse = null;
        try {
            deleteresponse = client.prepareDelete(index, type, id).execute().actionGet();
            logger.info(deleteresponse.getVersion());
        } catch (Exception e) {
            logger.error("elasticsearch delete failed." + e.getMessage());
            logger.error(e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        ESUtils_sub client = new ESUtils_sub();
        client.createIndex(CREDIT_TRACE_INDEX);
        try {
            Map<String, Map<String, String>> map = new HashMap<String, Map<String, String>>();
            Map<String, String> ana = new HashMap<String, String>();
            ana.put("type", "string");
            ana.put("store", "yes");
            ana.put("index", "not_analyzed");

            map.put("ID", ana);
            map.put(ESUtils_sub.PROP_TABLE_NAME, ana);

            Map<String, String> time = new HashMap<String, String>();
            time.put("type", "date");
            time.put("format", DateUtils.YYYYMMDDHHMMSS_19);
            map.put(ESUtils_sub.PROP_INSERTTIME, time);

            Map<String, String> date = new HashMap<String, String>();
            date.put("type", "date");
            date.put("format", DateUtils.YYYYMMDD_10);
            map.put(ESUtils_sub.PROP_INSERTDAY, date);

            client.createNotMapping(CREDIT_TRACE_INDEX, CREDIT_TRACE_INDEX_TYPE,
                    map);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

}
