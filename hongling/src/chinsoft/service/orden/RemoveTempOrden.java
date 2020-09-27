package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class RemoveTempOrden extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strOrdenID = getParameter("ordenid");			
			
			this.removeTempOrden(strOrdenID);
			output(Utility.RESULT_VALUE_OK);
			
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}