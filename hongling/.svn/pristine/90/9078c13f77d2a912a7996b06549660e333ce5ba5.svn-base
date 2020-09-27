package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SetTempComponentID extends BaseServlet {

	private static final long serialVersionUID = -1759095871257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nComponentID = Utility.toSafeInt(getParameter("id"));
			this.setTempComponentID(nComponentID);
			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.info("error" + e.getMessage());
		}
	}
}

