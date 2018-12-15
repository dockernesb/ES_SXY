package com.udatech.common.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfGState;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;
import com.udatech.common.model.StReportFontSizeConfig;
import com.udatech.common.resourceManage.model.CreditTemplate;
import com.udatech.common.resourceManage.vo.TemplateThemeColumn;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.util.DateUtils;

/**
 * <描述>： 信用报告pdf生成器<br>
 * @author 创建人：Ljj<br>
 * @version 创建时间：2017年8月29日上午11:18:51
 */
public class CreditReportPdfMaker {

    private static Logger logger = Logger.getLogger(CreditReportPdfMaker.class);

    /**
     * <描述>: 生成信用报告pdf
     * @author 作者：Ljj
     * @version 创建时间：2017年8月29日上午11:45:46
     * @param parameterMap
     * @throws DocumentException
     * @throws IOException
     */
    public static void createPdf(Map<String, Object> parameterMap) throws DocumentException, IOException {
        // 生成pdf路径
        String genPath = (String) parameterMap.get("genPath");
        // 项目根路径
        String realPath = (String) parameterMap.get("realPath");
        // 信用报告编号
        String xybgbh = (String) parameterMap.get("xybgbh");
        // 生成信用报告类型：1 法人，2 自然人
        int reportType = MapUtils.getIntValue(parameterMap, "reportType", 0);

        String destPathTemp = genPath + "/" + xybgbh + "_temp.pdf";
        String destPath = genPath + "/" + xybgbh + ".pdf";

        // 中文处理
        BaseFont bfChinese = BaseFont.createFont(realPath + "template/simsun.ttc,0", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);

        Document document = new Document(PageSize.A4, 72, 72, 72, 72);
        PdfWriter pdfWriter = PdfWriter.getInstance(document, new FileOutputStream(destPathTemp));
        pdfWriter.setPageEvent(new PdfHeaderFooter(bfChinese));
        document.open();

        // 添加封面
        addCover(document, bfChinese, parameterMap);

        // 添加基本信息
        addBaseInfo(document, bfChinese, parameterMap, reportType);

        // 添加信用数据
        addCreditData(document, bfChinese, parameterMap);

        // 添加底部信息
        addFooter(document, bfChinese, parameterMap, reportType);

        // 生成pdf
        document.close();

        // PDF文件添加水印
        addWatermarkByImage(destPathTemp, destPath, parameterMap);

        // 删除临时pdf文件
        File pdfTemp = new File(destPathTemp);
        pdfTemp.delete();
    }

    /**
     * <描述>: 添加水印图片
     * @author 作者：Ljj
     * @version 创建时间：2017年9月4日上午9:56:06
     * @param inputPath
     * @param outputPath
     * @param parameterMap
     * @throws IOException
     * @throws DocumentException
     */
    public static void addWatermarkByImage(String inputPath, String outputPath, Map<String, Object> parameterMap) throws IOException,
                    DocumentException {
        // 默认模板的详细信息
        CreditTemplate template = (CreditTemplate) parameterMap.get("template");
        // 项目根路径
        String realPath = (String) parameterMap.get("realPath");
        // 水印图片路径
        String imgPath = realPath + "app/images/creditReport/" + template.getBgImg();
    	PdfReader reader = new PdfReader(inputPath);
    	PdfStamper stamp = new PdfStamper(reader, new FileOutputStream(outputPath));
    	// 判断是否设置了水印
    	File file = new File(imgPath);
    	if(file.exists()){
    		PdfGState gs1 = new PdfGState();
    		gs1.setFillOpacity(0.3f);
    		gs1.setAlphaIsShape(false);
    		gs1.setTextKnockout(false);
    		
    		Image image = Image.getInstance(imgPath);
    		image.setAbsolutePosition(0, 350);
    		// 设置图片的显示大小
    		image.scaleToFit(600, 900);
    		
    		int n = reader.getNumberOfPages();
    		for (int i = 1; i <= n; i++) {
    			PdfContentByte pdfContentByte = stamp.getOverContent(i);
    			pdfContentByte.setGState(gs1);
    			
    			pdfContentByte.addImage(image);
    		}
    	}
    	
    	stamp.close();
    	reader.close();
    }

