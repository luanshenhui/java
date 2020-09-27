package chinsoft.service.customer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetTempCustomer extends BaseServlet {
	
	private static final long serialVersionUID = -2230701638950494027L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			output(this.getTempCustomer());			
		} catch (Exception e) {
			LogPrinter.debug("GetTempCustomer_err" + e.getMessage());
		}
	}

}
