package chinsoft.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Delivery;
import chinsoft.service.core.BaseServlet;

public class GetDeliveryByID extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strDeliveryID = getParameter("id");
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryID);
			output(delivery);
		} catch (Exception e) {
			LogPrinter.debug("GetDeliveryByID_err" + e.getMessage());
		}
	}
}