package com.udatech.dataInterchange.service;

import com.udatech.dataInterchange.dao.FtpDao;
import com.udatech.dataInterchange.dao.YwLSgsxzcfDao;
import com.udatech.dataInterchange.model.DpFtpUploadLogEntity;
import com.udatech.dataInterchange.model.YwLSgsxzcfEntity;
import com.udatech.dataInterchange.util.JaxbUtil;
import com.udatech.dataInterchange.vo.YwLSgsxzcfDatas;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.List;

@Service
public class YwLSgsxzcfService {
    private Logger logger = Logger.getLogger(YwLSgsxzcfService.class);

    private static String tableCode = "YW_L_SGSXZCF";
    private static String talbeNo = "01";

    @Autowired
    private YwLSgsxzcfDao ywLSgsxzcfDao;
    @Autowired
    private GenXmlService genXmlService;
    @Autowired
    private FtpDao ftpDao;

    public void genXml() {
        DpFtpUploadLogEntity recentlyData = ftpDao.getRecentlyData(tableCode);
        if (recentlyData == null) {
            // 无xml生成记录，表示之前从来没有生成过，本次是首次生成
            int pageCount = ywLSgsxzcfDao.getPageCount(true, recentlyData);
            if (pageCount == 0) {
                // 本日无数据，记录上传日志信息
                ftpDao.addNoDataLog(tableCode);
                return;
            }
            genXml(1, pageCount, true, recentlyData);

        } else {
            // 有xml生成记录，本次是非首次生成
            if (recentlyData.getCurrentPage() == recentlyData.getAllPage()) {
                // 该判断表示，之前的生成过程都是正常结束了，进行增量生成

                // 判断当天的定时任务是否已经执行过，避免定时任务重复执行时，导致数据重复生成
                if(genXmlService.hasYesterdayDataGenerated(recentlyData)){
                    logger.warn("ftp上报数据定时任务重复执行,已跳过。");
                    return;
                }

                int pageCount = ywLSgsxzcfDao.getPageCount(false, recentlyData);
                if (pageCount == 0) {
                    // 本日无数据，记录上传日志信息
                    ftpDao.addNoDataLog(tableCode);
                    return;
                }
                genXml(1, pageCount, false, recentlyData);
            } else {
                // 该判断表示，之前的生成过程出错断掉了，本次需要接着之前的继续生成
                if (ftpDao.isFirstBroken(tableCode)) {
                    // 首次全量生成时断掉的
                    genXml(recentlyData.getCurrentPage() + 1, recentlyData.getAllPage(), true, recentlyData);
                } else {
                    // 增量生成时断掉的
                    genXml(recentlyData.getCurrentPage() + 1, recentlyData.getAllPage(), false, recentlyData);
                }
            }
        }

    }

    private void genXml(int currentPage, int allPage, boolean firstFtpUpload, DpFtpUploadLogEntity recentlyData) {
        for (int i = currentPage; i <= allPage; i++) {
            List<YwLSgsxzcfEntity> list = ywLSgsxzcfDao.getData(i, firstFtpUpload, recentlyData);

            String filePath = genXmlService.getXmlFilePath(talbeNo);

            YwLSgsxzcfDatas YwLHeimingdanDatas = new YwLSgsxzcfDatas();
            YwLHeimingdanDatas.setData(list);
            JaxbUtil requestBinder = new JaxbUtil(YwLSgsxzcfDatas.class, JaxbUtil.CollectionWrapper.class);
            try {
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath, true), "UTF-8"));
                requestBinder.toXml(YwLHeimingdanDatas, writer);
            } catch (IOException e) {
                e.printStackTrace();
            }

            // 生成xml文件，并ftp上传
            genXmlService.addFtpLog(filePath, tableCode, i, allPage);

        }
    }

}
