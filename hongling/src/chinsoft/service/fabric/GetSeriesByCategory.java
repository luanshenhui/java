package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetSeriesByCategory extends BaseServlet{

	private static final long serialVersionUID = 8386556300167190420L;
	@Override
	public void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			output(new FabricManager().getSeries(Utility.toSafeInt(getParameter("categoryid"))));
		} catch (Exception e) {
			LogPrinter.debug("GetSeriesByCategory+err"+e.getMessage());
		}
	}
}
