package cn.rkylin.apollo.common.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;

public class ExportExcelSheet {
	private List<ExcelCell> listTitle; //单元格的属性设置项目
	private List<Map<String,Object>> listRow; //单个sheet的数据集
	
	public List<Map<String, Object>> getListRow() {
		return listRow;
	}
	public void setListRow(List<Map<String, Object>> listRow) {
		this.listRow = listRow;
	}
	public List<ExcelCell> getListTitle() {
		return listTitle;
	}
	public void setListTitle(List<ExcelCell> listTitle) {
		this.listTitle = listTitle;
	}
	
	//默认设置导出项目单元格
	public void setListTitle(String colName, String colValue) {
		String[] colNameArry = colName.split(",");
		String[] colValueArry = colValue.split(",");
		//设置题头单元格的属性
		if (colNameArry!=null && colNameArry.length > 0 && colValueArry!=null && colValueArry.length > 0 && colNameArry.length == colValueArry.length){
			listTitle = new ArrayList<ExcelCell>();
			for (int i = 0 ; i < colNameArry.length ; i++){
				if (StringUtils.isNotBlank(colNameArry[i]) && StringUtils.isNotBlank(colValueArry[i])){
					ExcelCell excelCell = new ExcelCell();
					excelCell.setCellType(HSSFCell.CELL_TYPE_STRING);
					excelCell.setName(colNameArry[i]);
					excelCell.setValue(colValueArry[i]);
					listTitle.add(excelCell);
				}
			}
		}
	}
}
