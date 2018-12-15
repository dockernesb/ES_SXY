package com.udatech.common.util;


import com.udatech.common.vo.ExcelExportVo2;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ExcelUtils3 {

    private static Logger logger = Logger.getLogger(ExcelUtils3.class);

    public static final int CLUMN_WIDTH_SET = 50;

    private ExcelUtils3() {
    }

    public static void excelExport2(HttpServletResponse response, ExcelExportVo2 vo) throws Exception {

        List<List<String>> values = new ArrayList<List<String>>();

        if (StringUtils.isNotEmpty(vo.getTitles1())
                && StringUtils.isNotEmpty(vo.getTitles2())
                && StringUtils.isNotEmpty(vo.getColumns())) {

            String[] titles1 = vo.getTitles1().split(",");
            String[] titles1spans = vo.getTitles1spans().split(",");
            String[] titles2 = vo.getTitles2().split(",");
            String[] columns = vo.getColumns().split(",");
            List<Map<String, Object>> list = vo.getList();

            if (titles1.length > 0 && titles1spans.length > 0 && titles2.length > 0 && columns.length > 0
                    && titles1.length == titles1spans.length && titles2.length == columns.length) {

                for (Map<String, Object> map : list) {
                    List<String> valueList = new ArrayList<String>();
                    for (int i = 0; i < columns.length; i++) {
                        String value = MapUtils.getString(map, columns[i], StringUtils.EMPTY);
                        valueList.add(value);
                    }
                    values.add(valueList);
                }

                String excelName = vo.getExcelName() + ".xlsx";
                String sheetName =
                        StringUtils.isNotBlank(vo.getSheetName()) ? vo.getSheetName() : "sheet01";

                response.reset();
                response.setHeader("Content-disposition",
                        "attachment;filename*=utf-8''" + URLEncoder.encode(excelName, "UTF-8") + ";filename=\""
                                + URLEncoder.encode(excelName, "UTF-8") + "\"");
                response.setContentType("application/vnd.ms-excel; charset=UTF-8");

                // 如果没有对每一列设定列宽，则默认自适应列宽
                if (StringUtils.isNotEmpty(vo.getCellWidths())) {
                    String[] cellWidths = vo.getCellWidths().split(",");
                    if (cellWidths.length != titles1.length) {
                        makeStreamExcel(sheetName, titles1, titles1spans, titles2, values, true, response.getOutputStream(), null);
                    } else {
                        makeStreamExcel(sheetName, titles1, titles1spans, titles2, values, false, response.getOutputStream(),
                                cellWidths);
                    }
                } else {
                    makeStreamExcel(sheetName, titles1, titles1spans, titles2, values, true, response.getOutputStream(), null);
                }
            }
        }

    }

    public static void makeStreamExcel(String sheetName, String[] titles1, String[] titles1spans, String[] titles2, List<List<String>> data, boolean isAutoWidth, OutputStream os, String[] cellWidths) {
        List<Integer> collength = new ArrayList();
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet();
        workbook.setSheetName(0, sheetName);

        XSSFCellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFillPattern((short) 1);
        titleStyle.setFillForegroundColor(IndexedColors.TAN.getIndex());
        XSSFFont font = workbook.createFont();
        font.setBoldweight((short) 700);
        titleStyle.setFont(font);
        XSSFCellStyle cellStyle = workbook.createCellStyle();

        /*
         * 设定合并单元格区域范围
         *  firstRow  0-based
         *  lastRow   0-based
         *  firstCol  0-based
         *  lastCol   0-based
         */
        CellRangeAddress cra1 = new CellRangeAddress(0, 0, 0, 3);
        CellRangeAddress cra2 = new CellRangeAddress(0, 0, 5, 6);

        //在sheet里增加合并单元格
        sheet.addMergedRegion(cra1);
        sheet.addMergedRegion(cra2);

        //  一级标题
        XSSFRow row0 = sheet.createRow(0);
        for (int i = 0; i < titles1.length; ++i) {
            XSSFCell cell = row0.createCell(i);
            cell.setCellType(1);
            cell.setCellStyle(titleStyle);
            cell.setCellValue(titles1[i]);
        }
        //  二级标题
        XSSFRow row1 = sheet.createRow(1);
        for (int i = 0; i < titles2.length; ++i) {
            XSSFCell cell = row1.createCell(i);
            cell.setCellType(1);
            cell.setCellStyle(titleStyle);
            cell.setCellValue(titles2[i]);
            if (cellWidths != null && cellWidths.length > 0 && Integer.valueOf(cellWidths[i]) > 0) {
                if (Integer.valueOf(cellWidths[i]) > 50) {
                    collength.add(Integer.valueOf(cellWidths[i]));
                } else {
                    collength.add(Integer.valueOf(cellWidths[i]));
                }
            } else if (isAutoWidth) {
                collength.add(titles2[i].getBytes().length);
            }
        }

        //  数据集
        String tempCellContent = "";

        int i;
        for (i = 0; i < data.size(); ++i) {
            List<String> tmpRow = (List) data.get(i);
            XSSFRow row = sheet.createRow(i + 2);

            for (int j = 0; j < tmpRow.size(); ++j) {
                XSSFCell cell = row.createCell(j);
                cell.setCellType(1);
                cell.setCellStyle(cellStyle);
                tempCellContent = tmpRow.get(j) == null ? "" : (String) tmpRow.get(j);
                cell.setCellValue(tempCellContent);
                if (isAutoWidth) {
                    if (j >= collength.size()) {
                        collength.add(tempCellContent.getBytes().length);
                    }

                    if ((Integer) collength.get(j) < tempCellContent.getBytes().length) {
                        collength.set(j, tempCellContent.getBytes().length);
                    }

                    if ((Integer) collength.get(j) > 50) {
                        collength.set(j, 50);
                    }
                }
            }
        }

        if (isAutoWidth || cellWidths.length > 0) {
            for (i = 0; i < titles2.length; ++i) {
                sheet.setColumnWidth(i, (int) ((double) (Integer) collength.get(i) * 1.3D * 256.0D));
            }
        }

        try {
            workbook.write(os);
        } catch (IOException var8) {
            logger.error(var8.getMessage(), var8);
        }

    }

    /**
     * @Description: 导出包含隐藏列
     * @param: @param response
     * @param: @param exportUtil
     * @param: @param list
     * @param: @throws Exception
     * @return: void
     * @throws
     * @since JDK 1.7.0_79
     */
    public static void excelExport3(HttpServletResponse response, ExcelExportVo2 exportUtil,
                                   List<Map<String, Object>> list, Map<String, Object> categoryMap) throws Exception {

        List<List<String>> values = new ArrayList<List<String>>();
        if (StringUtils.isNotEmpty(exportUtil.getTitles1()) && StringUtils.isNotEmpty(exportUtil.getColumns())) {
            String[] titles = exportUtil.getTitles1().split(",");
            String[] columns = exportUtil.getColumns().split(",");
            if (titles.length > 0 && columns.length > 0 && titles.length == columns.length) {
                for (Map<String, Object> map : list) {
                    List<String> valueList = new ArrayList<String>();
                    for (int i = 0; i < columns.length; i++) {
                        String value = MapUtils.getString(map, columns[i], StringUtils.EMPTY);
                        valueList.add(value);
                    }
                    values.add(valueList);
                }

                String excelName = exportUtil.getExcelName() + ".xlsx";
                String sheetName =
                        StringUtils.isNotBlank(exportUtil.getSheetName()) ? exportUtil.getSheetName() : "sheet01";

                response.reset();
                response.setHeader("Content-disposition",
                        "attachment;filename*=utf-8''" + URLEncoder.encode(excelName, "UTF-8") + ";filename=\""
                                + URLEncoder.encode(excelName, "UTF-8") + "\"");
                response.setContentType("application/vnd.ms-excel; charset=UTF-8");
                // 如果没有对每一列设定列宽，则默认自适应列宽
                if (StringUtils.isNotEmpty(exportUtil.getCellWidths())) {
                    String[] cellWidths = exportUtil.getCellWidths().split(",");
                    if (cellWidths.length != titles.length) {
                        makeStreamExcel2(sheetName, titles, values, true, response.getOutputStream(), null, exportUtil.getHiddenColumns(),
                                columns, categoryMap);
                    } else {
                        makeStreamExcel2(sheetName, titles, values, false, response.getOutputStream(),
                                cellWidths, exportUtil.getHiddenColumns(), columns, categoryMap);
                    }
                } else {
                    makeStreamExcel2(sheetName, titles, values, true, response.getOutputStream(), null, exportUtil.getHiddenColumns(), columns,
                            categoryMap);
                }
            }
        }

    }

    public static void makeStreamExcel2(String sheetName, String[] fieldName, List<List<String>> data, boolean isAutoWidth, OutputStream os,
                                        String[] cellWidth, List<Integer> hiddenColumns, String[] columns, Map<String, Object> categoryMap) {
        // 用来记录最大列宽,自动调整列宽。
        List<Integer> collength = new ArrayList<Integer>();
        // 使用兼容office2007和2003的格式来产生工作薄对象
        XSSFWorkbook workbook = new XSSFWorkbook();
        // 产生工作表对象
        XSSFSheet sheet = workbook.createSheet();
        // 设置工作簿名称
        workbook.setSheetName(0, sheetName);
        // 设置字体样式
        Font font = workbook.createFont();
        font.setColor(HSSFColor.GREEN.index); // 绿字
        XSSFCellStyle cellStyle = workbook.createCellStyle(); // 创建单元格样式
        cellStyle.setFont(font);

        XSSFRow row = sheet.createRow(0); // 创建Excel工作表的行（此处为第一行）

        Cell cell = row.createCell(2);
        cell.setCellStyle(cellStyle); // 创建Excel工作表指定行的单元格
        cell.setCellValue("departmentcode"); // 设置Excel工作表的值
        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("departmentname");
        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("tablecode");
        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("tablename");

        row = sheet.createRow(1);
        cell = row.createCell(2);
        cell.setCellStyle(cellStyle);
        cell.setCellValue(MapUtils.getString(categoryMap, "deptCode")); // 设置Excel工作表的值
        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue(MapUtils.getString(categoryMap, "deptName"));
        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue(MapUtils.getString(categoryMap, "tableCode"));
        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue(MapUtils.getString(categoryMap, "tableName"));
        row = sheet.createRow(2);
        cell.setCellStyle(cellStyle);

        // 隐藏列
        for (int i : hiddenColumns) {
            sheet.setColumnHidden(i, true);
        }

        row = sheet.createRow(2);

        for (int i = 0; i < columns.length; i++) {
            String column = columns[i];
                sheet.setColumnWidth(i, 5000);
                cell = row.createCell(i);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(column); // 设置Excel工作表的值

                XSSFDataValidationHelper helper = new XSSFDataValidationHelper(
                        sheet);
                XSSFDataValidationConstraint dvConstraint = (XSSFDataValidationConstraint) helper
                        .createCustomConstraint("A1");
                // 设置区域边界
                CellRangeAddressList addressList = new CellRangeAddressList(
                        4, 65536, i, i);
                XSSFDataValidation validation = (XSSFDataValidation) helper
                        .createValidation(dvConstraint, addressList);

                // 输入非法数据时，禁止弹窗警告框
                validation.setShowErrorBox(false);

                validation.setShowPromptBox(true);
                validation.setSuppressDropDownArrow(true);

                // 工作表添加验证数据
                sheet.addValidationData(validation);
        }

        row = sheet.createRow(3);

        // 写入各个字段的名称
        for (int i = 0; i < fieldName.length; i++) {
            // 创建第一行各个字段名称的单元格
            cell = row.createCell(i);
            // 设置单元格内容为字符串型
            cell.setCellType(HSSFCell.CELL_TYPE_STRING);
            // 设置单元格格式
            cell.setCellStyle(cellStyle);
            // 给单元格内容赋值
            cell.setCellValue(fieldName[i]);
            // 初始化列宽
            collength.add(fieldName[i].getBytes().length);
        }
        // 临时单元格内容
        String tempCellContent = "";
        // 写入各条记录,每条记录对应excel表中的一行
        for (int i = 0; i < data.size(); i++) {
            List<String> tmpRow = data.get(i);
            // 生成一行
            row = sheet.createRow(i + 4);
            for (int j = 0; j < tmpRow.size(); j++) {
                cell = row.createCell(j);
                // 设置单元格字符类型为String
                cell.setCellType(HSSFCell.CELL_TYPE_STRING);
                tempCellContent = (tmpRow.get(j) == null) ? "" : tmpRow.get(j);
                cell.setCellValue(tempCellContent);
                // 如果自动调整列宽度。
                if (isAutoWidth) {
                    // 数据列中的最大列数大于等于标题列的列数时
                    if (j >= collength.size()) {
                        collength.add(tempCellContent.getBytes().length);
                    }
                    // 如果这个内容的宽度大于之前最大的，就按照这个设置宽度。
                    if (collength.get(j) < tempCellContent.getBytes().length) {
                        collength.set(j, tempCellContent.getBytes().length);
                    }

                    // 如果这个内容的宽度大于50,就设置为50（防止过宽，大于255会报错）。
                    if (collength.get(j) > CLUMN_WIDTH_SET) {
                        collength.set(j, CLUMN_WIDTH_SET);
                    }
                }
            }
        }
        // 自动调整列宽度。
        if (isAutoWidth) {
            // 调整列为这列文字对应的最大宽度。
            for (int i = 0; i < fieldName.length; i++) {
                sheet.setColumnWidth(i, (int) (collength.get(i) * 1.3 * 256));
            }
        }

        try {
            workbook.write(os);
        } catch (IOException var8) {
            logger.error(var8.getMessage(), var8);
        }

    }

}
