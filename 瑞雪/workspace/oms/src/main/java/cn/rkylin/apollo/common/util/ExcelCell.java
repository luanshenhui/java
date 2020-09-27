package cn.rkylin.apollo.common.util;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class ExcelCell {
	private String name=null;	//单元格对应的中文名字
	private String value=null;  //单元格对应的英文名字，一般是字段名字
	private int cellType=HSSFCell.CELL_TYPE_STRING; //单元格的属性
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public int getCellType() {
		return cellType;
	}
	public void setCellType(int cellType) {
		this.cellType = cellType;
	}
}
