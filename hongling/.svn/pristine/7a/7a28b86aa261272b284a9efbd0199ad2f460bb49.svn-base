package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class RemoveFabrics extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String removedIDs = getParameter("removedIDs");
			output(new FabricManager().removeFabrics(removedIDs));
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}