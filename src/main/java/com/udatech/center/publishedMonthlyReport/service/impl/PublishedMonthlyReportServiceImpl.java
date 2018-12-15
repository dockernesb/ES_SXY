package com.udatech.center.publishedMonthlyReport.service.impl;

import com.udatech.center.publishedMonthlyReport.dao.PublishedMonthlyReportDao;
import com.udatech.center.publishedMonthlyReport.model.PublishedMonthlyReport;
import com.udatech.center.publishedMonthlyReport.service.PublishedMonthlyReportService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.log.ExpLog;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * @author IT-20170331ROM3
 * @category 双公示月报表
 * @time 2017-12-05 15:12:27
 */
@Service
@ExpLog(type = "双公示月报")
public class PublishedMonthlyReportServiceImpl implements PublishedMonthlyReportService {

    @Autowired
    private PublishedMonthlyReportDao publishedMonthlyReportDao;

    /**
     * 查询双公示月报表
     *
     * @param report
     * @param page
     * @return
     */
    public Pageable getList(PublishedMonthlyReport report, Page page) {
        return publishedMonthlyReportDao.getList(report, page);
    }

    /**
     * 查询双公示汇总
     *
     * @param report
     * @param page
     * @return
     */
    public Pageable<Map<String, Object>> getSumList(PublishedMonthlyReport report, Page page) {
        return publishedMonthlyReportDao.getSumList(report, page);
    }

    /**
     * 保存双公示月报
     *
     * @param report
     */
    public void saveMonthlyReport(PublishedMonthlyReport report) {
        if (StringUtils.isNotBlank(report.getId())) {   //  修改
            PublishedMonthlyReport old = publishedMonthlyReportDao.get(PublishedMonthlyReport.class, report.getId());
            if (old != null) {
                report.setCreateTime(old.getCreateTime());
                report.setCreateUser(old.getCreateUser());
                report.setStatus(old.getStatus());
                publishedMonthlyReportDao.evict(old);
                publishedMonthlyReportDao.update(report);
            }
        } else {
            report.setStatus("1");
            publishedMonthlyReportDao.save(report);
        }
    }

    /**
     * 删除双公示月报
     *
     * @param report
     */
    public void deleteMonthlyReport(PublishedMonthlyReport report) {
        if (StringUtils.isNotBlank(report.getId())) {   //  修改
            PublishedMonthlyReport old = publishedMonthlyReportDao.get(PublishedMonthlyReport.class, report.getId());
            if (old != null) {
                old.setStatus("2");
                old.setUpdateUser(report.getUpdateUser());
                old.setUpdateTime(new Date());
                publishedMonthlyReportDao.save(old);
            }
        }
    }

    /**
     * 根据id查询双公示月报表
     *
     * @param id
     * @return
     */
    public PublishedMonthlyReport getPublishedMonthlyReport(String id) {
        return publishedMonthlyReportDao.get(PublishedMonthlyReport.class, id);
    }

    /**
     * 导出双公示月报表
     *
     * @param report
     * @return
     */
    public String exportList(PublishedMonthlyReport report, String realPath) {
        PublishedMonthlyReport temp = publishedMonthlyReportDao.getMinDateAndMaxDate();
        if (StringUtils.isNotBlank(report.getBeginDate())) {
            temp.setBeginDate(report.getBeginDate());
        }
        if (StringUtils.isNotBlank(report.getEndDate())) {
            temp.setEndDate(report.getEndDate());
        }
        Map<String, Object> map = publishedMonthlyReportDao.getExportList(temp);
        if (map != null && !map.isEmpty()) {
            String descPath = PropertyConfigurer.getValue("upload.temp.path") + "/双公示月报表统计.xls";
            try {
                File srcFile = new File(realPath);
                File descFile = new File(descPath);
                if (descFile.exists()) {
                    descFile.delete();
                }
                FileUtils.copyFile(srcFile, descFile);
                writeDataToFile(temp, map, descFile);
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }
            return descPath;
        }
        return null;
    }

