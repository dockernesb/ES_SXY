package com.udatech.dataInterchange.service;

import com.udatech.dataInterchange.dao.FtpDao;
import com.udatech.dataInterchange.dao.YwPGrheimingdanDao;
import com.udatech.dataInterchange.model.DpFtpUploadLogEntity;
import com.udatech.dataInterchange.model.YwPGrheimingdanEntity;
import com.udatech.dataInterchange.util.JaxbUtil;
import com.udatech.dataInterchange.vo.YwPGrHeimingdanDatas;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.List;

@Service
public class YwPGrheimingdanService {
    private Logger logger = Logger.getLogger(YwPGrheimingdanService.class);
    private static String tableCode = "YW_P_GRHEIMINGDAN";
    private static String talbeNo = "04";

    @Autowired
    private YwPGrheimingdanDao ywPGrheimingdanDao;
    @Autowired
    private GenXmlService genXmlService;

    @Autowired
    private FtpDao ftpDao;

    public void genXml() {
        DpFtpUploadLogEntity recentlyData = ftpDao.getRecentlyData(tableCode);
        if (recentlyData == null) {
            // 无xml生成记录，表示之前从来没有生成过，本次是首次生成
            int pageCount = ywPGrheimingdanDao.getPageCount(true, recentlyData);
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

                // 判断前一天的数据是否已完成生成过，避免定时任务重复执行时，导致数据重复生成
                if (genXmlService.hasYesterdayDataGenerated(recentlyData)) {
                    logger.warn("ftp上报数据定时任务重复执行,已跳过。");
                    return;
                }

                int pageCount = ywPGrheimingdanDao.getPageCount(false, recentlyData);
                if (pageCount == 0) {
                    // 本日无数据，记录上传日志信息
                    ftpDao.addNoDataLog(tableCode);
                    return;
                }
                genXml(1, pageCount, false, recentlyData);
            } else {
                // 该判断表示，之前的生成过程都出错断掉了，本次需要接着之前的继续生成
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
            List<YwPGrheimingdanEntity> list = ywPGrheimingdanDao.getData(i, firstFtpUpload, recentlyData);

            String filePath = genXmlService.getXmlFilePath(talbeNo);

            YwPGrHeimingdanDatas YwLHeimingdanDatas = new YwPGrHeimingdanDatas();
            YwLHeimingdanDatas.setData(list);
            JaxbUtil requestBinder = new JaxbUtil(YwPGrHeimingdanDatas.class, JaxbUtil.CollectionWrapper.class);
            try {
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath, true), "UTF-8"));
                requestBinder.toXml(YwLHeimingdanDatas, writer);
            } catch (IOException e) {
                e.printStackTrace();
            }

            // 生成xml文件
            genXmlService.addFtpLog(filePath, tableCode, i, allPage);

        }
    }

}