    /**
     * <描述>: 添加报告底部信息
     * @author 作者：Ljj
     * @version 创建时间：2017年8月30日下午3:01:20
     * @param document
     * @param bfChinese
     * @param parameterMap
     * @param reportType
     * @throws DocumentException
     */
    private static void addFooter(Document document, BaseFont bfChinese, Map<String, Object> parameterMap, int reportType)
                    throws DocumentException {
        String reportTypeName = "";
        if (reportType == 1) {// 法人
            reportTypeName = "法人";
        } else if (reportType == 2) {// 自然人
            reportTypeName = "自然人";
        }

        // 字体大小
        StReportFontSizeConfig fontSize = (StReportFontSizeConfig) parameterMap.get("fontSize");
        fontSize = fontSize == null ? new StReportFontSizeConfig() : fontSize;

        // 默认模板的详细信息
        CreditTemplate template = (CreditTemplate) parameterMap.get("template");

        Paragraph footer = new Paragraph("    社会" + reportTypeName + "信用基础数据库信息来源于省、市有关政府部门。有何问题，请与我们联系。地址：" + template.getAddress()
                        + "，电话：" + template.getContactPhone() + "，联系人：" + template.getContact() + "。", new Font(bfChinese,
                        fontSize.getMainBody()));
        footer.setAlignment(Element.ALIGN_LEFT);
        document.add(footer);

        // 添加注释信息
        footer = new Paragraph("注：", new Font(bfChinese, 11, Font.BOLD));
        footer.setAlignment(Element.ALIGN_LEFT); // 居中设置
        footer.setSpacingBefore(15f);
        footer.add(new Phrase("1、黑色斜体加删除线的数据，表示该信用数据已发起信用修复申请但尚未处理完成。", new Font(bfChinese, 11, Font.BOLD)));
        document.add(footer);

        footer = new Paragraph("    2、黑色粗斜体的数据，表示该信用数据已发起异议申诉申请但尚未处理完成。", new Font(bfChinese, 11, Font.BOLD));
        footer.setAlignment(Element.ALIGN_LEFT); // 居中设置
        document.add(footer);
    }

