package centling.business;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import jxl.SheetSettings;
import jxl.format.Alignment;
import jxl.format.PageOrientation;
import jxl.format.PaperSize;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Formula;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableImage;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import centling.util.BlDateUtil;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Member;

public class BlExcelHelper {
	public static void exportExcel(ArrayList<String> headerlist,
			List<List<String>> cells, WritableWorkbook wwb, String listName)
			throws IOException, WriteException {

		jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
		jxl.write.Label labTable = null;
		// 定义头部单元格样式
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.WHITE);
		WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
		wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
		wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

		// 定义单元格样式
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wcf2 = new WritableCellFormat(wf2); // 单元格定义
		wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

		for (int i = 0; i < headerlist.size(); i++) {
			labTable = new jxl.write.Label(i, 0, headerlist.get(i), wcf);
			ws.setColumnView(0, 10);
			ws.setColumnView(i + 1, 20);
			ws.setRowView(0, 300);
			ws.addCell(labTable);
		}

		for (int i = 0; i < cells.size(); i++) {
			List<String> tempList = cells.get(i);
			if (tempList != null && tempList.size() > 0) {
				for (int j = 0; j < tempList.size(); j++) {
					labTable = new jxl.write.Label(j, i + 1, tempList.get(j),
							wcf2);
					ws.addCell(labTable);
				}

			}

		}
		wwb.write();
		wwb.close();
	}

	public static void exportExcelInspection(List<List<String>> cells,
			WritableWorkbook wwb, String listName) throws IOException,
			WriteException {
		// List<String> footerlist =headerlist;

		jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
		jxl.write.Label labTable = null;
		SheetSettings setting = ws.getSettings();

		/** */
		/** ********* 打印属性 **************** */
		setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
		setting.setPaperSize(PaperSize.A4); // 设置纸张
		setting.setFitHeight(1); // 打印区高度
		setting.setFitWidth(1); // 打印区宽度
		// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
		setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
		// setting.setScaleFactor(100);// 设置缩放比例

		// 设置列宽
		ws.setColumnView(0, 11); // 第1列
		ws.setColumnView(1, 17); // 第2列
		ws.setColumnView(2, 23);
		ws.setColumnView(3, 24);
		ws.setColumnView(4, 20);
		ws.setColumnView(5, 10);

		// 定义头部单元格样式
		WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 16,
				WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
		wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wctf.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,
				jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
		wctf1.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctf1.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
		wctf1.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,
				jxl.format.Colour.BLACK);
		wctf1.setWrap(true);// 设置自动换行

		// 定义头部单元格样式
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf2 = new WritableCellFormat(wf2); // 单元格定义
		wctf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wctf2.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
		wctf2.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,
				jxl.format.Colour.BLACK);
		wctf1.setWrap(true);// 设置自动换行

		ws.mergeCells(0, 0, 3, 0); // 合并单元格
		ws.mergeCells(0, 1, 3, 1); // 合并单元格
		ws.mergeCells(1, 2, 3, 2); // 合并单元格
		ws.mergeCells(1, 3, 3, 3); // 合并单元格
		ws.addCell(new jxl.write.Label(0, 0, "厂检通知", wctf));
		ws.addCell(new jxl.write.Label(0, 1, "请质检部按以下要求填写《青岛地区出口服装厂检合格单》一份。",
				wctf2));
		ws.addCell(new jxl.write.Label(0, 2, "客户名称", wctf1));
		ws.addCell(new jxl.write.Label(1, 2, "MSB", wctf2));
		ws.addCell(new jxl.write.Label(0, 3, "厂名", wctf1));
		ws.addCell(new jxl.write.Label(1, 3, "青岛红领制衣有限公司", wctf1));
		ws.addCell(new jxl.write.Label(0, 4, "商品名称", wctf1));
		ws.addCell(new jxl.write.Label(1, 4, "", wctf1));
		ws.addCell(new jxl.write.Label(2, 4, "合同号", wctf1));
		ws.addCell(new jxl.write.Label(3, 4, "GJ111029", wctf1));
		ws.addCell(new jxl.write.Label(0, 5, "货/款号", wctf1));
		ws.addCell(new jxl.write.Label(1, 5, "", wctf1));
		ws.addCell(new jxl.write.Label(2, 5, "输往国别", wctf1));
		ws.addCell(new jxl.write.Label(3, 5, "美国", wctf1));
		ws.addCell(new jxl.write.Label(0, 6, "数量", wctf1));
		ws.addCell(new jxl.write.Label(1, 6, "1箱20件", wctf1));
		ws.addCell(new jxl.write.Label(2, 6, "颜色", wctf1));
		ws.addCell(new jxl.write.Label(3, 6, "", wctf1));
		ws.addCell(new jxl.write.Label(0, 7, "经营单位", wctf1));
		ws.addCell(new jxl.write.Label(1, 7, "青岛凯妙服饰股份有限公司", wctf1));
		ws.addCell(new jxl.write.Label(2, 7, "备注", wctf1));
		ws.addCell(new jxl.write.Label(3, 7, "12.10发", wctf1));
		ws.addCell(new jxl.write.Label(0, 8, "完成时间", wctf1));
		ws.addCell(new jxl.write.Label(1, 8, "", wctf1));
		ws.addCell(new jxl.write.Label(2, 8, "业务员签字", wctf1));
		ws.addCell(new jxl.write.Label(3, 8, "解海州", wctf1));

		ws.addCell(new jxl.write.Label(4, 0, "", wctf1));
		ws.addCell(new jxl.write.Label(5, 0, "", wctf1));
		for (int i = 0; i < cells.size(); i++) {
			List<String> tempList = cells.get(i);
			if (tempList != null && tempList.size() > 0) {
				for (int j = 0; j < tempList.size(); j++) {
					labTable = new jxl.write.Label(j + 4, i + 1,
							tempList.get(j), wctf2);
					ws.addCell(labTable);
				}
			}
		}

		wwb.write();
		wwb.close();
	}

	/**
	 * 导出发货明细
	 * 
	 * @param headMap
	 *            表头
	 * @param cells
	 *            数据
	 * @param wwb
	 *            工作表
	 * @param listName
	 *            sheet页名称
	 * @throws IOException
	 * @throws WriteException
	 */
	public static void exportExcelDelivery(Map<String, String> headMap,
			List<List<String>> cells, WritableWorkbook wwb, String listName)
			throws IOException, WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
		jxl.write.Label labTable = null;
		SheetSettings setting = ws.getSettings();

		/** */
		/** ********* 打印属性 **************** */
		setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
		setting.setPaperSize(PaperSize.A4); // 设置纸张
		setting.setFitHeight(1); // 打印区高度
		setting.setFitWidth(1); // 打印区宽度
		// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
		setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
		// setting.setScaleFactor(100);// 设置缩放比例

		// 设置列宽
		ws.setColumnView(0, 10); // 第1列
		ws.setColumnView(1, 19); // 第2列
		ws.setColumnView(2, 12);
		ws.setColumnView(3, 19);
		ws.setColumnView(4, 10);
		ws.setColumnView(5, 10);
		ws.setColumnView(6, 10);

		// 定义头部单元格样式
		WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 16,
				WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
		wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wctf.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wctf.setBorder(jxl.format.Border.TOP,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wctf.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
		wctf1.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

		// 定义头部单元格样式
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf2 = new WritableCellFormat(wf2); // 单元格定义
		wctf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

		// 定义头部单元格样式
		WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf3 = new WritableCellFormat(wf3); // 单元格定义
		wctf3.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctf3.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wctf3.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wctf3.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf30 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf30 = new WritableCellFormat(wf30); // 单元格定义
		wctf30.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctf30.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
					
		// 定义头部单元格样式
		WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf4 = new WritableCellFormat(wf4); // 单元格定义
		wctf4.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctf4.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wctf4.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf4.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf5 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf5 = new WritableCellFormat(wf5); // 单元格定义
		wctf5.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wctf5.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf5.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf5.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf6 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf6 = new WritableCellFormat(wf6); // 单元格定义
		wctf6.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctf6.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf6.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf6.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf7 = new WritableFont(WritableFont.ARIAL, 11,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf7 = new WritableCellFormat(wf7); // 单元格定义
		wctf7.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

		// 定义头部单元格样式
		WritableFont wf8 = new WritableFont(WritableFont.ARIAL, 11,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf8 = new WritableCellFormat(wf8); // 单元格定义
		wctf8.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wctf8.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);

		// 定义头部单元格样式
		WritableFont wf9 = new WritableFont(WritableFont.ARIAL, 9,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf9 = new WritableCellFormat(wf9); // 单元格定义
		wctf9.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		
		// 定义头部单元格样式
		WritableFont wf10 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf10 = new WritableCellFormat(wf10); // 单元格定义
		wctf10.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wctf10.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wctf10.setBorder(jxl.format.Border.BOTTOM, jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		
		// 定义图片单元格样式
		WritableFont wfImge = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctfImge = new WritableCellFormat(wfImge); // 单元格定义
		wctfImge.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctfImge.setBorder(jxl.format.Border.TOP,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctfImge.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		
		// 定义头部单元格样式
		WritableFont wf11 = new WritableFont(WritableFont.ARIAL, 12,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wctf11 = new WritableCellFormat(wf11); // 单元格定义
		wctf11.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
		wctf11.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf11.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		wctf11.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
		
//		double cellSize = Math.ceil(cells.size() / 22.0);
		int m = 0;
	//	for (int m = 0; m < cellSize; m++) {
			// 插入图片
			ws.setRowView(0 + m * 37, 400);
			File fileImage = new File(
					System.getProperty("user.dir")
							.replaceAll("bin",
									"webapps/hongling/themes/default/images/DeliveryDetailTitle.png"));
			WritableImage image = new WritableImage(0, 0 + m * 37, 2, 1,
					fileImage);// 从A1开始 跨2行3个单元格
			ws.addImage(image);//

			ws.addCell(new jxl.write.Label(0, 1 + m * 37, "修改状态：", wctf1));
			ws.addCell(new jxl.write.Label(1, 1 + m * 37, "01", wctf1));
			ws.addCell(new jxl.write.Label(6, 1 + m * 37, "NO:0405", wctf2));

			ws.mergeCells(0, 2 + m * 37, 6, 2 + m * 37); // 合并单元格
			ws.addCell(new jxl.write.Label(0, 2 + m * 37, "MTM 发货明细", wctf));

			ws.mergeCells(0, 3 + m * 37, 6, 3 + m * 37); // 合并单元格
			ws.addCell(new jxl.write.Label(0, 3 + m * 37, "发出部门：国际业务部", wctf3));

			ws.setRowView(4 + m * 37, 600);
			ws.addCell(new jxl.write.Label(0, 4 + m * 37, "客户名称", wctf4));
			ws.addCell(new jxl.write.Label(1, 4 + m * 37, headMap.get("pubMemberName"), wctf5));
			ws.addCell(new jxl.write.Label(2, 4 + m * 37, "发货日期：", wctf5));
			ws.addCell(new jxl.write.Label(3, 4 + m * 37, headMap
					.get("deliveryDate"), wctf5));
			ws.addCell(new jxl.write.Label(4, 4 + m * 37, "业务员", wctf5));
			ws.mergeCells(5, 4 + m * 37, 6, 4 + m * 37); // 合并单元格
			ws.addCell(new jxl.write.Label(5, 4 + m * 37, headMap.get("bizPerson"), wctf10));

			ws.setRowView(5 + m * 37, 600);
			ws.addCell(new jxl.write.Label(0, 5 + m * 37, "序号", wctf4));
			ws.addCell(new jxl.write.Label(1, 5 + m * 37, "订单号", wctf11));
			ws.addCell(new jxl.write.Label(2, 5 + m * 37, "数量", wctf5));
			ws.addCell(new jxl.write.Label(3, 5 + m * 37, "面料成份", wctf5));
			ws.addCell(new jxl.write.Label(4, 5 + m * 37, "男装/女装", wctf5));
			ws.addCell(new jxl.write.Label(5, 5 + m * 37, "箱号", wctf5));
			ws.addCell(new jxl.write.Label(6, 5 + m * 37, "备注", wctf6));

			for (int i = 0; i < cells.size(); i++) {
				if (i + m * 22 > cells.size() - 1) {
					for (int j = 0; j < 7; j++) {
						if (j == 0) {
							labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf4);
						} else if (j==1) {
							labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf11);
						} else if (j == 6) {
							labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf6);
						} else {
							labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf5);
						}
						ws.setRowView(i + 6 + m * 37, 400);
						ws.addCell(labTable);
					}
				} else {
					List<String> tempList = cells.get(i + m * 22);
					if (tempList != null && tempList.size() > 0) {
						for (int j = 0; j < tempList.size(); j++) {
							if (j == 0) {
								labTable = new jxl.write.Label(j, i + 6 + m
										* 37, tempList.get(j), wctf4);
							} else if (j==1) {
								labTable = new jxl.write.Label(j, i + 6 + m * 37,tempList.get(j), wctf11);
							} else if (j == 6) {
								labTable = new jxl.write.Label(j, i + 6 + m
										* 37, tempList.get(j), wctf6);
							} else {
								labTable = new jxl.write.Label(j, i + 6 + m
										* 37, tempList.get(j), wctf5);
							}
							ws.setRowView(i + 6 + m * 37, 400);
							ws.addCell(labTable);
						}
					}
				}
				ws.mergeCells(0, cells.size()+6 + m * 37, 6, cells.size()+6 + m * 37); // 合并单元格
				//ws.mergeCells(0, 29 + m * 37, 6, 29 + m * 37); // 合并单元格
				ws.addCell(new jxl.write.Label(0, cells.size()+6 + m * 37, "包装要求", wctf));
				ws.mergeCells(0, cells.size()+7 + m * 37, 6, cells.size()+7 + m * 37); // 合并单元格
				ws.addCell(new jxl.write.Label(0, cells.size()+7 + m * 37, headMap.get("memo"), wctf3));
				ws.addCell(new jxl.write.Label(7, cells.size()+6 + m * 37, "", wctf30));
				ws.addCell(new jxl.write.Label(7, cells.size()+7 + m * 37, "", wctf30));
				
				ws.setRowView(cells.size()+7 + m * 37, 600);

				ws.addCell(new jxl.write.Label(0, cells.size()+8 + m * 37,
						"1、《发货明细》一式两份，提前于发货日两天给仓库。  ", wctf7));
				ws.addCell(new jxl.write.Label(0, cells.size()+9 + m * 37,
						"2、 实际发货当日，八点前必须将入库数量及时反馈给业务，并做好标记，以便制作下一次 ", wctf7));
				ws.addCell(new jxl.write.Label(0, cells.size()+11 + m * 37, "发货明细 ", wctf7));

				ws.addCell(new jxl.write.Label(4, cells.size()+12 + m * 37, "填表人：", wctf9));
				ws.mergeCells(5, cells.size()+12 + m * 37, 6, cells.size()+12 + m * 37); // 合并单元格
				ws.addCell(new jxl.write.Label(5, cells.size()+12 + m * 37, headMap.get("bizPerson"), wctf8));
				
				ws.addCell(new jxl.write.Label(4, cells.size()+13 + m * 37, "填表日期： ", wctf9));
				ws.mergeCells(5, cells.size()+13 + m * 37, 6, cells.size()+13 + m * 37); // 合并单元格
//				ws.addCell(new jxl.write.Label(5, 35 + m * 37, BlDateUtil.formatDate(new Date(), "yyyy/MM/dd"), wctf8));
				// 得到填表日期
				Date deliveryDate = new Date();
				try {
					deliveryDate = BlDateUtil.parseDate(headMap.get("deliveryDate"), "yyyy-MM-dd");
				} catch (Exception e) {
					LogPrinter.error("exportExcelDelivery_err"+e.getMessage());
				}
				Date fillDate = BlDateUtil.addDay(deliveryDate, -3);
				ws.addCell(new jxl.write.Label(5, cells.size()+13 + m * 37, BlDateUtil.formatDate(fillDate, "yyyy-MM-dd"), wctf8));
			}
	//	}
		wwb.write();
		wwb.close();
	}

	/**
	 * 导出厂检单
	 * @param cells1
	 * @param cells2
	 * @param wwb
	 * @param listName
	 * @throws IOException
	 * @throws WriteException
	 */
	public static void exportExcelChangjian(List<List<String>> cells1,
			List<List<String>> cells2, WritableWorkbook wwb, String listName)
			throws IOException, WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
		if (cells1.size() > 0) {

			jxl.write.Label labTable = null;
			SheetSettings setting = ws.getSettings();

			/** */
			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			// setting.setFitHeight(1) ; // 打印区高度
			setting.setFitWidth(1); // 打印区宽度
			// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
			// setting.setScaleFactor(100);// 设置缩放比例

			// 设置列宽
			ws.setColumnView(0, 11); // 第1列
			ws.setColumnView(1, 17); // 第2列
			ws.setColumnView(2, 23);
			ws.setColumnView(3, 24);
			ws.setColumnView(4, 20);
			ws.setColumnView(5, 10);

			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 16,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf.setBorder(jxl.format.Border.ALL,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);

			// 定义头部单元格样式
			WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
			wctf1.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf1.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wctf1.setBorder(jxl.format.Border.ALL,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf1.setWrap(true);// 设置自动换行

			// 定义头部单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf2 = new WritableCellFormat(wf2); // 单元格定义
			wctf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf2.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wctf2.setBorder(jxl.format.Border.ALL,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf1.setWrap(true);// 设置自动换行

		    int startRowNum = 0;// 每页的开始行

			for (int m = 0; m < cells1.size(); m++) {
				ws.mergeCells(0, 0 + startRowNum , 3, 0
						+ startRowNum ); // 合并单元格
				ws.mergeCells(0, 1 + startRowNum , 3, 1
						+ startRowNum ); // 合并单元格
				ws.mergeCells(1, 2 + startRowNum , 3, 2
						+ startRowNum); // 合并单元格
				ws.mergeCells(1, 3 + startRowNum, 3, 3
						+ startRowNum); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 0 + startRowNum, "厂检通知", wctf));
				ws.addCell(new jxl.write.Label(0, 1 + startRowNum, "请质检部按以下要求填写《青岛地区出口服装厂检合格单》一份。",
						wctf2));
				ws.addCell(new jxl.write.Label(0, 2 + startRowNum, "客户名称", wctf1));
				// ws.addCell(new jxl.write.Label(1,
				// 2+startRowNum+oneSize, "MSB", wctf2));
				ws.addCell(new jxl.write.Label(1, 2 + startRowNum, cells1.get(m).get(1), wctf2));// 客户名称
				ws.addCell(new jxl.write.Label(0, 3 + startRowNum, "厂名", wctf1));
				ws.addCell(new jxl.write.Label(1, 3 + startRowNum, "青岛红领制衣有限公司", wctf1));
				ws.addCell(new jxl.write.Label(0, 4 + startRowNum, "商品名称", wctf1));
				ws.addCell(new jxl.write.Label(1, 4 + startRowNum, "", wctf1));
				ws.addCell(new jxl.write.Label(2, 4 + startRowNum, "合同号", wctf1));
				// ws.addCell(new jxl.write.Label(3,
				// 4+startRowNum+oneSize, "GJ111029", wctf1));
				ws.addCell(new jxl.write.Label(3, 4 + startRowNum, cells1.get(m).get(2), wctf1));
				ws.addCell(new jxl.write.Label(0, 5 + startRowNum, "货/款号", wctf1));
				ws.addCell(new jxl.write.Label(1, 5 + startRowNum, cells1.get(m).get(1), wctf1));
				ws.addCell(new jxl.write.Label(2, 5 + startRowNum, "输往国别", wctf1));
				ws.addCell(new jxl.write.Label(3, 5 + startRowNum, cells1.get(m).get(3), wctf1));
				// ws.addCell(new jxl.write.Label(3,
				// 5+startRowNum+oneSize, "美国", wctf1));
				ws.addCell(new jxl.write.Label(0, 6 + startRowNum, "数量", wctf1));
				// ws.addCell(new jxl.write.Label(1,
				// 6+startRowNum+oneSize, "1箱20件", wctf1));
				ws.addCell(new jxl.write.Label(1, 6 + startRowNum, cells1.get(m).get(6), wctf1));
				ws.addCell(new jxl.write.Label(2, 6 + startRowNum, "颜色", wctf1));
				ws.addCell(new jxl.write.Label(3, 6 + startRowNum, "", wctf1));
				ws.addCell(new jxl.write.Label(0, 7 + startRowNum, "经营单位", wctf1));
				// ws.addCell(new jxl.write.Label(1,
				// 7+startRowNum+oneSize, "青岛凯妙服饰股份有限公司", wctf1));
				ws.addCell(new jxl.write.Label(1, 7 + startRowNum, cells1.get(m).get(5), wctf1));
				ws.addCell(new jxl.write.Label(2, 7 + startRowNum, "备注", wctf1));
				// ws.addCell(new jxl.write.Label(3,
				// 7+startRowNum+oneSize, "12.10发", wctf1));
				ws.addCell(new jxl.write.Label(3, 7 + startRowNum, cells1.get(m).get(4), wctf1));
				ws.addCell(new jxl.write.Label(0, 8 + startRowNum, "完成时间", wctf1));
				ws.addCell(new jxl.write.Label(1, 8 + startRowNum, "", wctf1));
				ws.addCell(new jxl.write.Label(2, 8 + startRowNum, "业务员签字", wctf1));
				// ws.addCell(new jxl.write.Label(3,
				// 8+startRowNum+oneSize, "解海州", wctf1));
				ws.addCell(new jxl.write.Label(3, 8 + startRowNum, cells1.get(m).get(7), wctf1));

				ws.addCell(new jxl.write.Label(4, 0 + startRowNum, "", wctf1));
				ws.addCell(new jxl.write.Label(5, 0 + startRowNum, "", wctf1));

				for (int b = 0; b < 8; b++) {
					ws.addCell(new jxl.write.Label(4, b + 1
							+ startRowNum , "", wctf2));
					ws.addCell(new jxl.write.Label(5, b + 1
							+ startRowNum , "", wctf2));
				}
				int n = 0;// 本次m值所对应的数据条数
				for (int i = 0; i < cells2.size(); i++) {
					List<String> tempList = cells2.get(i);
					if (tempList != null && tempList.size() > 0) {
						if (tempList.get(0)
								.equals(cells1.get(m).get(0))) {
							for (int j = 1; j < tempList.size(); j++) {
								labTable = new jxl.write.Label(
										j + 4 - 1, n + 1 + startRowNum,
										tempList.get(j), wctf2);
								ws.addCell(labTable);
							}
							n = n + 1;
						}
					}
				}
				for (int i2 = 9 + startRowNum; i2 < (m + 1) * 54; i2++) {
					ws.setRowView(i2, 550);
				}
				
				startRowNum = startRowNum + cells2.size() + 1;
			}
		}
		wwb.write();
		wwb.close();
	}



	/**
	 * 生成商检、报送单
	 * @param cells1
	 * @param cells2
	 * @param cells3
	 * @param cells4
	 * @param cells5
	 * @param cells6
	 * @param wwb
	 * @param listName
	 * @throws IOException
	 * @throws WriteException
	 */
	public static void exportExcelShangjian(String multpleFlag,List<List<String>> cells1,
			List<List<String>> cells2, List<List<String>> cells3,
			List<List<String>> cells4, List<List<String>> cells5,
			List<List<String>> cells6, List<List<String>> cells7,
			WritableWorkbook wwb, String listName)
			throws IOException, WriteException {
		// 生成符合性声明
		if (cells7.size() > 0&&(!"1".equals(multpleFlag))) {
			getExcelSheetDeclare(cells7,wwb);
		}
		// 生成发票
		if (cells1.size() > 0) {
//			jxl.write.WritableSheet ws1 = getExcelSheetInvoice(cells1, cells2, wwb);
			getExcelSheetInvoice(cells1, cells2, wwb);
		}
		// 生成箱单
		if (cells3.size() > 0) {
//			jxl.write.WritableSheet ws2 = getExcelSheetPacking(cells3, cells4, wwb);
			getExcelSheetPacking(cells3, cells4, wwb);
		}
		// 生成合同
		if (cells5.size() > 0) {
//			jxl.write.WritableSheet ws3 = getExcelSheetContract(cells5, cells6, wwb);
			getExcelSheetContract(cells5, cells6, wwb);
		}
		wwb.write();
		wwb.close();
	}
	
	/**
	 * 生成符合性声明
	 * @param cells1
	 * @param wwb
	 */
	private static void getExcelSheetDeclare(List<List<String>> cells7,
			WritableWorkbook wwb)throws IOException, WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet("DECLARE", 0);
		
		if (cells7.size() > 0) {
			SheetSettings setting = ws.getSettings();

			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			setting.setFitWidth(1); // 打印区宽度
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印

			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 18,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			wctf.setBackground(jxl.format.Colour.WHITE); // 设置单元格的背景颜色
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

		
						
			// 定义头部单元格样式
			WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 14,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf4 = new WritableCellFormat(wf4); // 单元格定义
			wctf4.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf4.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wctf4.setAlignment(Alignment.LEFT);
			wctf4.setWrap(true);

			// 定义头部单元格样式
			WritableFont wf5 = new WritableFont(WritableFont.ARIAL, 14,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf5 = new WritableCellFormat(wf5); // 单元格定义
			wctf5.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

			WritableFont wf6 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf6 = new WritableCellFormat(wf6); // 单元格定义
			wctf6.setAlignment(jxl.format.Alignment.RIGHT); // 设置对齐方式
//			wctf6.setBorder(jxl.format.Border.TOP,
//					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			
			// 设置列宽
			ws.setColumnView(0, 7);
			ws.setColumnView(1, 6);
			ws.setColumnView(2, 10);
			ws.setColumnView(3, 10);
			ws.setColumnView(4, 14);
			ws.setColumnView(5, 7);
			ws.setColumnView(6, 10);
			ws.setColumnView(7, 15);
			ws.setColumnView(8, 9);
			ws.setColumnView(9, 9);

			for (int m = 0; m < cells7.size(); m++) {
				ws.mergeCells(0, m * 57, 9, m * 57); // 合并单元格
			//	ws.mergeCells(0, 1 + m * 33, 9, 1 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 0 + m * 57, "进/出口服装符合性声明", wctf));
				String contactno = cells7.get(m).get(0);
				String name = cells7.get(m).get(1);
				String hsno = cells7.get(m).get(2);
				String count = cells7.get(m).get(3);
				String price = cells7.get(m).get(4);
				String date = BlDateUtil.formatDate(new Date(), "yyyy年MM月dd日");
				
				ws.mergeCells(0, 2 + m * 57, 9, 7 + m * 57); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 2 + m * 57,
						"      兹向贵局申报进/出口（合同号为    "+contactno+"  ）的货物（品名/规格）  "+name+" ，HS编码   "+hsno+"  ，数量    "+count+" ，货值     "+price+"  美元  ，经检验，该批货物质量符合：", wctf4));
				
				ws.addCell(new jxl.write.Label(1, 9 + m * 57, "■ 中国强制性技术规范；", wctf5));
				ws.addCell(new jxl.write.Label(1, 11 + m * 57, "■ 输入国的技术法规或标准；", wctf5));
				ws.addCell(new jxl.write.Label(1, 13 + m * 57, "■  合同要求；", wctf5));
				ws.addCell(new jxl.write.Label(1, 15 + m * 57, "□  其他：  无   。", wctf5));
				ws.addCell(new jxl.write.Label(1, 17 + m * 57, "特此声明。", wctf5));
				ws.addCell(new jxl.write.Label(8, 21 + m * 57, "进口商/出口生产企业签名（盖章）", wctf6));
				ws.addCell(new jxl.write.Label(8, 23 + m * 57, date, wctf6));
			}
		}
		
	}

	/**
	 * 生成合同
	 * @param cells5
	 * @param cells6
	 * @param wwb
	 * @return
	 * @throws IOException
	 * @throws WriteException
	 */
	private static WritableSheet getExcelSheetContract(
			List<List<String>> cells5, List<List<String>> cells6,
			WritableWorkbook wwb) throws IOException, WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet("CONTRACT", 0);
		
		//DecimalFormat df = new DecimalFormat("###,###.##");
		NumberFormat df=new DecimalFormat("'$'#,##0.00");
		
		if (cells5.size() > 0) {
			jxl.write.Label labTable = null;
			SheetSettings setting = ws.getSettings();

			/** */
			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			setting.setFitWidth(1); // 打印区宽度 横向一页内打印
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印

			// 设置列宽
			ws.setColumnView(0, 21); // 第1列
			ws.setColumnView(1, 8); // 第2列
			ws.setColumnView(2, 12);
			ws.setColumnView(3, 11);
			ws.setColumnView(4, 18);
			ws.setColumnView(5, 23);

			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 18,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			wctf.setBackground(jxl.format.Colour.WHITE); // 设置单元格的背景颜色
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
			wctf1.setBackground(jxl.format.Colour.WHITE); // 设置单元格的背景颜色
			wctf1.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf2 = new WritableCellFormat(wf2); // 单元格定义
			wctf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf3 = new WritableCellFormat(wf3); // 单元格定义
			wctf3.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf3.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THICK, jxl.format.Colour.BLACK);

			// 定义头部单元格样式
			WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 18,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf4 = new WritableCellFormat(wf4); // 单元格定义
			wctf4.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf5 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf5 = new WritableCellFormat(wf5); // 单元格定义
			wctf5.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf6 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf6 = new WritableCellFormat(wf6); // 单元格定义
			wctf6.setBackground(jxl.format.Colour.WHITE); // 设置单元格的背景颜色
			wctf6.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf7 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf7 = new WritableCellFormat(wf7); // 单元格定义
			wctf7.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf7.setBorder(jxl.format.Border.ALL,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);

			// 定义头部单元格样式
			WritableFont wf8 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf8 = new WritableCellFormat(wf8); // 单元格定义
			wctf8.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf8.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf8.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			
			WritableFont wf9 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf9 = new WritableCellFormat(wf9); // 单元格定义
			wctf9.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf9.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			
			for (int m = 0; m < cells5.size(); m++) {
				ws.mergeCells(0, 0 + m * 43, 5, 0 + m * 43); // 合并单元格
				ws.mergeCells(0, 1 + m * 43, 5, 1 + m * 43); // 合并单元格
				ws.mergeCells(0, 2 + m * 43, 5, 2 + m * 43); // 合并单元格
				ws.mergeCells(0, 3 + m * 43, 5, 3 + m * 43); // 合并单元格
				// head的内容
				// ws.addCell(new jxl.write.Label(0, 0+m*43,
				// "Qingdao Red Collar Clothing Co.,LTD", wctf));
				// ws.addCell(new jxl.write.Label(0, 1+m*43,
				// "Address: No.17 Redcollar Street ,Jimo, Qingdao, China",
				// wctf1));
				ws.addCell(new jxl.write.Label(0, 0 + m * 43, cells5.get(m).get(1), wctf));
				ws.addCell(new jxl.write.Label(0, 1 + m * 43, cells5.get(m).get(2), wctf1));
				ws.addCell(new jxl.write.Label(0,2 + m * 43,
						"Tel:00 86 531 8859 8176                              Fax:　00 86 531 8859 8033",
						wctf2));
				ws.addCell(new jxl.write.Label(0,3 + m * 43,
						"E-mail: rcollar_rcollar@sina.com, Website: www.redcollar.com.cn",
						wctf3));

				ws.mergeCells(0, 4+m*43, 5, 4+m*43); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 4 + m * 43, "contract", wctf4));
				ws.addCell(new jxl.write.Label(0, 5 + m * 43, "CONTRACT NO.:",
						wctf5));
				ws.addCell(new jxl.write.Label(0, 6 + m * 43, "INVOICE  NO.:",
						wctf5));
				// ws.addCell(new jxl.write.Label(1, 5+m*43, "GJ120202-5",
				// wctf5));
				// ws.addCell(new jxl.write.Label(1, 6+m*43, "MWUK", wctf5));
				// ws.addCell(new jxl.write.Label(2, 6+m*43, "120221", wctf5));
				// ws.addCell(new jxl.write.Label(5, 5+m*43, "DATE:2012-2-16",
				// wctf5));
				ws.addCell(new jxl.write.Label(1, 5 + m * 43, cells5.get(m)
						.get(10), wctf5));
				ws.addCell(new jxl.write.Label(1, 6 + m * 43, cells5.get(m)
						.get(7)+cells5.get(m).get(8), wctf5));
