package hongling.service.distribution;

import hongling.business.LogisticsManager;
import hongling.entity.Logistics;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.service.core.BaseServlet;

public class GetDistributionById extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		try {
			super.service();
			String id=getParameter("id");
			Logistics logistics=new LogisticsManager().getLogisticsById(id);
			output(logistics);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
