package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.service.core.BaseServlet;

public class DeleteFabricWareroom extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		try {
			super.service();
			String ids=getParameter("removedIDs");
			output(new FabricWareroomManager().removeFabricWareroom(ids));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
