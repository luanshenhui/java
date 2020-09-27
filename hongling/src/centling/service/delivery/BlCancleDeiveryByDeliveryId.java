package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlCancleDeiveryByDeliveryId extends BaseServlet {
	private static final long serialVersionUID = 4959828348250945612L;
	
	/**
	 *  撤销发货单
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			// 得到发货单ID
			String strDeliveryId = getParameter("deliveryid");
			
			// 更新发货单明细
			new BlDeliveryManager().cancleDelivery(strDeliveryId);
			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlCancleDeiveryByDeliveryId_err"+e.getMessage());
		}
	}

}
