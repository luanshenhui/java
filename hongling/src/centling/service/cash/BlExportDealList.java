package centling.service.cash;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import centling.business.BlDealManager;
import centling.business.BlExcelHelper;
import centling.dto.DealDto;
import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlExportDealList extends BaseServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7393792153758317732L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			String from = EntityHelper.getValueByKey(strFormData, "from").toString();//getParameter("from");
			
			String blmemberid = "";
			if (from!=null && "front".equals(from)){
				blmemberid = CurrentInfo.getCurrentMember().getID();
			}
			if (from!=null && "hou".equals(from)){
				blmemberid = EntityHelper.getValueByKey(strFormData, "blmemberid").toString();
			}

			String blKeyword = EntityHelper.getValueByKey(strFormData, "blKeyword").toString();

			Date blFromDate = null;
			Date blToDate = null;
			
			if (!"".equals(getParameter("blFromDate")) && !"".equals(getParameter("blToDate"))){
				blFromDate = Utility.toSafeDateTime(getParameter("blFromDate"));
				blToDate = Utility.toSafeDateTime(getParameter("blToDate"));
			}
			List<DealDto> dealdtos = new ArrayList<DealDto>();
			dealdtos = new BlDealManager().getDeals(0, 100000000, blmemberid, blKeyword, blFromDate, blToDate);
						
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Common_Index"));
			headList.add(ResourceHelper.getValue("Cash_DealDate"));
			headList.add(ResourceHelper.getValue("Cash_ClientCompanyName"));
			headList.add(ResourceHelper.getValue("Member_CompanyShortName"));
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
			int i = 0;
			for (DealDto dealdto : dealdtos) {
				i++;
				List<String> dealdtoStr = new ArrayList<String>();
				dealdtoStr.add(i + "");
				dealdtoStr.add(dealdto.getDealDate());
				dealdtoStr.add(dealdto.getCompanyName());
				dealdtoStr.add(dealdto.getCompanyShortName());
				dealdtoStr.add(dealdto.getUsername());
				dealdtoStr.add(dealdto.getDealItemName());
				dealdtoStr.add(dealdto.getMoneySignName());
				dealdtoStr.add(dealdto.getAccountIn());
				dealdtoStr.add(dealdto.getAccountOut());
				dealdtoStr.add(dealdto.getYundanId());
				dealdtoStr.add(dealdto.getNum());
				dealdtoStr.add(dealdto.getMemo());
				
				cells.add(dealdtoStr);
			}
			// 设置导出文件名
			String fileName = "dealList-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date())
					+ ".xls";
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
			BlExcelHelper.exportExcel(headList, cells, Workbook.createWorkbook(response
					.getOutputStream()),ResourceHelper.getValue("Orden_Info"));
			return;
			
		} catch (Exception e) {
			LogPrinter.error("ExportOrdens_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
