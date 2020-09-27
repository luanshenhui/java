package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ComponentPageSizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetComponentPageSize extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			Integer nParentID = Utility.toSafeInt(getParameter("parentid"));
			output(new ComponentPageSizeManager().getComponentPageSizeByID(nParentID));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

