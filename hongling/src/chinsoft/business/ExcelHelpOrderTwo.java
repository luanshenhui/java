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

public class ExcelHelpOrderTwo {	
	/**
	 * 导出excel
	 * @author luan.shen.hui
	 * date 2015-05-08
	 */
		public static void exportExcel(ArrayList<String> headerlist, List<List<String>> cells,WritableWorkbook wwb,String listName) throws IOException, WriteException {

			jxl.write.WritableSheet ws = wwb.createSheet(listName, 0);
			jxl.write.Label labTable = null;
			// 定义头部单元格样式
			WritableFont wf = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.WHITE);
			WritableCellFormat wcf = new WritableCellFormat(wf); // 单元格定义
			wcf.setBackground(jxl.format.Colour.PALE_BLUE); // 设置单元格的背景颜色
			wcf.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//
			wcf.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,jxl.format.Colour.BLACK);//
			
			//定义单元格样式
			WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);
			WritableCellFormat wcf2 = new WritableCellFormat(wf2); // 单元格定义
			wcf2.setAlignment(jxl.format.Alignment.CENTRE); // 设置对齐方式
			wcf2.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN,jxl.format.Colour.BLACK);//设置边框颜色
			for (int i = 0; i < headerlist.size(); i++) {
				labTable = new jxl.write.Label(i, 2, headerlist.get(i), wcf);
				ws.setColumnView(0, 10);
				ws.setColumnView(i+1, 20);
				ws.setRowView(0, 300);
				ws.addCell(labTable);
			}
			
			Label a=new Label(0,0,"品类",wcf); 
			Label b=new Label(1,0,"客户简称",wcf);			
			Label c=new Label(2,0,"客户名称",wcf);			
			Label d=new Label(3,0,"下单数量",wcf);		
			Label d1=new Label(3,1,"日累计量",wcf);		
			Label d2=new Label(4,1,"月累计量",wcf);		
			Label d3=new Label(5,1,"年累计量",wcf);		
			
			Label e=new Label(6,0,"返修扣款",wcf);						
			Label e1=new Label(6,1,"年累计扣款",wcf);						
			Label e2=new Label(7,1,"月累计扣款",wcf);						
			Label e3=new Label(8,1,"日累计扣款",wcf);						
			Label f=new Label(9,0,"返修数量",wcf);			
			Label g=new Label(9,1,"年返修数量",wcf);			
			Label h=new Label(17,1,"月返修数量",wcf);
			Label ii=new Label(25,1,"日返修数量",wcf);
			ws.addCell(a);
			ws.addCell(b);
			ws.addCell(c);
			ws.addCell(d);
			ws.addCell(d1);
			ws.addCell(d2);
			ws.addCell(d3);			
			ws.addCell(e);
			ws.addCell(e1);
			ws.addCell(e2);
			ws.addCell(e3);
			ws.addCell(f);
			ws.addCell(g);
			ws.addCell(h);			
			ws.addCell(ii);
			ws.mergeCells(0, 0, 0, 2);//品类
			ws.mergeCells(1, 0, 1, 2);//客户简称
			ws.mergeCells(2, 0, 2, 2);//客户名称
			ws.mergeCells(3, 0, 5, 0);//下单数量
			ws.mergeCells(6, 0, 8, 0);//返修扣款			
			ws.mergeCells(3, 1, 3, 2);//日累计量
			ws.mergeCells(4, 1, 4, 2);//月累计量
			ws.mergeCells(5, 1, 5, 2);//年累计量
			
			ws.mergeCells(6, 1, 6, 2);//年累计扣款
			ws.mergeCells(7, 1, 7, 2);//月累计扣款
			ws.mergeCells(8, 1, 8, 2);//日累计扣款
			
			ws.mergeCells(9, 0, 32, 0);//返修数量
			ws.mergeCells(9, 1, 16, 0);//年返修数量
			ws.mergeCells(17, 1, 24, 0);//月返修数量
			ws.mergeCells(25, 1, 32, 0);//日返修数量	
	
			
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


