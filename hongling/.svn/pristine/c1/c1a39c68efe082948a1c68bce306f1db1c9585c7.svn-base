package centling.service.cash;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;

import centling.business.BlDealManager;
import centling.business.BlExcelHelper;
import centling.dto.DealDto;
import centling.util.BlDateUtil;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class BlExportStatement extends BaseServlet {
	private static final long serialVersionUID = 7081123761708623872L;

	/**
	 * 导出对账单
	 */
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			String from = EntityHelper.getValueByKey(strFormData, "from").toString();
			String blmemberid = "";
			if (from!=null && "front".equals(from)){
				blmemberid = CurrentInfo.getCurrentMember().getID();
			}
			if (from!=null && "hou".equals(from)){
				blmemberid = EntityHelper.getValueByKey(strFormData, "blmemberid").toString();
			}
//			String blKeyword = EntityHelper.getValueByKey(strFormData, "blKeyword").toString();
			Date blFromDate = null;
			Date blToDate = null;
			
			if (getParameter("blFromDate") != null && !"".equals(getParameter("blFromDate"))) {
				blFromDate = Utility.toSafeDateTime(getParameter("blFromDate"));
			} else {
				blFromDate = BlDateUtil.getLastMonthDate();
			}
			if (getParameter("blToDate")!=null && !"".equals(getParameter("blToDate"))){
				blToDate = Utility.toSafeDateTime(getParameter("blToDate"));
			} else {
				blToDate = new Date();
			}
			
			Member member = new MemberManager().getMemberByID(blmemberid);
			Map<String, String> statementMap = new BlDealManager().getStateMentList(blFromDate,blToDate,blmemberid);
			
			List<DealDto> dealdtos = new ArrayList<DealDto>();
			dealdtos = new BlDealManager().getDeals(blmemberid, blFromDate, blToDate);
						
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Cash_DealDate"));
			headList.add(ResourceHelper.getValue("Cash_ClientCompanyName"));
//			headList.add(ResourceHelper.getValue("Member_CompanyShortName"));
			headList.add(ResourceHelper.getValue("Cash_AccountName"));
			headList.add(ResourceHelper.getValue("Cash_DealProject"));
			headList.add(ResourceHelper.getValue("Cash_MoneyKind"));
			
			headList.add(ResourceHelper.getValue("Cash_InAccount"));
			headList.add(ResourceHelper.getValue("Cash_OutAccount"));
			headList.add(ResourceHelper.getValue("Cash_OrderIdTrackingId"));
			headList.add(ResourceHelper.getValue("Cash_LocalNum"));
			headList.add(ResourceHelper.getValue("Common_Memo"));
			
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			for (DealDto dealdto : dealdtos) {
				List<String> dealdtoStr = new ArrayList<String>();
				dealdtoStr.add(dealdto.getDealDate());
				dealdtoStr.add(dealdto.getCompanyName());
//				dealdtoStr.add(dealdto.getCompanyShortName());
				dealdtoStr.add(dealdto.getUsername());
				dealdtoStr.add(dealdto.getDealItemName());
				dealdtoStr.add(dealdto.getMoneySignName());
				dealdtoStr.add(dealdto.getAccountIn());
				dealdtoStr.add(dealdto.getAccountOut());
				dealdtoStr.add(dealdto.getOrdenId());
				dealdtoStr.add(dealdto.getNum());
				dealdtoStr.add(dealdto.getMemo());
				
				cells.add(dealdtoStr);
			}
			
			Map<String, List<?>> payDetailMap = new HashMap<String, List<?>>();
			payDetailMap.put("detailMap", headList);
			payDetailMap.put("detailCells", cells);
			
			if (cells.size() <= 0) {
				String msg = ResourceHelper.getValue("Cash_NoStatementData");
				response.setContentType("text/html; charset=UTF-8"); //转码
			    PrintWriter out = response.getWriter();
			    out.flush();
			    out.println("<script>");
			    out.println("alert('"+msg+"');");
			    out.println("window.close();");
			    out.println("</script>");
			} else {
				String fileName = "statementList-"+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())+ ".xls";
				response.reset();
				// 禁止数据缓存。
				response.setHeader("Pragma", "no-cache");
				response.setHeader("Content-Disposition","attachment;filename=\""+ new String(fileName.getBytes("UTF8"),
						"iso-8859-1") + "\"");
				response.setContentType("application/octet-stream;charset=UTF-8");
				BlExcelHelper.exportExcelDuiZhangDan(member, statementMap, payDetailMap, Workbook.createWorkbook(response.getOutputStream()));
				return;
			}
			
		} catch (Exception e) {
			LogPrinter.error("BlExportStatement_err"+e.getMessage());
		}
	}
	
}
