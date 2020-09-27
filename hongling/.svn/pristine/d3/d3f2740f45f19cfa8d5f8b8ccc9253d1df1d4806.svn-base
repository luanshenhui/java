package chinsoft.service.message;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MessageManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class RemoveMessages extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String removedIDs = Utility.toSafeString(getParameter("removedIDs"));
			output(new MessageManager().removeMessages(removedIDs));
		} catch (Exception err) {
			LogPrinter.error(err.getMessage());
		}
	}
}