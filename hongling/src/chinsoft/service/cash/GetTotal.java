package chinsoft.service.cash;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CashManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetTotal extends BaseServlet{
	private static final long serialVersionUID = 7052343472564612874L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		
		try {
			super.service();
			output(Utility.toSafeString(new CashManager().getTotal(getParameter("memberid"))));
		} catch (Exception e) {
			LogPrinter.debug("GetTotal_err"+e.getMessage());
		}
	}

}
