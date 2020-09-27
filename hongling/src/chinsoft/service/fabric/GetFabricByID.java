package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetFabricByID extends BaseServlet {

	private static final long serialVersionUID = 8056845459527730974L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			output(new FabricManager().getFabricByID(Utility.toSafeInt(getParameter("id"))));
		} catch (Exception e) {
			LogPrinter.debug("GetFabricByID_err" + e.getMessage());
		}
	}
}
