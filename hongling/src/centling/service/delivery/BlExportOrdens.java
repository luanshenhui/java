package centling.service.delivery;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.CurrentInfo;
import chinsoft.business.ExcelHelper;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class BlExportOrdens extends BaseServlet {
	private static final long serialVersionUID = -1968480459185746030L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strKeyword = getParameter("blKeyword");		
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			int nStatusID = Utility.toSafeInt(getParameter("blSearchStatusID"));
			String strPubMemberID = getParameter("blSearchClientID");
			int nClothingID = Utility.toSafeInt(getParameter("blSearchClothingID"));
			Date fromDate = null;
			if (getParameter("blFromDate") != null && !"".equals(getParameter("blFromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("blFromDate"));
			}
			Date toDate = null;
			if (getParameter("blToDate") != null && !"".equals(getParameter("blToDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("blToDate"));
			}
			Date dealDate = null;
			Date dealToDate = null;
			if(getParameter("blDealDate") != null &&!"".equals(getParameter("blDealDate"))){
				dealDate = Utility.toSafeDateTime(getParameter("blDealDate"));
			}
			if (getParameter("blDealToDate")!=null && !"".equals(getParameter("blDealToDate"))) {
				dealToDate = Utility.toSafeDateTime(getParameter("blDealToDate"));
			}
			
			List<Orden> ordens = new ArrayList<Orden>();
			ordens = new OrdenManager().getOrdens(0, 100000000, strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Common_Index"));
			headList.add(ResourceHelper.getValue("Orden_Code"));
			headList.add(ResourceHelper.getValue("Orden_ClothingCategory"));
			headList.add(ResourceHelper.getValue("Customer_Name"));
			headList.add(ResourceHelper.getValue("Common_Gender"));
			headList.add(ResourceHelper.getValue("Size_Category"));
			headList.add(ResourceHelper.getValue("Common_Tel"));
			
			headList.add(ResourceHelper.getValue("Orden_Fabric"));
			headList.add(ResourceHelper.getValue("Common_Status"));
			headList.add(ResourceHelper.getValue("Orden_PubDate"));
			headList.add(ResourceHelper.getValue("Orden_DeliveryDate"));
			
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			int i = 0;
			for (Orden orden : ordens) {
				i++;
				List<String> ordenStr = new ArrayList<String>();
				ordenStr.add(i + "");
				ordenStr.add(orden.getOrdenID());
				ordenStr.add(orden.getClothingName());
				ordenStr.add(orden.getCustomer().getName());
				ordenStr.add(orden.getCustomer().getGenderName());
				ordenStr.add(orden.getSizeCategoryName());
				ordenStr.add(orden.getCustomer().getTel());
				ordenStr.add(orden.getFabricCode());
				ordenStr.add(orden.getStatusName());
				//ordenStr.add(orden.getConstDefine());
				ordenStr.add(Utility.dateToStr(orden.getPubDate(),"yyyy-MM-dd HH:mm:ss"));
				ordenStr.add(Utility.dateToStr(orden.getDeliveryDate(),"yyyy-MM-dd HH:mm:ss"));
				
				cells.add(ordenStr);
			}
			// 设置导出文件名
			String fileName = "order list-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date())
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
			ExcelHelper.exportExcel(headList, cells, Workbook.createWorkbook(response
					.getOutputStream()),ResourceHelper.getValue("Orden_Info"));
			
		} catch (Exception e) {
			LogPrinter.error("BlExportOrdens_" + e.getMessage());
			e.printStackTrace();
		}
	}
}