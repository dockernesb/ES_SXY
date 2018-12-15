package com.wa.framework.quartz.service;

import com.udatech.dataInterchange.service.FtpService;
import com.wa.framework.service.BaseService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Service
public class FtpXmlDataFileService extends BaseService {
    private Lock lock = new ReentrantLock();

    private Logger log = Logger.getLogger(FtpXmlDataFileService.class);

    @Autowired
    private FtpService ftpService;

    /**
     * 定时生成xml数据文件并上传到指定ftp服务器
     */
    public void interchangeData() {
        if (lock.tryLock()) {// 尝试获取锁
            try {
                ftpService.interchange();
            } catch (Exception e) {
                log.error(e.getMessage(), e);
            } finally {
                lock.unlock();// 一定要释放锁，不然会死锁
            }
        } else {
            log.info("定时生成xml数据文件并上传到指定ftp服务器任务获取锁失败，已跳过。已有一个线程正在执行中，线程名===" + Thread.currentThread().getName());
        }

    }

}
