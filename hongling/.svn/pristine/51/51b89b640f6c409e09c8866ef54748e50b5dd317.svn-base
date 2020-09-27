package centling.service.expresscom;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlExpressComManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

@SuppressWarnings("serial")
public class BlRemoveExpressCom extends BaseServlet {
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String removeIDs = getParameter("removedIDs");
			output(new BlExpressComManager().removeExpressComs(removeIDs));
		} catch (Exception err) {
			LogPrinter.error("removeExpressCom_err" + err.getMessage());
		}
	}
}