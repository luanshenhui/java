package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.service.core.BaseServlet;

public class GetExRateFabricWareroom extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			super.service();
			double d=new FabricWareroomManager().getEx();
			output(d);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
