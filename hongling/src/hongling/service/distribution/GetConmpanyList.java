package hongling.service.distribution;

import hongling.business.LogisticsManager;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import hongling.entity.LogisticsCompany;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetConmpanyList extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		
		try {
			super.service();
			int pageNo=Utility.toSafeInt(getParameter("pageindex"));
			List<LogisticsCompany> companys=new LogisticsManager().getCompanyList(pageNo, 5);
			PagingData page=new PagingData();
			page.setCount(companys.size());
			page.setData(companys);
			output(page);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
}
