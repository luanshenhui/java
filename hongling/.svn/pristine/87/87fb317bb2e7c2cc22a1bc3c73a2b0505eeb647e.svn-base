package hongling.service.customerassessment;
import hongling.business.CustomerAssessManager;
import hongling.util.DateUtils;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;

import org.apache.commons.lang.StringUtils;

import chinsoft.business.ExcelHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 导出客户周期评价
 * @author Chen.Xin.qi
 * @version 1.0 2015-05-07
 */
public class ExportPeriodAssess extends BaseServlet {

	private static final long serialVersionUID = 1L;

	@Override
	@SuppressWarnings("rawtypes")
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try{
			String username = request.getParameter("searchKeyword");
			String begintime=request.getParameter("dealDate");
			Date begindate=null;
			if(StringUtils.isNotBlank(begintime)){
				begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
			}
			List list = new CustomerAssessManager().getCustomerPeriodAppraiseReport(username,begindate,0,999999999);
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add("客户名称");
			headList.add("日差评量");
			headList.add("日差评率");
			headList.add("日好评量");
			headList.add("日好评率");
			headList.add("日发货量");
			headList.add("月差评量");
			headList.add("月差评率");
			headList.add("月好评量");
			headList.add("月好评率");
			headList.add("月发货量");
			headList.add("年差评量");
			headList.add("年差评率");
			headList.add("年好评量");
			headList.add("年好评率");
			headList.add("年发货量");
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			Iterator it = list.iterator();
			while(it.hasNext()){
				Object[] obj = (Object[]) it.next();
				List<String> assertStr = new ArrayList<String>();
				assertStr.add(String.valueOf(obj[0]));
				assertStr.add(String.valueOf(obj[5]));
				assertStr.add(String.valueOf(obj[19])+"%");
				assertStr.add(String.valueOf(obj[4]));
				assertStr.add(String.valueOf(obj[18])+"%");
				assertStr.add(String.valueOf(obj[2]));
				assertStr.add(String.valueOf(obj[9]));
				assertStr.add(String.valueOf(obj[15])+"%");
				assertStr.add(String.valueOf(obj[8]));
				assertStr.add(String.valueOf(obj[14])+"%");
				assertStr.add(String.valueOf(obj[6]));
				assertStr.add(String.valueOf(obj[13]));
				assertStr.add(String.valueOf(obj[17])+"%");
				assertStr.add(String.valueOf(obj[12]));
				assertStr.add(String.valueOf(obj[16])+"%");
				assertStr.add(String.valueOf(obj[10]));
				cells.add(assertStr);
			}
			String fileName = "customerPeriodAssess-" + Utility.dateToStr(new Date(),"yyyy-MM-dd")
					+ ".xls";
			//清除首部的空白行
			response.reset();
			// 禁止数据缓存。
	        response.setHeader("Pragma", "no-cache");
			
			try {
				response.setHeader(
						"Content-Disposition",
						"attachment;filename=\""
								+ new String(fileName.getBytes("UTF8"),
										"iso-8859-1") + "\"");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			response.setContentType("application/octet-stream;charset=UTF-8");
			ExcelHelper.exportExcel(headList, cells, Workbook.createWorkbook(response
					.getOutputStream()),"客户周期评价列表");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return;
	}

}
