package com.wa.framework.quartz.job;

import com.udatech.dataInterchange.service.GenXmlService;
import com.wa.framework.quartz.service.FtpXmlDataFileService;
import com.wa.framework.web.SpringContext;
import org.apache.log4j.Logger;
import org.quartz.JobExecutionContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

/**
 * 定时上传xml数据文件到 指定ftp服务器
 */
public class FtpXmlDataFileJob extends QuartzJobBean {
    private Logger log = Logger.getLogger(FtpXmlDataFileJob.class);

    /**
     * 定时生成xml数据文件并上传到指定ftp服务器
     */
    @Override
    protected void executeInternal(JobExecutionContext context) {
        FtpXmlDataFileService ftpXmlDataFileService;
        GenXmlService genXmlService;
        try {
            ftpXmlDataFileService = (FtpXmlDataFileService) SpringContext.getBean("ftpXmlDataFileService");
            ftpXmlDataFileService.interchangeData();

            // 续传ftp为上传成功的文件
            genXmlService = (GenXmlService) SpringContext.getBean("genXmlService");
            genXmlService.reFtpUploadFile();
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }

}
