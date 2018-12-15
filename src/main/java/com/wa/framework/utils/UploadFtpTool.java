package com.wa.framework.utils;

import com.alibaba.fastjson.JSON;
import com.thoughtworks.xstream.XStream;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;


public class UploadFtpTool {
    private static String url = "10.191.30.91";
    private static String username = "ftp_user001";
    private static String password = "abc.123";
//  private static String url = "192.168.1.100";
//  private static String username = "ftpuser";
//  private static String password = "123ABCabc";


    public static String putJson(Object object, String fileName, String[] photoPathGroup) throws Exception {

        if (object != null && fileName != null) {
            // 对象转化为json
            String json = JSON.toJSONString(object);
            // 生成唯一时间文件路径名
            SimpleDateFormat simpl = new SimpleDateFormat("yyyyMMddHHmmss");
            String dateString = simpl.format(new Date());
            //设置作文件名
            File file = new File("C:/UploadFtpTool/" + fileName);
            // 文件不存在，创建文件
            File fileParent = file.getParentFile();
            if (!fileParent.exists()) {
                fileParent.mkdirs();
            }
            if (!file.exists()) {
                file.createNewFile();
            }
            FileWriter writer;
            writer = new FileWriter(file);
            writer.write(json);
            writer.flush();
            writer.close();
            // 创建客户端对象
            FTPClient ftp = new FTPClient();
            // 获取登录用的参数
            // 连接ftp服务器
            ftp.connect(url);
            // 登录
            ftp.login(username, password);
            // 如果有指定路径,用指定路径,没有指定路径,用新的上传路径
            /*String path;
            if (filePath != null) {
                path = filePath;
            } else {
                path = "/" + dateString + "/";
            }*/
            // 检查上传路径是否存在 如果不存在返回false
//            boolean flag = ftp.changeWorkingDirectory(path);
//
//            if (!flag) {
//                // 创建上传的路径 该方法只能创建一级目录，在这里如果/home/ftpuser存在则可创建image
//                ftp.makeDirectory(path);
//            }
//            // 指定上传路径
//            ftp.changeWorkingDirectory(path);
            // 指定上传文件的类型 二进制文件
            ftp.setFileType(FTP.BINARY_FILE_TYPE);
            ftp.setControlEncoding("UTF-8");
            // 使用InputStream要上传的文件
            InputStream local = new FileInputStream(file);
            // 第一个参数是文件名
            ftp.storeFile(file.getName() + ".json", local);
            // 附件内容往文件中写
            if (photoPathGroup != null && photoPathGroup.length != 0) {
                for (int i = 0; i < photoPathGroup.length; i++) {
                    file = new File(photoPathGroup[i]);
                    local = new FileInputStream(file);
                    ftp.storeFile(file.getName(), local);
                }
            }
            // 关闭文件流
            local.close();
            // 退出
            ftp.logout();
            // 断开连接
            ftp.disconnect();
            // 删除临时文件
            if (file.exists()) {

                file.deleteOnExit();
                fileParent.deleteOnExit();

            }


        }
        return null;

    }


    public static String putMapJson(Map<String, Object> list, String fileName, String[] photoPathGroup) throws Exception {

        if (list != null && fileName != null) {
            // 对象转化为json
            String json = JSON.toJSONString(list);
            // 生成唯一时间文件路径名
            SimpleDateFormat simpl = new SimpleDateFormat("yyyyMMddHHmmss");
            String dateString = simpl.format(new Date());
            //设置作文件名
            File file = new File("C:/UploadFtpTool/" + fileName);
            // 文件不存在，创建文件
            File fileParent = file.getParentFile();
            if (!fileParent.exists()) {
                fileParent.mkdirs();
            }
            if (!file.exists()) {
                file.createNewFile();
            }
            FileWriter writer;
            writer = new FileWriter(file);
            writer.write(json);
            writer.flush();
            writer.close();
            // 创建客户端对象
            FTPClient ftp = new FTPClient();
            // 获取登录用的参数
            // 连接ftp服务器
            ftp.connect(url);
            // 登录
            ftp.login(username, password);

            ftp.setFileType(FTP.BINARY_FILE_TYPE);
            ftp.setControlEncoding("UTF-8");
            // 使用InputStream要上传的文件
            InputStream local = new FileInputStream(file);
            // 第一个参数是文件名
            ftp.storeFile(file.getName() + ".json", local);
            // 附件内容往文件中写
            if (photoPathGroup != null && photoPathGroup.length != 0) {
                for (int i = 0; i < photoPathGroup.length; i++) {
                    file = new File(photoPathGroup[i]);
                    local = new FileInputStream(file);
                    ftp.storeFile(file.getName(), local);
                }
            }
            // 关闭文件流
            local.close();
            // 退出
            ftp.logout();
            // 断开连接
            ftp.disconnect();
            // 删除临时文件
            if (file.exists()) {

                file.deleteOnExit();
                fileParent.deleteOnExit();

            }


        }
        return null;

    }


    public static void putXml(Object object, String fileName, String[] photoPathGroup) throws Exception {
        if (object != null && fileName != null) {
            // 对象转化为Xml
            String xml = new XStream().toXML(object);
            // 生成唯一时间文件路径名
            SimpleDateFormat simpl = new SimpleDateFormat("yyyyMMddHHmmss");
            String dateString = simpl.format(new Date());
            //设置作文件名
            File file = new File("C:/UploadFtpTool/" + fileName);
            // 文件不存在，创建文件
            File fileParent = file.getParentFile();
            if (!fileParent.exists()) {
                fileParent.mkdirs();
            }
            if (!file.exists()) {
                file.createNewFile();
            }
            FileWriter writer;
            writer = new FileWriter(file);
            writer.write(xml);
            writer.flush();
            writer.close();
            // 创建客户端对象
            FTPClient ftp = new FTPClient();

            // 连接ftp服务器
            ftp.connect(url);
            // 登录
            ftp.login(username, password);
            // 设置上传路径
            String path = "/" + dateString + "/";
            // 检查上传路径是否存在 如果不存在返回false
            boolean flag = ftp.changeWorkingDirectory(path);

            if (!flag) {
                // 创建上传的路径 该方法只能创建一级目录，在这里如果/home/ftpuser存在则可创建image
                ftp.makeDirectory(path);

            }
            // 指定上传路径
            ftp.changeWorkingDirectory(path);
            // 指定上传文件的类型 二进制文件
            ftp.setFileType(FTP.BINARY_FILE_TYPE);
            ftp.setControlEncoding("UTF-8");
            // 使用InputStream要上传的文件
            InputStream local = new FileInputStream(file);
            // 第一个参数是文件名
            ftp.storeFile(file.getName() + ".json", local);
            // 附件内容往文件中写
            if (photoPathGroup != null && photoPathGroup.length != 0) {
                for (int i = 0; i < photoPathGroup.length; i++) {
                    file = new File(photoPathGroup[i]);
                    local = new FileInputStream(file);
                    ftp.storeFile(file.getName(), local);
                }
            }

            // 关闭文件流
            local.close();
            // 退出
            ftp.logout();
            // 断开连接
            ftp.disconnect();
            // 删除临时文件
            if (file.exists()) {

                file.deleteOnExit();
                fileParent.deleteOnExit();

            }

        }
    }

}

