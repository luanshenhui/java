package hongling.service.orden;

import hongling.business.FabricWareroomManager;
import hongling.entity.FabricWareroom;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.Utility;
import chinsoft.entity.Fabric;

public class GetFabricByFabircId extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String code=request.getParameter("fabricCode");
		//System.out.println(id);
		FabricWareroom fabric=new FabricWareroomManager().getFabricWareroomByFabricCode(code);
		request.setCharacterEncoding("UTF-8");
		request.setAttribute("fabric", fabric);
	}

}
