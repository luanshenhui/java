package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryPlusManager;
import centling.entity.DeliveryPlus;
import chinsoft.business.DeliveryManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.service.core.BaseServlet;

public class BlSaveOtherDelivery extends BaseServlet {
	private static final long serialVersionUID = 5511102552814632995L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 得到发货单ID
			String deliveryId = getParameter("deliveryID");
			
			Delivery delivery = new DeliveryManager().getDeliveryByID(deliveryId);
			
			String strFormData = getParameter("formData");
			DeliveryPlus deliveryPluse = new DeliveryPlus();
			deliveryPluse = (DeliveryPlus)EntityHelper.updateEntityFromFormData(deliveryPluse, strFormData);
			deliveryPluse.setDeliveryID(deliveryId);
			deliveryPluse.setPubMemberID(delivery.getPubMemberID());
			
			new BlDeliveryPlusManager().saveDeliveryPlus(deliveryPluse);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlSaveOtherDelivery_err" + e.getMessage());
		}
	}
}