package hongling.service.distribution;

import hongling.business.LogisticsManager;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CurrentInfo;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class DeleteDistribution extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			String id=getParameter("ID");
			String name=CurrentInfo.getCurrentMember().getName();
			Date nTime=new Date();
			output(new LogisticsManager().deleteLogisticses(id,nTime,name));
		} catch (Exception e) {
			e.printStackTrace();
			e.getMessage();
		}
		
	}
}
