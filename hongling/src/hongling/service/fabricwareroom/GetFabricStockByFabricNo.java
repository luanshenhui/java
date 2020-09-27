package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.service.core.BaseServlet;

public class GetFabricStockByFabricNo extends BaseServlet {
 @Override
protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
		throws ServletException, IOException {
	// TODO Auto-generated method stub
	try {
		super.service();
		String fabricNo=getParameter("fabricNo");
		output(new FabricWareroomManager().getStockByFabricNo(fabricNo));
	} catch (Exception e) {
		e.printStackTrace();
	}
	
}
}
