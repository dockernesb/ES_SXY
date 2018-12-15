package com.udatech.dataInterchange.service;

import com.udatech.dataInterchange.dao.FtpDao;
import com.udatech.dataInterchange.model.DpFtpUploadLogEntity;
import com.udatech.dataInterchange.util.FTPUtil;
import com.wa.framework.QueryConditions;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.util.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
public class GenXmlService {

    private static final String bmbm = "0015"; // 部门编码：市经信委 0015
    private static final String encoding = "UTF-8";

    private static String ftp_host;
    private static int ftp_port;
    private static String ftp_username;
    private static String ftp_password;
    private static String ftp_root_path;

    @Autowired
    private FtpDao ftpDao;

    static {
        ftp_host = PropertyConfigurer.getValue("ftp.host");
        ftp_port = Integer.valueOf(PropertyConfigurer.getValue("ftp.port"));
        ftp_username = PropertyConfigurer.getValue("ftp.username");
        ftp_password = PropertyConfigurer.getValue("ftp.password");
        ftp_root_path = PropertyConfigurer.getValue("ftp.root.path");
    }

    public String getXmlFilePath(String talbeNo) {
        synchronized (GenXmlService.class) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String sq_ftpwjbh = ftpDao.getSequenceNextValue("SQ_FTPWJBH");
            // 文件名命名规则：报文号_日期_序号.xml，
            // 其中报文号为6位字符，前4位为市纪委统一编码的部门编号，后两位为自增序列；日期为8位，格式为YYYYMMDD；序号为5位数字，序号从1顺序增长，位数不足5位，前面补0；如001501_20180307_00001.xml；
            String fileName = bmbm + talbeNo + "_" + sdf.format(new Date()) + "_" + String.format("%05d", Integer.parseInt(sq_ftpwjbh)) + ".xml";
            String prePath = PropertyConfigurer.getValue("ftp.data.path");
            final String filePath = PropertyConfigurer.getValue("ftp.data.path") + fileName;
            File dir = new File(prePath);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            return filePath;
        }

    }

    /**
     * 添加xml文件生成日志，并上传至ftp服务器
     *
     * @param filePath
     * @param talbeCode
     * @param currentPage
     * @param allPage
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void addFtpLog(String filePath, final String talbeCode, int currentPage, int allPage) {
        // 记录xml生成日志信息
        DpFtpUploadLogEntity dpFtpUploadLogEntity = new DpFtpUploadLogEntity();
        dpFtpUploadLogEntity.setTableCode(talbeCode);
        dpFtpUploadLogEntity.setCreateTime(new Date());
        dpFtpUploadLogEntity.setXmlFileLocalPath(filePath);
        dpFtpUploadLogEntity.setFtpStatus("1");
        dpFtpUploadLogEntity.setCurrentPage(currentPage);
        dpFtpUploadLogEntity.setAllPage(allPage);
        ftpDao.save(dpFtpUploadLogEntity);

        // 上传xml数据文件到ftp服务器
        ftpUploadFile(filePath, talbeCode);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void ftpUploadFile(final String filePath, final String talbeCode) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    FTPUtil instance = new FTPUtil();
                    instance.login(ftp_host, ftp_port, ftp_username, ftp_password);
                    instance.uploadOverride(ftp_root_path, filePath);
                    instance.closeCon();

                    // ftp 上传成功，更新上传日志
                    QueryConditions queryConditions = new QueryConditions();
                    queryConditions.addEq("xmlFileLocalPath", filePath);
                    queryConditions.addEq("tableCode", talbeCode);
                    List<DpFtpUploadLogEntity> ftpLogList = ftpDao.find(DpFtpUploadLogEntity.class, queryConditions);
                    if (ftpLogList != null && ftpLogList.size() > 0) {
                        DpFtpUploadLogEntity dpFtpUploadLogEntity = ftpLogList.get(0);
                        dpFtpUploadLogEntity.setFtpStatus("2");
                        dpFtpUploadLogEntity.setFtpTime(new Date());
                        ftpDao.update(dpFtpUploadLogEntity);
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    /**
     * 重新上传未完成ftp上传的文件到ftp服务器<br/>
     * ftp上传状态：1待上传，2已上传
     */
    @PostConstruct
    public void reFtpUploadFile() {

        // 查询未完成ftp上传的文件
        QueryConditions queryConditions = new QueryConditions();
        queryConditions.addEq("ftpStatus", "1");
        List<DpFtpUploadLogEntity> ftpLogList = ftpDao.find(DpFtpUploadLogEntity.class, queryConditions);

        if (ftpLogList != null && ftpLogList.size() > 0) {
            for (DpFtpUploadLogEntity ftpLog : ftpLogList) {
                this.ftpUploadFile(ftpLog.getXmlFileLocalPath(), ftpLog.getTableCode());
            }

        }
    }

    /**
     * 判断定时任务当天是否已经执行过，避免定时任务重复执行时，导致数据重复生成
     *
     * @param recentlyData
     * @return
     */
    public boolean hasYesterdayDataGenerated(DpFtpUploadLogEntity recentlyData) {
        // 生成记录中的最新日期
        String xmlDayStr = DateUtils.format(recentlyData.getCreateTime(), DateUtils.YYYYMMDD_8);
        // 当前日期
        String nowDayStr = DateUtils.format(new Date(), DateUtils.YYYYMMDD_8);

        // 如果日志记录表中最新的的生成记录和当天是同一天，表示该定时任务当天已经执行过了
        if (xmlDayStr != null && xmlDayStr.equals(nowDayStr)) {
            return true;
        }
        return false;
    }
}
