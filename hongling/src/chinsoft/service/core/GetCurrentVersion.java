package chinsoft.service.core;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.CVersion;
import chinsoft.core.LogPrinter;

public class GetCurrentVersion extends BaseServlet{
	
	private static final long serialVersionUID = 88074467611947928L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			output(CVersion.getCurrentVersionID());
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
