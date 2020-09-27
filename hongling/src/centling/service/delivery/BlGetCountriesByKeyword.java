package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.DHLCountryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlGetCountriesByKeyword extends BaseServlet {
	private static final long serialVersionUID = -6679426600459413126L;

	/**
	 * 查询国家
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strKeyword = Utility.toUtf8(request.getParameter("q"));
			output(new DHLCountryManager().getDHLCountries(strKeyword));
		} catch (Exception e) {
			LogPrinter.error("BlGetCountries_err"+e.getMessage());
		}
	}
}