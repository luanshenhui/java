package chinsoft.service.information;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.InformationManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class RemoveInformations extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String removedIDs = getParameter("removedIDs");
			output(new InformationManager().removeInformations(removedIDs));
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}