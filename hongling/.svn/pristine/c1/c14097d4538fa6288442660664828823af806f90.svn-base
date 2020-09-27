package chinsoft.service.customer;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SetTempCustomer extends BaseServlet{

	private static final long serialVersionUID = -9210568961073475719L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String strFormData = getParameter("formData");
			setTempCustomer(strFormData);			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
	
	
}
