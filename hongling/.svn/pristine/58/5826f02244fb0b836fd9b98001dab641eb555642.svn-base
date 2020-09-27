package chinsoft.service.clothing;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetPosition extends BaseServlet {
	private static final long serialVersionUID = -1759095870257433228L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			String strPosition = new ClothingManager().getPosition(Utility.toSafeInt(getParameter("contentid")),this.getTempComponentIDs());
			output(strPosition);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}