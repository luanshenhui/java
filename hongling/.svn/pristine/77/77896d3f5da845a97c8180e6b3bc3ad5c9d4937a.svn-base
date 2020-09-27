package hongling.service.orden;

import hongling.util.DateUtils;


import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import jxl.Workbook;
import org.apache.commons.lang.StringUtils;

import chinsoft.business.ExcelHelpOrderTwo;

import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
import javax.servlet.ServletException;
import jxl.write.WriteException;
import chinsoft.business.RepairOrdenTwoManager;
public class ExportOrderTwo extends BaseServlet {
	/**
	 * 导出excel
	 * @author luan.shen.hui
	 * date 2015-05-08
	 */
	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String cloth = getParameter("searchClothingID");
		// 按 客户名称分类
		String memberName = getParameter("memberName");
		// 按时间查询
		String begintime = getParameter("dealDate");

		// 处理日期
		Date begindate = null;
		if (StringUtils.isNotBlank(begintime)) {
			begindate = DateUtils.parse(begintime, "yyyy-MM-dd");
		}

		ArrayList<String> header = new ArrayList<String>();
		ArrayList<List<String>> rows = new ArrayList<List<String>>();
		header.add("品类");
		header.add("客户简称");
		header.add("客户名称");
		header.add("日累计量");
		header.add("月累计量");
		
		header.add("年下单量");
		header.add("年累计扣款");
		header.add("月累计量扣款");
		header.add("日累计扣款");
		header.add("尺寸原因");
		header.add("做工原因");
		header.add("版型原因");
		header.add("面辅料原因");
		header.add("更改款式");
		header.add("更改工艺");
		header.add("顾客原因");
		header.add("更改附件及配色料");

		header.add("尺寸原因");
		header.add("做工原因");
		header.add("版型原因");
		header.add("面辅料原因");
		header.add("更改款式");
		header.add("更改工艺");
		header.add("顾客原因");
		header.add("更改附件及配色料");

		header.add("尺寸原因");
		header.add("做工原因");
		header.add("版型原因");
		header.add("面辅料原因");
		header.add("更改款式");
		header.add("更改工艺");
		header.add("顾客原因");
		header.add("更改附件及配料");
		List repairOrdenAssess = new RepairOrdenTwoManager().getRepairInfo(
				begindate, cloth, memberName, 0, 999999999);


		Iterator it = repairOrdenAssess.iterator();
		while (it.hasNext()) {
			Object[] obj = (Object[]) it.next();
			List<String> row = new ArrayList<String>();
			row.add(String.valueOf(obj[2]));
			row.add(String.valueOf(obj[0]));
			row.add(String.valueOf(obj[1]));
			row.add(String.valueOf(obj[3]));
			row.add(String.valueOf(obj[4]));
			row.add(String.valueOf(obj[5]));
			row.add(String.valueOf(obj[6]));
			row.add(String.valueOf(obj[7]));
			row.add(String.valueOf(obj[8]));
			row.add(String.valueOf(obj[9]));
			
			row.add(String.valueOf(obj[10]));
			row.add(String.valueOf(obj[11]));
			row.add(String.valueOf(obj[12]));
			row.add(String.valueOf(obj[13]));
			row.add(String.valueOf(obj[14]));
			row.add(String.valueOf(obj[15]));
			row.add(String.valueOf(obj[16]));
			
			row.add(String.valueOf(obj[17]));
			row.add(String.valueOf(obj[18]));
			row.add(String.valueOf(obj[19]));
			row.add(String.valueOf(obj[20]));
			row.add(String.valueOf(obj[21]));
			row.add(String.valueOf(obj[22]));
			row.add(String.valueOf(obj[23]));
			row.add(String.valueOf(obj[24]));
			row.add(String.valueOf(obj[25]));
			row.add(String.valueOf(obj[26]));
			row.add(String.valueOf(obj[27]));
			row.add(String.valueOf(obj[28]));
			row.add(String.valueOf(obj[29]));
			row.add(String.valueOf(obj[30]));
			row.add(String.valueOf(obj[31]));
			row.add(String.valueOf(obj[32]));
			rows.add(row);
		}

		String fileName = "FabricWareroomStatus_putOn-"
				+ Utility.dateToStr(new Date(), "yyyy-MM-dd") + ".xls";
		 response.reset();
		// 禁止数据缓存。
		response.setHeader("Pragma", "no-cache");

		try {
			response.setHeader("Content-Disposition", "attachment;filename=\""
					+ new String(fileName.getBytes("UTF8"), "iso-8859-1")
					+ "\"");
			response.setContentType("application/octet-stream;charset=UTF-8");
			ExcelHelpOrderTwo.exportExcel(header, rows,
					Workbook.createWorkbook(response.getOutputStream()),
					"二级返修信息");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (WriteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
		return;

	}

}
