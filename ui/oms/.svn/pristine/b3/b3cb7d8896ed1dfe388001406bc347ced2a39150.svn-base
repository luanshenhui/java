package cn.rkylin.apollo.common.util;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;


public class ExportProjectUtil {

	private static final Log log = LogFactory.getLog(ExportProjectUtil.class);
	/**
	 * 创建项目管理下载Excel
	 * @param dataList
	 * @return
	 * @throws Exception
	 */
	public HSSFWorkbook projectExportExcel(List<Map<String,Object>> dataList,List<Map<String,Object>> sysDicfmList,String sheetName) throws Exception {
		String[][] reportTitles = {
				{"项目编号","PROJECT_CODE","string","n"},
				{"项目名称","PROJECT_NAME","string","n"},
				{"项目类型","PROJECT_TYPE","number","n"},
				{"经营类目","OPERATE_GENRE","number","n"},
				{"项目状态","PROJECT_STATUS","number","n"},
				{"签约公司","SIGN_COMPANY","number","n"},
				{"所属地区","AREA","number","n"},
			};
		HSSFWorkbook workbook = null;
		try {
			// 创建工作簿实例
			workbook = new HSSFWorkbook();
			// 创建工作表实例
			HSSFSheet sheet = workbook.createSheet(sheetName);
			// 设置列宽
			this.setSheetColumnWidth(sheet,reportTitles);
			
			//创建字符串单元格的样式
			HSSFCellStyle styleStr = workbook.createCellStyle();
			styleStr.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直 居中
			styleStr.setWrapText(true);//自动换行    
			styleStr.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));
			
			//创建数字单元格的样式
			HSSFCellStyle styleNum = workbook.createCellStyle();
			styleNum.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直 居中
			styleNum.setWrapText(true);//自动换行      
			
			//写数据   
			if (dataList != null && dataList.size() > 0) {
				HSSFCellStyle styleTitle = workbook.createCellStyle();
				styleTitle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直   
				styleTitle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 水平    
		          
				HSSFFont font=workbook.createFont();
				font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);  //字体增粗
				font.setFontHeightInPoints((short)11);//字体大小
				styleTitle.setFont(font);
				
				HSSFRow rowTitle = sheet.createRow((short) 0);// 建立新行
				rowTitle.setHeightInPoints(20);
				
