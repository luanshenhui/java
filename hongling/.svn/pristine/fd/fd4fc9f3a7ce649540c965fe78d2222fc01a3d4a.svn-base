package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ApproveOrden extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015725L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strOrdenID =  Utility.toUtf8(request.getParameter("id"));
			output(new OrdenManager().updateOrdenStatus(strOrdenID, CDict.OrdenStatusPlateMaking.getID(), ""));
		} catch (Exception err) {
			LogPrinter.debug("ApproveOrdens_err"+err.getMessage());
		}
	}
}