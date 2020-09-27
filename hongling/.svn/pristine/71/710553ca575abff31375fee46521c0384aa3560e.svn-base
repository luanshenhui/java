package hongling.service.fabrictrader;

import hongling.business.FabricTraderManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.service.core.BaseServlet;

public class DeleteFabricTrader extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			String ids=getParameter("removedIDs");
			output(new FabricTraderManager().removeFabricTader(ids));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
