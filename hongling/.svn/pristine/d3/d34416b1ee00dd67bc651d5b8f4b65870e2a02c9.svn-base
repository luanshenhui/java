package chinsoft.service.core;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;

public class IsAdmin extends BaseServlet {

	private static final long serialVersionUID = -1759096802257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			output(CurrentInfo.isAdmin());
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

