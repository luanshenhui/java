package hongling.service.orden;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.entity.Orden;

public class GetOrdenByNo extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String orderNo=request.getParameter("code");
		Orden orden=new OrdenManager().getordenByOrderId(orderNo);
		request.setAttribute("orden", orden);
	}

}
