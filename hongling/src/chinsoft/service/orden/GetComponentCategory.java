package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetComponentCategory extends BaseServlet {
	private static final long serialVersionUID = -1759095870257443218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{
		try {
			super.service();	
//			int nSingleClothingID = Utility.toSafeInt(getParameter("singleclothingid"));
//			output(new OrdenManager().getComponentCategoryTree(nSingleClothingID));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

