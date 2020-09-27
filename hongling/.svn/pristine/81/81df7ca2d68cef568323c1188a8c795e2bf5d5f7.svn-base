package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ChangeRateFabricWareroom extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			String rate=getParameter("formData");
			String[] ra=rate.split(",");
			double us=Double.parseDouble(ra[0]);
			double cn=Double.parseDouble(ra[1]);
			
			new FabricWareroomManager().changeEx(us,cn);
			new FabricWareroomManager().changeRate(us);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
