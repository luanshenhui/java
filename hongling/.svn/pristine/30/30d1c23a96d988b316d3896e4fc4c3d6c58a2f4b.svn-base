package chinsoft.service.fashion;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FashionManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.FashionDict;
import chinsoft.service.core.BaseServlet;


public class GetFashionCategoryIdById extends BaseServlet{
	private static final long serialVersionUID = 2374662018001169039L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nType = Utility.toSafeInt(getParameter("id"));
			FashionDict dict = new FashionManager().getFashionsByID(nType);
			output(dict);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
