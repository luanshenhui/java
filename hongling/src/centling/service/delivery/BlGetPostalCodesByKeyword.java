package centling.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.DHLCityManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlGetPostalCodesByKeyword extends BaseServlet {
	private static final long serialVersionUID = -507153698813555383L;

	/**
	 * 查询邮编
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 得到国家编号
			String countryCode = Utility.toSafeString(getParameter("countryCode"));
			
			// 得到城市
			String city = Utility.toSafeString(getParameter("city"));
			List<String> list = new DHLCityManager().getDHLPostalCodes(countryCode, city);
 			output(list);
		} catch (Exception e) {
			LogPrinter.error("BlGetCountries_err"+e.getMessage());
		}
	}
}