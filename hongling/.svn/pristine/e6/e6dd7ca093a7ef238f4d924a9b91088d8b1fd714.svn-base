package chinsoft.service.dict;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;


public class GetDicts extends BaseServlet{
	private static final long serialVersionUID = 2374662018001169009L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			output(DictManager.getDicts(Utility.toSafeInt(getParameter("categoryid"))));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
		
	}
}