    /**
     * 数据写入文件
     *
     * @param list
     * @param descFile
     */
    private void writeDataToFile(PublishedMonthlyReport report, Map<String, Object> map, File descFile)
            throws IOException, InvalidFormatException {
        Map<String, Object> sum = (Map<String, Object>) map.get("sum"); //  合计
        List<Map<String, Object>> descList = (List<Map<String, Object>>) map.get("descList");   //  部门列表
        List<Map<String, Object>> boardList = (List<Map<String, Object>>) map.get("boardList"); //  版块列表
        HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(descFile));
        HSSFSheet sheet = workbook.getSheet("双公示月报统计");
        HSSFRow row = sheet.getRow(0);
        HSSFCell cell = row.getCell(0);
        String beginDate = report.getBeginDate().replaceAll("-", "/");
        String endDate = report.getEndDate().replaceAll("-", "/");
        String title = "苏州市双公示工作" + beginDate + "-" + endDate + "数据统计表";
        cell.setCellValue(title);

        //创建字体
        HSSFFont font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);//字体大小
        //创建单元格样式
        HSSFCellStyle leftStyle = workbook.createCellStyle();
        leftStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);//水平
        leftStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//c垂直居中
        leftStyle.setFont(font);
        HSSFCellStyle centerStyle = workbook.createCellStyle();
        centerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);//水平
        centerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//c垂直居中
        centerStyle.setFont(font);
        HSSFCellStyle rightStyle = workbook.createCellStyle();
        rightStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);//水平
        rightStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);//c垂直居中
        rightStyle.setFont(font);

        HSSFRow row5 = sheet.getRow(5);
        //  行政许可合计
        HSSFCell row5cell2 = row5.createCell(2);
        row5cell2.setCellStyle(rightStyle);  //样式加到单元格中
        row5cell2.setCellValue(MapUtils.getString(sum, "XZXK_CSSL"));
        HSSFCell row5cell3 = row5.createCell(3);
        row5cell3.setCellStyle(rightStyle);
        row5cell3.setCellValue(MapUtils.getString(sum, "XZXK_BDWGSSL"));
        HSSFCell row5cell4 = row5.createCell(4);
        row5cell4.setCellStyle(rightStyle);
        row5cell4.setCellValue(MapUtils.getString(sum, "XZXK_BSSL"));
        HSSFCell row5cell5 = row5.createCell(5);
        row5cell5.setCellStyle(rightStyle);
        row5cell5.setCellValue(MapUtils.getString(sum, "XZXK_WBSSL"));
        HSSFCell row5cell7 = row5.createCell(7);
        row5cell7.setCellStyle(rightStyle);
        row5cell7.setCellValue(MapUtils.getString(sum, "XZXK_SIZE"));
        HSSFCell row5cell8 = row5.createCell(8);
        row5cell8.setCellStyle(rightStyle);
        row5cell8.setCellValue(MapUtils.getString(sum, "XZXK_SIZE"));
        //  行政处罚合计
        HSSFCell row5cell9 = row5.createCell(9);
        row5cell9.setCellStyle(rightStyle);
        row5cell9.setCellValue(MapUtils.getString(sum, "XZCF_CSSL"));
        HSSFCell row5cell10 = row5.createCell(10);
        row5cell10.setCellStyle(rightStyle);
        row5cell10.setCellValue(MapUtils.getString(sum, "XZCF_BDWGSSL"));
        HSSFCell row5cell11 = row5.createCell(11);
        row5cell11.setCellStyle(rightStyle);
        row5cell11.setCellValue(MapUtils.getString(sum, "XZCF_BSSL"));
        HSSFCell row5cell12 = row5.createCell(12);
        row5cell12.setCellStyle(rightStyle);
        row5cell12.setCellValue(MapUtils.getString(sum, "XZCF_WBSSL"));
        HSSFCell row5cell14 = row5.createCell(14);
        row5cell14.setCellStyle(rightStyle);
        row5cell14.setCellValue(MapUtils.getString(sum, "XZCF_SIZE"));
        HSSFCell row5cell15 = row5.createCell(15);
        row5cell15.setCellStyle(rightStyle);
        row5cell15.setCellValue(MapUtils.getString(sum, "XZCF_SIZE"));

        int rowIndex = 6;
        //  输入部门统计数据
        if (descList != null && !descList.isEmpty()) {
            for (Map<String, Object> desc : descList) {
                HSSFRow descRow = sheet.createRow(rowIndex);
                HSSFCell descCell0 = descRow.createCell(0);
                descCell0.setCellStyle(centerStyle);
                descCell0.setCellValue(MapUtils.getString(desc, "DEPT_NAME"));
                HSSFCell descCell1 = descRow.createCell(1);
                descCell1.setCellStyle(leftStyle);
                descCell1.setCellValue(MapUtils.getString(desc, "WEB_URL"));
                //  行政许可合计
                HSSFCell descCell2 = descRow.createCell(2);
                descCell2.setCellStyle(rightStyle);
                descCell2.setCellValue(MapUtils.getString(desc, "XZXK_CSSL"));
                HSSFCell descCell3 = descRow.createCell(3);
                descCell3.setCellStyle(rightStyle);
                descCell3.setCellValue(MapUtils.getString(desc, "XZXK_BDWGSSL"));
                HSSFCell descCell4 = descRow.createCell(4);
                descCell4.setCellStyle(rightStyle);
                descCell4.setCellValue(MapUtils.getString(desc, "XZXK_BSSL"));
                HSSFCell descCell5 = descRow.createCell(5);
                descCell5.setCellStyle(rightStyle);
                descCell5.setCellValue(MapUtils.getString(desc, "XZXK_WBSSL"));
                HSSFCell descCell6 = descRow.createCell(6);
                descCell6.setCellStyle(leftStyle);
                descCell6.setCellValue(MapUtils.getString(desc, "XZXK_WBSYJ"));
                HSSFCell desccell7 = descRow.createCell(7);
                desccell7.setCellStyle(rightStyle);
                desccell7.setCellValue(MapUtils.getString(desc, "XZXK_SIZE"));
                HSSFCell desccell8 = descRow.createCell(8);
                desccell8.setCellStyle(rightStyle);
                desccell8.setCellValue(MapUtils.getString(desc, "XZXK_SIZE"));
                //  行政处罚合计
                HSSFCell desccell9 = descRow.createCell(9);
                desccell9.setCellStyle(rightStyle);
                desccell9.setCellValue(MapUtils.getString(desc, "XZCF_CSSL"));
                HSSFCell desccell10 = descRow.createCell(10);
                desccell10.setCellStyle(rightStyle);
                desccell10.setCellValue(MapUtils.getString(desc, "XZCF_BDWGSSL"));
                HSSFCell desccell11 = descRow.createCell(11);
                desccell11.setCellStyle(rightStyle);
                desccell11.setCellValue(MapUtils.getString(desc, "XZCF_BSSL"));
                HSSFCell desccell12 = descRow.createCell(12);
                desccell12.setCellStyle(rightStyle);
                desccell12.setCellValue(MapUtils.getString(desc, "XZCF_WBSSL"));
                HSSFCell desccell13 = descRow.createCell(13);
                desccell13.setCellStyle(leftStyle);
                desccell13.setCellValue(MapUtils.getString(desc, "XZCF_WBSYJ"));
                HSSFCell desccell14 = descRow.createCell(14);
                desccell14.setCellStyle(rightStyle);
                desccell14.setCellValue(MapUtils.getString(desc, "XZCF_SIZE"));
                HSSFCell desccell15 = descRow.createCell(15);
                desccell15.setCellStyle(rightStyle);
                desccell15.setCellValue(MapUtils.getString(desc, "XZCF_SIZE"));

                rowIndex++;
            }
        }

        //  输出版块统计数据
        if (boardList != null && !boardList.isEmpty()) {
            for (Map<String, Object> board : boardList) {
                HSSFRow boardRow = sheet.createRow(rowIndex);
                HSSFCell boardCell0 = boardRow.createCell(0);
                boardCell0.setCellStyle(centerStyle);
                boardCell0.setCellValue(MapUtils.getString(board, "DEPT_NAME"));
                HSSFCell boardCell1 = boardRow.createCell(1);
                boardCell1.setCellStyle(leftStyle);
                boardCell1.setCellValue(MapUtils.getString(board, "WEB_URL"));
                //  行政许可合计
                HSSFCell boardCell2 = boardRow.createCell(2);
                boardCell2.setCellStyle(rightStyle);
                boardCell2.setCellValue(MapUtils.getString(board, "XZXK_CSSL"));
                HSSFCell boardCell3 = boardRow.createCell(3);
                boardCell3.setCellStyle(rightStyle);
                boardCell3.setCellValue(MapUtils.getString(board, "XZXK_BDWGSSL"));
                HSSFCell boardCell4 = boardRow.createCell(4);
                boardCell4.setCellStyle(rightStyle);
                boardCell4.setCellValue(MapUtils.getString(board, "XZXK_BSSL"));
                HSSFCell boardCell5 = boardRow.createCell(5);
                boardCell5.setCellStyle(rightStyle);
                boardCell5.setCellValue(MapUtils.getString(board, "XZXK_WBSSL"));
                HSSFCell boardCell6 = boardRow.createCell(6);
                boardCell6.setCellStyle(leftStyle);
                boardCell6.setCellValue(MapUtils.getString(board, "XZXK_WBSYJ"));
                HSSFCell boardcell7 = boardRow.createCell(7);
                boardcell7.setCellStyle(rightStyle);
                boardcell7.setCellValue(MapUtils.getString(board, "XZXK_SIZE"));
                HSSFCell boardcell8 = boardRow.createCell(8);
                boardcell8.setCellStyle(rightStyle);
                boardcell8.setCellValue(MapUtils.getString(board, "XZXK_SIZE"));
                //  行政处罚合计
                HSSFCell boardcell9 = boardRow.createCell(9);
                boardcell9.setCellStyle(rightStyle);
                boardcell9.setCellValue(MapUtils.getString(board, "XZCF_CSSL"));
                HSSFCell boardcell10 = boardRow.createCell(10);
                boardcell10.setCellStyle(rightStyle);
                boardcell10.setCellValue(MapUtils.getString(board, "XZCF_BDWGSSL"));
                HSSFCell boardcell11 = boardRow.createCell(11);
                boardcell11.setCellStyle(rightStyle);
                boardcell11.setCellValue(MapUtils.getString(board, "XZCF_BSSL"));
                HSSFCell boardcell12 = boardRow.createCell(12);
                boardcell12.setCellStyle(rightStyle);
                boardcell12.setCellValue(MapUtils.getString(board, "XZCF_WBSSL"));
                HSSFCell boardcell13 = boardRow.createCell(13);
                boardcell13.setCellStyle(leftStyle);
                boardcell13.setCellValue(MapUtils.getString(board, "XZCF_WBSYJ"));
                HSSFCell boardcell14 = boardRow.createCell(14);
                boardcell14.setCellStyle(rightStyle);
                boardcell14.setCellValue(MapUtils.getString(board, "XZCF_SIZE"));
                HSSFCell boardcell15 = boardRow.createCell(15);
                boardcell15.setCellStyle(rightStyle);
                boardcell15.setCellValue(MapUtils.getString(board, "XZCF_SIZE"));

                rowIndex++;
            }
        }

        FileOutputStream out = null;
        try {
            out = new FileOutputStream(descFile);
            workbook.write(out);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

}
