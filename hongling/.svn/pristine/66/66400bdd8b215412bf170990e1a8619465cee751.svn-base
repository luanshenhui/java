package chinsoft.service.clothing;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ElementColorManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetElementColor extends BaseServlet {
	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			String strColor = new ElementColorManager().getElementColor(Utility.toSafeInt(getParameter("contentid")),this.getTempComponentIDs());
			output("#" + strColor);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}