//				ws.addCell(new jxl.write.Label(2, 6 + m * 43, cells5.get(m)
//						.get(8), wctf5));
				ws.addCell(new jxl.write.Label(5, 5 + m * 43, "DATE:"
						+ Constant.BL_EXCEL_CONTRACT_DATE, wctf5));

				ws.mergeCells(0, 7 + m * 43, 5, 7 + m * 43); // 合并单元格
				ws.mergeCells(0, 8 + m * 43, 5, 8 + m * 43); // 合并单元格
				ws.mergeCells(0, 9 + m * 43, 5, 9 + m * 43); // 合并单元格

				// ws.addCell(new jxl.write.Label(0, 7+m*43,
				// "Qingdao Redcollar Clothing Co., Ltd (Here after referred as party A ) ",
				// wctf6));
				// ws.addCell(new jxl.write.Label(0, 8+m*43,
				// "and made 2 measure clothing (Here after refferred  Party B)",
				// wctf6));
				ws.addCell(new jxl.write.Label(0, 7 + m * 43, cells5.get(m)
						.get(12), wctf6));
				ws.addCell(new jxl.write.Label(0, 8 + m * 43, cells5.get(m)
						.get(13), wctf6));
				ws.addCell(new jxl.write.Label(
						0,
						9 + m * 43,
						"Have agreed party A will process the following garments under stipulation as follows :",
						wctf5));

				ws.addCell(new jxl.write.Label(0, 10 + m * 43,
						"1. THE ITEM OF PROCESSING", wctf5));

				ws.mergeCells(0, 11 + m * 43, 2, 11 + m * 43); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 11 + m * 43, "NAME", wctf7));
				ws.addCell(new jxl.write.Label(3, 11 + m * 43, "qty", wctf7));
				ws.addCell(new jxl.write.Label(4, 11 + m * 43, "UNIT PRICE",
						wctf7));
				ws.addCell(new jxl.write.Label(5, 11 + m * 43, "T/AMOUNT",
						wctf7));
				
				// 设置行高
				for (int i2 = 12 + m * 43; i2 < (m + 1) * 43; i2++) {
					ws.setRowView(i2, 400);
				}

				int n = 0;// 本次m值所对应的数据条数
				Integer amount = 0;
				Double totalAmount = 0.00;
				StringBuffer totalgongshi = new StringBuffer();
				StringBuffer qtygongshi = new StringBuffer();
				for (int i = 0; i < cells6.size(); i++) {
					List<String> tempList = cells6.get(i);
					if (tempList != null && tempList.size() > 0) {
						if (tempList.get(0).equals(cells5.get(m).get(0))) {
							amount += Utility.toSafeInt((tempList.get(2)));
							totalAmount += Double.parseDouble(tempList.get(4));
							// 合并单元格
							ws.mergeCells(0, n + 12 + m * 43, 2, n + 12 + m * 43);
							totalgongshi.append("F"+(n + 13 + m* 43)+"+");
							qtygongshi.append("D"+(n + 13 + m* 43)+"+");
							for (int j = 1, k = 0; j < tempList.size(); j++, k++) {
								if (j == 2) {
									k = j + 1;
								}
								//添加公式（下面两行）
								int lie = n + 12 + m* 43;
								Formula f = new Formula(5, lie,"CONCATENATE(\"$\","+"D"+(n + 13 + m* 43)+"*E"+(n + 13 + m* 43)+")", wctf7);
								
								if(j>2){
									labTable = new jxl.write.Label(k, n + 12 + m* 43, df.format(Double.parseDouble(tempList.get(j))), wctf7);
								}
								else{
									labTable = new jxl.write.Label(k, n + 12 + m* 43, tempList.get(j), wctf7);
								}
								ws.addCell(labTable);
								ws.addCell(f);
							}
							n = n + 1;
						}
					}
				}
				totalgongshi.append("0");
				qtygongshi.append("0");
				ws.mergeCells(0, n + 12 + m * 43, 2, n + 12 + m * 43);
				ws.addCell(new jxl.write.Label(0, n + 12 + m * 43, "TOTAL ",
						wctf7));
