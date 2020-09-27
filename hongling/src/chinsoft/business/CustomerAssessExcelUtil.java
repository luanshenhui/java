package chinsoft.business;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

/**
 * 导出excel客户评价,包含合并单元格
 * @author Chen.Xin.qi 
 * date 2015-05-07
 */
public class CustomerAssessExcelUtil {

	
	public static void exportExcel( ArrayList<String> headerlist, List<List<String>> cells,WritableWorkbook wwb,String listName) throws IOException, WriteException {

		
		jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
		jxl.write.Label labTable = null;
		// 定义头部单元格样式
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.WHITE);
		WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
		wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
		wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wcf.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		wcf.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,jxl.format.Colour.BLACK);
		
		
		//定义单元格样式
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);
		WritableCellFormat wcf2 = new WritableCellFormat(wf2); // 单元格定义
		wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
		wcf2.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,jxl.format.Colour.BLACK);
		for (int i = 0; i < headerlist.size(); i++) {
			labTable = new jxl.write.Label(i, 1, headerlist.get(i), wcf);
			ws.setColumnView(0, 10);
			ws.setColumnView(i+1, 20);
			ws.setRowView(0, 300);
			ws.addCell(labTable);
		}
		Label haoping=new Label(2,0,"好评",wcf);  
		Label chaping=new Label(4,0,"差评",wcf);  
		Label tongji=new Label(6,0,"差评原因统计",wcf);  
		Label yonghuming=new Label(0,0,"用户名",wcf);  
		Label zongliang=new Label(1,0,"评价总量",wcf);  
		ws.addCell(haoping);
		ws.addCell(chaping);
		ws.addCell(tongji);
		ws.addCell(yonghuming);
		ws.addCell(zongliang);
		ws.mergeCells(2, 0, 3, 0);
		ws.mergeCells(4, 0, 5, 0);
		ws.mergeCells(6, 0, 9, 0);
		ws.mergeCells(0, 0, 0, 1);
		ws.mergeCells(1, 0, 1, 1);
		
		for (int i = 0; i < cells.size(); i++) {
			List<String> tempList = cells.get(i);
			if (tempList != null && tempList.size() > 0) {
				for (int j = 0; j < tempList.size(); j++) {
					labTable = new jxl.write.Label(j, i + 2, tempList.get(j), wcf2);
					ws.addCell(labTable);
				}

			}

		}
		wwb.write();
		wwb.close();
	}

}
