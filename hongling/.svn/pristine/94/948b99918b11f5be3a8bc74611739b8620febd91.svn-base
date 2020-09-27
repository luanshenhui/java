package chinsoft.service.receiving;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.ExcelHelper;
import chinsoft.business.ReceivingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Receiving;
import chinsoft.service.core.BaseServlet;

public class ExportReceivings extends BaseServlet {

	private static final long serialVersionUID = 8636260733060268024L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));
			String strMemberCode=Utility.toSafeString(getParameter("searchClientID"));

			String fromDate = null;
			if (getParameter("fromDate") != null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeString(getParameter("fromDate"));
			}
			String toDate = null;
			if (getParameter("toDate") != null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeString(getParameter("toDate"));
			}
			
			List<Receiving> receivings = new ArrayList<Receiving>();
			receivings = new ReceivingManager().getReceivings(0,100000000,"",strMemberCode, nClothingID, fromDate, toDate);
			
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Common_Index"));
			headList.add(ResourceHelper.getValue("Member_OwnedStore"));
			headList.add(ResourceHelper.getValue("Orden_Code"));
			headList.add(ResourceHelper.getValue("Customer_Name"));
			headList.add(ResourceHelper.getValue("Orden_ClothingCategory"));
			headList.add(ResourceHelper.getValue("Common_Tel"));

			headList.add(ResourceHelper.getValue("Cash_LastDealDate"));
			headList.add(ResourceHelper.getValue("Common_Memo"));

			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			int i = 0;
			for (Receiving receiving : receivings) {
				i++;
				List<String> ordenStr = new ArrayList<String>();
				ordenStr.add(i + "");
				ordenStr.add(receiving.getOwnedstore());
				ordenStr.add(receiving.getOrdenid());
				ordenStr.add(receiving.getName());
				ordenStr.add(receiving.getSortName());
				ordenStr.add(receiving.getPhonenumber());
				ordenStr.add(receiving.getCreatetime());
				ordenStr.add(receiving.getMemo());

				cells.add(ordenStr);
			}
			// 设置导出文件名
			String fileName =new SimpleDateFormat("yyyy-MM-dd").format(new Date())
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
			ExcelHelper.exportExcel(headList, cells,
					Workbook.createWorkbook(response.getOutputStream()),
					ResourceHelper.getValue("Orden_Info"));
			return;

		} catch (Exception e) {
			LogPrinter.error("ExportOrdens_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
