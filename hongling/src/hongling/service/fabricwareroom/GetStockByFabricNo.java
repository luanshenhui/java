package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.service.core.BaseServlet;

public class GetStockByFabricNo extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		try {
			super.service();
			String fabricNo=getParameter("formData");
			Double d=new FabricWareroomManager().getStockByFabricNo(fabricNo);
			output(d);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
