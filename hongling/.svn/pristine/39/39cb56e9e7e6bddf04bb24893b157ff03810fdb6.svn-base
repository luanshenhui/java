package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.LogisticManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Logistic;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetOrdenLogisticByID extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387704L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			String strOrdenID = Utility.toSafeString(getParameter("id"));
			Logistic losgistic = new LogisticManager().getLogisticByOrdenID(strOrdenID);
			output(losgistic);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenLogisticByID_err" + e.getMessage());
		}
	}
}