//				Formula formula = new Formula(3, n + 12 + m*43, "SUM(D13:D13)", wctf7);
//				ws.addCell(formula);
				Formula f1 = new Formula(3, n + 12 + m * 43, qtygongshi.toString(), wctf7);
				ws.addCell(f1);
//				ws.addCell(new jxl.write.Label(3, n + 12 + m * 43, amount
//						.toString(), wctf7));
				ws.addCell(new jxl.write.Label(4, n + 12 + m * 43, "", wctf7));
				Formula f2 = new Formula(5, n + 12 + m * 43, "CONCATENATE(\"$\","+totalgongshi.toString()+")", wctf7);
				//ws.addCell(new jxl.write.Label(5, n + 12 + m * 43, df.format(totalAmount), wctf7));
				ws.addCell(f2);
				ws.addCell(new jxl.write.Label(0, n + 13 + m * 43,
						"2. TRANSPORT  :", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 14 + m * 43,
						"  (1.)LOADING PORT OF MATERIALS:", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 15 + m * 43,
						"  (2) DELIVERY OF MATERIALS:   ", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 16 + m * 43,
						"  (3.) THE LATEST  TIME OF SHIPMENT OF PRODUCTS ：",
						wctf5));
				ws.addCell(new jxl.write.Label(0, n + 17 + m * 43,
						"  (4.)DESTINATION  PORT:", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 18 + m * 43,
						"  (5) DEPARTURE PORT:   ", wctf5));

				ws.addCell(new jxl.write.Label(5, n + 14 + m * 43, "", wctf8));
				ws.addCell(new jxl.write.Label(5, n + 15 + m * 43, "", wctf8));
				// ws.addCell(new jxl.write.Label(5, n+16+m*43, "2012/12/31",
				// wctf5));
				ws.addCell(new jxl.write.Label(5, n + 16 + m * 43, cells5
						.get(m).get(11), wctf5));
				// ws.addCell(new jxl.write.Label(5, n+17+m*43, "Canada",
				// wctf5));
				ws.addCell(new jxl.write.Label(5, n + 17 + m * 43, cells5
						.get(m).get(6), wctf5));
				ws.addCell(new jxl.write.Label(5, n + 18 + m * 43, "Qingdao",
						wctf8));

				ws.addCell(new jxl.write.Label(0, n + 20 + m * 43,
						" 3.TERMS OF PAYMENT :  ", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 21 + m * 43,
						" 4.VALID DATE:", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 22 + m * 43,
						" 5. PLACE WHERE TO ISSUE THE CONTRACT: ", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 23 + m * 43,
						" 6. OTHER TERMS", wctf5));

				ws.addCell(new jxl.write.Label(5, n + 20 + m * 43, "T/T", wctf5));
				ws.addCell(new jxl.write.Label(5, n + 21 + m * 43, "", wctf8));
				ws.addCell(new jxl.write.Label(5, n + 22 + m * 43,
						"Jimo ,Qingdao", wctf8));
				ws.addCell(new jxl.write.Label(5, n + 23 + m * 43, "", wctf8));

				ws.addCell(new jxl.write.Label(0, n + 25 + m * 43, "PARTY  A",
						wctf5));
				// ws.addCell(new jxl.write.Label(0, n+26+m*43,
				// "QINGDAO REDCOLLAR CLOTHING CO.,LTD.", wctf5));
				ws.addCell(new jxl.write.Label(0, n + 26 + m * 43, cells5
						.get(m).get(15), wctf5));
				ws.addCell(new jxl.write.Label(0, n + 27 + m * 43, cells5
						.get(m).get(14), wctf5));
				ws.addCell(new jxl.write.Label(0, n + 28 + m * 43,
						"JIMO, QINGDAO, CHINA", wctf5));

				ws.addCell(new jxl.write.Label(4, n + 25 + m * 43, "PARTY  B",
						wctf5));
				ws.addCell(new jxl.write.Label(4, n + 26 + m * 43, Utility.toSafeString(cells5
						.get(m).get(16)), wctf5));
				ws.addCell(new jxl.write.Label(4, n + 27 + m * 43, Utility.toSafeString(cells5
						.get(m).get(3))+cells5.get(m).get(4), wctf5));
				ws.addCell(new jxl.write.Label(4, n + 28 + m * 43, cells5
						.get(m).get(5)+","+cells5.get(m).get(6), wctf5));
				
