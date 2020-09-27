package centling.service.cash;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CashManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Cash;
import chinsoft.service.core.BaseServlet;

public class GetCashByMemberID extends BaseServlet{

	private static final long serialVersionUID = -3823455375189273161L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strMemberID = getParameter("pubmemberid");
			Cash cash = new CashManager().getCashByMemberID(strMemberID);
			output(cash);
		} catch (Exception e) {
			LogPrinter.debug("GetCashByMemberID_err"+e.getMessage());
		}
	}
}
