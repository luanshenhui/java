package centling.service.expresscom;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlExpressComManager;
import centling.entity.ExpressCom;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlgetAllExpressComs extends BaseServlet {
	private static final long serialVersionUID = -2438854310788262906L;
	
	/**
	 * 查询全部的快递公司
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			List<ExpressCom> data = new BlExpressComManager().getAllExpressComs();
			output(data);
		} catch (Exception e) {
			LogPrinter.error("getAllExpressComs_err" + e.getMessage());
		}
	}
}