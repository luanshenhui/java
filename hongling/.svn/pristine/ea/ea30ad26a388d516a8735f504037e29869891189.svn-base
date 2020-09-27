package chinsoft.business;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jxl.format.UnderlineStyle;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

/**
 * 导出excel
 * @author 周勇
 * date 2012-02-21
 */
public class ExcelHelper {

	
	public static void exportExcel(ArrayList<String> headerlist, List<List<String>> cells,WritableWorkbook wwb,String listName) throws IOException, WriteException {

		
		jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
		jxl.write.Label labTable = null;
		// 定义头部单元格样式
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.WHITE);
		WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
		wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
		wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		
		//定义单元格样式
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);
		WritableCellFormat wcf2 = new WritableCellFormat(wf2); // 单元格定义
		wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		
		for (int i = 0; i < headerlist.size(); i++) {
			labTable = new jxl.write.Label(i, 0, headerlist.get(i), wcf);
			ws.setColumnView(0, 10);
			ws.setColumnView(i+1, 20);
			ws.setRowView(0, 300);
			ws.addCell(labTable);
		}

		for (int i = 0; i < cells.size(); i++) {
			List<String> tempList = cells.get(i);
			if (tempList != null && tempList.size() > 0) {
				for (int j = 0; j < tempList.size(); j++) {
					labTable = new jxl.write.Label(j, i + 1, tempList.get(j), wcf2);
					ws.addCell(labTable);
				}

			}

		}
		wwb.write();
		wwb.close();
	}

}
