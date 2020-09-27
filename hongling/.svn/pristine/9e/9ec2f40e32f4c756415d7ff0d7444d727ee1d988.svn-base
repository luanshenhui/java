package chinsoft.service.cash;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import centling.dto.CashDto;
import chinsoft.business.CashManager;
import chinsoft.business.ExcelHelper;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
public class ExportCashs extends BaseServlet{
	private static final long serialVersionUID = 3941900143254890885L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strKeyword = request.getParameter("keyword");	
			Date fromDate = Utility.toSafeDateTime(request.getParameter("fromDate"));
			Date toDate = Utility.toSafeDateTime(request.getParameter("toDate"));
			
			List<CashDto> allCashList = new CashManager().getCashs(0, 999999999,strKeyword,fromDate,toDate);
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Common_Index"));
			headList.add(ResourceHelper.getValue("Member_CompanyName"));
			headList.add(ResourceHelper.getValue("Member_CompanyShortName"));
			headList.add(ResourceHelper.getValue("Cash_SalesName"));
			headList.add(ResourceHelper.getValue("Cash_Num"));
			headList.add(ResourceHelper.getValue("Cash_Memo"));
			headList.add(ResourceHelper.getValue("Cash_IsReconciliation"));
			headList.add(ResourceHelper.getValue("Cash_LastDealDate"));
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			int i = 0;
			for (CashDto cash : allCashList) {
				i++;
				List<String> cashStr = new ArrayList<String>();
				cashStr.add(i + "");
				//memberStr.add(member.getID());
				cashStr.add(cash.getMember_companyName());
				cashStr.add(cash.getMember_companyShortName());
				cashStr.add(cash.getMember_parentName());
				cashStr.add(cash.getCash_num()+" ("+cash.getMember_moneySignName()+")");
				cashStr.add(cash.getCash_memo());
				//memberStr.add(member.getCustomerCode());
				cashStr.add(cash.getIsReconciliationName());
				//memberStr.add(member.getIsTrustName());
				//memberStr.add(member.getPayTypeName());
				cashStr.add(cash.getCash_pubDate());
				cells.add(cashStr);
			}
			// 设置导出文件名
			String fileName = "cashList-" + Utility.dateToStr(new Date(),"yyyy-MM-dd")
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
					.getOutputStream()),ResourceHelper.getValue("Cash_Info"));
			return;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
