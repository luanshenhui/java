package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import rcmtm.business.Geo_CN;

import centling.business.DHLCityManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlGetCitysByKeyword extends BaseServlet {
	private static final long serialVersionUID = -805924785184099223L;

	/**
	 * 查询城市
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strKeyword = Utility.toUtf8(request.getParameter("q"));
			// 得到编号
			String code = request.getParameter("param1");
			
			// 得到类型
			String type = request.getParameter("type");
			
			String countryCode = Utility.toUtf8(request.getParameter("countryCode"));
			if (countryCode.equals("CN")) {
				output(new Geo_CN().shortening(strKeyword, code));
			} else {
				output(new DHLCityManager().getDHLCitys(strKeyword, code, type));
			}
		} catch (Exception e) {
			LogPrinter.error("BlGetCountries_err"+e.getMessage());
		}
	}

}