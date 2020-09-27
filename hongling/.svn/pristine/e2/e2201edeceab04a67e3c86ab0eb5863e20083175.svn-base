package chinsoft.service.core;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;

public class GetValue extends BaseServlet {

	private static final long serialVersionUID = -1759096872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {		
			output(ResourceHelper.getValue(getParameter("name1"), getParameter("name2")));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

