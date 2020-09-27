package chinsoft.service.orden;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.ExcelHelper;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.XmlManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

/**
 * 导出所有订单
 * @author zhouyong
 * date 2012-02-21
 *
 */
public class ExportOrdens  extends BaseServlet{
	
	private static final long serialVersionUID = 3941900143054890884L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strKeyword = getParameter("keyword");		
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			int nStatusID = Utility.toSafeInt(getParameter("searchStatusID"))==10000?-1:Utility.toSafeInt(getParameter("searchStatusID"));
			String strPubMemberID = getParameter("searchClientID");
			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));
			
			Date fromDate = null;
			if (getParameter("fromDate") != null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("fromDate"));
			}
			Date toDate = null;
			if (getParameter("toDate") != null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("toDate"));
			}
			Date dealDate = null;
			Date dealToDate = null;
			if(getParameter("dealDate") != null &&!"".equals(getParameter("dealDate"))){
				dealDate = Utility.toSafeDateTime(getParameter("dealDate"));
			}
			if (getParameter("dealToDate")!=null && !"".equals(getParameter("dealToDate"))) {
				dealToDate = Utility.toSafeDateTime(getParameter("dealToDate"));
			}
			List<Orden> ordens = new ArrayList<Orden>();
			
			ordens = new OrdenManager().getOrdens(0, 100000000, strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Common_Index"));
			headList.add(ResourceHelper.getValue("Orden_Code"));
			headList.add(ResourceHelper.getValue("Customer_No"));
			headList.add(ResourceHelper.getValue("Orden_ClothingCategory"));
			headList.add(ResourceHelper.getValue("Customer_Name"));
			headList.add(ResourceHelper.getValue("Customer_Email"));
			headList.add(ResourceHelper.getValue("Common_Gender"));
			headList.add(ResourceHelper.getValue("Size_Category"));
			headList.add(ResourceHelper.getValue("Common_Tel"));
			
			headList.add(ResourceHelper.getValue("Orden_Fabric"));
			headList.add(ResourceHelper.getValue("Common_Status"));
			headList.add(ResourceHelper.getValue("Orden_PubDate"));
			headList.add(ResourceHelper.getValue("Orden_DeliveryDate"));
			headList.add(ResourceHelper.getValue("Orden_DealDate"));
			headList.add(ResourceHelper.getValue("Dict_431"));
			
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			int i = 0;
			for (Orden orden : ordens) {
				i++;
				List<String> ordenStr = new ArrayList<String>();
				ordenStr.add(i + "");
				ordenStr.add(orden.getOrdenID());
				ordenStr.add(orden.getUserordeNo());
				ordenStr.add(orden.getClothingName());
				ordenStr.add(orden.getCustomer().getName());
				ordenStr.add(orden.getCustomer().getEmail());
				ordenStr.add(orden.getCustomer().getGenderName());
				ordenStr.add(orden.getSizeCategoryName());
				ordenStr.add(orden.getCustomer().getTel());
				ordenStr.add(orden.getFabricCode());
				ordenStr.add(orden.getStatusName());
				//ordenStr.add(orden.getConstDefine());
				ordenStr.add(Utility.dateToStr(orden.getPubDate(),"yyyy-MM-dd"));
				ordenStr.add(Utility.dateToStr(orden.getDeliveryDate(),"yyyy-MM-dd HH:mm:ss"));
				ordenStr.add(Utility.dateToStr(orden.getJhrq(),"yyyy-MM-dd"));
				
				//衬类型
				Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
				String interliningType = member.getLiningType();//默认衬类型
				int clothing = orden.getClothingID();
				if(clothing == 7 || clothing == 95000 || clothing == 98000){
					interliningType = "00C3";
				}
				if(clothing == 3000 || clothing == 5000){
					interliningType = "";
				}else{
					if(clothing == 1 || clothing == 2  || clothing == 6){
						clothing = 3;
					}else if(clothing == 4){
						clothing = 4000;
					}else if(clothing == 5){
						clothing = 90000;
					}else if(clothing == 7){
						clothing = 95000;
					}
					
					String strEcode = new XmlManager().getInterliningType(clothing, orden.getComponents());
					if (!"".equals(strEcode) && !",".equals(strEcode)) {
						strEcode = strEcode.substring(1, strEcode.length() - 1);
						interliningType = strEcode;
					}
				}
				ordenStr.add(interliningType);
				
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
			return;
			
		} catch (Exception e) {
			LogPrinter.error("ExportOrdens_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
