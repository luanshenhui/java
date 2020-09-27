package chinsoft.service.customer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CustomerManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetCustomerByID extends BaseServlet{
	
	private static final long serialVersionUID = 3021763182205601003L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strCustomerID=getParameter("customerid");
			output(new CustomerManager().getCustomerByID(strCustomerID));
			
		} catch (Exception e) {
			LogPrinter.debug("GetCustomerById_err" + e.getMessage());
		}
	}
}
