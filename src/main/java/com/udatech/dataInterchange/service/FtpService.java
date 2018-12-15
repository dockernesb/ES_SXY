package com.udatech.dataInterchange.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FtpService {
    @Autowired
    private YwLSgsxzcfService ywLSgsxzcfService;
    @Autowired
    private YwLSgsxzxkService ywLSgsxzxkService;
    @Autowired
    private YwLHeimingdanService ywLHeimingdanService;
    @Autowired
    private YwPGrheimingdanService ywPGrheimingdanService;
    @Autowired
    private YwPGrhydjService ywPGrhydjService;
    @Autowired
    private YwLJgslbgdjService ywLJgslbgdjService;

    /**
     * 生成以下目录的xml数据文件，并上传至ftp 服务器<br/>
     * 01: sgsxzcf  双公示行政处罚 <br/>
     * 02: sgsxzxk  双公示行政许可 <br/>
     * 03: lheimingdan  法人黑名单<br/>
     * 04: grheimingdan 自然人黑名单<br/>
     * 05: grhydj   自然人婚姻登记信息<br/>
     * 06: jgslbgdj 企业基本信息<br/>
     */
    public void interchange() {
        synchronized (FtpService.class) {
            ywLSgsxzcfService.genXml();
            ywLSgsxzxkService.genXml();

            ywLHeimingdanService.genXml();
            ywPGrheimingdanService.genXml();

            ywPGrhydjService.genXml();
            ywLJgslbgdjService.genXml();
        }
    }

}
