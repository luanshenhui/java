package chinsoft.service.fashion;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FashionManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.FashionDict;
import chinsoft.service.core.BaseServlet;


public class GetFashionByName extends BaseServlet{
	private static final long serialVersionUID = 2374667018001166039L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nID = Utility.toSafeInt(getParameter("id"));
			String strName = getParameter("name");
			FashionDict dict = new FashionManager().getFashionsByName(nID,strName);
			output(dict);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
