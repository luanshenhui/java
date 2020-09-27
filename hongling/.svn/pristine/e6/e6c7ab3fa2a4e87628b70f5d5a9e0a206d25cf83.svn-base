package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.service.core.BaseServlet;

public class GetFabricwareroomByCode extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		try {
			super.service();
			String fabricNo=getParameter("fabricNo");
			//System.out.println(fabricNo);
			//System.out.println(new FabricWareroomManager().getFabricWareroomByFabricCode(fabricNo));
			output(new FabricWareroomManager().getFabricWareroomByFabricCode(fabricNo));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
