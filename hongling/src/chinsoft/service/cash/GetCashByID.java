package chinsoft.service.cash;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CashManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Cash;
import chinsoft.service.core.BaseServlet;

public class GetCashByID extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strCashID = getParameter("id");
			Cash cash = new CashManager().getCashByID(strCashID);
			output(cash);
		} catch (Exception e) {
			LogPrinter.debug("GetCashByID_err" + e.getMessage());
		}
	}
}
