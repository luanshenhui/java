package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import chinsoft.business.DeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.service.core.BaseServlet;

/**
 * 保存备注
 *
 */
public class BlSaveDeiveryByDeliveryId extends BaseServlet {
	private static final long serialVersionUID = 3920581371055077142L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			// 得到发货单ID
			String strDeliveryId = getParameter("deliveryid");
			
			// 得到发货备注
			String strMemo = getParameter("deliveryMemo");
			
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryId);
			
			delivery.setMemo(strMemo);
			
			new BlDeliveryManager().saveDelivery(delivery);
			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlSaveDeiveryByDeliveryId_err"+e.getMessage());
		}
	}
}