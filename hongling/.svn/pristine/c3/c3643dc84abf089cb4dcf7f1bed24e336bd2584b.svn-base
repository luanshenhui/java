package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ReleaseFabric extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strCode =  Utility.toUtf8(request.getParameter("id"));
			String strOrdenId =  Utility.toUtf8(request.getParameter("ordenId"));

			String result = new FabricManager().releaseFabric(strCode,strOrdenId);
			
			output(result);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}