package hongling.service.fabricwareroom;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.service.core.BaseServlet;

public class GetFabricByCode extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		try {
			super.service();
			String fabricNo=getParameter("formData");
			output(new FabricManager().getFabricByCode(fabricNo));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
