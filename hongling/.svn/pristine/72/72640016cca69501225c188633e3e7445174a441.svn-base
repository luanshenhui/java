package centling.service.cash;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDealItemManager;
import centling.entity.DealItem;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetDealItemByID extends BaseServlet{

	private static final long serialVersionUID = 2600586911283911932L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			Integer ID = Utility.toSafeInt(getParameter("ID"));
			DealItem dealItem = new BlDealItemManager().getDealItemByID(ID);
			output(dealItem);
		} catch (Exception e) {
			LogPrinter.debug("GetDealItemByID_err"+e.getMessage());
		}
	}
}
