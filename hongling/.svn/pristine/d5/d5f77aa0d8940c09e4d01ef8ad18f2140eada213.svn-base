package hongling.service.fabrictrader;

import hongling.business.FabricTraderManager;
import hongling.entity.FabricTrader;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.service.core.BaseServlet;

public class GetFabricTraderById extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			String id=getParameter("id");
			FabricTrader fabricTrader=new FabricTraderManager().getFabricTraderByID(id);
			output(fabricTrader);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