//				ws.mergeCells(4, n+33+m*45, 5, n+33+m*45);
//				ws.addCell(new jxl.write.Label(4, n+33+m*45, cells5.get(m).get(1),wctf9));
			}
		}
		return ws;
	}
	
	/**
	 * 生成箱单
	 * @param cells3
	 * @param cells4
	 * @param wwb
	 * @return
	 * @throws IOException
	 * @throws WriteException
	 */
	private static WritableSheet getExcelSheetPacking(
			List<List<String>> cells3, List<List<String>> cells4,
			WritableWorkbook wwb) throws IOException, WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet("PACKINGLIST", 0);
		DecimalFormat df = new DecimalFormat("0.0");
		if (cells3.size() > 0) {
			jxl.write.Label labTable = null;
			SheetSettings setting = ws.getSettings();

			/** */
			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			// setting.setFitHeight(1) ; // 打印区高度
			setting.setFitWidth(1); // 打印区宽度
			// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
			// setting.setScaleFactor(100);// 设置缩放比例

			// 设置列宽
			ws.setColumnView(0, 8); // 第1列
			ws.setColumnView(1, 4); // 第2列
			ws.setColumnView(2, 5);
			ws.setColumnView(3, 5);
			ws.setColumnView(4, 8);
			ws.setColumnView(5, 6);
			ws.setColumnView(6, 9);
			ws.setColumnView(7, 8);
			ws.setColumnView(8, 10);
			ws.setColumnView(9, 9);
			ws.setColumnView(10, 8);
			ws.setColumnView(11, 12);
			ws.setColumnView(12, 12);

			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 24,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			// wctf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义项目部单元格样式
			WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcdf = new WritableCellFormat(wf1); // 单元格定义
			// wcdf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wcdf.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
			// wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wcf.setWrap(true);// 设置自动换行
			wcf.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);
			wcf.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);

			// 定义单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf2 = new WritableCellFormat(wf2); // 单元格定义
			wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf2.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐

			// 定义单元格样式
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 10,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf3 = new WritableCellFormat(wf3); // 单元格定义
			wcf3.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wcf3.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐

			// 定义单元格样式
			WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf4 = new WritableCellFormat(wf4); // 单元格定义
			wcf4.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf4.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wcf4.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);
			
			WritableFont wf5 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf5 = new WritableCellFormat(wf5); // 单元格定义
			wcf5.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wcf5.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);

			for (int m = 0; m < cells3.size(); m++) {
				ws.mergeCells(0, 0 + m * 34, 12, 0 + m * 34); // 合并单元格
				// ws.setRowView(2,300); //指定第i+1行的高度
				ws.addCell(new jxl.write.Label(0, 0 + m * 34, "Packing List",
						wctf));

				ws.addCell(new jxl.write.Label(0, 2 + m * 34, "TO:", wcdf));
				// ws.addCell(new jxl.write.Label(1, 2+m*34,
				// "275 York Hill BLVD", wcdf));
				// ws.addCell(new jxl.write.Label(1, 3+m*34,
				// "Thornhill,Ontario,", wcdf));
				// ws.addCell(new jxl.write.Label(1, 4+m*34, "L4J 3L5", wcdf));
				// ws.addCell(new jxl.write.Label(1, 5+m*34, "Canada", wcdf));
				ws.addCell(new jxl.write.Label(1, 2 + m * 34, cells3.get(m).get(10), wcdf));
				ws.addCell(new jxl.write.Label(1, 3 + m * 34, Utility.toSafeString(cells3.get(m).get(1))+
						Utility.toSafeString(cells3.get(m).get(2)), wcdf));
				ws.addCell(new jxl.write.Label(1, 4 + m * 34, cells3.get(m)
						.get(3), wcdf));
				ws.addCell(new jxl.write.Label(1, 5 + m * 34, cells3.get(m)
						.get(4), wcdf));
				ws.addCell(new jxl.write.Label(0, 7 + m * 34,
						"Vessel/Voy No.:", wcdf));
				ws.addCell(new jxl.write.Label(0, 8 + m * 34, "B/L No.:", wcdf));
				ws.addCell(new jxl.write.Label(0, 9 + m * 34, "ETD:", wcdf));
				ws.addCell(new jxl.write.Label(0, 10 + m * 34, "ETA:", wcdf));

				ws.addCell(new jxl.write.Label(8, 2 + m * 34, "INVOICE NO.: ",
						wcdf));
				// ws.addCell(new jxl.write.Label(10, 2+m*34, "MWUK",
				// wcdf));//客户简称
				// ws.addCell(new jxl.write.Label(11, 2+m*34, "120221",
				// wcdf));//发货的日期
				ws.addCell(new jxl.write.Label(10, 2 + m * 34, cells3.get(m)
						.get(5)+cells3.get(m).get(6), wcdf));// 客户简称
//				ws.addCell(new jxl.write.Label(11, 2 + m * 34, cells3.get(m)
//						.get(6), wcdf));// 发货的日期

				ws.addCell(new jxl.write.Label(8, 3 + m * 34, "DATE:  ", wcdf));
				// ws.addCell(new jxl.write.Label(9, 3+m*34, "12/2/21", wcdf));
//				ws.addCell(new jxl.write.Label(9, 3 + m * 34, cells3.get(m)
//						.get(7), wcdf));
				ws.addCell(new jxl.write.Label(9, 3 + m * 34,BlDateUtil.formatDate(new Date(), "yyyy-MM-dd"), wcdf));

				ws.addCell(new jxl.write.Label(8, 4 + m * 34, "CONTRACT NO.:",
						wcdf));
				// ws.addCell(new jxl.write.Label(10, 4+m*34, "GJ120202-5",
				// wcdf));//选择客户简称，关联合同，直接生成合同号
				ws.addCell(new jxl.write.Label(10, 4 + m * 34, cells3.get(m)
						.get(8), wcdf));// 选择客户简称，关联合同，直接生成合同号

				ws.addCell(new jxl.write.Label(8, 5 + m * 34, "Payment Terms:",
						wcdf));
				ws.addCell(new jxl.write.Label(10, 5 + m * 34, "T/T", wcdf));

				ws.addCell(new jxl.write.Label(8, 7 + m * 34, "L/C No.:", wcdf));
				ws.addCell(new jxl.write.Label(8, 8 + m * 34, "From:", wcdf));
				ws.addCell(new jxl.write.Label(9, 8 + m * 34, "Qingdao", wcdf));
				ws.addCell(new jxl.write.Label(8, 9 + m * 34, "To: ", wcdf));
				// ws.addCell(new jxl.write.Label(9, 9+m*34, "Canada", wcdf));
				ws.addCell(new jxl.write.Label(9, 9 + m * 34, cells3.get(m)
						.get(4), wcdf));
				ws.addCell(new jxl.write.Label(8, 10 + m * 34,
						"PBy Vessel / Air: ", wcdf));
				// ws.addCell(new jxl.write.Label(10, 10+m*34, "Air", wcdf));
				ws.addCell(new jxl.write.Label(10, 10 + m * 34, cells3.get(m)
						.get(9), wcdf));

				ws.mergeCells(0, 13 + m * 34, 1, 13 + m * 34); // 合并单元格
				ws.mergeCells(2, 13 + m * 34, 6, 13 + m * 34); // 合并单元格

				ws.addCell(new jxl.write.Label(0, 13 + m * 34, "Marks & No.s",
						wcf));
				ws.addCell(new jxl.write.Label(2, 13 + m * 34, "Descriptions",
						wcf));
				ws.addCell(new jxl.write.Label(7, 13 + m * 34, "Qty", wcf));
				ws.addCell(new jxl.write.Label(8, 13 + m * 34, "Unit N.W", wcf));
				ws.addCell(new jxl.write.Label(9, 13 + m * 34, "Total  N.W",
						wcf));
				ws.addCell(new jxl.write.Label(10, 13 + m * 34, "Total G. W",
						wcf));
				ws.addCell(new jxl.write.Label(11, 13 + m * 34, "measure CBM ",
						wcf));
				ws.addCell(new jxl.write.Label(12, 13 + m * 34, "cartons", wcf));

				for (int i2 = 14 + m * 34; i2 < (m + 1) * 34; i2++) {
					ws.setRowView(i2, 600);
				}

				int n = 0;// 本次m值所对应的数据条数
				Integer amount = 0;
				Double totalNW = 0.00;
				Double totalGW = 0.00;
				Double measureCBM = 0.00;
				Integer cartons = 0;
				String shirtsIntr = "";
				Double shirtsCBM = 0.00;
				Integer shirtscarton = 0;
				int flagqty = 0;
				for (int i = 0; i < cells4.size(); i++) {
					List<String> tempList = cells4.get(i);
					if (tempList != null && tempList.size() > 0) {
						if (tempList.get(0).equals(cells3.get(m).get(0))) {
							amount = amount + Integer.parseInt(tempList.get(2));
							totalNW = totalNW
									+ Double.parseDouble(tempList.get(4));
							flagqty +=1;
							totalGW = totalGW
									+ Double.parseDouble(tempList.get(5));
							measureCBM = measureCBM
									+ Double.parseDouble(tempList.get(6));
							cartons = cartons
									+ Integer.parseInt(tempList.get(7));
							ws.mergeCells(2, n + 14, 6, n + 14);
							shirtsIntr = tempList.get(1).toString();
							shirtsCBM=Double.parseDouble(tempList.get(6));
							shirtscarton = Integer.parseInt(tempList.get(7));

							for (int j = 1, k = 0; j < tempList.size(); j++, k++) {
								//添加公式（下面两行）
								int lie = n + 14 + m* 34;
								Formula f = new Formula(9, lie, "H"+(n + 15 + m* 34)+"*I"+(n + 15 + m* 34), wcf2);
								Formula f2 = new Formula(10, lie, "H"+(n + 15 + m* 34)+"*(I"+(n + 15 + m* 34)+"+0.1)", wcf2);
								
								if (j == 1) {
									k = j + 1;
								}
								if (j == 2) {
									k = j + 5;
								} 
								if (k == 2) {
									labTable = new jxl.write.Label(k, n + 14
											+ m * 34, tempList.get(j).trim(), wcf3);
								} else {
									labTable = new jxl.write.Label(k, n + 14
											+ m * 34, tempList.get(j).trim(), wcf2);
								}
								shirtsIntr = tempList.get(1).toString();
								ws.addCell(labTable);
								ws.addCell(f);
								ws.addCell(f2);
								
								Formula f3 = new Formula(11,  n + 14 + m * 34, "M"+(n + 15 + m * 34)+"*0.1", wcf4);
								ws.addCell(f3);
							}
							n = n + 1;
						}
					}
				}
			    if(shirtsIntr.contains("shirts")){
			    	ws.mergeCells(11, 14 + m * 34, 11, n + 12 + m * 34);
			    	ws.mergeCells(12, 14 + m * 34, 12, n + 12 + m * 34);
			    	measureCBM = (measureCBM-shirtsCBM)/(n-1)+shirtsCBM;
			    	cartons = (cartons-shirtscarton)/(n-1)+shirtscarton;
			    }
			    else{
			    	ws.mergeCells(11, 14 + m * 34, 11, n + 13 + m * 34);
			    	ws.mergeCells(12, 14 + m * 34, 12, n + 13 + m * 34);
			    	measureCBM = measureCBM/n;
			    	cartons = cartons/n;
			    }

				ws.mergeCells(0, 14 + m * 34, 1, n + 13 + m * 34);
				ws.addCell(new jxl.write.Label(0, 14 + m * 34, "N/M", wcf));

				ws.mergeCells(1, n + 14 + m * 34, 6, n + 14 + m * 34); // 合并单元格
				ws.addCell(new jxl.write.Label(0, n + 14 + m * 34, "Total:",
						wcf4));
				ws.addCell(new jxl.write.Label(1, n + 14 + m * 34, "", wcf4));
				ws.addCell(new jxl.write.Label(6, n + 14 + m * 34, "", wcf4));
				
				
				
				
				ws.addCell(new jxl.write.Label(8, n + 14 + m * 34, "", wcf4));
				if(flagqty>1){
					Formula f5 = new Formula(9,  n + 14 + m * 34, "SUM(J"+(n + 15 + m * 34-flagqty)+":J"+(n + 15 + m * 34-1), wcf4);
					ws.addCell(f5);
				}else{
					ws.addCell(new jxl.write.Label(9, n + 14 + m * 34, df.format(totalNW), wcf4));
				}
				if(flagqty>1){
					Formula f6 = new Formula(10,  n + 14 + m * 34, "SUM(K"+(n + 15 + m * 34-flagqty)+":K"+(n + 15 + m * 34-1), wcf4);
					ws.addCell(f6);
				}else{
					ws.addCell(new jxl.write.Label(10, n + 14 + m * 34, df.format(totalGW), wcf4));
				}
				
				//ws.addCell(new jxl.write.Label(11, n + 14 + m * 34, df.format(measureCBM), wcf4));
				ws.addCell(new jxl.write.Label(12, n + 14 + m * 34, cartons.toString(), wcf4));
				
				ws.mergeCells(9, n+22+m*34, 12, n+22+m*34);
				ws.addCell(new jxl.write.Label(9, n+22+m*34,cells3.get(m).get(11),wcf5));
				
				if(flagqty>1){
					Formula f4 = new Formula(11,  n + 14 + m * 34, "SUM(L"+(n + 15 + m * 34-flagqty)+":L"+(n + 15 + m * 34-1), wcf4);
					ws.addCell(f4);
				}else{
					ws.addCell(new jxl.write.Label(11, n + 14 + m * 34, df.format(measureCBM), wcf4));
				}
				if(flagqty>1){
//					int start = n + 15 + m * 34-flagqty;
//					int end = n + 15 + m * 34-1;
					String sumstr = "";
					for(int i = 1;i<=flagqty;i++){
						if(i==flagqty){
							sumstr+="H"+(n + 15 + m * 34-i);
						}else{
							sumstr+="H"+(n + 15 + m * 34-i)+"+";
						}
						
					}
					Formula f7 = new Formula(7,  n + 14 + m * 34, sumstr, wcf4);
					ws.addCell(f7);
				}else{
					ws.addCell(new jxl.write.Label(7, n + 14 + m * 34, amount
							.toString(), wcf4));
				}
			}
		}
		return ws;
	}
	
	/**
	 * 生成发票
	 * @param cells1
	 * @param cells2
	 * @param wwb
	 * @return
	 * @throws IOException
	 * @throws WriteException
	 */
	private static WritableSheet getExcelSheetInvoice(
			List<List<String>> cells1, List<List<String>> cells2,
			WritableWorkbook wwb) throws IOException, WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet("COMERCIALINVOICE", 0);
		NumberFormat df=new DecimalFormat("'$'#,##0.00");
		
		if (cells1.size() > 0) {
			jxl.write.Label labTable = null;
			SheetSettings setting = ws.getSettings();

			/** */
			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			// setting.setFitHeight(1) ; // 打印区高度
			setting.setFitWidth(1); // 打印区宽度
			// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
			// setting.setScaleFactor(100);// 设置缩放比例

			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 18,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			wctf.setBackground(jxl.format.Colour.WHITE); // 设置单元格的背景颜色
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
			// wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wcf.setWrap(true);// 设置自动换行
			wcf.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);
			wcf.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);

			// 定义头部单元格样式
			WritableFont wf01 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf1 = new WritableCellFormat(wf01); // 单元格定义
			// wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wcf1.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf1.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wcf1.setWrap(true);// 设置自动换行
			wcf1.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);

			// 定义头部单元格样式
			WritableFont wf02 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf2 = new WritableCellFormat(wf02); // 单元格定义
			// wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf2.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			wcf2.setWrap(true);// 设置自动换行
			wcf2.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.DOUBLE,
					jxl.format.Colour.BLACK);

			// 定义头部单元格样式
			WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
			wctf1.setBackground(jxl.format.Colour.WHITE); // 设置单元格的背景颜色
			wctf1.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 11,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf2 = new WritableCellFormat(wf2); // 单元格定义
			wctf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf2.setVerticalAlignment(VerticalAlignment.CENTRE); // 垂直对齐
			
			// 定义头部单元格样式
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf3 = new WritableCellFormat(wf3); // 单元格定义
			wctf3.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf3.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THICK, jxl.format.Colour.BLACK);
						
			// 定义头部单元格样式
			WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 18,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf4 = new WritableCellFormat(wf4); // 单元格定义
			wctf4.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf4.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE); // 设置对齐方式

			// 定义头部单元格样式
			WritableFont wf5 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf5 = new WritableCellFormat(wf5); // 单元格定义
			wctf5.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式

			WritableFont wf6 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf6 = new WritableCellFormat(wf6); // 单元格定义
			wctf6.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf6.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			
			// 设置列宽
			ws.setColumnView(0, 7);
			ws.setColumnView(1, 6);
			ws.setColumnView(2, 10);
			ws.setColumnView(3, 10);
			ws.setColumnView(4, 14);
			ws.setColumnView(5, 7);
			ws.setColumnView(6, 10);
			ws.setColumnView(7, 15);
			ws.setColumnView(8, 9);
			ws.setColumnView(9, 9);

			for (int m = 0; m < cells1.size(); m++) {
				ws.mergeCells(0, m * 33, 9, m * 33); // 合并单元格
				ws.mergeCells(0, 1 + m * 33, 9, 1 + m * 33); // 合并单元格
				ws.mergeCells(0, 2 + m * 33, 9, 2 + m * 33); // 合并单元格
				ws.mergeCells(0, 3 + m * 33, 9, 3 + m * 33); // 合并单元格
				// head的内容
				// ws.addCell(new jxl.write.Label(0, 0+m*33,
				// "Qingdao Red Collar Clothing Co.,LTD", wctf));
				// ws.addCell(new jxl.write.Label(0, 1+m*33,
				// "Address: No.17 Redcollar Street ,Jimo, Qingdao, China",
				// wctf1));
				ws.addCell(new jxl.write.Label(0, 0 + m * 33, cells1.get(m)
						.get(1), wctf));
				ws.addCell(new jxl.write.Label(0, 1 + m * 33, cells1.get(m)
						.get(2), wctf1));

				ws.addCell(new jxl.write.Label(
						0,
						2 + m * 33,
						"Tel:00 86 533 8859 8176                              Fax:　00 86 533 8859 8033",
						wctf2));
				ws.addCell(new jxl.write.Label(
						0,
						3 + m * 33,
						"E-mail: rcollar_rcollar@sina.com, Website: www.redcollar.com.cn",
						wctf3));

				ws.mergeCells(0, 4 + m * 33, 9, 4 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 4 + m * 33,
						"Commercial     Invoice ", wctf4));
				ws.setRowView(4 + m * 33, 800);

				ws.addCell(new jxl.write.Label(0, 5 + m * 33, "TO:", wctf5));
				// ws.addCell(new jxl.write.Label(1, 5+m*33,
				// "275 York Hill BLVD", wctf5));
				// ws.addCell(new jxl.write.Label(1, 6+m*33,
				// "Thornhill,Ontario,", wctf5));
				// ws.addCell(new jxl.write.Label(1, 7+m*33, "L4J 3L5", wctf5));
				// ws.addCell(new jxl.write.Label(1, 8+m*33, "Canada", wctf5));
				ws.addCell(new jxl.write.Label(1, 5 + m * 33, cells1.get(m).get(12), wctf5));
				ws.addCell(new jxl.write.Label(1, 6 + m * 33, Utility.toSafeString(cells1.get(m).get(3))+
						Utility.toSafeString(cells1.get(m).get(4)), wctf5));
				ws.addCell(new jxl.write.Label(1, 7 + m * 33, cells1.get(m)
						.get(5), wctf5));
				ws.addCell(new jxl.write.Label(1, 8 + m * 33, cells1.get(m)
						.get(6), wctf5));

				ws.addCell(new jxl.write.Label(0, 10 + m * 33,
						"Vessel/Voy No.:", wctf5));
				ws.addCell(new jxl.write.Label(0, 11 + m * 33, "B/L No.:",
						wctf5));
				ws.addCell(new jxl.write.Label(0, 12 + m * 33, "ETD:", wctf5));
				ws.addCell(new jxl.write.Label(0, 13 + m * 33, "ETA:", wctf5));

				ws.addCell(new jxl.write.Label(6, 5 + m * 33, "INVOICE NO.: ",
						wctf5));
				// ws.addCell(new jxl.write.Label(8, 5+m*33, "MWUK",
				// wctf5));//客户简称
				// ws.addCell(new jxl.write.Label(9, 5+m*33, "120221",
				// wctf5));//发货的日期
				ws.addCell(new jxl.write.Label(8, 5 + m * 33, cells1.get(m)
						.get(7)+cells1.get(m).get(8), wctf5));// 客户简称
