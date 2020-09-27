package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryPlusManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlDeleteDeliveryDetailByOrdenId extends BaseServlet {
	private static final long serialVersionUID = 4486299839816392407L;

	/**
	 * 根据订单号删除发货明细 
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			// 得到订单号
			String strOrdenId = getParameter("ordenId");
			
			// 得到发货单号
			String deliveryId = getParameter("deliveryid");
			
			// 得到类型
			String type = getParameter("type");
			
			if ("1".equals(type)) {
				// 执行删除操作
				new OrdenManager().updateOrdenById(strOrdenId);
			} else {
				new BlDeliveryPlusManager().deleteDeliveryPlus(deliveryId, strOrdenId);
			}
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlDeleteDeliveryDetailByOrdenId_err"+e.getMessage());
		}
	}
}