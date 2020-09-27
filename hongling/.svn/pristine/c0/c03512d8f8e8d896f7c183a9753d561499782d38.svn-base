package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetFabricOccupys extends BaseServlet {

	private static final long serialVersionUID = -6535997613729365562L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strUsername = CurrentInfo.getERPUserName();
			Object result = new FabricManager().getFabricOccupys(strUsername);
			response.setContentType("text/html;charset=utf-8");
			response.getWriter().print(result);
		} catch (Exception e) {
			LogPrinter.debug("getfabrics_err" + e.getMessage());
		}
	}
}
