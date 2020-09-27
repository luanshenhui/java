package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;
import hongling.entity.FabricTrader;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.service.core.BaseServlet;

public class GetFabricTraderList extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			super.service();
			List<FabricTrader> fabricTraders=new FabricWareroomManager().getFabricTraderList();
			output(fabricTraders);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
