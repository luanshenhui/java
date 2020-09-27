package cn.rkylin.apollo.common.util;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;

/**
 * EXCEL导出
 * 
 * @author jinshen
 * @version 1.0
 * @created 10-2月-2017 09:11:15
 */
public class ExportExcelFileUtil {
	private static final Log log = LogFactory.getLog(ExportProjectUtil.class);
	
	/**
	 * 根据dataList生成Excel
	 * @param exportExcelMap      对应的指定sheet的数据的内容
	 * @param fileName 导出文件的名字
	 * @return HSSFWorkbook
	 * @throws Exception
	 */
	public static HSSFWorkbook exportData(Map<String,ExportExcelSheet> exportExcelMap, String fileName) throws Exception {
		HSSFWorkbook workbook = null;	//
		//没有导出项目
		if (exportExcelMap==null || exportExcelMap.size()<=0){
			log.info("没有要导出的文件。");
			return null;
		}
		
		// 创建工作簿实例
		workbook = new HSSFWorkbook();
		Set set = exportExcelMap.keySet();
		
		for(Iterator iter = set.iterator(); iter.hasNext();){
			//sheet名字取得
			String sheetName = (String)iter.next();
			ExportExcelSheet exportExcelSheet = (ExportExcelSheet)exportExcelMap.get(sheetName);
			
			// 创建工作表实例
			creatExcelSheet(workbook,sheetName,exportExcelSheet);
		}
        return workbook;
    }
	
	/**
	 * 创建sheet内容
	 * @param workbook         对应的指定sheet的数据的内容
	 * @param sheet            sheet名字
	 * @param exportExcelSheet sheet的内容
	 * @throws Exception
	 */
	public static void creatExcelSheet(HSSFWorkbook workbook , String sheetName , ExportExcelSheet exportExcelSheet) {
		final int maxLength = 10000;    //
		final int maxRow = 65530;  		//最大导出行数
		
		//创建sheet
		Sheet outputSheet = workbook.createSheet(sheetName);
		outputSheet.setDefaultColumnWidth(15);
		
		//如果没有题头直接返回
		//创建题头
		List<ExcelCell> listTitleName = exportExcelSheet.getListTitle();
		if (listTitleName!=null && listTitleName.size()>0){
			//创建题头行
			Row excelRow = outputSheet.createRow(0);
			for (int i = 0; i < listTitleName.size(); i++) {
				Cell cell = excelRow.createCell(i);
	            switch (listTitleName.get(i).getCellType()) {
            	//字符情况
	            case HSSFCell.CELL_TYPE_STRING:{
	            	cell.setCellType(HSSFCell.CELL_TYPE_STRING);
	            	cell.setCellValue(listTitleName.get(i).getName());
	            }
	            	break;
	            //其他情况	
	            default:{
	            	cell.setCellValue(listTitleName.get(i).getName());
	            }
					break;
	            }
            }
			
			//创建内容
			List<Map<String, Object>> listRow = exportExcelSheet.getListRow();
			if (listRow!=null && listRow.size()>0){
				if (listRow.size()>=maxRow){
					//TODO 异常，log，还是其他
				} else {
					for (int i = 0 ; i < listRow.size() ; i++){
						//创建内容行
						Row row = outputSheet.createRow(i+1);
						Map<String,Object> mapRow = listRow.get(i);
						for (int j = 0; j < listTitleName.size(); j++) {
							//创建cell并且设置值
							Cell cell = row.createCell(j);
							String cellValue = "";
							switch (listTitleName.get(j).getCellType()) {
			            	//字符情况
				            case HSSFCell.CELL_TYPE_STRING:{
				            	cell.setCellType(HSSFCell.CELL_TYPE_STRING);
				            	
				            	if (mapRow.get(listTitleName.get(j).getValue())!=null){
				            		cellValue = mapRow.get(listTitleName.get(j).getValue()).toString();
				            	}
				            	cell.setCellValue(cellValue);
				            }
				            	break;
				            //数字情况
				            case HSSFCell.CELL_TYPE_NUMERIC:{
				            	cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
				            	
				            	if (mapRow.get(listTitleName.get(j).getValue())!=null){
				            		cellValue = mapRow.get(listTitleName.get(j).getValue()).toString();
				            	}
				            	cell.setCellValue(cellValue);
				            }
				            	break;
				            //其他情况	
				            default:{
				            	if (mapRow.get(listTitleName.get(j).getValue())!=null){
				            		cellValue = mapRow.get(listTitleName.get(j).getValue()).toString();
				            	}
				            	cell.setCellValue(cellValue);
				            }
				            	
								break;
				            }
						}
					}
				}
			}
        }
	}
}
