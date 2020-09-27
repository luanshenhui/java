package hongling.service.distribution;

import hongling.business.LogisticsManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.service.core.BaseServlet;

public class DeleteCompany extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			String id=getParameter("id");
			if(new LogisticsManager().checkCompanyInLogistics(id)){
				output(new LogisticsManager().removeCompany(id));
			}
			else
			{
				output("No");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
}
