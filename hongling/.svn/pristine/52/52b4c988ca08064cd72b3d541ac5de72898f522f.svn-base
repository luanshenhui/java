package hongling.service.orden;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.entity.OrdenDetail;

public class GetOrdenDetailByOrdenId extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String ordenID=request.getParameter("ordenID");
		List<OrdenDetail> details=new OrdenManager().getOrdenDetailByOrdenID(ordenID);
		request.setAttribute("details", details);
	}

}
