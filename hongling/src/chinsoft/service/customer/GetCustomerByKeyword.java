package chinsoft.service.customer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.CustomerManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetCustomerByKeyword extends BaseServlet {
	private static final long serialVersionUID = 6177171136167941106L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strCurrentMemberID = CurrentInfo.getCurrentMember().getID();
			String strKeyword = Utility.toUtf8(request.getParameter("q"));
			output(new CustomerManager().getCustomers(strKeyword, strCurrentMemberID));	
		} catch (Exception e) {
			LogPrinter.debug("GetCustomerByKeyword_err" + e.getMessage());
		}
	}
}