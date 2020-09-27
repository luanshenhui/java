package chinsoft.service.orden;


import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import chinsoft.business.ClothingManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Embroidery;
import chinsoft.service.core.BaseServlet;

public class GetOrdenEmbroideryByClothingID extends BaseServlet{
	private static final long serialVersionUID = -6898385861459365048L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String ordenID=getParameter("ordenID");
			String strClothingID=getParameter("clothingID");
//			Embroidery data=new ClothingManager().getEmbroideryLoaction( new OrdenManager().getOrdenByID(ordenID), Utility.toSafeInt(strClothingID));
//			output(data);
			List<Embroidery> data=new ClothingManager().getEmbroideryLoaction( new OrdenManager().getOrdenByID(ordenID), Utility.toSafeInt(strClothingID));
			output(data.get(0));
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenStatisticerr"+e.getMessage());
		}
	}
}