//				ws.addCell(new jxl.write.Label(9, 5 + m * 33, cells1.get(m)
//						.get(8), wctf5));// 发货的日期

				ws.addCell(new jxl.write.Label(6, 6 + m * 33, "DATE:  ", wctf5));
				// ws.addCell(new jxl.write.Label(7, 6+m*33, "12/2/21", wctf5));
//				ws.addCell(new jxl.write.Label(7, 6 + m * 33, cells1.get(m)
//						.get(9), wctf5));
				ws.addCell(new jxl.write.Label(7, 6 + m * 33,BlDateUtil.formatDate(new Date(), "yyyy-MM-dd"), wctf5));

				ws.addCell(new jxl.write.Label(6, 7 + m * 33, "CONTRACT NO.:",
						wctf5));
				// ws.addCell(new jxl.write.Label(8, 7+m*33, "GJ120202-5",
				// wctf5));//选择客户简称，关联合同，直接生成合同号
				ws.addCell(new jxl.write.Label(8, 7 + m * 33, cells1.get(m)
						.get(10), wctf5));// 选择客户简称，关联合同，直接生成合同号

				ws.addCell(new jxl.write.Label(6, 8 + m * 33, "Payment Terms:",
						wctf5));
				ws.addCell(new jxl.write.Label(8, 8 + m * 33, "T/T", wctf5));

				ws.addCell(new jxl.write.Label(6, 10 + m * 33, "L/C No.:",
						wctf5));
				ws.addCell(new jxl.write.Label(6, 11 + m * 33, "From:", wctf5));
				ws.addCell(new jxl.write.Label(7, 11 + m * 33, "Qingdao", wctf5));
				ws.addCell(new jxl.write.Label(6, 12 + m * 33, "To: ", wctf5));
				// ws.addCell(new jxl.write.Label(7, 12+m*33, "Canada", wctf5));
				ws.addCell(new jxl.write.Label(7, 12 + m * 33, cells1.get(m)
						.get(6), wctf5));
				ws.addCell(new jxl.write.Label(6, 13 + m * 33,
						"PBy Vessel / Air: ", wctf5));
				// ws.addCell(new jxl.write.Label(8, 13+m*33, "Air", wctf5));
				ws.addCell(new jxl.write.Label(8, 13 + m * 33, cells1.get(m)
						.get(11), wctf5));

				// dataList的header
				ws.mergeCells(0, 15 + m * 33, 1, 16 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 15 + m * 33, "Marks & No.s",
						wcf));

				ws.mergeCells(2, 15 + m * 33, 4, 16 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(2, 15 + m * 33, "Descriptions",
						wcf));

				ws.mergeCells(5, 15 + m * 33, 5, 16 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(5, 15 + m * 33, "qty", wcf));

				ws.mergeCells(6, 15 + m * 33, 6, 16 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(6, 15 + m * 33, "Unit", wcf));

				ws.mergeCells(7, 15 + m * 33, 9, 15 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(7, 15 + m * 33, "FOB  QINGDAO",
						wcf1));
				ws.addCell(new jxl.write.Label(7, 16 + m * 33,
						" Unit Price (USD)", wcf2));

				ws.mergeCells(8, 16 + m * 33, 9, 16 + m * 33); // 合并单元格
				ws.addCell(new jxl.write.Label(8, 16 + m * 33,
						"Total Amount (USD)", wcf2));

				for (int i2 = 17 + m * 33; i2 < (m + 1) * 33; i2++) {
					ws.setRowView(i2, 600);
				}

				
			//	
				
				int n = 0;// 本次m值所对应的数据条数
				Integer amount = 0;
				Double totalAmount = 0.00;
				StringBuffer totalgongshi = new StringBuffer();
				StringBuffer qtygongshi = new StringBuffer();
				for (int i = 0; i < cells2.size(); i++) {
					List<String> tempList = cells2.get(i);
					if (tempList != null && tempList.size() > 0) {
						if (tempList.get(0).equals(cells1.get(m).get(0))) {
							// ws.mergeCells(0, i + 17+m*33, 1, i + 17+m*33);
							amount = amount + Utility.toSafeInt(tempList.get(2));
							totalAmount = totalAmount
									+ Double.parseDouble(tempList.get(5));
							
							ws.mergeCells(2, n + 17 + m * 33, 4, n + 17 + m
									* 33);
							ws.mergeCells(8, n + 17 + m * 33, 9, n + 17 + m
									* 33);
							totalgongshi.append("I"+(n + 18 + m* 33)+"+");
							qtygongshi.append("F"+(n + 18 + m* 33)+"+");
							for (int j = 1, k = 0; j < tempList.size(); j++, k++) {
								if (j == 1) {
									k = j + 1;
								}
								if (j == 2) {
									k = j + 3;
								}
								
								//下面两行添加公式
								int lie = n + 17 + m* 33;
								Formula f = new Formula(8, lie, "CONCATENATE(\"$\","+"F"+(n + 18 + m* 33)+"*H"+(n + 18 + m* 33)+")" , wctf2);
								
								if(j>3){
									labTable = new jxl.write.Label(k, n + 17 + m* 33, df.format(Double.parseDouble(tempList.get(j))), wctf2);
									
								}
								else{
									labTable = new jxl.write.Label(k, n + 17 + m* 33, tempList.get(j), wctf2);
								}
								ws.addCell(labTable);
								ws.addCell(f);
							}
							n = n + 1;
						}

					}
				}
				totalgongshi.append("0");
				qtygongshi.append("0");
				
				ws.mergeCells(0, n + 17 + m * 33, 1, n + 17 + m * 33); // 合并单元格
				ws.mergeCells(8, n + 17 + m * 33, 9, n + 17 + m * 33); // 合并单元格
				for (int i1 = 0; i1 < 10; i1++) {
					labTable = new jxl.write.Label(i1, n + 17 + m * 33, "",
							wcf1);
					ws.addCell(labTable);
				}
				ws.addCell(new jxl.write.Label(0, n + 17 + m * 33, "Total:",
						wcf1));
				
				Formula f1 = new Formula(5, n + 17 + m * 33, qtygongshi.toString(), wcf1);
				ws.addCell(f1);
				Formula f2 = new Formula(8, n + 17 + m * 33, "CONCATENATE(\"$\","+totalgongshi.toString()+")", wcf1);
				ws.addCell(f2);
				
