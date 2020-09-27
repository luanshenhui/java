package chinsoft.service.logistic;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.imx.webwork.Constants.Request;

import chinsoft.business.LogisticManager;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class UpdateLogisticInfoByOrdenID extends BaseServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			String ordenID=req.getParameter("ordenID");
			String company=req.getParameter("logisticCompany");
			String logisticNo=req.getParameter("logisticNo");
			
			new LogisticManager().updateLogisticInfoByOrdenID(ordenID, company, logisticNo);
		
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
