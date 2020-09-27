package chinsoft.service.clothing;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ElementFontManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetElementFont extends BaseServlet {
	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			String strFont = new ElementFontManager().getElementFont(Utility.toSafeInt(getParameter("contentid")),this.getTempComponentIDs());
			output(strFont);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}