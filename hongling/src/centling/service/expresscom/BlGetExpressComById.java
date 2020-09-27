package centling.service.expresscom;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlExpressComManager;
import centling.entity.ExpressCom;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlGetExpressComById extends BaseServlet {
	private static final long serialVersionUID = 4357800847381831587L;
	
	/**
	 * 根据主键查询快递公司
	 */
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strExpressComId = getParameter("id");
			ExpressCom expressCom = new BlExpressComManager().getExpressComById(strExpressComId);
			output(expressCom);
		} catch (Exception e) {
			LogPrinter.debug("GetExpressComById_err" + e.getMessage());
		}
	}
}