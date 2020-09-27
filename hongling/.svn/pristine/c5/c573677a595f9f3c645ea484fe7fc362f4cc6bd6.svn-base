package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricPriceManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 删除指定的面料价格
 * @author Dirk
 *
 */
public class DeleteFabricPrice extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String removeIDs = getParameter("removedIDs");
			new FabricPriceManager().removeFabricPrice(removeIDs);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.error("DeleteFabricPrice_err" + err.getMessage());
		}
	}
}
