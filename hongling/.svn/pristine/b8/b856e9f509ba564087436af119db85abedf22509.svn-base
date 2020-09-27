package chinsoft.service.fashion;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FashionManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;


public class GetFashionDefaultProcess extends BaseServlet{
	private static final long serialVersionUID = 2374667018001166039L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int id = Utility.toSafeInt(getParameter("id"));
			String strProcess = new FashionManager().getDefaultProcess(id);
			output(strProcess);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
