package hongling.service.orden;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;

public class GetDictBycompId extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String Id=request.getParameter("compositionId");
		Dict dict=new DictManager().getDictByID(Utility.toSafeInt(Id));
		request.setAttribute("comp", dict);
	}

}
