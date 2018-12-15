package com.wa.framework.elastic;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.log4j.Logger;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;

import java.net.InetSocketAddress;

/**
 * @author fenghj
 */

public class ElaticsearchUtils_sub {
    Logger logger = Logger.getLogger(this.getClass());
    private Client client;
    private static String elas_host = "";
    private static int elas_port = 9300;

    static {
        System.out.println("===============elastic.properties init========================");
        CompositeConfiguration config = new CompositeConfiguration();
        try {
            config.addConfiguration(new PropertiesConfiguration("properties/elastic.properties"));
        } catch (ConfigurationException e) {
            e.printStackTrace();
        }
        // 从配置文件中获取属性值
        elas_host = config.getString("shebao.host");
        elas_port = config.getInt("shebao.port");

    }
    // 单例
    private static ElaticsearchUtils_sub me;

    public static ElaticsearchUtils_sub getInstance() {
        if (me == null) {
            me = new ElaticsearchUtils_sub();
        }
        return me;
    }

    public Client getClient() {

        if (client == null) {
            // 设置集群名称
            Settings settings = addClusterName();

            // 构建客户端Client
            try {
                this.client = getConnectToCluster(settings);
            } catch (Exception e) {
                logger.error("build Elastic client error !", e);
            }
        }

        return client;
    }

    /**
     * 关闭连接
     */
    public void colseClient() {
        this.client.close();
        this.client = null;
    }

    public ElaticsearchUtils_sub() {
        me = this;

    }

    /**
     * @Description: 设置集群名称
     * @param:
     * @return: void
     * @throws @since JDK 1.6
     */
    private Settings addClusterName() {
        // 设置集群名称，不设置默认是：elasticsearch
        // 设置client.transport.sniff为true来使客户端去嗅探整个集群的状态，把集群中其它机器的ip地址加到客户端中
        // 这样做的好处是一般你不用手动设置集群里所有集群的ip到连接客户端，它会自动帮你添加，并且自动发现新加入集群的机器
//        Map<String, String> map = new HashMap<String, String>();  
//        map.put("cluster.name", "dataTrace");  
//        return Settings.settingsBuilder().put(map).build();
        return Settings.settingsBuilder().build();
    }

    /**
     * @Description: 构建客户端连接
     * @param: @param settings
     * @param: @return
     * @return: TransportClient
     * @throws @since JDK 1.6
     */
    private TransportClient getConnectToCluster(Settings settings) {
        TransportClient client = null;
        if (settings == null) {
            client = new TransportClient.Builder().build();
        } else {
            client = new TransportClient.Builder().settings(settings).build();
        }

        client.addTransportAddress(new InetSocketTransportAddress(new InetSocketAddress(elas_host, elas_port)));
        return client;
    }
    
    
    /**
     * 
     * @Description: 获取一个新的连接
     * @param: @return
     * @return: Client
     * @throws
     * @since JDK 1.6
     */
    public  Client getNewClient(){ 
     
        Settings settings = addClusterName();

        // 构建客户端Client
        try {
            return  getConnectToCluster(settings);
        } catch (Exception e) {
            logger.error("build Elastic client error !", e);
            return null;
        }
    }

}
