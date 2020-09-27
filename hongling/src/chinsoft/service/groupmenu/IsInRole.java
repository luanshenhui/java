package chinsoft.service.groupmenu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class IsInRole extends BaseServlet{
	private static final long serialVersionUID = -6192897803965485696L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			int nFunctionID = Utility.toSafeInt(getParameter("id"));
            output(CurrentInfo.isInRole(nFunctionID));
		} catch (Exception e) {
			LogPrinter.info("IsInRole_err   "+e.getMessage());
		}
	}
}
