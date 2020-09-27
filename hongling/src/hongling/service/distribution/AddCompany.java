package hongling.service.distribution;

import hongling.business.LogisticsManager;
import hongling.entity.LogisticsCompany;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class AddCompany extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		
		try {
			super.service();
			String company=getParameter("companyname");
			String formdata="{companyname:'"+company+"'}";
			
			LogisticsCompany logis=new LogisticsCompany();
			logis=(LogisticsCompany)EntityHelper.updateEntityFromFormData(logis, formdata);
			new LogisticsManager().saveLogisticsCompany(logis);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
