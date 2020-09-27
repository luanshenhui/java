package chinsoft.service.dict;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.CVersion;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;


public class GetVersions extends BaseServlet{
	private static final long serialVersionUID = 2374662018011169009L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			output(CVersion.All);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
		
	}
}
