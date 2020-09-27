package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import rcmtm.business.Geo_CN;
import centling.business.DHLStateManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlGetStatesByKeyword extends BaseServlet {
	private static final long serialVersionUID = 1503474096178131589L;

	/**
	 * 查询州
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strKeyword = Utility.toUtf8(request.getParameter("q"));
			String countryCode = Utility.toUtf8(request.getParameter("countryCode"));
			if (countryCode.equals("CN")) {
				output(new Geo_CN().shortening(strKeyword, "0"));
			} else {
				output(new DHLStateManager().getDHLStates(strKeyword));
			}
		} catch (Exception e) {
			LogPrinter.error("BlGetCountries_err"+e.getMessage());
		}
	}
}