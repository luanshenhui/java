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

import chinsoft.business.CustomerAssessExcelUtil;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 导出客户评价报表
 * @author Chen.xin.qi  
 * @version 1.0 2015-05-07
 */
public class ExportAssessInfo extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	@SuppressWarnings("rawtypes")
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try{
		String username = request.getParameter("searchKeyword");
		String jhrqstart = request.getParameter("dealDate");
		String jhrqstop = request.getParameter("dealToDate");
		if(StringUtils.isNotBlank(jhrqstop)){
			Date d=DateUtils.dateAddDay(DateUtils.parse(jhrqstop, "yyyy-MM-dd"), 1) ;
			jhrqstop=DateUtils.formatDate(d, "yyyy-MM-dd");
		}
		
		List list=new CustomerAssessManager().getAppraiseReport(username, jhrqstart, jhrqstop,0,999999999 );
		// 表头
		ArrayList<String> headList = new ArrayList<String>();
		headList.add("用户名");
		headList.add("评价总量");
		headList.add("好评数");
		headList.add("好评率(%)");
		headList.add("差评数");
		headList.add("差评率(%)");
		headList.add("版型");
		headList.add("做工");
		headList.add("尺寸");
		headList.add("服务支持");
		// 要写入的数据
		List<List<String>> cells = new ArrayList<List<String>>();
		Iterator it = list.iterator();
		while(it.hasNext()){
			Object[] obj = (Object[]) it.next();
			List<String> assertStr = new ArrayList<String>();
			assertStr.add(String.valueOf(obj[0]));
			assertStr.add(String.valueOf(obj[2]));
			assertStr.add(String.valueOf(obj[3]));
			assertStr.add(String.valueOf(obj[5]));
			assertStr.add(String.valueOf(obj[4]));
			assertStr.add(String.valueOf(obj[6]));
			assertStr.add(String.valueOf(obj[7]));
			assertStr.add(String.valueOf(obj[8]));
			assertStr.add(String.valueOf(obj[9]));
			assertStr.add(String.valueOf(obj[10]));
			cells.add(assertStr);
		}
		String fileName = "customerAssessList-" + Utility.dateToStr(new Date(),"yyyy-MM-dd")
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
		CustomerAssessExcelUtil.exportExcel(headList, cells, Workbook.createWorkbook(response
				.getOutputStream()),"客户评价列表");
		}catch(Exception e){
			e.printStackTrace();
		}
		return;
	}
}
