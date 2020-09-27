package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetOrdenByID extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387704L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
//			super.service();
			String strOrdenID = Utility.toSafeString(getParameter("id"));
			Orden orden = this.getOrdenByID(strOrdenID);
			output(orden);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenById_err" + e.getMessage());
		}
	}
}
