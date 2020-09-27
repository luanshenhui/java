package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricDiscountManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;


/**
 * 删除面料打折促销
 * @author Dirk
 *
 */
public class DeleteFabricDiscount extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String id = getParameter("id");
			new FabricDiscountManager().removeFabricDiscount(id);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.error("DeleteFabricPrice_err" + err.getMessage());
		}
	}
}