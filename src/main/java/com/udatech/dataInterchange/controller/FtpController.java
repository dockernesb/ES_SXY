package com.udatech.dataInterchange.controller;

import com.udatech.dataInterchange.service.FtpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * ftp上传控制器
 */
@Controller
@RequestMapping("/ftp")
public class FtpController {

    @Autowired
    private FtpService ftpService;

    @RequestMapping("/data/interchange")
    @ResponseBody
    public void interchange() {
        ftpService.interchange();
    }

}