				for(int t=0;t<reportTitles.length;t++){
					createCell(rowTitle, t, HSSFCell.CELL_TYPE_STRING,styleTitle, reportTitles[t][0]);
				}
				boolean isSame = false;//是否合并单元格
				int startNum = 1;//合并单元格的开始行
				// 给excel填充数据
				for (int i = 0; i < dataList.size(); i++) {
					/*导出报表按照创建日期来排序
					Collections.sort(dataList, new Comparator<Map<String, Object>>() {
						public int compare(Map<String, Object> map, Map<String, Object> map1) {
							String createTime = (String) map.get("create_time");
							String createTime1 = (String) map1.get("create_time");
							return createTime.compareTo(createTime1);
						}
					});*/
					Map<String,Object> dataMap = (Map<String,Object>) dataList.get(i);
					int rowNum = i+1;//行数
					//判断是否需要合并单元格
					/*String code = "";
					if (dataMap.get("code") != null){
						code = dataMap.get("code").toString();
						if(sameCode.equals(code)){
							isSame = true;
							//counter++;
						}else{
							sameCode = code;
							no = no+1;
							isSame = false;
						}
					}
					//设置合并行的开始行
					if(!isSame && rowNum!=1 ){
						startNum = rowNum;
					}*/
					HSSFRow row = sheet.createRow((short)rowNum);// 建立新行
					//createCell(row, 0, HSSFCell.CELL_TYPE_STRING,styleStr, payTime);
					if(isSame){
						setRegionBlank(sheet, startNum+1, rowNum, 0);
						//sheet.addMergedRegion(new Region(startNum,(short)0,rowNum,(short)0)); 
						sheet.addMergedRegion(new CellRangeAddress(startNum,(short)0,(short)0,(short)0));
					}
					for (int j = 0; j < reportTitles.length; j++) {
						int colNum = j;// 列数
						String titleName = reportTitles[colNum][1];
						if (StringUtils.isNotEmpty(titleName) && null != dataMap.get(titleName)) {
							if ("PROJECT_TYPE".equals(titleName)) {
								createCell(row, colNum, HSSFCell.CELL_TYPE_STRING, styleStr,convertProject(titleName,String.valueOf(dataMap.get(titleName)),sysDicfmList));
							} else if ("OPERATE_GENRE".equals(titleName)) {
								createCell(row, colNum, HSSFCell.CELL_TYPE_STRING, styleStr,convertProject(titleName,String.valueOf(dataMap.get(titleName)),sysDicfmList));
							} else if ("PROJECT_STATUS".equals(titleName)) {
								createCell(row, colNum, HSSFCell.CELL_TYPE_STRING, styleStr,converProjectStatus(String.valueOf(dataMap.get(titleName))));
							} else if ("SIGN_COMPANY".equals(titleName)) {
								createCell(row, colNum, HSSFCell.CELL_TYPE_STRING, styleStr,convertProject(titleName,String.valueOf(dataMap.get(titleName)),sysDicfmList));
							} else if ("AREA".equals(titleName)) {
								createCell(row, colNum, HSSFCell.CELL_TYPE_STRING, styleStr,convertProject(titleName,String.valueOf(dataMap.get(titleName)),sysDicfmList));
							} else {
								if ("string".equals(reportTitles[colNum][2])) {
									createCell(row, colNum, HSSFCell.CELL_TYPE_STRING, styleStr,dataMap.get(titleName));
								}
								if ("number".equals(reportTitles[colNum][2])) {
									createCell(row, colNum, HSSFCell.CELL_TYPE_NUMERIC, styleNum,dataMap.get(titleName));
								}
							}
						}
						if (isSame && "y".equals(reportTitles[colNum][3])) {
							setRegionBlank(sheet, startNum + 1, rowNum, colNum);
							//sheet.addMergedRegion(new Region(startNum, (short) colNum, rowNum, (short) colNum));
							sheet.addMergedRegion(new CellRangeAddress(startNum,(short)colNum,rowNum,(short)colNum));
						}
					}
					}
			} else {
				createCell(sheet.createRow(0), 0, HSSFCell.CELL_TYPE_STRING,styleStr, "查无记录");
			}
		} catch (Exception e) {
			log.error("导出项目报表异常",e);
		}
		return workbook;
	}
	
	/**
	 * 项目下载，转换相关数据类型的 key-value
	 * @param columnName
	 * @param titleValue
	 * @param sysDicfmProjectList
	 * @return
	 */
	private Object convertProject(String columnName, String titleValue,
			List<Map<String, Object>> sysDicfmProjectList) {
		Object sysDdicColumnValue = null;
		try {
			if (!ListUtils.isEmpty(sysDicfmProjectList) && sysDicfmProjectList.size() > 0) {
				for (Map<String, Object> sysDicMap : sysDicfmProjectList) {
					if (null != sysDicMap.get("COLUMN_NAME")) {
						String sysDdicColumnName = String.valueOf(sysDicMap.get("COLUMN_NAME"));
						String sysDdicColumnKey = String.valueOf(sysDicMap.get("COLUMN_KEY"));
						if (columnName.equalsIgnoreCase(sysDdicColumnName) && titleValue.equals(sysDdicColumnKey)) {
							sysDdicColumnValue = sysDicMap.get("COLUMN_VALUE");
							break;
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("项目下载获取字典表value异常", e);
		}
		return sysDdicColumnValue;
	}
	
	/**
	 * 格式化项目状态
	 * @param projectSts
	 * @return
	 */
	private Object converProjectStatus(String projectSts) {
		Object proStatus = null;
		if (StringUtils.isNotEmpty(projectSts)) {
			if ("1".equals(projectSts)) {
				proStatus = "运营中";
			} else if ("2".equals(projectSts)) {
				proStatus = "清算中";
			} else if ("3".equals(projectSts)) {
				proStatus = "已结束";
			}
		}
		return proStatus;
	}
	
	/**
	 * 设置列宽
	 * @param sheet
	 */
	private void setSheetColumnWidth(HSSFSheet sheet,String[][] reportTitles) {
		
		// 根据你数据里面的记录有多少列，就设置多少列
		for(int i=0;i<reportTitles.length;i++){
			String colName = reportTitles[i][1];
			if("title".equals(colName) || "remark".equals(colName) || "promotion_name".equals(colName)){
				sheet.setColumnWidth(i, 10000);
			}else{
				sheet.setColumnWidth(i, 5000);
			}
		}

	}
	
	//设置合并单元格的其它单元格为空
		private void setRegionBlank(HSSFSheet sheet,int startRow,int endRow,int columnNum){
			for(int i=startRow;i<=endRow;i++){
				HSSFRow row = sheet.getRow(i);
				HSSFCell cell = row.getCell(columnNum);
				cell.setCellType(HSSFCell.CELL_TYPE_BLANK);
			}
		}
	
	// 创建Excel单元格
		public static HSSFCell createCell(HSSFRow row, int column, int cellType,HSSFCellStyle style, Object value) {
			
			HSSFCell cell = row.createCell(column);

			switch (cellType) {
				case HSSFCell.CELL_TYPE_BLANK: {

				}
				break;
		
				case HSSFCell.CELL_TYPE_STRING: {
					/*if(null != style){
						style.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));
					}*/
					cell.setCellType(HSSFCell.CELL_TYPE_STRING);
					if(null != value){
						cell.setCellValue(value.toString());
					}
				}
				break;
		
				case HSSFCell.CELL_TYPE_NUMERIC: {
					if(null != style){
						//style_.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0.00"));
					}
					cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
					cell.setCellValue(Double.parseDouble(value.toString()));
				}
				break;
				
				default:
				break;
			}
			
			if (style != null) {
				cell.setCellStyle(style);
			}
			return cell;
		}


}
