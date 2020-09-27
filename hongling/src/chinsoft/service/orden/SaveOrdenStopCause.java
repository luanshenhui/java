package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveOrdenStopCause extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String ordenID = request.getParameter("ordenID");
			int stopCauseID = Utility.toSafeInt(request.getParameter("stopCauseID"));
			String strResult = "";
			strResult = new OrdenManager().updateOrdenStopCause(ordenID,stopCauseID);
			output(strResult);
			
		} catch (Exception err) {
			output("error:" + err.getMessage());
		}
	}

	
}