package chinsoft.service.orden;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetOrdenProcessByClothingID extends BaseServlet{
	private static final long serialVersionUID = -6898385861459365048L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String ordenID=getParameter("ordenID");
			String strClothingID=getParameter("clothingID");
			String data=new ClothingManager().getOrderProcessHtml(ordenID, Utility.toSafeInt(strClothingID));
			output(data);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetOrdenStatisticerr"+e.getMessage());
		}
	}
}
