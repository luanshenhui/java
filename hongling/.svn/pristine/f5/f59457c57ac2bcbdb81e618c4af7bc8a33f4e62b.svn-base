package hongling.service.distribution;

import hongling.business.LogisticsManager;
import hongling.entity.LogisticsCompany;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.service.core.BaseServlet;

public class FillCompany extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			List<LogisticsCompany> companys=new LogisticsManager().getCompanyList();
			output(companys);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
