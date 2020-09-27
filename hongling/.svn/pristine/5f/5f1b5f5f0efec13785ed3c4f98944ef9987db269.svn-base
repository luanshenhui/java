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
 * 返修一级报表导出Excel帮助类,包含合并单元格
 * @author Chen.Xin.qi 
 * date 2015-05-08
 */
public class RepairTopExcelUtil {

	
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
			labTable = new jxl.write.Label(i, 2, headerlist.get(i), wcf);
			ws.setColumnView(0, 16);
			ws.setColumnView(i+1, 16);
			ws.setRowView(0, 300);
			ws.addCell(labTable);
		}
		Label category=new Label(0,0,"品类名称",wcf);  
		Label orderNum=new Label(1,0,"下单数量",wcf);  
		Label repairNum=new Label(4,0,"返修数量",wcf);  
		Label repairRate=new Label(28,0,"返修率",wcf);  
		Label yearOrder=new Label(1,1,"年下单量",wcf);  
		Label monthOrder=new Label(2,1,"月下单量",wcf);  
		Label dayOrder=new Label(3,1,"日下单量",wcf);  
		Label yearRepair=new Label(4,1,"年返修量",wcf);  
		Label monthRepair=new Label(12,1,"月返修量",wcf);  
		Label dayRepair=new Label(20,1,"日返修量",wcf);  
		Label yearRate=new Label(28,1,"年返修率",wcf);  
		Label monthRate=new Label(29,1,"月返修率",wcf);  
		Label dayRate=new Label(30,1,"日返修率",wcf);  
		ws.addCell(category);ws.addCell(orderNum);
		ws.addCell(repairNum);ws.addCell(repairRate);
		ws.addCell(yearOrder);ws.addCell(monthOrder);
		ws.addCell(dayOrder);ws.addCell(yearRepair);
		ws.addCell(monthRepair);ws.addCell(dayRepair);
		ws.addCell(yearRate);ws.addCell(monthRate);
		ws.addCell(dayRate);
		
		ws.mergeCells(0, 0, 0, 1);
		ws.mergeCells(1, 0, 3, 0);
		ws.mergeCells(4, 0, 27, 0);
		ws.mergeCells(28, 0, 30, 0);
		ws.mergeCells(1, 1, 1, 2);
		ws.mergeCells(2, 1, 2, 2);
		ws.mergeCells(3, 1, 3, 2);
		ws.mergeCells(4, 1, 11, 1);
		ws.mergeCells(12, 1, 19, 1);
		ws.mergeCells(20, 1, 27, 1);
		
		for (int i = 0; i < cells.size(); i++) {
			List<String> tempList = cells.get(i);
			if (tempList != null && tempList.size() > 0) {
				for (int j = 0; j < tempList.size(); j++) {
					labTable = new jxl.write.Label(j, i + 3, tempList.get(j), wcf2);
					ws.addCell(labTable);
				}

			}

		}
		wwb.write();
		wwb.close();
	}

}