    /**
     * <描述>: 添加企业信用数据
     * @author 作者：Ljj
     * @version 创建时间：2017年8月29日下午8:54:16
     * @param document
     * @param bfChinese
     * @param parameterMap
     * @throws DocumentException
     */
    private static void addCreditData(Document document, BaseFont bfChinese, Map<String, Object> parameterMap) throws DocumentException {
        // 信用数据信息
        @SuppressWarnings("unchecked")
        List<TemplateThemeNode> themeInfo = (List<TemplateThemeNode>) parameterMap.get("themeInfo");

        // 字体大小
        StReportFontSizeConfig fontSize = (StReportFontSizeConfig) parameterMap.get("fontSize");
        fontSize = fontSize == null ? new StReportFontSizeConfig() : fontSize;

        if (themeInfo != null && themeInfo.size() > 0) {
            for (int i = 0; i < themeInfo.size(); i++) {
                TemplateThemeNode themeOne = themeInfo.get(i);
                String titleNum = getTitleNum(i);
                Paragraph desc = new Paragraph(titleNum + themeOne.getText(), new Font(bfChinese, fontSize.getMainBodyTitle(), Font.BOLD));
                desc.setAlignment(Element.ALIGN_LEFT);
                desc.setSpacingBefore(30f);
                document.add(desc);
                List<TemplateThemeNode> children = themeOne.getChildren();
                for (int j = 0; j < children.size(); j++) {
                    TemplateThemeNode themeTwo = children.get(j);
                    // 加载表格头描述
                    desc = new Paragraph((j + 1) + "、" + themeTwo.getText(), new Font(bfChinese, fontSize.getMainBodyTitle()));
                    desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
                    desc.setSpacingBefore(12f);
                    document.add(desc);

                    List<TemplateThemeColumn> columns = themeTwo.getColumns();
                    // 加载表格
                    PdfPTable table = new PdfPTable(columns.size());// 建立一个pdf表格
                    table.setSpacingBefore(10f);// 设置表格上面空白宽度
                    table.setTotalWidth(720);// 设置表格的宽度
                    table.setWidthPercentage(100);// 设置表格宽度为%100

                    // 加载表头
                    for (TemplateThemeColumn column : columns) {
                        PdfPCell cell = new PdfPCell(new Phrase(column.getColumnAlias(), new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
                        cell.setPadding(5f);
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
                        table.addCell(cell);
                    }

                    // 加载表格数据
                    List<Map<String, Object>> data = themeTwo.getData();
                    if (data != null && data.size() > 0) {
                        boolean isAllUnchecked = true;// 是否某个表格的数据全部未勾选
                        for (Map<String, Object> map : data) {
                            if (MapUtils.getBoolean(map, "checked", true)) {
                                isAllUnchecked = false;
                                break;
                            }
                        }

                        // 若是某个表格的数据全部未勾选，则生成一条暂无数据的记录
                        if (isAllUnchecked) {
                            for (@SuppressWarnings("unused")
                            TemplateThemeColumn column : columns) {
                                PdfPCell cell = new PdfPCell(new Phrase("暂无数据", new Font(bfChinese, fontSize.getTd())));
                                cell.setPadding(5f);
                                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                                cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
                                table.addCell(cell);
                            }
                        } else {
                            for (Map<String, Object> map : data) {
                                if (!MapUtils.getBoolean(map, "checked", true)) {
                                    // 审核时未勾选的数据，不生成在信用报告中
                                    continue;
                                }

                                for (TemplateThemeColumn column : columns) {
                                    Object value = MapUtils.getObject(map, column.getColumnName(), null);
                                    String columnValue = "";
                                    if (value != null) {
                                        if (value instanceof Date) {
                                            columnValue = new SimpleDateFormat(DateUtils.YYYYMMDD_10).format(value);
                                        } else {
                                            columnValue = String.valueOf(value);
                                        }
                                    }

                                    Font font = new Font(bfChinese, fontSize.getTd());
                                    // 信用修复数据，斜体加删除线展示
                                    String status = MapUtils.getString(map, "STATUS");
                                    if ("2".equals(status)) {
                                        font = new Font(bfChinese, fontSize.getTd(), Font.ITALIC | Font.STRIKETHRU);
                                    } else {
                                        // 争议中的数据（是指该数据正在异议申诉申请处理中，但尚未处理完成的数据）
                                        Boolean isObjection = MapUtils.getBoolean(map, "isObjection", false);
                                        if (isObjection) {
                                            // 争议中数据，红色斜体展示
                                            font = new Font(bfChinese, fontSize.getTd(), Font.BOLDITALIC);
                                        }
                                        // 修复中的数据（是指该数据正在信用修复申请处理中，但尚未处理完成的数据）
                                        Boolean isRepair = MapUtils.getBoolean(map, "isRepair", false);
                                        if (isRepair) {
                                            // 修复中的数据，斜体加删除线展示
                                            font = new Font(bfChinese, fontSize.getTd(), Font.ITALIC | Font.STRIKETHRU);
                                        }
                                    }

                                    // 初始化单元格
                                    PdfPCell cell = new PdfPCell(new Phrase(columnValue, font));
                                    cell.setPadding(5f);
                                    cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                                    cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
                                    table.addCell(cell);
                                }
                            }
                        }

                    } else {
                        for (@SuppressWarnings("unused")
                        TemplateThemeColumn column : columns) {
                            PdfPCell cell = new PdfPCell(new Phrase("暂无数据", new Font(bfChinese, fontSize.getTd())));
                            cell.setPadding(5f);
                            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
                            table.addCell(cell);
                        }
                    }

                    document.add(table);
                }
            }
        }
    }

    /**
     * <描述>: 获取中文编号
     * @author 作者：Ljj
     * @version 创建时间：2017年8月29日下午9:02:44
     * @param i
     * @return
     */
    private static String getTitleNum(int i) {
        i = i + 2;
        String num = "";
        switch (i) {
        case 2:
            num = "二、";
            break;
        case 3:
            num = "三、";
            break;
        case 4:
            num = "四、";
            break;
        case 5:
            num = "五、";
            break;
        case 6:
            num = "六、";
            break;
        case 7:
            num = "七、";
            break;
        case 8:
            num = "八、";
            break;
        case 9:
            num = "九、";
            break;
        case 10:
            num = "十、";
            break;
        case 11:
            num = "十一、";
            break;
        case 12:
            num = "十二、";
            break;
        case 13:
            num = "十三、";
            break;
        case 14:
            num = "十四、";
            break;
        case 15:
            num = "十五、";
            break;
        case 16:
            num = "十六、";
            break;
        case 17:
            num = "十七、";
            break;
        default:
            break;
        }

        return num;
    }

    /**
     * <描述>: 添加企业基本信息
     * @author 作者：Ljj
     * @version 创建时间：2017年8月29日下午8:54:26
     * @param document
     * @param bfChinese
     * @param parameterMap
     * @param reportType
     * @throws DocumentException
     */
    private static void addBaseInfo(Document document, BaseFont bfChinese, Map<String, Object> parameterMap, int reportType)
                    throws DocumentException {
        // 字体大小
        StReportFontSizeConfig fontSize = (StReportFontSizeConfig) parameterMap.get("fontSize");
        fontSize = fontSize == null ? new StReportFontSizeConfig() : fontSize;
        if (reportType == 1) {// 法人
            // 企业基本信息
            @SuppressWarnings("unchecked")
            Map<String, Object> qyxx = MapUtils.getMap(parameterMap, "qyxx", Collections.EMPTY_MAP);
            // 查询日期
            String queryDate = (String) parameterMap.get("queryDate");

            String KSSJ = (String) qyxx.get("KSSJ");
            String JSSJ = (String) qyxx.get("JSSJ");

            String descTitle = "";
            if (StringUtils.isNotBlank(KSSJ) && StringUtils.isNotBlank(JSSJ)) {
                KSSJ = KSSJ.substring(0, 7);
                JSSJ = JSSJ.substring(0, 7);
                descTitle = "    根据" + MapUtils.getString(qyxx, "JGQC", "") + "提出查询信用信息的申请，我中心在社会法人信用基础数据库进行查询，统计数据时间段为" + KSSJ + "到"
                                + JSSJ + "，结果如下：";
            } else {
                descTitle = "    根据" + MapUtils.getString(qyxx, "JGQC", "") + "提出查询信用信息的申请，我中心在社会法人信用基础数据库进行查询，截止" + queryDate + "，结果如下：";
            }

            Paragraph desc = new Paragraph(descTitle, new Font(bfChinese, fontSize.getMainBody()));
            desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
            desc.setSpacingBefore(55f);
            document.add(desc);

            desc = new Paragraph("一、基本信息", new Font(bfChinese, fontSize.getMainBodyTitle(), Font.BOLD));
            desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
            desc.setSpacingBefore(40f);
            document.add(desc);

            desc = new Paragraph("1、注册登记信息", new Font(bfChinese, fontSize.getMainBodyTitle()));
            desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
            desc.setSpacingBefore(15f);
            document.add(desc);

            // 基本信息的表格
            float[] columns = {30f, 70f};// 设置表格的列宽和列数
            PdfPTable table = new PdfPTable(columns);// 建立一个pdf表格
            table.setSpacingBefore(10f);// 设置表格上面空白宽度
            table.setTotalWidth(720);// 设置表格的宽度
            table.setWidthPercentage(100);// 设置表格宽度为%100

            PdfPCell cell = null;
            cell = new PdfPCell(new Phrase("企业名称", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "JGQC", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("工商注册号", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "GSZCH", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("组织机构代码", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "ZZJGDM", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("统一社会信用代码", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "TYSHXYDM", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("注册资本", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(new Phrase(MapUtils.getString(qyxx, "ZCZJ", "0") + "万", new Font(bfChinese, fontSize.getTd()))));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("注册日期", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "FZRQ", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("法定代表人", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "FDDBRXM", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("登记机关", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "FZJGMC", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("所属行业名称", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "SSHYMC", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("企业类型", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "QYLXMC", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("经营范围", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "JYFW", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("企业地址", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(qyxx, "JGDZ", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            document.add(table);
        } else if (reportType == 2) {// 自然人
            // 个人基本信息
            @SuppressWarnings("unchecked")
            Map<String, Object> grxx = MapUtils.getMap(parameterMap, "grxx", Collections.EMPTY_MAP);
            @SuppressWarnings("unchecked")
            Map<String, Object> zrrxx = MapUtils.getMap(parameterMap, "zrrxx", Collections.EMPTY_MAP);
            // 查询日期
            String queryDate = (String) parameterMap.get("queryDate");

            String KSSJ = (String) grxx.get("kssj");
            String JSSJ = (String) grxx.get("jssj");

            String descTitle = "";
            if (StringUtils.isNotBlank(KSSJ) && StringUtils.isNotBlank(JSSJ)) {
                KSSJ = KSSJ.substring(0, 7);
                JSSJ = JSSJ.substring(0, 7);
                descTitle = "    根据" + MapUtils.getString(grxx, "name", "") + "提出查询信用信息的申请，我中心在社会自然人信用基础数据库进行查询，统计数据时间段为" + KSSJ + "到"
                                + JSSJ + "，结果如下：";
            } else {
                descTitle = "    根据" + MapUtils.getString(grxx, "name", "") + "提出查询信用信息的申请，我中心在社会自然人信用基础数据库进行查询，截止" + queryDate + "，结果如下：";
            }

            Paragraph desc = new Paragraph(descTitle, new Font(bfChinese, fontSize.getMainBody()));
            desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
            desc.setSpacingBefore(54f);
            document.add(desc);

            desc = new Paragraph("一、基本信息", new Font(bfChinese, fontSize.getMainBodyTitle(), Font.BOLD));
            desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
            desc.setSpacingBefore(40f);
            document.add(desc);

            desc = new Paragraph("1、个人信息", new Font(bfChinese, fontSize.getMainBodyTitle()));
            desc.setAlignment(Element.ALIGN_LEFT); // 居中设置
            desc.setSpacingBefore(15f);
            document.add(desc);

            // 基本信息的表格
            float[] columns = {30f, 70f};// 设置表格的列宽和列数
            PdfPTable table = new PdfPTable(columns);// 建立一个pdf表格
            table.setSpacingBefore(10f);// 设置表格上面空白宽度
            table.setTotalWidth(720);// 设置表格的宽度
            table.setWidthPercentage(100);// 设置表格宽度为%100

            PdfPCell cell = null;
            cell = new PdfPCell(new Phrase("姓名", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(grxx, "name", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("身份证号", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(MapUtils.getString(grxx, "idCard", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("性别", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(MapUtils.getString(zrrxx, "XB", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("民族", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(MapUtils.getString(zrrxx, "MZ", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("所属行业", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(MapUtils.getString(zrrxx, "SSHY", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("出生日期", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(MapUtils.getString(zrrxx, "CSRQ", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("户籍地址", new Font(bfChinese, fontSize.getTh(), Font.BOLD)));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(MapUtils.getString(zrrxx, "HJDZ", ""), new Font(bfChinese, fontSize.getTd())));
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
            table.addCell(cell);
            
            document.add(table);
        }
    }

    /**
     * <描述>: 设置信用报告封面
     * @author 作者：Ljj
     * @version 创建时间：2017年8月29日下午8:54:35
     * @param document
     * @param bfChinese
     * @param parameterMap
     * @throws DocumentException
     */
    private static void addCover(Document document, BaseFont bfChinese, Map<String, Object> parameterMap) throws DocumentException {
        // 信用报告编号
        String xybgbh = (String) parameterMap.get("xybgbh");
        // 查询日期
        String queryDate = (String) parameterMap.get("queryDate");
        // 默认模板的详细信息
        CreditTemplate template = (CreditTemplate) parameterMap.get("template");
        // 字体大小
        StReportFontSizeConfig fontSize = (StReportFontSizeConfig) parameterMap.get("fontSize");
        fontSize = fontSize == null ? new StReportFontSizeConfig() : fontSize;

        Paragraph cover = new Paragraph(" 编号:", new Font(bfChinese, fontSize.getCoverBgbh()));
        cover.setLeading(54f);
        cover.add(new Phrase(xybgbh, new Font(bfChinese, fontSize.getCoverBgbh() - 1, Font.BOLD)));
        document.add(cover);

        cover = new Paragraph(template.getTitle(), new Font(bfChinese, fontSize.getCoverTitle(), Font.BOLD));
        cover.setAlignment(Element.ALIGN_CENTER); // 居中设置
        cover.setSpacingBefore(110f);
        document.add(cover);

        cover = new Paragraph("查询报告", new Font(bfChinese, fontSize.getCoverTitle(), Font.BOLD));
        cover.setAlignment(Element.ALIGN_CENTER); // 居中设置
        cover.setSpacingBefore(12f);
        document.add(cover);

        cover = new Paragraph(template.getReportSource() + "（签章）", new Font(bfChinese, fontSize.getCoverSign(), Font.BOLD));
        cover.setAlignment(Element.ALIGN_CENTER); // 居中设置
        cover.setSpacingBefore(250f);
        document.add(cover);

        cover = new Paragraph("查询日期： " + queryDate, new Font(bfChinese, fontSize.getCoverDate()));
        cover.setAlignment(Element.ALIGN_CENTER); // 居中设置
        cover.setSpacingBefore(24f);
        cover.setSpacingAfter(24f);
        document.add(cover);
    }

    /**
     * <描述>: PDF添加水印文字
     * @author 作者：Ljj
     * @version 创建时间：2017年8月29日下午12:33:36
     * @param pdfStamper
     * @param waterMarkName
     * @param basePath
     */
    public static void addWatermark(PdfStamper pdfStamper, String waterMarkName, String realPath) {
        PdfContentByte content = null;
        BaseFont base = null;
        Rectangle pageRect = null;
        PdfGState gs = new PdfGState();
        try {
            // 设置字体
            base = BaseFont.createFont(realPath + "template/simsun.ttc,0", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        } catch (Exception e) {
            logger.error("BaseFont.createFont方法异常：", e);
        }
        try {
            if (base == null || pdfStamper == null) {
                return;
            } // 设置透明度为0.2
            gs.setFillOpacity(0.2f);
            gs.setStrokeOpacity(0.2f);
            int toPage = pdfStamper.getReader().getNumberOfPages();
            for (int i = 1; i <= toPage; i++) {
                pageRect = pdfStamper.getReader().getPageSizeWithRotation(i); // 计算水印X,Y坐标
                float x = pageRect.getWidth() / 2;
                float y = pageRect.getHeight() / 2; // 获得PDF最顶层
                content = pdfStamper.getOverContent(i);
                content.saveState(); // set Transparency
                content.setGState(gs);
                content.beginText();
                content.setColorFill(BaseColor.GRAY);
                content.setFontAndSize(base, 60); // 水印文字成45度角倾斜
                content.showTextAligned(Element.ALIGN_CENTER, waterMarkName, x, y, 45);
                content.endText();
            }
        } catch (Exception e) {
            logger.error("添加水印操作异常：", e);
        }
    }
}
