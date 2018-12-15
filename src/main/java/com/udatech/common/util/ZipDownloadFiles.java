package com.udatech.common.util;

import org.apache.commons.lang.StringEscapeUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipDownloadFiles {

    public static String zipFiles(List<File> files, String zipFileName) {
        try {
            //List<File> 作为参数传进来，就是把多个文件的路径放到一个list里面
            //创建一个临时压缩文件

            //临时文件可以放在CDEF盘中，但不建议这么做，因为需要先设置磁盘的访问权限，最好是放在服务器上，方法最后有删除临时文件的步骤

//            zipFileName = "D:/tempZip.zip";
            File file = new File(zipFileName);
            if (!file.exists()) {
                file.createNewFile();
            }

            //创建文件输出流
            FileOutputStream fous = new FileOutputStream(file);
            ZipOutputStream zipOut = new ZipOutputStream(fous);
            zipFile(files, zipOut);
            zipOut.close();
            fous.close();
            return zipFileName;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 把接受的全部文件打成压缩包
     *
     * @param List<File>;
     * @param org.apache.tools.zip.ZipOutputStream
     */
    public static void zipFile(List files, ZipOutputStream outputStream) {
        int size = files.size();
        for (int i = 0; i < size; i++) {
            File file = (File) files.get(i);
            zipFile(file, outputStream);
        }
    }

    /**
     * 根据输入的文件与输出流对文件进行打包
     *
     * @param File
     * @param org.apache.tools.zip.ZipOutputStream
     */
    public static void zipFile(File inputFile, ZipOutputStream ouputStream) {
        try {
            if (inputFile.exists()) {
                if (inputFile.isFile()) {
                    FileInputStream IN = new FileInputStream(inputFile);
                    BufferedInputStream bins = new BufferedInputStream(IN, 512);
                    ZipEntry entry = new ZipEntry(inputFile.getName());
                    ouputStream.putNextEntry(entry);
                    // 向压缩文件中输出数据
                    int nNumber;
                    byte[] buffer = new byte[512];
                    while ((nNumber = bins.read(buffer)) != -1) {
                        ouputStream.write(buffer, 0, nNumber);
                    }
                    // 关闭创建的流对象
                    bins.close();
                    IN.close();
                } else {
                    try {
                        File[] files = inputFile.listFiles();
                        for (int i = 0; i < files.length; i++) {
                            zipFile(files[i], ouputStream);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                inputFile.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void downLoadFile(HttpServletRequest request, HttpServletResponse response, String filePath) throws Exception {
        // 创建file对象
        File file = new File(filePath);
        if (file.exists()) {
            String fileName = file.getName();
            fileName = StringEscapeUtils.unescapeHtml(fileName);

            // 设置response的编码方式
            response.setContentType("application/octet-stream");
            // 写明要下载的文件的大小
            response.setContentLength((int) file.length());
            // 设置输出的格式
            FileUtils.setDownFileName(response, request, fileName);
            // 读出文件到i/o流
            FileInputStream fis = new FileInputStream(file);
            BufferedInputStream buff = new BufferedInputStream(fis);
            byte[] b = new byte[1024];// 相当于我们的缓存
            long k = 0;// 该值用于计算当前实际下载了多少字节
            // 从response对象中得到输出流,准备下载
            OutputStream os = response.getOutputStream();
            // 开始循环下载
            while (k < file.length()) {
                int j = buff.read(b, 0, 1024);
                k += j;
                // 将b中的数据写到客户端的内存
                os.write(b, 0, j);
            }
            // 将写入到客户端的内存的数据,刷新到磁盘
            os.flush();
            buff.close();
            os.close();

            file.delete();
        }
    }
}