//				ws.addCell(new jxl.write.Label(5, n + 17 + m * 33, amount
//						.toString(), wcf1));
//				ws.addCell(new jxl.write.Label(8, n + 17 + m * 33,  df.format(totalAmount)
//						, wcf1));

				ws.addCell(new jxl.write.Label(1, n+19+m*33, "Country of origin:China", wctf5));
				
				ws.mergeCells(0, 17 + m * 33, 1, n + 17 + m * 33 - 1); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 17 + m * 33, "N/M", wcf));
				
				ws.mergeCells(6, n + 24 + m * 33, 9, n + 24 + m * 33);
				ws.addCell(new jxl.write.Label(6,n + 24 + m * 33,cells1.get(m).get(1),wctf6));
			}
		}
		return ws;
	}

	/**
	 * 批量导出发货明细
	 * 
	 * @param headMapList
	 * @param cellsMap
	 * @param createWorkbook
	 * @throws WriteException 
	 * @throws IOException 
	 */
	public static void batchExportExcelDelivery(List<Map<String, String>> headMapList,Map<String, List<List<String>>> cellsMap,WritableWorkbook wwb) throws WriteException, IOException {
		int k=0;
		for (Map<String, String> headMap: headMapList) {
			// 得到表中数据
			List<List<String>> cells = cellsMap.get(headMap.get("deliveryID"));
			jxl.write.WritableSheet ws = wwb.createSheet(headMap.get("sheetName")+k, k++);
			jxl.write.Label labTable = null;
			SheetSettings setting = ws.getSettings();
	
			/** */
			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			setting.setFitHeight(1); // 打印区高度
			setting.setFitWidth(1); // 打印区宽度
			// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
			// setting.setScaleFactor(100);// 设置缩放比例
	
			// 设置列宽
			ws.setColumnView(0, 10); // 第1列
			ws.setColumnView(1, 19); // 第2列
			ws.setColumnView(2, 12);
			ws.setColumnView(3, 19);
			ws.setColumnView(4, 10);
			ws.setColumnView(5, 10);
			ws.setColumnView(6, 10);
	
			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 16,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			wctf.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			wctf.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
	
			// 定义头部单元格样式
			WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 10,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
			wctf1.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
	
			// 定义头部单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf2 = new WritableCellFormat(wf2); // 单元格定义
			wctf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
	
			// 定义头部单元格样式
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf3 = new WritableCellFormat(wf3); // 单元格定义
			wctf3.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf3.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			wctf3.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			wctf3.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
	
			// 定义头部单元格样式
			WritableFont wf30 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf30 = new WritableCellFormat(wf30); // 单元格定义
			wctf30.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf30.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
						
			// 定义头部单元格样式
			WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf4 = new WritableCellFormat(wf4); // 单元格定义
			wctf4.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf4.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			wctf4.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf4.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
	
			// 定义头部单元格样式
			WritableFont wf5 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf5 = new WritableCellFormat(wf5); // 单元格定义
			wctf5.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf5.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf5.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf5.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
	
			// 定义头部单元格样式
			WritableFont wf6 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf6 = new WritableCellFormat(wf6); // 单元格定义
			wctf6.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf6.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf6.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf6.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
	
			// 定义头部单元格样式
			WritableFont wf7 = new WritableFont(WritableFont.ARIAL, 11,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf7 = new WritableCellFormat(wf7); // 单元格定义
			wctf7.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
	
			// 定义头部单元格样式
			WritableFont wf8 = new WritableFont(WritableFont.ARIAL, 11,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf8 = new WritableCellFormat(wf8); // 单元格定义
			wctf8.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf8.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
	
			// 定义头部单元格样式
			WritableFont wf9 = new WritableFont(WritableFont.ARIAL, 9,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf9 = new WritableCellFormat(wf9); // 单元格定义
			wctf9.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			
			// 定义头部单元格样式
			WritableFont wf10 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf10 = new WritableCellFormat(wf10); // 单元格定义
			wctf10.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf10.setBorder(jxl.format.Border.RIGHT, jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
			wctf10.setBorder(jxl.format.Border.BOTTOM, jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			
			// 定义图片单元格样式
			WritableFont wfImge = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctfImge = new WritableCellFormat(wfImge); // 单元格定义
			wctfImge.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctfImge.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctfImge.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			
			// 定义头部单元格样式
			WritableFont wf11 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf11 = new WritableCellFormat(wf11); // 单元格定义
			wctf11.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			wctf11.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf11.setBorder(jxl.format.Border.BOTTOM,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			wctf11.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.BLACK);
			
			//double cellSize = Math.ceil(cells.size() / 22.0);
			int m = 0;
			int cellSize = cells.size();
		//	for (int m = 0; m < cellSize; m++) {
				// 插入图片
				ws.setRowView(0 + m * 37, 400);
				File fileImage = new File(
						System.getProperty("user.dir")
								.replaceAll("bin",
										"webapps/hongling/themes/default/images/DeliveryDetailTitle.png"));
				WritableImage image = new WritableImage(0, 0 + m * 37, 2, 1,
						fileImage);// 从A1开始 跨2行3个单元格
				ws.addImage(image);//
	
				ws.addCell(new jxl.write.Label(0, 1 + m * 37, "修改状态：", wctf1));
				ws.addCell(new jxl.write.Label(1, 1 + m * 37, "01", wctf1));
				ws.addCell(new jxl.write.Label(6, 1 + m * 37, "NO:0405", wctf2));
	
				ws.mergeCells(0, 2 + m * 37, 6, 2 + m * 37); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 2 + m * 37, "MTM 发货明细", wctf));
	
				ws.mergeCells(0, 3 + m * 37, 6, 3 + m * 37); // 合并单元格
				ws.addCell(new jxl.write.Label(0, 3 + m * 37, "发出部门：国际业务部", wctf3));
	
				ws.setRowView(4 + m * 37, 600);
				ws.addCell(new jxl.write.Label(0, 4 + m * 37, "客户名称", wctf4));
				ws.addCell(new jxl.write.Label(1, 4 + m * 37, headMap.get("pubMemberName"), wctf5));
				ws.addCell(new jxl.write.Label(2, 4 + m * 37, "发货日期：", wctf5));
				ws.addCell(new jxl.write.Label(3, 4 + m * 37, headMap
						.get("deliveryDate"), wctf5));
				ws.addCell(new jxl.write.Label(4, 4 + m * 37, "业务员", wctf5));
				ws.mergeCells(5, 4 + m * 37, 6, 4 + m * 37); // 合并单元格
				ws.addCell(new jxl.write.Label(5, 4 + m * 37, headMap.get("bizPerson"), wctf10));
	
				ws.setRowView(5 + m * 37, 600);
				ws.addCell(new jxl.write.Label(0, 5 + m * 37, "序号", wctf4));
				ws.addCell(new jxl.write.Label(1, 5 + m * 37, "订单号", wctf11));
				ws.addCell(new jxl.write.Label(2, 5 + m * 37, "数量", wctf5));
				ws.addCell(new jxl.write.Label(3, 5 + m * 37, "面料成份", wctf5));
				ws.addCell(new jxl.write.Label(4, 5 + m * 37, "男装/女装", wctf5));
				ws.addCell(new jxl.write.Label(5, 5 + m * 37, "箱号", wctf5));
				ws.addCell(new jxl.write.Label(6, 5 + m * 37, "备注", wctf6));
	
				for (int i = 0; i < cellSize; i++) {
					if (i + m * 22 > cells.size() - 1) {
						for (int j = 0; j < 7; j++) {
							if (j == 0) {
								labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf4);
							} else if (j==1) {
								labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf11);
							} else if (j == 6) {
								labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf6);
							} else {
								labTable = new jxl.write.Label(j, i + 6 + m * 37,"", wctf5);
							}
							ws.setRowView(i + 6 + m * 37, 400);
							ws.addCell(labTable);
						}
					} else {
						List<String> tempList = cells.get(i + m * 22);
						if (tempList != null && tempList.size() > 0) {
							for (int j = 0; j < tempList.size(); j++) {
								if (j == 0) {
									labTable = new jxl.write.Label(j, i + 6 + m
											* 37, tempList.get(j), wctf4);
								} else if (j==1) {
									labTable = new jxl.write.Label(j, i + 6 + m * 37,tempList.get(j), wctf11);
								} else if (j == 6) {
									labTable = new jxl.write.Label(j, i + 6 + m
											* 37, tempList.get(j), wctf6);
								} else {
									labTable = new jxl.write.Label(j, i + 6 + m
											* 37, tempList.get(j), wctf5);
								}
								ws.setRowView(i + 6 + m * 37, 400);
								ws.addCell(labTable);
							}
						}
					}
					ws.mergeCells(0, cellSize+6 + m * 37, 6, cellSize+6 + m * 37); // 合并单元格28
					//ws.mergeCells(0, 29 + m * 37, 6, 29 + m * 37); // 合并单元格
					ws.addCell(new jxl.write.Label(0, cellSize+6 + m * 37, "包装要求", wctf));//28
					ws.mergeCells(0, cellSize+7 + m * 37, 6, cellSize+7 + m * 37); // 合并单元格29
					ws.addCell(new jxl.write.Label(0, cellSize+7 + m * 37, headMap.get("memo"), wctf3));
					ws.addCell(new jxl.write.Label(7, cellSize+6 + m * 37, "", wctf30));
					ws.addCell(new jxl.write.Label(7, cellSize+7 + m * 37, "", wctf30));
					
					ws.setRowView(cellSize+7 + m * 37, 600);
	
					ws.addCell(new jxl.write.Label(0, cellSize+8 + m * 37,
							"1、《发货明细》一式两份，提前于发货日两天给仓库。  ", wctf7));
					ws.addCell(new jxl.write.Label(0, cellSize+9 + m * 37,
							"2、 实际发货当日，八点前必须将入库数量及时反馈给业务，并做好标记，以便制作下一次 ", wctf7));
					ws.addCell(new jxl.write.Label(0, cellSize+11 + m * 37, "发货明细 ", wctf7));
	
					ws.addCell(new jxl.write.Label(4, cellSize+13 + m * 37, "填表人：", wctf9));
					ws.mergeCells(5, cellSize+13 + m * 37, 6, cellSize+13 + m * 37); // 合并单元格
					ws.addCell(new jxl.write.Label(5, cellSize+13 + m * 37, headMap.get("bizPerson"), wctf8));
					
					ws.addCell(new jxl.write.Label(4, cellSize+14 + m * 37, "填表日期： ", wctf9));
					ws.mergeCells(5, cellSize+14 + m * 37, 6, cellSize+14 + m * 37); // 合并单元格
					// 得到填表日期
					Date deliveryDate = new Date();
					try {
						deliveryDate = BlDateUtil.parseDate(headMap.get("deliveryDate"), "yyyy-MM-dd");
					} catch (Exception e) {
						LogPrinter.error("exportExcelDelivery_err"+e.getMessage());
					}
					Date fillDate = BlDateUtil.addDay(deliveryDate, -3);
					ws.addCell(new jxl.write.Label(5, cellSize+14 + m * 37, BlDateUtil.formatDate(fillDate, "yyyy-MM-dd"), wctf8));
				}
		//	}
		}
		wwb.write();
		wwb.close();
	}
	
	/**
	 * 生成对账单
	 * @param member
	 * @param statementMap
	 * @param payDetailMap
	 * @param wwb
	 * @throws IOException
	 * @throws WriteException
	 */
	public static void exportExcelDuiZhangDan(Member member,Map<String, String> statementMap,
			Map<String, List<?>> payDetailMap, WritableWorkbook wwb)
			throws IOException, WriteException {
		// 生成款项明细
		getExcelSheetPayDetail(payDetailMap, wwb);
		
		// 生成对账单
		getExcelSheetStatement(member, statementMap, wwb);

		wwb.write();
		wwb.close();
	}

	/**
	 * 生成对账单
	 * @param member
	 * @param statementMap
	 * @param wwb
	 * @throws WriteException 
	 */
	private static WritableSheet getExcelSheetStatement(Member member,Map<String, String> statementMap, WritableWorkbook wwb) throws WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet("STATEMENT", 0);
		NumberFormat usDf=new DecimalFormat("'$'#,##0.00");
		NumberFormat cnDf=new DecimalFormat("'￥'#,##0.00");
		
		if (statementMap.size() > 0) {
			SheetSettings setting = ws.getSettings();

			/** */
			/** ********* 打印属性 **************** */
			setting.setOrientation(PageOrientation.LANDSCAPE); // 设置为横向打印
			setting.setPaperSize(PaperSize.A4); // 设置纸张
			// setting.setFitHeight(1) ; // 打印区高度
			setting.setFitWidth(1); // 打印区宽度
			// setting.setPrintArea(1, 2, 3, 4); // 设置打印范围（右上的列号和行号，左下的列号和行号）
			setting.setOrientation(PageOrientation.PORTRAIT); // 设置为纵向打印
			// setting.setScaleFactor(100);// 设置缩放比例

			// 定义头部单元格样式
			WritableFont wf0 = new WritableFont(WritableFont.ARIAL, 11,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf = new WritableCellFormat(wf0); // 单元格定义
			wctf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wctf.setBorder(jxl.format.Border.LEFT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.GRAY_25);
			wctf.setBorder(jxl.format.Border.TOP,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.GRAY_25);
			wctf.setBorder(jxl.format.Border.RIGHT,
					jxl.format.BorderLineStyle.THIN, jxl.format.Colour.GRAY_25);

			// 标题栏
			WritableFont wf = new WritableFont(WritableFont.ARIAL, 14,
					WritableFont.BOLD, false, UnderlineStyle.SINGLE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
			wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf.setVerticalAlignment(VerticalAlignment.BOTTOM); // 垂直对齐

			// 定义头部单元格样式
			WritableFont wf1 = new WritableFont(WritableFont.ARIAL, 10,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf1 = new WritableCellFormat(wf1); // 单元格定义
			wctf1.setAlignment(jxl.format.Alignment.LEFT); // 设置对齐方式
			
			// 定义表格头部单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf2 = new WritableCellFormat(wf2);
			wctf2.setAlignment(jxl.format.Alignment.CENTRE);
			wctf2.setWrap(true);// 设置自动换行
			wctf2.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.DOUBLE,jxl.format.Colour.BLACK);
			wctf2.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.DOUBLE,jxl.format.Colour.BLACK);
			
			// 定义表格头部单元格样式
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf3 = new WritableCellFormat(wf3);
			wctf3.setAlignment(jxl.format.Alignment.CENTRE);
			
			// 定义表格头部单元格样式
			WritableFont wf4 = new WritableFont(WritableFont.ARIAL, 12,
					WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
					jxl.format.Colour.BLACK);
			WritableCellFormat wctf4 = new WritableCellFormat(wf4);
			wctf4.setAlignment(jxl.format.Alignment.CENTRE);
			wctf4.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.DOUBLE,jxl.format.Colour.BLACK);
			
			// 设置列宽
			ws.setColumnView(0, 12);
			ws.setColumnView(1, 16);
			ws.setColumnView(2, 17);
			ws.setColumnView(3, 16);
			ws.setColumnView(4, 14);
			ws.setColumnView(5, 21);

			// 合并表头单元格
			ws.mergeCells(0, 0, 5, 0); // 合并单元格
			ws.mergeCells(0, 1, 5, 1); // 合并单元格
			ws.mergeCells(0, 2, 5, 2); // 合并单元格
			// 标题
			ws.mergeCells(0, 3, 5, 3); // 合并单元格
			
			// head的内容
			ws.addCell(new jxl.write.Label(0, 0, "Qingdao KM Finery CO., LTD.", wctf));
			ws.addCell(new jxl.write.Label(0, 1, "NO.19 Redcollar Street, Jimo, Qingdao, China  Tel: 0086-531-88597308", wctf));
			ws.addCell(new jxl.write.Label(0, 2, "www.rcmtm.com",wctf));
			
			// 设置标题名
			ws.addCell(new jxl.write.Label(0, 3, "COMMERCIAL  INVOICE", wcf));
			ws.setRowView(3, 800);

			ws.addCell(new jxl.write.Label(0, 4, "Issue To ：", wctf1));
			ws.mergeCells(1, 4, 2, 4);
			if (member.getAddressLine2() != null || member.getAddressLine1() != null) {
				ws.addCell(new jxl.write.Label(1, 4, member.getAddressLine2()+member.getAddressLine1(), wctf1));
			} else {
				ws.addCell(new jxl.write.Label(1, 4, "", wctf1));
			}
			ws.addCell(new jxl.write.Label(4, 4, "Invoice No.", wctf1));
			ws.addCell(new jxl.write.Label(5, 4, member.getCompanyShortName()+BlDateUtil.formatDate(new Date(), "yyyyMM"), wctf1));
			ws.setRowView(4, 800);
			
			ws.addCell(new jxl.write.Label(0,5,"",wctf1));
			if (member.getCity() != null || member.getDivision()!=null) {
				ws.addCell(new jxl.write.Label(1,5,member.getCity()+member.getDivision(),wctf1));
			} else {
				ws.addCell(new jxl.write.Label(1,5,"",wctf1));
			}
			ws.addCell(new jxl.write.Label(4,5,"Date：",wctf1));
			ws.addCell(new jxl.write.Label(5,5,BlDateUtil.formatDate(new Date(), "dd/MM/yyyy"), wctf1));
			ws.setRowView(5, 300);
			
			if (member.getCountryName() != null) {
				ws.addCell(new jxl.write.Label(1,6,member.getCountryName(),wctf1));
			} else {
				ws.addCell(new jxl.write.Label(1,6,"",wctf1));
			} 
			ws.setRowView(6, 300);
			
			if (member.getPhoneNumber() != null) {
				ws.addCell(new jxl.write.Label(1,7,member.getPhoneNumber(),wctf1));
			} else {
				ws.addCell(new jxl.write.Label(1,7,"",wctf1));
			}
			ws.setRowView(7, 300);
			
			ws.addCell(new jxl.write.Label(0,8,"Atten：",wctf1));
			ws.addCell(new jxl.write.Label(1,8,member.getName(),wctf1));
			ws.addCell(new jxl.write.Label(4,8,"From:",wctf1));
			ws.addCell(new jxl.write.Label(5,8,"Red Collar",wctf1));
			ws.setRowView(8, 300);
			
			ws.setRowView(9, 300);
			
			ws.addCell(new jxl.write.Label(0,10,"No.",wctf2));
			ws.addCell(new jxl.write.Label(1,10,"Item",wctf2));
			ws.addCell(new jxl.write.Label(2,10,"Description",wctf2));
			ws.addCell(new jxl.write.Label(3,10,"Quantity",wctf2));
			if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
				ws.addCell(new jxl.write.Label(4,10,"Amount  (RMB)",wctf2));
			} else {
				ws.addCell(new jxl.write.Label(4,10,"Amount  (USD)",wctf2));
			}
			ws.addCell(new jxl.write.Label(5,10,"Remark",wctf2));
			ws.setRowView(10, 800);
			
			ws.addCell(new jxl.write.Label(0,11,"1",wctf3));
			ws.addCell(new jxl.write.Label(1,11,"garments",wctf3));
			ws.addCell(new jxl.write.Label(2,11,"",wctf3));
			ws.addCell(new jxl.write.Label(3,11,statementMap.get("garmentQty"),wctf3));
			if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
				ws.addCell(new jxl.write.Label(4,11,cnDf.format(Utility.toSafeDouble(statementMap.get("garmentsAmount"))),wctf3));
			} else {
				ws.addCell(new jxl.write.Label(4,11,usDf.format(Utility.toSafeDouble(statementMap.get("garmentsAmount"))),wctf3));
			}
			ws.addCell(new jxl.write.Label(5,11,"",wctf3));
			ws.setRowView(11, 800);
			
			ws.addCell(new jxl.write.Label(0,12,"2",wctf3));
			ws.addCell(new jxl.write.Label(1,12,"shipping",wctf3));
			ws.addCell(new jxl.write.Label(2,12,"",wctf3));
			ws.addCell(new jxl.write.Label(3,12,statementMap.get("shippingQty"),wctf3));
			if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
				ws.addCell(new jxl.write.Label(4,12,cnDf.format(Utility.toSafeDouble(statementMap.get("shippingAmount"))),wctf3));
			} else {
				ws.addCell(new jxl.write.Label(4,12,usDf.format(Utility.toSafeDouble(statementMap.get("shippingAmount"))),wctf3));
			}
			ws.addCell(new jxl.write.Label(5,12,"",wctf3));
			ws.setRowView(12, 800);
			
			ws.addCell(new jxl.write.Label(0,13,"3",wctf3));
			ws.addCell(new jxl.write.Label(1,13,"swatches",wctf3));
			ws.addCell(new jxl.write.Label(2,13,"",wctf3));
			ws.addCell(new jxl.write.Label(3,13,statementMap.get("swatchesQty"),wctf3));
			if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
				ws.addCell(new jxl.write.Label(4,13,cnDf.format(Utility.toSafeDouble(statementMap.get("swatchesAmount"))),wctf3));
			} else {
				ws.addCell(new jxl.write.Label(4,13,usDf.format(Utility.toSafeDouble(statementMap.get("swatchesAmount"))),wctf3));
			}
			ws.addCell(new jxl.write.Label(5,13,"",wctf3));
			ws.setRowView(13, 800);
			
			ws.addCell(new jxl.write.Label(0,14,"4",wctf3));
			ws.addCell(new jxl.write.Label(1,14,"other",wctf3));
			ws.addCell(new jxl.write.Label(2,14,"",wctf3));
			ws.addCell(new jxl.write.Label(3,14,statementMap.get("otherQty"),wctf3));
			if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
				ws.addCell(new jxl.write.Label(4,14,cnDf.format(Utility.toSafeDouble(statementMap.get("otherAmount"))),wctf3));
			} else {
				ws.addCell(new jxl.write.Label(4,14,usDf.format(Utility.toSafeDouble(statementMap.get("otherAmount"))),wctf3));
			}
			ws.addCell(new jxl.write.Label(5,14,"",wctf3));
			ws.setRowView(14, 800);
			
			if ("0".equals(statementMap.get("chargeQty"))) {
				ws.addCell(new jxl.write.Label(0,15,"5",wctf3));
				ws.addCell(new jxl.write.Label(1,15,"discount",wctf3));
				ws.addCell(new jxl.write.Label(2,15,"",wctf3));
				ws.addCell(new jxl.write.Label(3,15,statementMap.get("discountQty"),wctf3));
				if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
					ws.addCell(new jxl.write.Label(4,15,cnDf.format(Utility.toSafeDouble(statementMap.get("discountAmount"))),wctf3));
				} else {
					ws.addCell(new jxl.write.Label(4,15,usDf.format(Utility.toSafeDouble(statementMap.get("discountAmount"))),wctf3));
				}
				ws.addCell(new jxl.write.Label(5,15,"",wctf3));
				ws.setRowView(15, 800);
				
				ws.addCell(new jxl.write.Label(0,16,"Total:",wctf4));
				ws.addCell(new jxl.write.Label(1,16,"",wctf4));
				ws.addCell(new jxl.write.Label(2,16,"",wctf4));
				ws.addCell(new jxl.write.Label(3,16,statementMap.get("totalQty"),wctf4));
				if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
					ws.addCell(new jxl.write.Label(4,16,cnDf.format(Utility.toSafeDouble(statementMap.get("totalAmount"))),wctf4));
				} else {
					ws.addCell(new jxl.write.Label(4,16,usDf.format(Utility.toSafeDouble(statementMap.get("totalAmount"))),wctf4));
				}
				ws.addCell(new jxl.write.Label(5,16,"",wctf4));
				ws.setRowView(16, 800);
			} else {
				ws.addCell(new jxl.write.Label(0,15,"5",wctf3));
				ws.addCell(new jxl.write.Label(1,15,"charge back",wctf3));
				ws.addCell(new jxl.write.Label(2,15,"",wctf3));
				ws.addCell(new jxl.write.Label(3,15,statementMap.get("chargeQty"),wctf3));
				if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
					ws.addCell(new jxl.write.Label(4,15,cnDf.format(Utility.toSafeDouble(statementMap.get("chargeAmount"))),wctf3));
				} else {
					ws.addCell(new jxl.write.Label(4,15,usDf.format(Utility.toSafeDouble(statementMap.get("chargeAmount"))),wctf3));
				}
				ws.addCell(new jxl.write.Label(5,15,"",wctf3));
				ws.setRowView(15, 800);
				
				ws.addCell(new jxl.write.Label(0,16,"6",wctf3));
				ws.addCell(new jxl.write.Label(1,16,"discount",wctf3));
				ws.addCell(new jxl.write.Label(2,16,"",wctf3));
				ws.addCell(new jxl.write.Label(3,16,statementMap.get("discountQty"),wctf3));
				if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
					ws.addCell(new jxl.write.Label(4,16,cnDf.format(Utility.toSafeDouble(statementMap.get("discountAmount"))),wctf3));
				} else {
					ws.addCell(new jxl.write.Label(4,16,usDf.format(Utility.toSafeDouble(statementMap.get("discountAmount"))),wctf3));
				}
				ws.addCell(new jxl.write.Label(5,16,"",wctf3));
				ws.setRowView(16, 800);
				
				ws.addCell(new jxl.write.Label(0,17,"Total:",wctf4));
				ws.addCell(new jxl.write.Label(1,17,"",wctf4));
				ws.addCell(new jxl.write.Label(2,17,"",wctf4));
				ws.addCell(new jxl.write.Label(3,17,statementMap.get("totalQty"),wctf4));
				if (member.getMoneySignID()!=null && member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
					ws.addCell(new jxl.write.Label(4,17,cnDf.format(Utility.toSafeDouble(statementMap.get("totalAmount"))),wctf4));
				} else {
					ws.addCell(new jxl.write.Label(4,17,usDf.format(Utility.toSafeDouble(statementMap.get("totalAmount"))),wctf4));
				}
				ws.addCell(new jxl.write.Label(5,17,"",wctf4));
				ws.setRowView(17, 800);
			}
		}
		return ws;
	}
	
	
	/**
	 * 生成款项明细
	 * @param cells3
	 * @param cells4
	 * @param wwb
	 * @throws WriteException 
	 */
	@SuppressWarnings("unchecked")
	private static void getExcelSheetPayDetail(Map<String, List<?>> detailMap,WritableWorkbook wwb) throws WriteException {
		jxl.write.WritableSheet ws = wwb.createSheet("PayDetails", 0);
		jxl.write.Label labTable = null;
		List<String> headList = (List<String>)detailMap.get("detailMap");
		List<List<String>> cells = (List<List<String>>)detailMap.get("detailCells");
		
		NumberFormat df = new DecimalFormat("0.00");
		
		// 定义头部单元格样式
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
		wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wcf.setBorder(jxl.format.Border.TOP,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);

		// 定义单元格样式
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wcf2 = new WritableCellFormat(wf2); // 单元格定义
		wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wcf2.setBorder(jxl.format.Border.TOP,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf2.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf2.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf2.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		
		// 定义头部单元格样式
		WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 10,
				WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,
				jxl.format.Colour.BLACK);
		WritableCellFormat wcf3 = new WritableCellFormat(wf3); // 单元格定义
		wcf3.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wcf3.setBorder(jxl.format.Border.TOP,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf3.setBorder(jxl.format.Border.BOTTOM,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf3.setBorder(jxl.format.Border.LEFT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
		wcf3.setBorder(jxl.format.Border.RIGHT,
				jxl.format.BorderLineStyle.MEDIUM, jxl.format.Colour.BLACK);
				
		ws.mergeCells(0, 0, 9, 0);
		ws.addCell(new jxl.write.Label(0,0,ResourceHelper.getValue("Cash_DealDetail"),wcf3));
		ws.setRowView(0, 500);
		
		for (int i = 0; i < headList.size(); i++) {
			labTable = new jxl.write.Label(i, 1, headList.get(i), wcf);
			ws.setColumnView(0, 12);
			ws.setColumnView(1, 20);
//			ws.setColumnView(2, 10);
			ws.setColumnView(2, 14);
			ws.setColumnView(3, 14);
			ws.setColumnView(4, 6);
			ws.setColumnView(5, 15);
			ws.setColumnView(6, 15);
			ws.setColumnView(7, 15);
			ws.setColumnView(8, 10);
			ws.setColumnView(9, 10);
			ws.setRowView(0, 300);
			ws.addCell(labTable);
		}
		
		Double inAmount = 0.0;
		Double outAmount = 0.0;
		for (int i = 0; i < cells.size(); i++) {
			List<String> tempList = cells.get(i);
			if (tempList != null && tempList.size() > 0) {
				for (int j = 0; j < tempList.size(); j++) {
					labTable = new jxl.write.Label(j, i + 2, tempList.get(j),wcf2);
					if (j==6) {
						inAmount += Utility.toSafeDouble(tempList.get(j));
					}
					if (j==7) {
						outAmount += Utility.toSafeDouble(tempList.get(j));
					}
					ws.addCell(labTable);
				}
			}
		}
		
		ws.addCell(new jxl.write.Label(0,cells.size()+2,ResourceHelper.getValue("Cash_Total"),wcf));
		ws.addCell(new jxl.write.Label(1,cells.size()+2,"",wcf));
//		ws.addCell(new jxl.write.Label(2,cells.size()+2,"",wcf));
		ws.addCell(new jxl.write.Label(2,cells.size()+2,"",wcf));
		ws.addCell(new jxl.write.Label(3,cells.size()+2,"",wcf));
		ws.addCell(new jxl.write.Label(4,cells.size()+2,"",wcf));
		ws.addCell(new jxl.write.Label(5,cells.size()+2,df.format(inAmount),wcf2));
		ws.addCell(new jxl.write.Label(6,cells.size()+2,df.format(outAmount),wcf2));
		ws.addCell(new jxl.write.Label(7,cells.size()+2,"",wcf));
		ws.addCell(new jxl.write.Label(8,cells.size()+2,"",wcf));
		ws.addCell(new jxl.write.Label(9,cells.size()+2,"",wcf));
	}
	 /**
	  * 插入公式
	  * 
	  * @param sheet
	  * @param col
	  * @param row
	  * @param formula
	  * @param format
	  */
	 public static void insertFormula(WritableSheet sheet, Integer col, Integer row,
	   String formula, WritableCellFormat format) {
	  try {
	   Formula f = new Formula(col, row, formula, format);
	   sheet.addCell(f);
	  } catch (Exception e) {
	   e.printStackTrace();
	  }
	 }
}
