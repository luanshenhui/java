package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class UpdateFabricWareroomStatus extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			super.service();
			String ids=getParameter("ids");
			new FabricWareroomManager().updateStatus(ids);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
